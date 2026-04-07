#!/bin/bash
#SBATCH --job-name=bsA_array
#SBATCH --cpus-per-task=1
#SBATCH --partition=short
#SBATCH --time=1:00:00
#SBATCH --array=1-90
#SBATCH --error=/home/kosukesano/tools/for_paml/251014/IAA/bsA/log/%x_%A_%a.err.log
#SBATCH --output=/home/kosukesano/tools/for_paml/251014/IAA/bsA/log/%x_%A_%a.out.log

######### YOUR JOB #########

# ディレクトリパス
FASTA_DIR="/home/kosukesano/tools/for_paml/251014/IAA/data"
TREE_FILE="/home/kosukesano/tools/for_paml/251014/IAA/tree.txt"
OUT_DIR="/home/kosukesano/tools/for_paml/251014/IAA/bsA/result"
CTL_DIR="/home/kosukesano/tools/for_paml/251014/IAA/bsA/ctl"
WORK_DIR="/home/kosukesano/tools/for_paml/251014/IAA/bsA"
FILE_LIST="${FASTA_DIR}/file_list.txt"

# 出力ディレクトリを作成
mkdir -p "$OUT_DIR"
mkdir -p "$CTL_DIR"
mkdir -p "$WORK_DIR/log"

# JOB配列番号に対応するFASTAファイルを取得
SEQ_FILE_NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$FILE_LIST")
SEQ_FILE="${FASTA_DIR}/${SEQ_FILE_NAME}"

# 拡張子を除いたベース名を取得
BASENAME=$(basename "$SEQ_FILE_NAME" .fasta)

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

上記ファイルはfile_list.txtに含まれるファイルを指定のディレクトリから取得し、codemlを実行するためのCTLファイルを生成します。

このスクリプトについて、以下の/home/kosukesano/tools/for_paml/251017/test/species_check/reorganized_file_list.txtに記載されているファイルを記載のパスより取得し、codemlを実行するためのCTLファイルを生成するように改造してください。

### reorganized_file_list.txtの一部。各配列ファイルの/home/kosukesano/tools/for_paml/251017/test/以下の相対パスが記されている。
species_check/complete_files/OG0000083.fasta_8.fna
species_check/complete_files/OG0000083.fasta_9.fna
species_check/missing_files/Dmel/OG0000199.fasta_1.fna
species_check/missing_files/Dmel/OG0000199.fasta_10.fna
species_check/missing_files/Dmel/OG0000199.fasta_11.fna
species_check/missing_files/Dmel/OG0000199.fasta_2.fna

また、使用する種系統樹ファイルは以下のディレクトリ/home/kosukesano/tools/for_paml/251017/test/treeに格納されています。
kosukesano@a001:~/tools/for_paml/251017/test/tree$ ls
complete_tree.txt  tree_noAgra.nwk  tree_noAgra_Orus.nwk  tree_noBmor.nwk  tree_noBmor_Dmel.nwk  tree_noBmor_Dpon.nwk  tree_noDmel.nwk  tree_noEbra.nwk  tree_noMtri.nwk
kosukesano@a001:~/tools/for_paml/251017/test/tree$

reorganized_file_list.txtの記載では、各配列ファイルは中に含まれる種に応じてディレクトリが分けられています。例えば全ての種が含まれている場合はspecies_check/complete_files/に、Dmelが欠損している場合はspecies_check/missing_files/Dmel/に格納されています。
CTLファイルを生成する際にパスの記述から使用するべきツリーファイルを選択し、適切なパスを設定する機能も追加してください。

mlarva	llarva	Adult
3.42678	0.434454	131.651
2.607511	0.803535	10.61966
2.256859	0	30.87488


g8639 OG0008894	Agra_P_050301079.1, Agra_P_050307630.1					Ebra_g1777.t1, Ebra_g1778.t1	Escr_g1880.t1, Escr_g1881.t1		Mtri_g7149.t1, Mtri_g7150.t1			SM1_g8638.t1, SM1_g8639.t2
g4416 OG0002135	Agra_P_050296846.1, Agra_P_050296853.1, Agra_P_050315004.1	Bmor_XP_004933335.2	Cass_AG9764303.1		Dpon_P_048518069.1	Ebra_g4586.t1, Ebra_g4587.t1	Escr_g4722.t1, Escr_g4723.t1	Ldef_g10224.t1	Mtri_g6822.t1	Orus_g9763.t1, Orus_g9765.t1	Pcer_g3786.t1	SM1_g4415.t1	Sory_P_030764969.1	Tcas_P_015837687.1
g2566 OG0000326	Agra_P_050304773.1, Agra_P_050309216.1, Agra_P_050314569.1, Agra_P_050314570.1	Bmor_NP_001036872.1, Bmor_NP_001140192.1, Bmor_XP_004921596.1, Bmor_XP_004932389.1, Bmor_XP_037876240.1	Cass_AG9759440.1	Dmel_NP_001259867.1, Dmel_NP_001260940.1	Dpon_P_019765308.1, Dpon_P_019765311.1, Dpon_P_019766593.1	Ebra_g1373.t1, Ebra_g1374.t1, Ebra_g9366.t1	Escr_g1430.t1, Escr_g1431.t1, Escr_g9326.t1	Ldef_g13438.t1, Ldef_g26763.t1, Ldef_g26764.t1, Ldef_g930.t1	Mtri_g10395.t1, Mtri_g10569.t1, Mtri_g791.t1, Mtri_g794.t1	Orus_g11041.t1, Orus_g20773.t2, Orus_g20775.t1, Orus_g20776.t1, Orus_g623.t1, Orus_g624.t1, Orus_g625.t1, Orus_g626.t1, Orus_g627.t1, Orus_g630.t1, Orus_g631.t1, Orus_g8680.t1	Pcer_g17550.t1, Pcer_g17551.t1, Pcer_g23780.t1, Pcer_g23800.t1, Pcer_g9733.t1	SM1_g1010.t1, SM1_g11231.t1, SM1_g11233.t1, SM1_g11464.t1, SM1_g11867.t1, SM1_g13386.t1, SM1_g2566.t1, SM1_g3906.t1, SM1_g7210.t1	Sory_P_030748329.1, Sory_P_030757212.1	Tcas_P_008199365.1, Tcas_P_015838652.1
g12995