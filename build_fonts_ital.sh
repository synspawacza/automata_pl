#!/bin/bash

#workaround for italics - replace with different characters:
#0104	1ea0	Ą	Ạ
#0105	1ea1	ą	ạ
#0106	010a	Ć	Ċ
#0107	010b	ć	ċ
#0118	0116	Ę	Ė
#0119	0117	ę	ė
#0141	013f	Ł	Ŀ
#0142	0140	ł	ŀ
#0143	1e44	Ń	Ṅ
#0144	1e45	ń	ṅ
#015a	1e60	Ś	Ṡ
#015b	1e61	ś	ṡ
#0179	1e8e	Ź	Ẏ
#017a	1e8f	ź	ẏ
#017b	1e92	Ż	Ẓ
#017c	1e93	ż	ẓ

function build_font() {
    echo "building font ${1}"

    mkdir -p assembly/font/font_${1}.dat/
    mkdir -p assembly/font/font_${1}.dtt/
    mkdir -p output/font/
    mkdir -p output/font/

    # add ĄąĆćĘęŁłŃńŚśŹźŻż
    ./tools/put_glyphs.py unpacked/font/font_${1}.dat/font_${1}.ftb unpacked/font/font_${1}.dtt/font_${1}.wtp_00${2}.dds \
        assembly/font/font_${1}.dat/font_${1}.ftb assembly/font/font_${1}.dtt/font_${1}.wtp_00${2}.png --page ${2} \
        --char $((16#0104)) fonts/${1}/0104.png \
        --char $((16#0105)) fonts/${1}/0105.png \
        --char $((16#0106)) fonts/${1}/0106.png \
        --char $((16#0107)) fonts/${1}/0107.png \
        --char $((16#0118)) fonts/${1}/0118.png \
        --char $((16#0119)) fonts/${1}/0119.png \
        --char $((16#0141)) fonts/${1}/0141.png \
        --char $((16#0142)) fonts/${1}/0142.png \
        --char $((16#0143)) fonts/${1}/0143.png \
        --char $((16#0144)) fonts/${1}/0144.png \
        --char $((16#015a)) fonts/${1}/015a.png \
        --char $((16#015b)) fonts/${1}/015b.png \
        --char $((16#0179)) fonts/${1}/0179.png \
        --char $((16#017a)) fonts/${1}/017a.png \
        --char $((16#017b)) fonts/${1}/017b.png \
        --char $((16#017c)) fonts/${1}/017c.png \
        --char $((16#1ea0)) fonts/${1}/1ea0.png \
        --char $((16#1ea1)) fonts/${1}/1ea1.png \
        --char $((16#010a)) fonts/${1}/010a.png \
        --char $((16#010b)) fonts/${1}/010b.png \
        --char $((16#0116)) fonts/${1}/0116.png \
        --char $((16#0117)) fonts/${1}/0117.png \
        --char $((16#013f)) fonts/${1}/013f.png \
        --char $((16#0140)) fonts/${1}/0140.png \
        --char $((16#1e44)) fonts/${1}/1e44.png \
        --char $((16#1e45)) fonts/${1}/1e45.png \
        --char $((16#1e60)) fonts/${1}/1e60.png \
        --char $((16#1e61)) fonts/${1}/1e61.png \
        --char $((16#1e8e)) fonts/${1}/1e8e.png \
        --char $((16#1e8f)) fonts/${1}/1e8f.png \
        --char $((16#1e92)) fonts/${1}/1e92.png \
        --char $((16#1e93)) fonts/${1}/1e93.png

    convert -define dds:mipmaps=0 assembly/font/font_${1}.dtt/font_${1}.wtp_00${2}.png assembly/font/font_${1}.dtt/font_${1}.wtp_00${2}.dds
    
    # add ĄąĆćĘęŃńŚśŹźŻż (skip Ł and ł)
    if [ -e unpacked/font/font_${1}.dat/font_${1}.ktb ]
    then
        ./tools/clone_kernings.py unpacked/font/font_${1}.dat/font_${1}.ktb assembly/font/font_${1}.dat/font_${1}.ktb \
            --char $((16#0041)) $((16#0104)) \
            --char $((16#0061)) $((16#0105)) \
            --char $((16#0043)) $((16#0106)) \
            --char $((16#0063)) $((16#0107)) \
            --char $((16#0045)) $((16#0118)) \
            --char $((16#0065)) $((16#0119)) \
            --char $((16#004E)) $((16#0143)) \
            --char $((16#006E)) $((16#0144)) \
            --char $((16#0053)) $((16#015a)) \
            --char $((16#0073)) $((16#015b)) \
            --char $((16#005A)) $((16#0179)) \
            --char $((16#007A)) $((16#017a)) \
            --char $((16#005A)) $((16#017b)) \
            --char $((16#007A)) $((16#017c)) \
            --char $((16#0041)) $((16#1ea0)) \
            --char $((16#0061)) $((16#1ea1)) \
            --char $((16#0043)) $((16#010a)) \
            --char $((16#0063)) $((16#010b)) \
            --char $((16#0045)) $((16#0116)) \
            --char $((16#0065)) $((16#0117)) \
            --char $((16#004E)) $((16#1e44)) \
            --char $((16#006E)) $((16#1e45)) \
            --char $((16#0053)) $((16#1e60)) \
            --char $((16#0073)) $((16#1e61)) \
            --char $((16#005A)) $((16#1e8e)) \
            --char $((16#007A)) $((16#1e8f)) \
            --char $((16#005A)) $((16#1e92)) \
            --char $((16#007A)) $((16#1e93))
    fi

    ./tools/repack_wtp.py unpacked/font/font_${1}.dat/font_${1}.wta unpacked/font/font_${1}.dtt/font_${1}.wtp \
        --texture ${2} assembly/font/font_${1}.dtt/font_${1}.wtp_00${2}.dds \
        assembly/font/font_${1}.dat/font_${1}.wta assembly/font/font_${1}.dtt/font_${1}.wtp

    ./tools/repack_dat.py data/font/font_${1}.dat output/font/font_${1}.dat assembly/font/font_${1}.dat/*
    ./tools/repack_dat.py data/font/font_${1}.dtt output/font/font_${1}.dtt assembly/font/font_${1}.dtt/*.wtp
}

build_font 11 2
