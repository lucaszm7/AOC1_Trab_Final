# TRABALHO FINAL DA DICIPLINA DE AOC I
# ====================================
# <INSERIR NOME DO PROJETO>

.data

.text
j main

DEF_COR:
li $s4, 0xFF0000 # VERMELHO => MACA
li $s5, 0xADFF2F # BLUE_VIOLET => COR DA COBRA
li $s2, 0x008000 # VERDE_MAIS_ESCURO => BORDAS
li $s3, 0x006400 # VERDE_ESCURO => COR DO FUNDO
jr $ra

DEF_INICIAL:
lui $s0, 0x1000 # INICIO
li $s1, 8192 # QUANTIDADE DE PONTOS NA TELA => (512 * 256) / 16

# ==== DEF COBRA ==== *
li $t0, 4 # LARGURA (FIXA)
li $t1, 4 # ALTURA (FIXA)
li $t2, 1 # TAMANHO VARIAVEL
li $t3, 16640 # POSICAO DA CABEÇA

li $t4, -1 # PONTUAÇÃO
lui $a3, 0x1001
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


DESENHA_BORDAS:

BORDAS_HORIZONTAIS:
and $s0, $s0, $zero
lui $s0, 0x1000
li $s1, 512
C_HORIZONTAIS:
sw $s2, 0($s0)
addi $s0, $s0, 4
addi $s1, $s1, -1
bne $s1, $zero, C_HORIZONTAIS

and $s0, $s0, $zero
lui $s0, 0x1000
addi $s0, $s0, 30720
li $s1, 512
B_HORIZONTAIS:
sw $s2, 0($s0)
addi $s0, $s0, 4
addi $s1, $s1, -1
bne $s1, $zero, B_HORIZONTAIS

li $v0, 4
li $v1, 0
BORDAS_LATERAIS:
and $s0, $s0, $zero
lui $s0, 0x1000
add $s0, $s0, $v1
li $s1, 256
C_LATERAIS:
sw $s2, 0($s0)
addi $s0, $s0, 512
addi $s1, $s1, -1
bne $s1, $zero, C_LATERAIS
addi $v0, $v0, -1
addi $v1, $v1, 4
bne $v0, $zero, BORDAS_LATERAIS

li $v0, 4
li $v1, 0
BORDAS_LATERAIS_2:
and $s0, $s0, $zero
lui $s0, 0x1000
addi $s0, $s0, 508
add $s0, $s0, $v1
li $s1, 256
D_LATERAIS:
sw $s2, 0($s0)
addi $s0, $s0, 512
addi $s1, $s1, -1
bne $s1, $zero, D_LATERAIS
addi $v0, $v0, -1
addi $v1, $v1, -4
bne $v0, $zero, BORDAS_LATERAIS_2

jr $ra


DESENHA_COBRA:

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
j DESENHA_PEDACOS


DESENHA_PEDACOS:
move $t6, $t4
beq $t6, $zero, DESENHA_PEDACOS_FIM
lui $t7, 0x1001
DESENHA_PEDACO_2:
move $a1, $t1 # ALTURA
and $s0, $s0, $zero
lui $s0, 0x1000
lw $v0, 0($t7)
add $s0, $s0, $v0 # POSICAO
DESENHA_COLUNA_PEDACO:
mul $a0, $t2, $t0 # TAMANHO DA COBRA
DESENHA_LINHA_PEDACO:
sw $s5, 0($s0)
addi $s0, $s0, 4
addi $a0, $a0, -1
bne $a0, $zero, DESENHA_LINHA_PEDACO
addi $a1, $a1, -1
mul $t5, $t0, $t1
mul $t5, $t5, $t2
addi $t5, $t5, -512
mul $t5, $t5, -1
add $s0, $s0, $t5
bne $a1, $zero, DESENHA_COLUNA_PEDACO

addi $t6, $t6, -1
addi $t7, $t7, 4
bne $t6, $zero, DESENHA_PEDACO_2
DESENHA_PEDACOS_FIM:
jr $ra


COBRA_ESQUERDA:
addi $t3, $t3, -16
jr $ra

COBRA_DIREITA:
addi $t3, $t3, 16
jr $ra

COBRA_CIMA:
addi $t3, $t3, -2048
jr $ra

COBRA_BAIXO:
addi $t3, $t3, 2048
jr $ra


