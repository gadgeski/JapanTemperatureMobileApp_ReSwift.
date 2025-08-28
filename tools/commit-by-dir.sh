#!/usr/bin/env bash
set -euo pipefail

# --- 行末/不可視文字チェック（早期に気づけるように） -------------------
# CRLF混入チェック（^M があると bash が変数名を誤解して unbound variable になりやすい）
if grep -q $'\r' "$0"; then
  echo "Error: CRLF detected. Fix with: sed -i '' -e 's/\\r$//' $0" >&2
  exit 1
fi
# 必須ではないが、ゼロ幅文字の混入を検知したら警告（実害が出たら除去を推奨）
if LC_ALL=C grep -q -P $'[\x{200B}\x{200C}\x{200D}\x{FEFF}]' "$0" 2>/dev/null; then
  echo "Warning: zero-width char detected (ZWSP/ZWJ/ZWNJ/BOM). If errors persist, remove them." >&2
fi

# === 設定（必要に応じて変更） ===========================================
# コミットメッセージのテンプレート。{dir} がディレクトリ名に置き換わります。
MSG_TEMPLATE='chore({dir}): auto commit'
# 自動 push するなら true / しないなら false（環境変数でも上書き可）
AUTO_PUSH=${AUTO_PUSH:-false}
# push 先（AUTO_PUSH=true の時だけ有効）
REMOTE=${REMOTE:-origin}
# 空なら現在のブランチ (HEAD) に push（mainに固定したい時は BRANCH=main）
BRANCH=${BRANCH:-}
# 余り（ルート直下のファイルなど）をコミットするか
COMMIT_LEFTOVERS=${COMMIT_LEFTOVERS:-false}
# ルート直下自動列挙のときに除外するディレクトリ名パターン（スペース区切り）
# .git と *.xcodeproj を既定で除外（Xcodeプロジェクトはディレクトリ扱いのため）
EXCLUDE_NAMES=(".git" "*.xcodeproj")
# ======================================================================

usage() {
  cat <<'USAGE'
commit-by-dir.sh  -- 各ディレクトリごとに自動コミット
使い方:
  ./commit-by-dir.sh                 # ルート直下の全ディレクトリを対象（.git, *.xcodeprojは除外）
  ./commit-by-dir.sh dir1 dir2 ...   # 対象ディレクトリを指定
環境:
  MSG_TEMPLATE='...'   : コミットメッセージ（{dir} が置換されます）
  AUTO_PUSH=true|false : 自動 push の有無（既定: false）
  REMOTE=origin        : push 先リモート名
  BRANCH=main          : push 先ブランチ（未指定なら現在のブランチ）
  COMMIT_LEFTOVERS=true|false : 残り物（ルート直下のファイル等）も最後に1コミット（既定: false）
オプション:
  -n / --dry-run       : 何をコミット/Pushするかだけ表示して終了（変更はしない）
  -h / --help          : このヘルプを表示
USAGE
}

DRY_RUN=false
ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=true; shift;;
    -h|--help) usage; exit 0;;
    *) ARGS+=("$1"); shift;;
  esac
done

# リポジトリルートへ移動
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "${REPO_ROOT}" ]]; then
  echo "Error: ここは Git リポジトリではありません。" >&2
  exit 1
fi
cd "$REPO_ROOT"

# AUTO_PUSH 時、detached HEAD かつ BRANCH 未指定なら危険なので早期に止める
if [[ "${AUTO_PUSH}" == "true" && "$(git rev-parse --abbrev-ref HEAD)" == "HEAD" && -z "${BRANCH}" ]]; then
  echo "Detached HEAD。BRANCH=main のように push 先ブランチを明示してください。" >&2
  exit 1
fi

# 対象ディレクトリの決定（引数がなければルート直下の全ディレクトリ）
declare -a DIRS
if [[ ${#ARGS[@]} -gt 0 ]]; then
  DIRS=("${ARGS[@]}")
else
  # find で .git / *.xcodeproj を除外
  # macOS/BSD find 互換で書く（-print0で安全取得）
  # shellcheck disable=SC2016
  FIND_EXPR=(find . -mindepth 1 -maxdepth 1 -type d)
  for pat in "${EXCLUDE_NAMES[@]}"; do
    FIND_EXPR+=(! -name "$pat")
  done
  while IFS= read -r -d '' d; do
    DIRS+=("${d#./}")
  done < <("${FIND_EXPR[@]}" -print0)
fi

if [[ ${#DIRS[@]} -eq 0 ]]; then
  echo "対象ディレクトリが見つかりませんでした。"
  exit 0
fi

current_branch() {
  git rev-parse --abbrev-ref HEAD
}

commit_one_dir() {
  local dir="$1"

  # インデックスをクリーンに（他ディレクトリのステージを混ぜない）
  git reset --quiet

  # そのディレクトリの変更（追加/更新/削除）だけをステージ
  git add -A -- "$dir"

  # ステージ済みの変更がなければスキップ
  if git diff --cached --quiet -- "$dir"; then
    echo "Skip: ${dir}（変更なし）"
    git reset --quiet
    return 0
  fi

  : "${MSG_TEMPLATE:=chore({dir}): auto commit}"
  local msg="${MSG_TEMPLATE//\{dir\}/${dir}}"

  echo "Commit: ${dir} -> \"${msg}\""
  if [[ "${DRY_RUN}" == "true" ]]; then
    # 何がステージされているか表示だけ
    git diff --cached --name-status -- "$dir"
    git reset --quiet
    return 0
  fi

  git commit -m "$msg"

  if [[ "${AUTO_PUSH}" == "true" ]]; then
    # push 直前ガード（detached HEAD）
    if [[ "$(git rev-parse --abbrev-ref HEAD)" == "HEAD" && -z "${BRANCH}" ]]; then
      echo "Detached HEAD。BRANCH=main のように push 先ブランチを明示してください。" >&2
      return 1
    fi
    local target_ref="${BRANCH:-$(current_branch)}"
    echo "Push: ${REMOTE} ${target_ref}"
    if [[ "${DRY_RUN}" == "true" ]]; then
      git push --dry-run "${REMOTE}" "HEAD:${target_ref}" || true
    else
      # upstream 未設定なら -u で設定しておく（親切仕様）
      if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
        git push "${REMOTE}" "HEAD:${target_ref}"
      else
        git push -u "${REMOTE}" "HEAD:${target_ref}"
      fi
    fi
  fi
}

echo "== commit-by-dir: repo=${REPO_ROOT} =="
echo "対象: ${DIRS[*]}"

for d in "${DIRS[@]}"; do
  # 実在するディレクトリのみ
  if [[ ! -d "$d" ]]; then
    echo "Warn: ディレクトリではありません -> $d"
    continue
  fi
  commit_one_dir "$d"
done

# 余り（ルート直下のファイルなど）をコミット（任意）
if [[ "${COMMIT_LEFTOVERS}" == "true" ]]; then
  git reset --quiet
  git add -A .
  if ! git diff --cached --quiet; then
    if [[ "${DRY_RUN}" == "true" ]]; then
      echo 'Commit: (leftovers) -> "chore(misc): auto commit"'
      git diff --cached --name-status
      git reset --quiet
    else
      git commit -m "chore(misc): auto commit"
      if [[ "${AUTO_PUSH}" == "true" ]]; then
        local target_ref="${BRANCH:-$(current_branch)}"
        git push "${REMOTE}" "HEAD:${target_ref}"
      fi
    fi
  fi
fi

echo "Done."
