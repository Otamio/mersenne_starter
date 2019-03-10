# pow_big.asm

  .data
PROMPT_POW:   .asciiz "Power Tests\n"
newline:      .asciiz "\n"
.align 2
Bigint_tmp1:  .space  1404
.align 2
Bigint_tmp2:  .space  1404
.align 2
Bigint_tmp3:  .space  1404
.align 2
Tmp_pow:      .space  1404

  .text

##########################################################
### Function: pow_big
###-------------------------------------------------------
### % Code Segment %
### (1)  Bigint pow_big(Bigint a, int p) {
### (2)  	Bigint b = a;
### (3)  	for (int i = 1; i < p; ++i)
### (4)  		b = mult_big(b, a);
### (5)  	return b;
### (6) }
###-------------------------------------------------------
### % Variable Table %
###   a       := $s0
###   p       := $s1
###   b       := $s2
###   i       := $s7
###   Tmp_pow := $t9
###-------------------------------------------------------
### Since we cannot pow bigint in place, a temporary bigint
###   must be allocated to the function, which we call b
### That is, b is a pointer to an empty bigint
##########################################################

pow_big:

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
### (1)  Bigint pow_big(Bigint a, int p) {
###-------------------------------------------------------
###   a := $s0
###   p := $s1
###   b := $s2, b is an empty bigint
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is integer p
  move $s2, $a2               # $s2 is the starting address of b

##########################################################
### (2)  	Bigint b = a;
###-------------------------------------------------------
###   a := $s0
###   b := $s2
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
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $s0
  move $a1, $s2
  jal copy_bigint

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
### Initialize temporary variable in pow_big (Tmp_pow)
###-------------------------------------------------------
###   Tmp_pow := $t9
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -16          # 4 elements are pushed onto the stack
  sw $a0, 12($sp)
  sw $a1, 8($sp)
  sw $a2, 4($sp)
  sw $a3, 0($sp)

#**#######################################################
#** Function call: call init_bigint
#**#######################################################

  la $t9, Tmp_pow
  move $a0, $t9
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
### (3)  	for (int i = 1; i < p; ++i)
###-------------------------------------------------------
###   p := $s1
###   i := $s7
##########################################################

# prepare for loop
  li $s7, 1                   # $s7 = 1 (i)

POW_loop:
  bge $s7, $s1, POW_return    # branch to exit if i >= p

##########################################################
### (4)  		b = mult_big(b, a);
###-------------------------------------------------------
###   a       := $s0
###   p       := $s1
###   b       := $s2
###   i       := $s7
###   Tmp_pow := $t9
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $a0, 16($sp)
  sw $a1, 12($sp)
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $t9, 0($sp)

#**#######################################################
#** Function call: call mult_big
#**#######################################################

  move $a0, $s0
  move $a1, $s2
  move $a2, $t9               # $t9 gets reinitialized in this call (no worry of garbage)
  jal mult_big

#**#######################################################
#** Function call: restore state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 16($sp)
  lw $a1, 12($sp)
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $t9, 0($sp)
  addi $sp, $sp, 20

##########################################################
### copy $t9 back to b
##########################################################

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  addi $sp, $sp, -20
  sw $a0, 16($sp)
  sw $a1, 12($sp)
  sw $a2, 8($sp)
  sw $a3, 4($sp)
  sw $t9, 0($sp)

#**#######################################################
#** Function call: call copy_bigint
#**#######################################################

  move $a0, $t9
  move $a1, $s2
  jal copy_bigint

#**#######################################################
#** Function call: save state
#** The caller is responsible for managing arguments
#**   and temporary registers
#**#######################################################

  lw $a0, 16($sp)
  lw $a1, 12($sp)
  lw $a2, 8($sp)
  lw $a3, 4($sp)
  lw $t9, 0($sp)
  addi $sp, $sp, 20

##########################################################
### (3)  	for (int i = 1; i < p; ++i)
###-------------------------------------------------------
###   i := $s7
##########################################################

  addi $s7, $s7, 1           # increment i
  j POW_loop

POW_return:

##########################################################
### (5)  	return b;
###-------------------------------------------------------
###   i := $s7
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
### Function: copy_bigint
###-------------------------------------------------------
### % Code Segment %
### (1) copy_bigint(Bigint *a, Bigint *b) {
### (2)   for (x=a, y=b; x<=350+a; ++x, ++y)
### (3)     *y = *x
### (4) }
###-------------------------------------------------------
### % Variable Table %
###   a             := $s0
###   b             := $s1
###   c             := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   b.n           := $t1
###   c.n           := $t2
###   carry         := $t3
###   val           := $t8
###   a.n+i         := $t9
##########################################################

copy_bigint:

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
### (1) copy_bigint(Bigint *a, Bigint *b) {
### (2)   for (x=a, y=b; x<=350+a; ++x, ++y)
###-------------------------------------------------------
###   x       :=  $s0
###   x+350   :=  $s1
###   y       :=  $s2
##########################################################

# Initialize Loop
  move $s0, $a0                 # s0 is the starting address of a
  addi $s1, $s0, 1400           # s1 is the (word) address of the last element
  move $s2, $a1                 # s2 is the starting address of b

copy_loop:
  bgt $s0, $s1, copy_exit       # if $s0 > $s1, branch to exit

##########################################################
### (3)     *y = *x
###-------------------------------------------------------
###   x       :=  $s0
###   y       :=  $s2
###   a[i]    :=  $s7
##########################################################

  lw $s7, 0($s0)                # load a[i]
  sw $s7, 0($s2)                # save a[i]

##########################################################
### (2)   for (x=a, y=b; x<=350+a; ++x, ++y)
###-------------------------------------------------------
###   x       :=  $s0
###   y       :=  $s2
##########################################################

  addi $s0, $s0, 4
  addi $s2, $s2, 4
  j copy_loop

copy_exit:

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
### Function: mult_big
###-------------------------------------------------------
### % Code Segment %
### (1)   Bigint mult_big(Bigint a, Bigint b) {
### (2)     Bigint c;
### (3)     c.n = a.n + b.n;
### (4)    	for (int i=0; i < c.n; ++i)
### (5)    		c.digits[i] = 0;
### (6)    	for (int i=0; i < b.n; ++i) {
### (7)    		int carry = 0;
### (8)    		int j;
### (9)
### (10)   		for (j=i; j < a.n+i; ++j) {
### (11) 	  		int val = c.digits[j] + (b.digits[i] * a.digits[j-i]) + carry;
### (12)  			carry       = val / 10;
### (13)   			c.digits[j] = val % 10;
### (14)   		}
### (15)
### (16)  		if (carry > 0) {
### (17)   			int val = c.digits[j] + carry;
### (18)  			carry       = val / 10;
### (19)  			c.digits[j] = val % 10;
### (20)   		}
### (21) 	  }
### (22) 	  compress(&c);
### (23)   	return c;
### (24) }
###-------------------------------------------------------
### % Variable Table %
###   a             := $s0
###   b             := $s1
###   c             := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   b.n           := $t1
###   c.n           := $t2
###   carry         := $t3
###   val           := $t8
###   a.n+i         := $t9
###-------------------------------------------------------
### Since we cannot mult bigint in place, a temporary bigint
###   must be allocated to the function, which we call c
### That is, c is a pointer to an empty bigint
##########################################################

mult_big:

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
### (1)   Bigint mult_big(Bigint a, Bigint b) { }
###-------------------------------------------------------
###   a := $s0
###   b := $s1
###   c := $s2, c is an empty bigint
##########################################################

# read parameters
  move $s0, $a0               # $s0 is the starting address of a
  move $s1, $a1               # $s1 is the starting address of b
  move $s2, $a2               # $s2 is the starting address of c (the return value)

##########################################################
### (2)     Bigint c;
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
### (3)     c.n = a.n + b.n;
###-------------------------------------------------------
###   a   := $s0
###   b   := $s1
###   c   := $s2, c is an empty bigint
###   a.n := $t0
###   b.n := $t1
###   c.n := $t2
##########################################################

# c.n = a.n + b.n
  lw $t0, 0($s0)              # $t0 = a.n
  lw $t1, 0($s1)              # $t1 = b.n
  add $t2, $t0, $t1           # $t2 = a.n + b.n
  sw $t2, 0($s2)              # c.n = a.n + b.n

##########################################################
### (4)    	for (int i=0; i < c.n; ++i)
### (5)    		c.digits[i] = 0; (see (2))
##########################################################

# initialization for c has been done in the previous step

##########################################################
### (6)    	for (int i=0; i < b.n; ++i) { }
###-------------------------------------------------------
###   a             := $s0
###   b             := $s1
###   c             := $s2, c is an empty bigint
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   i             := $s7
###   b.n           := $t1
##########################################################

# prepare for loop
  addi $s3, $s0, 4            # $s3 = &(a.digits[])
  addi $s4, $s1, 4            # $s4 = &(b.digits[])
  addi $s5, $s2, 4            # $s5 = &(c.digits[])
  li $s7, 0                   # $s7 = 0 (i)

MUL_loop_out:
  bge $s7, $t1, MUL_end       # branch to end if $s7 (i) >= $t1 (b.n)

##########################################################
### (7)    		int carry = 0;
###-------------------------------------------------------
###   carry := $t3
##########################################################

  li $t3, 0                   # $t3 = 0 (carry)

##########################################################
### (8)    		int j;
###-------------------------------------------------------
###   j := $s6
##########################################################

  move $s6, $s7               # $s6 = i (j)

##########################################################
### (10)   		for (j=i; j < a.n+i; ++j) {
###-------------------------------------------------------
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   a.n+i         := $t9
##########################################################

  add $t9, $t0, $s7           # $t9 = a.n + i (used to condition)

MUL_loop_in:
  bge $s6, $t9, MUL_iend      # branch if j >= a.n+i

##########################################################
### (11) 	  		int val = c.digits[j] + (b.digits[i] * a.digits[j-i]) + carry;
###-------------------------------------------------------
###   a             := $s0
###   b             := $s1
###   c             := $s2
###   &(a.digits[]) := $s3
###   &(b.digits[]) := $s4
###   &(c.digits[]) := $s5
###   j             := $s6
###   i             := $s7
###   carry         := $t3
###   val           := $t8
###   a.n+i         := $t9
##########################################################

  # (define) t8 is *val*

  sll $t4, $s7, 2             # $t4 = $s7*4 (4i)
  add $t4, $s4, $t4           # $t4 = &(b.digits[i])
  lw $t8, 0($t4)              # $t8 = b.digits[i]

  sub $t4, $s6, $s7           # $t4 = $s6 - $s7 (j-i)
  sll $t4, $t4, 2             # $t4 = 4(j-i)
  add $t4, $s3, $t4           # $t4 = &(a.digits[j-i])
  lw $t4, 0($t4)              # $t4 = a.digits[j-i]
  mul $t8, $t8, $t4           # $t8 = b.digits[i] * a.digits[j-i]

  sll $t4, $s6, 2             # $t4 = $s6*4 (4j)
  add $t4, $s5, $t4           # $t4 = $s5 + $t4 = &(c.digits[j])
  lw $t5, 0($t4)              # $t5 = c.digits[j], $t4 = &(c.digits[j])
  add $t8, $t8, $t5           # $t8 = b.digits[i] * a.digits[j-i] + c.digits[j]

  add $t8, $t8, $t3           # $t8 = b.digits[i] * a.digits[j-i] + c.digits[j] + carry

##########################################################
### (12)  			carry       = val / 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
###   a.n+i         := $t9
##########################################################

# val div (mod) 10
  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10

##########################################################
### (13)   			c.digits[j] = val % 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
###   a.n+i         := $t9
##########################################################

  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

