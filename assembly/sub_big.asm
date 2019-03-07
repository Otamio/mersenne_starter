# sub_big.asm
# Bigint sub_big(Bigint a, Bigint b)
# {
#   Bigint c;
# 	c.n = a.n;
# 	for (int i = 0; i < c.n; ++i)
# 		c.digits[i] = 0;
#
# 	int carry = 0;
# 	for (int i = 0; i < b.n; ++i) {
# 		c.digits[i] = a.digits[i] - b.digits[i] + carry;
# 		if (c.digits[i] < 0) {
# 			carry = -1;
# 			c.digits[i] += 10;
# 		} else
# 			carry = 0;
# 	}
#
# 	if (a.n > b.n) {
# 		for (int i=b.n; i<a.n; ++i) {
# 			c.digits[i] = a.digits[i] + carry;
# 			if (c.digits[i]<0) {
# 				carry = -1;
# 				c.digits[i] += 10;
# 			} else
# 				carry = 0;
# 		}
# 	}
#
# 	compress(&c);
# 	return c;
# }
