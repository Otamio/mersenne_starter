# sub_big.asm

  .data
PROMPT_SUB:   .asciiz "Subtraction Tests\n"
newline:      .asciiz "\n"
.align 2
Bigint_tmp1:  .space  1404
.align 2
Bigint_tmp2:  .space  1404
.align 2
Bigint_tmp3:  .space  1404

  .text

##########################################################
### Function: sub_big
###-------------------------------------------------------
### % Code Segment %
### (1)   Bigint sub_big(Bigint a, Bigint b)
### (2)   {
### (3)     Bigint c;
### (4)     c.n = a.n;
### (5)   	for (int i = 0; i < c.n; ++i)
### (6)    		c.digits[i] = 0;
### (7)
### (8)    	int carry = 0;
### (9)   	for (int i = 0; i < b.n; ++i) {
### (10)  		c.digits[i] = a.digits[i] - b.digits[i] + carry;
### (11)   		if (c.digits[i] < 0) {
### (12)   			carry = -1;
### (13)   			c.digits[i] += 10;
### (14)   		} else
### (15)   			carry = 0;
### (16)   	}
### (17)
### (18)   	if (a.n > b.n) {
### (19)   		for (int i=b.n; i<a.n; ++i) {
### (20)  			c.digits[i] = a.digits[i] + carry;
### (21)   			if (c.digits[i]<0) {
### (22)   				carry = -1;
### (23)   				c.digits[i] += 10;
### (24)   			} else
### (25)   				carry = 0;
### (26)   		}
### (27)   	}
### (28)
### (29)   	compress(&c);
### (30)   	return c;
### (31)  }
###-------------------------------------------------------
### % Variable Table %
###   a := $s0
###   b := $s2
###   c := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s6
###   carry         := $s7
###   c.digits[i]   := $t8
###-------------------------------------------------------
### Since we cannot pow bigint in place, a temporary bigint
###   must be allocated to the function, which we call c
### That is, c is a pointer to an empty bigint
##########################################################

sub_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1)   Bigint sub_big(Bigint a, Bigint b)
###-------------------------------------------------------
###   a := $s0
###   b := $s2
###   c := $s2, c is an empty bigint
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c

##########################################################
### (3)     Bigint c;
### (5)   	for (int i = 0; i < c.n; ++i)
### (6)    		c.digits[i] = 0;
###-------------------------------------------------------
###   c := $s2, c is an empty bigint
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  move $a0, $s2
  jal init_bigint

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

##########################################################
### (4)     c.n = a.n;
###-------------------------------------------------------
###   a := $s0
###   c := $s2
##########################################################

  lw $t0, 0($s0)              # $t0 = a.n
  sw $t0, 0($s2)              # c.n = a.n

##########################################################
### (8)    	int carry = 0;
###-------------------------------------------------------
###   carry := $s7
##########################################################

  li $s7, 0                   # $s7 is carry


##########################################################
### (9)   	for (int i = 0; i < b.n; ++i) {
###-------------------------------------------------------
###   a             := $s0
###   b             := $s1
###   c             := $s2
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s6
###   carry         := $s7
###   b.n           := $t9
##########################################################

# prepare for loop 1
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  lw $t9, 0($s1)              # $t9 = b.n
  li $s6, 0                   # $s7 = 0 (i)

SUB_loop1:
  bge $s6, $t9, SUB_loop1_end # branch if i>=b.n

##########################################################
### (10)  		c.digits[i] = a.digits[i] - b.digits[i] + carry;
###-------------------------------------------------------
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s6
###   carry         := $s7
###   c.digits[i]   := $t8
##########################################################

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s3           # $t2 = &(a.digits[i])
  lw $t8, 0($t2)              # $t8 = a.digits[i]

  add $t2, $t1, $s4           # $t2 = &(b.digits[i])
  lw $t2, 0($t2)              # $t2 = b.digits[i]
  sub $t8, $t8, $t2           # $t8 = a.digits[i] - b.digits[i]

  add $t8, $t8, $s7           # $t8 = a.digits[i] - b.digits[i] + carry

  add $t2, $t1, $s5           # $t2 = &(c.digits[i])

  sw $t8, 0($t2)              # c.digits[i] = $t8

##########################################################
### (11)   		if (c.digits[i] < 0) {
###-------------------------------------------------------
###   c.digits[i]   := $t8
##########################################################

  blt $t8, $0, SUB_loop1_if   # branch if c.digits[i] <= 0 (optimized)

##########################################################
### (15)   			carry = 0;
###-------------------------------------------------------
###   carry         := $s7
##########################################################

  li $s7, 0                   # carry = 0
  j SUB_loop1_if_end

SUB_loop1_if:

##########################################################
### (12)   			carry = -1;
### (13)   			c.digits[i] += 10;
###-------------------------------------------------------
###   carry         := $s7
###   c.digits[i]   := $t8
##########################################################

  li $s7, -1                  # carry = -1

  addi $t8, $t8, 10           # $t8 += 10
  sw $t8, 0($t2)              # c.digits[i] += 10

  j SUB_loop1_if_end

SUB_loop1_if_end:

##########################################################
### (9)   	for (int i = 0; i < b.n; ++i) {
###-------------------------------------------------------
###   i             := $s6
##########################################################

  addi $s6, $s6, 1            # ++i
  j SUB_loop1

SUB_loop1_end:

##########################################################
### (18)   	if (a.n > b.n) {
###-------------------------------------------------------
###   a.n             := $t8
###   b.n             := $t9
##########################################################

  lw $t9, 0($s1)              # $t9 = b.n
  lw $t8, 0($s0)              # $t8 = a.n
  ble $t8, $t9, SUB_if_end    # branch if a.n <= b.n

##########################################################
### (19)   		for (int i=b.n; i<a.n; ++i) {
###-------------------------------------------------------
###   i               := $s6
###   a.n             := $t8
###   b.n             := $t9
##########################################################

  move $s6, $t9               # $s6 = b.n (i)

SUB_if_loop:
  bge $s6, $t8, SUB_if_end    # branch if i>= a.n

##########################################################
### (20)  			c.digits[i] = a.digits[i] + carry;
###-------------------------------------------------------
###   i                   := $s6
###   &(c.digits[i])      := $t2
###   a.digits[i] + carry := $t7
##########################################################

  sll $t1, $s6, 2             # $t1 = 4i
  add $t2, $t1, $s3           # $t2 = &(a.digits[i])
  lw $t7, 0($t2)              # $t7 = a.digits[i]

  add $t7, $t7, $s7           # $t7 = a.digits[i] + carry

  add $t2, $t1, $s5           # $t2 = &(c.digits[i])
  sw $t7, 0($t2)              # c.digits[i] = a.digits[i] + carry

##########################################################
### (21)   			if (c.digits[i]<0) {
###-------------------------------------------------------
###   c.digits[i]         := $t7
##########################################################

SUB_if_if:
  blt $t7, $0, SUB_if_if_t    # branch if $t7 < 0

##########################################################
### (25)   				carry = 0;
###-------------------------------------------------------
###   carry               := $s7
##########################################################

  li $s7, 0                   # carry = 0
  j SUB_if_if_end

SUB_if_if_t:

##########################################################
### (22)   				carry = -1;
### (23)   				c.digits[i] += 10;
###-------------------------------------------------------
###   carry               := $s7
###   c.digits[i]         := $t7
##########################################################

  li $s7, -1                  # carry = -1
  addi $t7, $t7, 10           # $t7 = $t7 + 10
  sw $t7, 0($t2)              # c.digits[i] += 10
  j SUB_if_if_end

SUB_if_if_end:

##########################################################
### (19)   		for (int i=b.n; i<a.n; ++i) {
###-------------------------------------------------------
###   i               := $s6
##########################################################

  addi $s6, $s6, 1            # i += 1
  j SUB_if_loop

SUB_if_end:

##########################################################
### (29)   	compress(&c);
###-------------------------------------------------------
###   c               := $s2
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call compress
#**#######################################################

  move $a0, $s2
  jal compress

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 12($sp)
  lw $a1, 8($sp)
  lw $a2, 4($sp)
  lw $a3, 0($sp)
  addi $sp, $sp, 16

SUB_return:

##########################################################
### (30)   	return c;
###-------------------------------------------------------
###   c               := $s2
##########################################################

  move $v0, $s2

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: compress
###-------------------------------------------------------
### % Code Segment %
### (1) void compress(Bigint *a) {
### (2)   for (int i = a->n - 1; i > 0; --i) {
### (3)     if (a->digits[i] == 0)
### (4)       continue;
### (5)     else {
### (6)       a->n = i+1;
### (7)       return;
### (8)     }
### (9) 	}
### (10) }
###-------------------------------------------------------
### % Variable Table %
###   p                :=   $s0
###   i                :=   $s7
###   a->digits        :=   $s6
###   &(a->digits[i])  :=   $t0
###   a->digits[i]     :=   $t1
##########################################################

compress:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void compress(Bigint *a) {
###-------------------------------------------------------
### a := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a

##########################################################
### (2)   for (int i = a->n - 1; i > 0; --i) {
###-------------------------------------------------------
### p   :=  $s0
### i   :=  $s7
##########################################################

# initialize the loop
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = i (a->n-1)
  addi $s6, $s0, 4            # $s6 = &(a->digits[])
  ble $s7, $0, CPS_exit       # branch if i<=0

CPS_loop:

##########################################################
### (3)     if (a->digits[i] == 0)
###-------------------------------------------------------
### p                :=   $s0
### i                :=   $s7
### a->digits        :=   $s6
### &(a->digits[i])  :=   $t0
### a->digits[i]     :=   $t1
##########################################################

  move $t0, $s7               # $t0 = i
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4i
  add $t0, $s6, $t0           # $t0 = &a->digits[i]
  lw $t1, 0($t0)              # load a->digits[i] into $t1
  bne $t1, $0, CPS_exit       # branch if (a->digits[i] != 0)

##########################################################
### (2)   for (int i = a->n - 1; i > 0; --i) {
###
### (4)       continue;
###-------------------------------------------------------
### i   :=  $s7
##########################################################

  addi $s7, $s7, -1           # --i;
  ble $s7, $0, CPS_exit       # branch if i<=0
  j CPS_loop

CPS_exit:

##########################################################
### (6)       a->n = i+1;
### (7)       return;
###-------------------------------------------------------
### i   :=  $s7
##########################################################

  addi $s5, $s7, 1            # new size should be i+1 (since i is the index)
  sw $s5, 0($s0)              # update the new value to the memory address

CPS_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


##########################################################
### Function: init_bigint
###-------------------------------------------------------
### % Code Segment %
### (1) void init_bigint(Bigint *a) {
### (2)   for (int i = a; i < a+1400; ++i)
### (3)     *a = 0;
### (4) }
###-------------------------------------------------------
### % Variable Table %
###   a       :=  $t0
###   a+1400  :=  $t1
##########################################################

init_bigint:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void init_bigint(Bigint *a) {}
###-------------------------------------------------------
### a := $t0
##########################################################

  move $t0, $a0                # t0 is the address of the first element (n)

##########################################################
### (2)   for (int i = a; i < a+1400; ++i)
###-------------------------------------------------------
### a       :=  $t0
### a+1400  :=  $t1
##########################################################

  addi $t1, $t0, 1400          # t1 is the (word) address of the last element

init_loop:
  bgt $t0, $t1, init_exit      # if $t0 > $t1, branch to exit

##########################################################
### (3)     *a = 0;
###-------------------------------------------------------
### a       :=  $t0
### a+1400  :=  $t1
##########################################################

  sw $0, 0($t0)                # arr[$t0] = 0

  addi $t0, $t0, 4             # $t0 += 4 (go to next element)
  j init_loop

init_exit:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra



##########################################################
### Function: print_big
###-------------------------------------------------------
### % code segment %
### (1) void print_big(Bigint b) {
### (2) 	for (int c = b.n-1; c>=0; --c)
### (3) 		printf("%d", b.digits[c]);
### (4) 	printf("\n");
### (5) }
###-------------------------------------------------------
### % Variable Table %
###   b   :=  $s0
###   c             :=  $s7
###   b.digits      :=  $s6
###   &b.digits[c]  :=  $t0
##########################################################

print_big:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  addi $sp, $sp, -36
  sw $s0, 32($sp)
  sw $s1, 28($sp)
  sw $s2, 24($sp)
  sw $s3, 20($sp)
  sw $s4, 16($sp)
  sw $s5, 12($sp)
  sw $s6, 8($sp)
  sw $s7, 4($sp)
  sw $ra, 0($sp)

##########################################################
### (1) void print_big(Bigint b) {}
###-------------------------------------------------------
### b := $s0
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of b

##########################################################
### (2) 	for (int c = b.n-1; c>=0; --c)
###-------------------------------------------------------
### p         :=  $s0
### c         :=  $s7
### b.digits  :=  $s6
##########################################################

# initialize the loop
  lw $s7, 0($s0)
  addi $s7, $s7, -1           # $s7 = c (b.n-1)
  addi $s6, $s0, 4            # $s6 = &b.digits[]
  blt $s7, $0, PG_exit        # branch if c<0

# loop
BG_loop:

##########################################################
### (3) 		printf("%d", b.digits[c]);
###-------------------------------------------------------
### p             :=  $s0
### c             :=  $s7
### b.digits      :=  $s6
### &b.digits[c]  :=  $t0
##########################################################

  move $t0, $s7               # $t0 = c
  sll $t0, $t0, 2             # $t0 = 4*$s7 = 4c
  add $t0, $s6, $t0           # $t0 = &b.digits[c]
  lw $a0, 0($t0)              # load b.digits[c]
  li $v0, 1                   # load print sys call
  syscall                     # print element
  addi $s7, $s7, -1           # $s7 = $s7 - 1
  blt $s7, $0, PG_exit        # branch if c<0
  j BG_loop

##########################################################
### (4) 	printf("\n");
##########################################################

PG_exit:
  la $a0, newline             # load linefeed into $a0 for printing
  li $v0, 4                   # load print string syscall code
  syscall

PG_return:

##########################################################
### Function call: save state
### The callee is responsible for managing saved registers
##########################################################

  lw $s0, 32($sp)
  lw $s1, 28($sp)
  lw $s2, 24($sp)
  lw $s3, 20($sp)
  lw $s4, 16($sp)
  lw $s5, 12($sp)
  lw $s6, 8($sp)
  lw $s7, 4($sp)
  lw $ra, 0($sp)
  addi $sp, $sp, 36

##########################################################
### Exit function
##########################################################

  jr $ra


# test driver
main:

##########################################################
### Print "Multiplication Tests\n"
##########################################################

  la $a0, PROMPT_SUB
  li $v0, 4
	syscall

##########################################################
### Test case 1, 7 and 3, expects 4
##########################################################

# init bigint1
  la $a0, Bigint_tmp1            # $a0 is the starting address of Bigint_tmp1
  jal init_bigint                # initialize Bigint_tmp1

# load Bigint_tmp1
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 7
  sw $t1, 4($a0)            # the digit is 7

# init Bigint_tmp2
  la $a0, Bigint_tmp2           # $a0 is the starting address of Bigint_tmp2
  jal init_bigint               # initialize Bigint_tmp2

# load bigint2
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 3
  sw $t1, 4($a0)            # the digit is 3

# call sub_big
  la $a0, Bigint_tmp1
  la $a1, Bigint_tmp2
  la $a2, Bigint_tmp3
  jal sub_big

# print output
  move $a0, $v0
  jal print_big

##########################################################
### Test case 2, 42 and 12, expects 30
##########################################################

# init Bigint_tmp1
  la $a0, Bigint_tmp1            # $a0 is the starting address of Bigint_tmp1
  jal init_bigint                # initialize Bigint_tmp1

# load Bigint_tmp1
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 2

  li $t1, 4
  sw $t1, 8($a0)            # first digit is 4
  li $t1, 2
  sw $t1, 4($a0)            # second digit is 2

# init Bigint_tmp2
  la $a0, Bigint_tmp2           # $a0 is the starting address of Bigint_tmp2
  jal init_bigint               # initialize Bigint_tmp2

# load Bigint_tmp2
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 2

  li $t1, 1
  sw $t1, 8($a0)            # first digit is 1
  li $t1, 2
  sw $t1, 4($a0)            # second digit is 2

# call sub_big
  la $a0, Bigint_tmp1
  la $a1, Bigint_tmp2
  la $a2, Bigint_tmp3
  jal sub_big

# print output
  move $a0, $v0
  jal print_big

##########################################################
### Test case 3, 9,000,000,000 and 7,654,321, expects 8,992,345,679
##########################################################

# init Bigint_tmp1
  la $a0, Bigint_tmp1            # $a0 is the starting address of Bigint_tmp1
  jal init_bigint                # initialize Bigint_tmp1

# load bigint1
  li $t1, 10
  sw $t1, 0($a0)            # Bigint size is 10

  li $t1, 9
  sw $t1, 40($a0)            # 1st digit is 9
  li $t1, 0
  sw $t1, 36($a0)            # 2nd digit is 0
  li $t1, 0
  sw $t1, 32($a0)            # 3rd digit is 0
  li $t1, 0
  sw $t1, 28($a0)            # 4th digit is 0
  li $t1, 0
  sw $t1, 24($a0)            # 5th digit is 0
  li $t1, 0
  sw $t1, 20($a0)            # 6th digit is 0
  li $t1, 0
  sw $t1, 16($a0)            # 7th digit is 0
  li $t1, 0
  sw $t1, 12($a0)            # 8th digit is 0
  li $t1, 0
  sw $t1, 8($a0)             # 9th digit is 0
  li $t1, 0
  sw $t1, 4($a0)             # 10th digit is 0

# init Bigint_tmp2
  la $a0, Bigint_tmp2           # $a0 is the starting address of Bigint_tmp2
  jal init_bigint               # initialize Bigint_tmp2

# load Bigint_tmp2
  li $t1, 7
  sw $t1, 0($a0)             # Bigint size is 7

  li $t1, 7
  sw $t1, 28($a0)            # 1st digit is 7
  li $t1, 6
  sw $t1, 24($a0)            # 2nd digit is 6
  li $t1, 5
  sw $t1, 20($a0)            # 3rd digit is 5
  li $t1, 4
  sw $t1, 16($a0)            # 4th digit is 4
  li $t1, 3
  sw $t1, 12($a0)            # 5th digit is 3
  li $t1, 2
  sw $t1, 8($a0)             # 6th digit is 2
  li $t1, 1
  sw $t1, 4($a0)             # 7th digit is 1

# call sub_big
  la $a0, Bigint_tmp1
  la $a1, Bigint_tmp2
  la $a2, Bigint_tmp3
  jal sub_big

# print output
  move $a0, $v0
  jal print_big

##########################################################
### Exit the program
##########################################################

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