##########################################################
### (10)   		for (j=i; j < a.n+i; ++j) {
###-------------------------------------------------------
###   j             := $s6
###   i             := $s7
###   a.n           := $t0
###   a.n+i         := $t9
##########################################################

# increment j and go to next iteration
  addi $s6, $s6, 1            # $j += 1
  j MUL_loop_in

MUL_iend:

##########################################################
### (16)  		if (carry > 0) {
###-------------------------------------------------------
###   carry := $t3
##########################################################

  ble $t3, $0, MUL_iloop_end  # branch if $t3 (carry) <= 0

##########################################################
### (17)   			int val = c.digits[j] + carry;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
##########################################################

  sll $t4, $s6, 2             # $t4 = 4j
  add $t4, $s5, $t4           # $t4 = &(c.digits[j])
  lw $t5, 0($t4)              # $t5 = c.digits[j]
  add $t8, $t5, $t3           # val = c.digits[j] + carry

##########################################################
### (18)  			carry       = val / 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
##########################################################

  li $t5, 10                  # $t5 = 10
  div $t8, $t5
  mflo $t3                    # $t3 = val / 10

##########################################################
### (19)  			c.digits[j] = val % 10;
###-------------------------------------------------------
###   carry         := $t3
###   &(c.digits[j]):= $t4
###   val           := $t8
##########################################################

  mfhi $t5                    # $t5 = val % 10
  sw $t5, 0($t4)              # c.digits[j] = val % 10

MUL_iloop_end:

##########################################################
### (6)    	for (int i=0; i < b.n; ++i) { }
###-------------------------------------------------------
###   i := $s7
##########################################################

  addi $s7, $s7, 1            # i += 1
  j MUL_loop_out              # go to the next out loop

MUL_end:

##########################################################
### (22) 	  compress(&c);
###-------------------------------------------------------
###   c := $s2
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

##########################################################
### (23)   	return c;
###-------------------------------------------------------
###   c := $s2
##########################################################

  move $v0, $a2

MUL_return:

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



# test driver
main:

##########################################################
### Print "Power Tests\n"
##########################################################

  la $a0, PROMPT_POW
  li $v0, 4
  syscall

##########################################################
### Test case 1, 3 and 4, expects 81
##########################################################

# init bigint1
  la $a0, Bigint_tmp1            # $a0 is the starting address of Bigint_tmp1
  jal init_bigint                # initialize Bigint_tmp1

# load bigint
  li $t1, 1
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 3
  sw $t1, 4($a0)            # the digit is 3

# init bigint2
  la $a0, Bigint_tmp2            # $a0 is the starting address of Bigint_tmp2
  jal init_bigint            # initialize bigint 1

# call pow_big
  la $a0, Bigint_tmp1
  li $a1, 4
  la $a2, Bigint_tmp2
  jal pow_big

# print output
  move $a0, $v0
  jal print_big

##########################################################
### Test case 2, 42 and 42, expects 150130937545296572356771972164254457814047970568738777235893533016064
##########################################################

# init bigint1
  la $a0, Bigint_tmp1           # $a0 is the starting address of Bigint_tmp1
  jal init_bigint               # initialize Bigint_tmp1

# load bigint
  li $t1, 2
  sw $t1, 0($a0)            # Bigint size is 1

  li $t1, 4
  sw $t1, 8($a0)            # first digit is 4
  li $t1, 2
  sw $t1, 4($a0)            # second digit is 2

# init bigint2
  la $a0, Bigint_tmp2            # $a0 is the starting address of Bigint_tmp2
  jal init_bigint                # initialize Bigint_tmp2

# call pow_big
  la $a0, Bigint_tmp1
  li $a1, 42
  la $a2, Bigint_tmp2
  jal pow_big

# print output
  move $a0, $v0
  jal print_big

##########################################################
### Exit the program
##########################################################

# exit (from main)
  li $v0, 10                 # load exit syscall code
  syscall                    # exit
