
########################################
### s = mod_big(s, Mp);
### ------------------------------------
### s := $s2
### Mp := $s1
########################################


########################################
### s = sub_big(s, two);
### ------------------------------------
### s := $s2
### two := $s5
########################################

### call subtraction ###################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call sub_big
  move $a0, $s2
  move $a1, $s5
  la $a2, bigint19            # initialize $s4 (bigint22)
  jal sub_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### call modulus #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call mod_big
  move $a0, $s2
  move $a1, $s1
  la $a2, bigint19            # initialize $s4 (bigint22)
  jal mod_big

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20

### copy output #######################

# save state
  addi $sp, $sp, -20          # 4 elements are pushed onto the stack
  sw $t9, 16($sp)
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call copy_bigint
  move $a0, $v0
  move $a1, $s2
  jal copy_bigint

# restore state
  lw $t9, 16($sp)
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 20





########################################
### if (compare_big(s, zero) == 0) {}
### else {}
### ------------------------------------
### s := $s2
### zero := $s5
### compare_big(s, zero) == 0 := $t8
########################################

### call compare_big ###################

# save state
  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

# call compare_big
  move $a0, $s2
  move $a1, $s5
  jal compare_big

# restore state
  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

# get return value
  move $t8, $v0

### branch and exit ###################

  beq $t8, $0, LLT_IF_1

########################################
### return 0
########################################

  li $v0, 0
  j LLT_RET

########################################
### return 1
########################################

LLT_IF_1:
  li $v1, 1
  j LLT_RET



# get return value and print
  move $a0, $v0
  li $v0, 1                   # load print syscall code
  syscall                     # print result

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall
