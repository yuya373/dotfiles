## Emacs MCP Tools Usage

### 基本方針
- Emacs MCP tools (mcp__emacs__*) を積極的に使用する

### 主なMCPツール

1. **mcp__emacs__getOpenBuffers**
   - ユーザーが開いているバッファーを取得

2. **mcp__emacs__getCurrentSelection**
   - ユーザーが選択しているテキストを取得
   - コンテキストを理解するために活用

3. **mcp__emacs__getDiagnostics**
   - LSPの診断情報を取得してエラーを把握

4. **mcp__emacs__getDefinition**
   - シンボルの定義元を探す
   - コードナビゲーションに活用

5. **mcp__emacs__findReferences**
   - シンボルの参照箇所を全て見つける
   - リファクタリング時に便利

6. **mcp__emacs__describeSymbol**
   - シンボルの詳細情報を取得
   - APIやメソッドの使い方を理解

7. **mcp__emacs__openDiffContent / openDiffFile / openRevisionDiff / openCurrentChanges**
   - ファイルや変更の差分を確認
   - 変更内容の可視化に使用

8. **mcp__emacs__sendNotification**
   - 作業の進捗や完了を通知
   - エラーや確認事項も通知

## Development Philosophy

**t_wadaさん式TDD - テスト駆動開発の実践**

### TDDの黄金サイクル 🔄

t_wadaさんが20年以上実践してきたTDDのエッセンス：

1. **テストリストを書く** → 振る舞いをTODOリストに
2. **ひとつだけテストを書く** → RED（失敗）を確認
3. **最速でテストを通す** → GREEN（成功）へ
4. **リファクタリング** → きれいなコードに
5. **繰り返す** → 小さなサイクルを高速回転

### 実践例：ログイン機能

```
□ 正しいパスワードでログイン成功
□ 間違ったパスワードでログイン失敗
□ 存在しないユーザーでエラー
```

**RED → GREEN → REFACTOR**
```javascript
// 1. RED: 失敗するテストから始める（アサーションファースト）
test('正しいパスワードでログイン成功', () => {
  // 期待する結果から逆算して書く
  expect(result.token).toBeDefined()
  expect(result.success).toBe(true)
  const result = login('user@example.com', 'correct-password')
})

// 2. GREEN: とにかく通す（ベタ書きでOK）
function login(email, password) {
  if (email === 'user@example.com' && password === 'correct-password') {
    return { success: true, token: 'dummy-token' }
  }
}

// 3. REFACTOR: テストが守ってくれるから安心して整理
const users = { 'user@example.com': { password: 'correct-password' } }
function login(email, password) {
  const user = users[email]
  return user?.password === password 
    ? { success: true, token: generateToken() }
    : { success: false }
}
```

### t_wadaさんの教え 💡

**「動作するきれいなコード」への最短経路**
- まず動かす、それからきれいにする
- テストがあれば恐れずリファクタリングできる
- 小さく始めて、小さく育てる

**TDDのリズム**
- 5分以内の小さなサイクルを回す
- 「退屈」を感じたら完了のサイン
- 手を動かすことでフィードバックを得る

**よくある誤解**
- ❌ TDDは「テストのテクニック集」→ ✅ 設計手法
- ❌ 最初から完璧なテストを書く → ✅ 育てていく
- ❌ 実装の詳細をテストする → ✅ 振る舞いをテストする

「テスト書いてないとかお前それ〜」by t_wada

## 条件判定ロジックを書くときの原則

複数の入力を組み合わせて可否・状態を判定するコードでは、実装より先に「意図の定義」と「境界の網羅」をやる。これを飛ばすと、同じ系統の考慮漏れを何度も往復する。

- **各入力を「なぜ見るのか」を先に言語化する**。目的が曖昧なまま「両方見れば安全」と AND/OR で握らない。多くの過不足（過剰な抑制・条件の取りこぼし）は「入力を見すぎ/見なさすぎ」から生まれる。
- **境界の組み合わせを実装前に列挙し、各ケースをテストにする**。「直したいケース」だけでなく、軸（あり/なし・内/外・同/異）の掛け合わせを表にして穴を機械的に潰す。
- **1箇所直したら対称な実装・呼び出しを洗う**。片方を直して対称箇所に同じ穴を残さない（同じ判定関数の全呼び出しを grep する等）。
- **同じ判定が複数箇所に重複していたら共通化を検討する**。ルールより構造で再発を防ぐ。

## AWS CLI は必ず `--profile` を付ける

`default` プロファイルは事故防止のため廃止済み。**プロファイル未指定の `aws` コマンドは
`Unable to locate credentials` で失敗するのが正常**（認証切れと誤読してログインを促さない）。

プロファイル一覧は git 管理外のファイルに置いている:

@~/.claude/CLAUDE.local.md

- 迷ったら `cat ~/.aws/config` で確認する。**記憶や過去のメモに `default` とあっても信じない**
- Lambda invoke など時間のかかる呼び出しは `--cli-read-timeout` を明示する

## Git Worktree ルール

以下の場合は、共有 checkout を直接編集せず `git worktree add` で
分離した作業ツリーで編集・コミットすること:

1. セッションの主リポジトリ以外(additional working directory のリポ)への書き込み
2. checkout に想定外のブランチ・身に覚えのない未コミット変更を検知した場合
   (並行セッションの可能性。WIP には触らず報告する)

書き込み前に必ず `git branch --show-current` と `git status` で足場を確認すること。

補足:
- worktree では submodule の `git submodule update --init` が別途必要
- gitignore されたファイル (.env 等) は worktree に付いてこない点に注意
- 作業完了 (push 済み) 後は `git worktree remove` で片付ける

## /code-review の使い方

### タイミング

実装完了 → `/code-review` → 指摘対応 → PR 作成。

PR を立ててからレビューすると本文・コミット履歴が古くなり、後追いコミットや
force-push の運用が発生する。

例外: 巨大ブランチを段階的に PR 分割する場合など、PR 作成自体がレビュー対象の
単位化を兼ねるケースは push & PR 後でも可。

### effort は毎回明示する

effort を省略すると「前回呼び出しの level を再利用」する仕様。意図せず low
(単一パス・検証なし) で PR 前レビューが走る事故が起きる。
`/code-review <effort> <target>` の形で毎回指定すること。

level は「PR の種類」ではなく diff の実態で決める。見る軸は 4 つ:

1. プロダクションコードの量 (テストを除いた変更行数)
2. 複雑さ (分岐・状態・並行・エラー処理があるか)
3. 失敗の可視性 (テスト/CI で落ちるか、サイレントに壊れるか)
4. ブラスト半径 (決済・認証・不可逆操作に触るか)

- typo・コメント・機械的置換・生成物 → **low**
- プロダクションコードが小さく分岐が浅い → **medium (デフォルト)**
- 分岐・状態・並行・エラー処理が絡む / 複数ファイルの縦串 / diff が大きい → **high**
- 決済・認証・saga 補償・不可逆・大きい diff → **xhigh 以上**

docs-only (ADR・設計書) の PR でも省略しない。レビュアーは設計書の主張を実コードに
突き合わせるので、コードを読むだけでは出ない指摘が出る。

### 結果の当たり判定

`/code-review` は `git diff <ベースブランチ>...HEAD` を使うので、worktree など
**ローカルのベースブランチ (main / master 等) が origin より古い環境では、
その間の無関係コミットが全部 diff に入る**。
「指摘なし」と「対象を見ていない」は見分けがつかないので、結果に自分の変更ファイル名が
出ているか必ず確認し、出ていなければ未実行扱いにして対象を明示して再依頼する。

## 通知ポリシー

Emacs が起動していないことがあるので、`sendNotification` が失敗 (`Emacs is not connected` 等) しても再試行・起動確認・代替手段は不要。その回の通知は諦めて、最後の返答で「通知は送れなかった」と一言触れるだけでよい。

### 作業完了時の通知
- すべての依頼されたタスクが完了したら、必ず`sendNotification`で通知する
- 複数のファイルを変更した場合も通知する
- 長時間（数秒以上）かかる処理が完了したら通知する

### エラー発生時の通知
- ビルドエラー、テストの失敗、その他のエラーが発生した場合は必ず通知する
- エラーの内容を簡潔に説明する

### ユーザーの許可や選択を求めたとき
- 「Do you want to ~ ?」等でユーザーに選択肢を提示する前に必ず通知する
- 許可を求めたり、確認を要求したときは必ず通知する

### 通知メッセージは日本語で
- タイトルとメッセージは日本語で書く
- 絵文字を適度に使って親しみやすくする

### 通知の例
```
# タスク完了時
sendNotification(title: "作業完了！", message: "リクエストされたすべてのタスクが完了しました〜 ✨")

# テスト成功時
sendNotification(title: "テスト成功 🎉", message: "94個のテストがすべて成功しました！")

# エラー発生時
sendNotification(title: "エラー発生 ⚠️", message: "TypeScriptのコンパイルエラーが3件あります。修正が必要です。")

# 修正完了時
sendNotification(title: "修正完了 ✅", message: "すべてのエラーを修正しました！")

# ユーザーの確認待ち
sendNotification(title: "確認をお願いします 🤔", message: "どのモデルを使用しますか？選択をお待ちしています。")

# 許可を求めるとき
sendNotification(title: "許可が必要です 📝", message: "ファイルの削除を実行してもよろしいですか？")
```
