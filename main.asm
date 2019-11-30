# TRABALHO FINAL DA DICIPLINA DE AOC I
# ====================================
# <INSERIR NOME DO PROJETO>

.data
pontuacao: .asciiz "Pontuacao: "

.text
j main

DEF_COR:
li $s4, 0xFF0000 # VERMELHO => MACA
li $s5, 0xADFF2F # BLUE_VIOLET => COR DA COBRA
li $s2, 0xFF0000 # GRAY11 => BORDAS
li $s3, 0x006400 # GRAY => COR DO FUNDO
jr $ra

DEF_INICIAL:
lui $s0, 0x1000 # INICIO
li $s1, 8192 # QUANTIDADE DE PONTOS NA TELA => (512 * 256) / 16

# ==== DEF COBRA ==== *
li $t0, 4 # LARGURA (FIXA)
li $t1, 4 # ALTURA (FIXA)
li $t2, 1 # TAMANHO VARIAVEL
li $t3, 16640 # POSICAO DA CABEÇA

li $t4, 0 # PONTUAÇÃO
lui $a3, 0xffff
addi $a3, $a3, 12
sw $t4, 0($a3)

jr $ra

DESENHA_FUNDO:
and $s0, $s0, $zero
lui $s0, 0x1000
li $s1, 8192
C_DESENHA_FUNDO:
sw $s3, 0($s0)
addi $s0, $s0, 4
addi $s1, $s1, -1
bne $s1, $zero, C_DESENHA_FUNDO
jr $ra


DESENHA_COBRA:
add $s0, $s0, $t3 # POSICAO
sw $t3, 0($sp)
addi $sp, $sp, -4
DESENHA_PEDACO:
move $a1, $t1 # ALTURA
and $s0, $s0, $zero
lui $s0, 0x1000
add $s0, $s0, $t3 # POSICAO
DESENHA_COLUNA_COBRA:
mul $a0, $t2, $t0 # TAMANHO DA COBRA
DESENHA_LINHA_COBRA:
sw $s5, 0($s0)
addi $s0, $s0, 4
addi $a0, $a0, -1
bne $a0, $zero, DESENHA_LINHA_COBRA
addi $a1, $a1, -1
mul $t5, $t0, $t1
mul $t5, $t5, $t2
addi $t5, $t5, -512
mul $t5, $t5, -1
add $s0, $s0, $t5
bne $a1, $zero, DESENHA_COLUNA_COBRA
jr $ra


COBRA_ESQUERDA:
sw $t3, 0($sp)
addi $t3, $t3, -16
jr $ra

COBRA_DIREITA:
sw $t3, 0($sp)
addi $t3, $t3, 16
jr $ra

COBRA_CIMA:
sw $t3, 0($sp)
addi $t3, $t3, -2048
jr $ra

COBRA_BAIXO:
sw $t3, 0($sp)
addi $t3, $t3, 2048
jr $ra


DELAY:
li $v0, 32
li $a0, 200 # 200 EH O IDEAL
syscall
jr $ra


APAGA_COBRA:
move $a1, $t1 # ALTURA
and $s0, $s0, $zero
lui $s0, 0x1000
add $s0, $s0, $t3 # POSICAO
APAGA_COLUNA_COBRA:
mul $a0, $t2, $t0 # TAMANHO DA COBRA
APAGA_LINHA_COBRA:
sw $s3, 0($s0)
addi $s0, $s0, 4
addi $a0, $a0, -1
bne $a0, $zero, APAGA_LINHA_COBRA
addi $a1, $a1, -1
mul $t5, $t0, $t1
mul $t5, $t5, $t2
addi $t5, $t5, -512
mul $t5, $t5, -1
add $s0, $s0, $t5
bne $a1, $zero, APAGA_COLUNA_COBRA
jr $ra


COLISOES:

and $v0, $v0, $zero
add $v0, $v0, $t3 # POSICAO

li $v1, 512

slt $t9, $v0, $v1
bne $t9, $zero, main

div $v0, $v1
mfhi $v1
beq $v1, $zero, main

li $v1, 31216
div $v1, $v0
mfhi $v1
beq $v1, $zero, main

li $v1, 0
beq $v0, $v1, main
li $v1, 496    # TEM 32 QUADRADINHOS DE LARGURA
beq $v0, $v1, main
li $v1, 30720  # TEM 16 QUADRADINHOS DE ALTURA
beq $v0, $v1, main
li $v1, 31216  # TEM 16 QUADRADINHOS DE ALTURA
beq $v0, $v1, main

jr $ra


MOVEMENT:
lui $t9, 0xffff
lw $v0, 4($t9)
li $t5, 119 # W
li $t6, 97  # A
li $t7, 115 # S
li $t8, 100 # D
beq $v0, $t5, COBRA_CIMA
beq $v0, $t6, COBRA_ESQUERDA
beq $v0, $t7, COBRA_BAIXO
beq $v0, $t8, COBRA_DIREITA
j COBRA_DIREITA


SET_MACA:
li $a1, 30  #GEN EIXO X
li $v0, 42  #generates the random number.
syscall
move $s7, $a0
li $v0, 16
mul $s7, $s7, $v0
addi $s7, $s7, 16
li $a1, 14  #GEN EIXO X
li $v0, 42  #generates the random number.
syscall
li $v0, 2048
mul $a0, $a0, $v0
addi $a0, $a0, 2048
add $s7, $s7, $a0
jr $ra


DESENHA_MACA:
DESENHA_PEDACO_MACA:
move $a1, $t1 # ALTURA
and $s0, $s0, $zero
lui $s0, 0x1000
add $s0, $s0, $s7 # POSICAO
DESENHA_COLUNA_MACA:
mul $a0, $t2, $t0 # TAMANHO DA COBRA
DESENHA_LINHA_MACA:
sw $s2, 0($s0)
addi $s0, $s0, 4
addi $a0, $a0, -1
bne $a0, $zero, DESENHA_LINHA_MACA
addi $a1, $a1, -1
mul $t5, $t0, $t1
mul $t5, $t5, $t2
addi $t5, $t5, -512
mul $t5, $t5, -1
add $s0, $s0, $t5
bne $a1, $zero, DESENHA_COLUNA_MACA
jr $ra


COLISAO_MACA:
beq $s7, $t3, MACA_INIT
jr $ra


main:
jal DEF_INICIAL
jal DEF_COR
jal DESENHA_FUNDO

MACA_INIT:
addi $t4, $t4, 1
sw $t4, 0($a3)
jal SET_MACA
jal DESENHA_MACA

LOOP:
jal DESENHA_COBRA
jal DELAY
jal APAGA_COBRA
jal COLISOES
jal MOVEMENT
jal COLISAO_MACA
bne $v0, $v1, LOOP
j main