DELAY:
li $v0, 32
li $t7, -3
move $t6, $t4
mul $t6, $t6, $t7
li $a0, 200 # 200 EH O IDEAL
add $a0, $a0, $t6
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
j APAGA_PEDACO


APAGA_PEDACO:
move $t6, $t4
beq $t6, $zero, APAGA_PEDACOS_FIM
lui $t7, 0x1001
APAGA_PEDACO_2:

move $a1, $t1 # ALTURA
and $s0, $s0, $zero
lui $s0, 0x1000
lw $v0, 0($t7)
add $s0, $s0, $v0 # POSICAO
APAGA_COLUNA_PEDACO:
mul $a0, $t2, $t0 # TAMANHO DA COBRA
APAGA_LINHA_PEDACO:
sw $s3, 0($s0)
addi $s0, $s0, 4
addi $a0, $a0, -1
bne $a0, $zero, APAGA_LINHA_PEDACO
addi $a1, $a1, -1
mul $t5, $t0, $t1
mul $t5, $t5, $t2
addi $t5, $t5, -512
mul $t5, $t5, -1
add $s0, $s0, $t5
bne $a1, $zero, APAGA_COLUNA_PEDACO

addi $t6, $t6, -1
addi $t7, $t7, 4
bne $t6, $zero, APAGA_PEDACO_2
APAGA_PEDACOS_FIM:

jr $ra


COLISOES:
#COLISAO_MACA:
beq $s7, $t3, MACA_INIT

and $v0, $v0, $zero
add $v0, $v0, $t3 # POSICAO

li $v1, 512
slt $t9, $v0, $v1
bne $t9, $zero, main

div $v0, $v1
mfhi $v1
beq $v1, $zero, main

li $v0, 30720
li $v1, 1
slt $t9, $v0, $t3
beq $t9, $v1, main

li $v0, 2048
li $v1, 2544
move $t9, $t3
sub $t9, $t9, $v1

div $t9, $v0
mfhi $v1
beq $v1, $zero, main

# === COBRA === #
move $v0, $t4
lui $v1, 0x1001
beq $v0, $zero, FIM_COLISAO_CORPO_CORBRA
COLISAO_CORPO_COBRA:

lw $t5, 0($v1)
beq $t5, $t3, main

addi $v1, $v1, 4
addi $v0, $v0, -1
bne $v0, $zero, COLISAO_CORPO_COBRA
FIM_COLISAO_CORPO_CORBRA:
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
li $v0, 1
move $a1, $t1 # ALTURA
and $s0, $s0, $zero
lui $s0, 0x1000
add $s0, $s0, $s7 # POSICAO
DESENHA_COLUNA_MACA:
mul $a0, $v0, $t0 # TAMANHO DA COBRA
DESENHA_LINHA_MACA:
sw $s4, 0($s0)
addi $s0, $s0, 4
addi $a0, $a0, -1
bne $a0, $zero, DESENHA_LINHA_MACA
addi $a1, $a1, -1
mul $t5, $t0, $t1
mul $t5, $t5, $v0
addi $t5, $t5, -512
mul $t5, $t5, -1
add $s0, $s0, $t5
bne $a1, $zero, DESENHA_COLUNA_MACA
jr $ra


COLISAO_MACA:
beq $s7, $t3, MACA_INIT
jr $ra


ATT_POSICOES:
move $v1, $t4
move $t5, $v1
#beq $t5, $zero, ATT_POSICOES_FIM
#addi $t5, $t5, -1
li $t6, 4

ATT_POSICOES_2:
beq $v1, $zero, ATT_POSICOES_FIM
lui $v0, 0x1001
mul $t7, $t6, $v1
add $v0, $v0, $t7
lw $t7, -4($v0)
sw $t7, 0($v0)
addi $v1, $v1, -1
addi $v0, $v0, -4
j ATT_POSICOES_2

ATT_POSICOES_FIM:
lui $v0, 0x1001
sw $t3, 0($v0)
jr $ra 


main:
jal DEF_INICIAL
jal DEF_COR
jal DESENHA_FUNDO
jal DESENHA_BORDAS

MACA_INIT:
addi $t4, $t4, 1
#jal ATT_POSICOES
# jal SHOW_PONTUACAO
jal SET_MACA
jal DESENHA_MACA

LOOP:
jal DESENHA_COBRA
jal DESENHA_MACA
jal DELAY
jal APAGA_COBRA
jal ATT_POSICOES
jal MOVEMENT
jal COLISOES
bne $v0, $v1, LOOP
j main
