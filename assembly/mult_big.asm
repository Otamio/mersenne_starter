  # shift_left.asm
  # Bigint mult_big(Bigint a, Bigint b) {
  # 	Bigint c;
  # 	c.n = a.n + b.n;
  # 	for (int i=0; i < c.n; ++i)
  # 		c.digits[i] = 0;
  # 	for (int i=0; i < b.n; ++i) {
  # 		int carry = 0;
  # 		int j;
  #
  # 		for (j=i; j < a.n+i; ++j) {
  # 			int val = c.digits[j] + (b.digits[i] * a.digits[j-i]) + carry;
  # 			carry       = val / 10;
  # 			c.digits[j] = val % 10;
  # 		}
  #
  # 		if (carry > 0) {
  # 			int val = c.digits[j] + carry;
  # 			carry       = val / 10;
  # 			c.digits[j] = val % 10;
  # 		}
  # 	}
  # 	compress(&c);
  # 	return c;
  # }
  .data
test_g:  .asciiz "Multiplication Tests"
newline: .asciiz "\n"
  .text
function_g:
# save state
