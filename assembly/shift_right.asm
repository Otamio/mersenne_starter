# shift_right.asm

# void shift_right(Bigint *a) {
# 	// Copy stuff
# 	for (int i = a->n; i>0; --i)
# 		a->digits[i] = a->digits[i-1];
# 	// Set lowest digit to 0
# 	a->digits[0] = 0;
# 	// Set to new larger size
# 	a->n += 1;
# }

  .data
PROMPT_SR:  .asciiz   "Shift Right Test\n"
newline:    .asciiz   "\n"
.align 2
Bigint_tmp1:  .space  1404

  .text
shift_right:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of a

# loop init
  lw $s7, 0($s0)              # $s7 = i (a->n)
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, SR_exit        # branch if i<=0

SR_loop:
  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a.digits[i]
  lw $t1, -4($t0)             # load a->digits[i-1] into $t1
  sw $t1, 0($t0)              # a->digits[i] = a->digits[i-1]

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, SR_exit        # branch if i<=0
  j SR_loop

SR_exit:
  sw $0, 4($s0)              # a->digits[0] = 0;
  lw $s7, 0($s0)             # $s7 = a->n;
  addi $s7, $s7, 1           # $s7 += 1;
  sw $s7, 0($s0)             # a->n = $s7 (a->n+=1);

SR_return:
  # recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra


print_big:
# save state
  addi $sp, $sp, -36          # 8 elements are pushed onto the stack
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

# read parameters
  move $s0, $a0               # $s0 is the starting address of b

# loop init
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = c (b.n-1)
  addi $s6, $s0, 4            # $s6 = &b.digits[]
  blt $s7, $0, PG_exit        # branch if c<0

# loop
BG_loop:
  move $t0, $s7               # $t0 = c
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4c
  add $t0, $s6, $t0           # $t0 = &b.digits[c]
  lw $a0, 0($t0)              # load b.digits[c]
  li $v0, 1                   # load print sys call
  syscall                     # print element
  addi $s7, $s7, -1           # $s7 = $s7 - 1
  blt $s7, $0, PG_exit        # branch if c<0
  j BG_loop

# end of loop (print newline)
PG_exit:
  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

PG_return:
# recover state
  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36           # 8 elements are popped from the stack

# return
  jr $ra


# This function clears the memory of an uninitialized big int
# store bigint
init_bigint:
  move $t0, $a0                # t0 is the address of the first element (n)
  addi $t1, $t0, 1400          # t1 is the (word) address of the last element

init_loop:
  bgt $t0, $t1, init_exit      # if $t0 > $t1, branch to exit
  sw $0, 0($t0)                # arr[$t0] = 0
  addi $t0, $t0, 4             # $t0 += 4 (go to next element)
  j init_loop

init_exit:
# return (no return value)
  jr $ra


# test driver
main:
# print test notification
  la $a0, test_d
  li $v0, 4
  syscall

  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

# init bigint
  la $a0, bigint1            # $a0 is the starting address of bigint1
  jal init_bigint

# load bigint
  li $t1, 1
  sw $t1, 0($a0)           # Bigint size is 1

  li $t1, 3
  sw $t1, 4($a0)           # the digit is 3

# call shift_right 3 times
  jal shift_right
  jal shift_right
  jal shift_right

# call print_big
  jal print_big

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
