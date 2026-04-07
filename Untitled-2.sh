#!/bin/bash
#SBATCH --job-name=bsA_array
#SBATCH --cpus-per-task=1
#SBATCH --partition=short
#SBATCH --time=1:00:00
#SBATCH --array=1-13
#SBATCH --error=/home/kosukesano/tools/for_paml/251015/APH_test/bsA/log/%x_%A_%a.err.log
#SBATCH --output=/home/kosukesano/tools/for_paml/251015/APH_test/bsA/log/%x_%A_%a.out.log

######### YOUR JOB #########

# ディレクトリパス
FASTA_DIR="/home/kosukesano/tools/for_paml/251015/APH_test/bsA/data"
TREE_FILE="/home/kosukesano/tools/for_paml/251015/APH_test/tree.txt"
OUT_DIR="/home/kosukesano/tools/for_paml/251015/APH_test/bsA/result"
CTL_DIR="/home/kosukesano/tools/for_paml/251015/APH_test/bsA/ctl"
WORK_DIR="/home/kosukesano/tools/for_paml/251015/APH_test/bsA"
FILE_LIST="${FASTA_DIR}/file_list.txt"

# 出力ディレクトリを作成
mkdir -p "$OUT_DIR"
mkdir -p "$CTL_DIR"
mkdir -p "$WORK_DIR/log"

# JOB配列番号に対応するFASTAファイルを取得
SEQ_FILE_NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$FILE_LIST")
SEQ_FILE="${FASTA_DIR}/${SEQ_FILE_NAME}"

# 拡張子を除いたベース名を取得
BASENAME=$(basename "$SEQ_FILE_NAME" .fna)

# 出力ファイル名
OUT_FILE="${OUT_DIR}/${BASENAME}_bsa.txt"
CTL_FILE="${CTL_DIR}/${BASENAME}_bsa.ctl"

# CTLファイルを生成
cat > "$CTL_FILE" <<EOF
      seqfile = $SEQ_FILE
     treefile = $TREE_FILE
      outfile = $OUT_FILE

        noisy = 9
      verbose = 1
      runmode = 0

      seqtype = 1
    CodonFreq = 2
        clock = 0
        model = 2

      NSsites = 2
        icode = 0

    fix_kappa = 0
        kappa = 2
    fix_omega = 0
        omega = 1

    fix_alpha = 1
        alpha = .0
       Malpha = 0
        ncatG = 4

        getSE = 0
 RateAncestor = 0
       method = 0
  fix_blength = 0
EOF

# 実行内容を表示
echo "Running codeml for ${SEQ_FILE_NAME} (Task ID: ${SLURM_ARRAY_TASK_ID})"

# codeml 実行
apptainer exec -e /usr/local/biotools/p/paml:4.9--h779adbc_6 codeml "$CTL_FILE"

このようなスクリプトを用いてPAMLを実行しようとしています。
しかし、解析に使用する系統樹に含まれる種と、解析に使用する配列ファイルに含まれる種が一致しない場合があります。
特に、系統樹に含まれる種が配列ファイルに含まれないために、PAMLがエラーを出して停止してしまいます。

この問題を解決するため、以下の機能を追加してください。
1. 系統樹を先に読み込んで、含まれる種のリストを取得する。
2. 各配列ファイルを読み込んで、含まれる種のリストを取得する。
3. 配列ファイルに含まれる種のリストが系統樹に含まれる種のリストと一致しない場合、以下のコマンドを用いてその種を除いた新しい系統樹ファイルを作成し、それを参照するようにする。
   ```
   apptainer exec /usr/local/biotools/n/newick_utils:1.6--hec16e2b_6 nw_prune tree.txt Bmor >tree_noBmor.nwk
   ```
   これはBmorを系統樹から除外する例です。実際には、配列ファイルに含まれない全ての種について同様の操作を行う必要があります。
4. その後、PAMLを実行する。