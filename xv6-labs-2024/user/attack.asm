
user/_attack:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/riscv.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // your code here.  you should write the secret to fd 2 using write
  // (e.g., write(2, secret, 8)

  exit(1);
   8:	4505                	li	a0,1
   a:	26e000ef          	jal	278 <exit>

000000000000000e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
   e:	1141                	addi	sp,sp,-16
  10:	e406                	sd	ra,8(sp)
  12:	e022                	sd	s0,0(sp)
  14:	0800                	addi	s0,sp,16
  extern int main();
  main();
  16:	febff0ef          	jal	0 <main>
  exit(0);
  1a:	4501                	li	a0,0
  1c:	25c000ef          	jal	278 <exit>

0000000000000020 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  20:	1141                	addi	sp,sp,-16
  22:	e422                	sd	s0,8(sp)
  24:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  26:	87aa                	mv	a5,a0
  28:	0585                	addi	a1,a1,1
  2a:	0785                	addi	a5,a5,1
  2c:	fff5c703          	lbu	a4,-1(a1)
  30:	fee78fa3          	sb	a4,-1(a5)
  34:	fb75                	bnez	a4,28 <strcpy+0x8>
    ;
  return os;
}
  36:	6422                	ld	s0,8(sp)
  38:	0141                	addi	sp,sp,16
  3a:	8082                	ret

000000000000003c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  42:	00054783          	lbu	a5,0(a0)
  46:	cb91                	beqz	a5,5a <strcmp+0x1e>
  48:	0005c703          	lbu	a4,0(a1)
  4c:	00f71763          	bne	a4,a5,5a <strcmp+0x1e>
    p++, q++;
  50:	0505                	addi	a0,a0,1
  52:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  54:	00054783          	lbu	a5,0(a0)
  58:	fbe5                	bnez	a5,48 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  5a:	0005c503          	lbu	a0,0(a1)
}
  5e:	40a7853b          	subw	a0,a5,a0
  62:	6422                	ld	s0,8(sp)
  64:	0141                	addi	sp,sp,16
  66:	8082                	ret

0000000000000068 <strlen>:

uint
strlen(const char *s)
{
  68:	1141                	addi	sp,sp,-16
  6a:	e422                	sd	s0,8(sp)
  6c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  6e:	00054783          	lbu	a5,0(a0)
  72:	cf91                	beqz	a5,8e <strlen+0x26>
  74:	0505                	addi	a0,a0,1
  76:	87aa                	mv	a5,a0
  78:	86be                	mv	a3,a5
  7a:	0785                	addi	a5,a5,1
  7c:	fff7c703          	lbu	a4,-1(a5)
  80:	ff65                	bnez	a4,78 <strlen+0x10>
  82:	40a6853b          	subw	a0,a3,a0
  86:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret
  for(n = 0; s[n]; n++)
  8e:	4501                	li	a0,0
  90:	bfe5                	j	88 <strlen+0x20>

0000000000000092 <memset>:

void*
memset(void *dst, int c, uint n)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  98:	ca19                	beqz	a2,ae <memset+0x1c>
  9a:	87aa                	mv	a5,a0
  9c:	1602                	slli	a2,a2,0x20
  9e:	9201                	srli	a2,a2,0x20
  a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  a8:	0785                	addi	a5,a5,1
  aa:	fee79de3          	bne	a5,a4,a4 <memset+0x12>
  }
  return dst;
}
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strchr>:

char*
strchr(const char *s, char c)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cb99                	beqz	a5,d4 <strchr+0x20>
    if(*s == c)
  c0:	00f58763          	beq	a1,a5,ce <strchr+0x1a>
  for(; *s; s++)
  c4:	0505                	addi	a0,a0,1
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbfd                	bnez	a5,c0 <strchr+0xc>
      return (char*)s;
  return 0;
  cc:	4501                	li	a0,0
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  return 0;
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strchr+0x1a>

00000000000000d8 <gets>:

char*
gets(char *buf, int max)
{
  d8:	711d                	addi	sp,sp,-96
  da:	ec86                	sd	ra,88(sp)
  dc:	e8a2                	sd	s0,80(sp)
  de:	e4a6                	sd	s1,72(sp)
  e0:	e0ca                	sd	s2,64(sp)
  e2:	fc4e                	sd	s3,56(sp)
  e4:	f852                	sd	s4,48(sp)
  e6:	f456                	sd	s5,40(sp)
  e8:	f05a                	sd	s6,32(sp)
  ea:	ec5e                	sd	s7,24(sp)
  ec:	1080                	addi	s0,sp,96
  ee:	8baa                	mv	s7,a0
  f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f2:	892a                	mv	s2,a0
  f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
  f6:	4aa9                	li	s5,10
  f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
  fa:	89a6                	mv	s3,s1
  fc:	2485                	addiw	s1,s1,1
  fe:	0344d663          	bge	s1,s4,12a <gets+0x52>
    cc = read(0, &c, 1);
 102:	4605                	li	a2,1
 104:	faf40593          	addi	a1,s0,-81
 108:	4501                	li	a0,0
 10a:	186000ef          	jal	290 <read>
    if(cc < 1)
 10e:	00a05e63          	blez	a0,12a <gets+0x52>
    buf[i++] = c;
 112:	faf44783          	lbu	a5,-81(s0)
 116:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 11a:	01578763          	beq	a5,s5,128 <gets+0x50>
 11e:	0905                	addi	s2,s2,1
 120:	fd679de3          	bne	a5,s6,fa <gets+0x22>
    buf[i++] = c;
 124:	89a6                	mv	s3,s1
 126:	a011                	j	12a <gets+0x52>
 128:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 12a:	99de                	add	s3,s3,s7
 12c:	00098023          	sb	zero,0(s3)
  return buf;
}
 130:	855e                	mv	a0,s7
 132:	60e6                	ld	ra,88(sp)
 134:	6446                	ld	s0,80(sp)
 136:	64a6                	ld	s1,72(sp)
 138:	6906                	ld	s2,64(sp)
 13a:	79e2                	ld	s3,56(sp)
 13c:	7a42                	ld	s4,48(sp)
 13e:	7aa2                	ld	s5,40(sp)
 140:	7b02                	ld	s6,32(sp)
 142:	6be2                	ld	s7,24(sp)
 144:	6125                	addi	sp,sp,96
 146:	8082                	ret

0000000000000148 <stat>:

int
stat(const char *n, struct stat *st)
{
 148:	1101                	addi	sp,sp,-32
 14a:	ec06                	sd	ra,24(sp)
 14c:	e822                	sd	s0,16(sp)
 14e:	e04a                	sd	s2,0(sp)
 150:	1000                	addi	s0,sp,32
 152:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 154:	4581                	li	a1,0
 156:	162000ef          	jal	2b8 <open>
  if(fd < 0)
 15a:	02054263          	bltz	a0,17e <stat+0x36>
 15e:	e426                	sd	s1,8(sp)
 160:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 162:	85ca                	mv	a1,s2
 164:	16c000ef          	jal	2d0 <fstat>
 168:	892a                	mv	s2,a0
  close(fd);
 16a:	8526                	mv	a0,s1
 16c:	134000ef          	jal	2a0 <close>
  return r;
 170:	64a2                	ld	s1,8(sp)
}
 172:	854a                	mv	a0,s2
 174:	60e2                	ld	ra,24(sp)
 176:	6442                	ld	s0,16(sp)
 178:	6902                	ld	s2,0(sp)
 17a:	6105                	addi	sp,sp,32
 17c:	8082                	ret
    return -1;
 17e:	597d                	li	s2,-1
 180:	bfcd                	j	172 <stat+0x2a>

0000000000000182 <atoi>:

int
atoi(const char *s)
{
 182:	1141                	addi	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 188:	00054683          	lbu	a3,0(a0)
 18c:	fd06879b          	addiw	a5,a3,-48
 190:	0ff7f793          	zext.b	a5,a5
 194:	4625                	li	a2,9
 196:	02f66863          	bltu	a2,a5,1c6 <atoi+0x44>
 19a:	872a                	mv	a4,a0
  n = 0;
 19c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 19e:	0705                	addi	a4,a4,1
 1a0:	0025179b          	slliw	a5,a0,0x2
 1a4:	9fa9                	addw	a5,a5,a0
 1a6:	0017979b          	slliw	a5,a5,0x1
 1aa:	9fb5                	addw	a5,a5,a3
 1ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1b0:	00074683          	lbu	a3,0(a4)
 1b4:	fd06879b          	addiw	a5,a3,-48
 1b8:	0ff7f793          	zext.b	a5,a5
 1bc:	fef671e3          	bgeu	a2,a5,19e <atoi+0x1c>
  return n;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  n = 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <atoi+0x3e>

00000000000001ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e422                	sd	s0,8(sp)
 1ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1d0:	02b57463          	bgeu	a0,a1,1f8 <memmove+0x2e>
    while(n-- > 0)
 1d4:	00c05f63          	blez	a2,1f2 <memmove+0x28>
 1d8:	1602                	slli	a2,a2,0x20
 1da:	9201                	srli	a2,a2,0x20
 1dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1e2:	0585                	addi	a1,a1,1
 1e4:	0705                	addi	a4,a4,1
 1e6:	fff5c683          	lbu	a3,-1(a1)
 1ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1ee:	fef71ae3          	bne	a4,a5,1e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
    dst += n;
 1f8:	00c50733          	add	a4,a0,a2
    src += n;
 1fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 1fe:	fec05ae3          	blez	a2,1f2 <memmove+0x28>
 202:	fff6079b          	addiw	a5,a2,-1
 206:	1782                	slli	a5,a5,0x20
 208:	9381                	srli	a5,a5,0x20
 20a:	fff7c793          	not	a5,a5
 20e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 210:	15fd                	addi	a1,a1,-1
 212:	177d                	addi	a4,a4,-1
 214:	0005c683          	lbu	a3,0(a1)
 218:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 21c:	fee79ae3          	bne	a5,a4,210 <memmove+0x46>
 220:	bfc9                	j	1f2 <memmove+0x28>

0000000000000222 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 228:	ca05                	beqz	a2,258 <memcmp+0x36>
 22a:	fff6069b          	addiw	a3,a2,-1
 22e:	1682                	slli	a3,a3,0x20
 230:	9281                	srli	a3,a3,0x20
 232:	0685                	addi	a3,a3,1
 234:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 236:	00054783          	lbu	a5,0(a0)
 23a:	0005c703          	lbu	a4,0(a1)
 23e:	00e79863          	bne	a5,a4,24e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 242:	0505                	addi	a0,a0,1
    p2++;
 244:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 246:	fed518e3          	bne	a0,a3,236 <memcmp+0x14>
  }
  return 0;
 24a:	4501                	li	a0,0
 24c:	a019                	j	252 <memcmp+0x30>
      return *p1 - *p2;
 24e:	40e7853b          	subw	a0,a5,a4
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  return 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <memcmp+0x30>

000000000000025c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 264:	f67ff0ef          	jal	1ca <memmove>
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 270:	4885                	li	a7,1
 ecall
 272:	00000073          	ecall
 ret
 276:	8082                	ret

0000000000000278 <exit>:
.global exit
exit:
 li a7, SYS_exit
 278:	4889                	li	a7,2
 ecall
 27a:	00000073          	ecall
 ret
 27e:	8082                	ret

0000000000000280 <wait>:
.global wait
wait:
 li a7, SYS_wait
 280:	488d                	li	a7,3
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 288:	4891                	li	a7,4
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <read>:
.global read
read:
 li a7, SYS_read
 290:	4895                	li	a7,5
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <write>:
.global write
write:
 li a7, SYS_write
 298:	48c1                	li	a7,16
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <close>:
.global close
close:
 li a7, SYS_close
 2a0:	48d5                	li	a7,21
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2a8:	4899                	li	a7,6
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2b0:	489d                	li	a7,7
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <open>:
.global open
open:
 li a7, SYS_open
 2b8:	48bd                	li	a7,15
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2c0:	48c5                	li	a7,17
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2c8:	48c9                	li	a7,18
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2d0:	48a1                	li	a7,8
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <link>:
.global link
link:
 li a7, SYS_link
 2d8:	48cd                	li	a7,19
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2e0:	48d1                	li	a7,20
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2e8:	48a5                	li	a7,9
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2f0:	48a9                	li	a7,10
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2f8:	48ad                	li	a7,11
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 300:	48b1                	li	a7,12
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 308:	48b5                	li	a7,13
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 310:	48b9                	li	a7,14
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 318:	48dd                	li	a7,23
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 320:	1101                	addi	sp,sp,-32
 322:	ec06                	sd	ra,24(sp)
 324:	e822                	sd	s0,16(sp)
 326:	1000                	addi	s0,sp,32
 328:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 32c:	4605                	li	a2,1
 32e:	fef40593          	addi	a1,s0,-17
 332:	f67ff0ef          	jal	298 <write>
}
 336:	60e2                	ld	ra,24(sp)
 338:	6442                	ld	s0,16(sp)
 33a:	6105                	addi	sp,sp,32
 33c:	8082                	ret

000000000000033e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 33e:	7139                	addi	sp,sp,-64
 340:	fc06                	sd	ra,56(sp)
 342:	f822                	sd	s0,48(sp)
 344:	f426                	sd	s1,40(sp)
 346:	0080                	addi	s0,sp,64
 348:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 34a:	c299                	beqz	a3,350 <printint+0x12>
 34c:	0805c963          	bltz	a1,3de <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 350:	2581                	sext.w	a1,a1
  neg = 0;
 352:	4881                	li	a7,0
 354:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 358:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 35a:	2601                	sext.w	a2,a2
 35c:	00000517          	auipc	a0,0x0
 360:	4fc50513          	addi	a0,a0,1276 # 858 <digits>
 364:	883a                	mv	a6,a4
 366:	2705                	addiw	a4,a4,1
 368:	02c5f7bb          	remuw	a5,a1,a2
 36c:	1782                	slli	a5,a5,0x20
 36e:	9381                	srli	a5,a5,0x20
 370:	97aa                	add	a5,a5,a0
 372:	0007c783          	lbu	a5,0(a5)
 376:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 37a:	0005879b          	sext.w	a5,a1
 37e:	02c5d5bb          	divuw	a1,a1,a2
 382:	0685                	addi	a3,a3,1
 384:	fec7f0e3          	bgeu	a5,a2,364 <printint+0x26>
  if(neg)
 388:	00088c63          	beqz	a7,3a0 <printint+0x62>
    buf[i++] = '-';
 38c:	fd070793          	addi	a5,a4,-48
 390:	00878733          	add	a4,a5,s0
 394:	02d00793          	li	a5,45
 398:	fef70823          	sb	a5,-16(a4)
 39c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3a0:	02e05a63          	blez	a4,3d4 <printint+0x96>
 3a4:	f04a                	sd	s2,32(sp)
 3a6:	ec4e                	sd	s3,24(sp)
 3a8:	fc040793          	addi	a5,s0,-64
 3ac:	00e78933          	add	s2,a5,a4
 3b0:	fff78993          	addi	s3,a5,-1
 3b4:	99ba                	add	s3,s3,a4
 3b6:	377d                	addiw	a4,a4,-1
 3b8:	1702                	slli	a4,a4,0x20
 3ba:	9301                	srli	a4,a4,0x20
 3bc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3c0:	fff94583          	lbu	a1,-1(s2)
 3c4:	8526                	mv	a0,s1
 3c6:	f5bff0ef          	jal	320 <putc>
  while(--i >= 0)
 3ca:	197d                	addi	s2,s2,-1
 3cc:	ff391ae3          	bne	s2,s3,3c0 <printint+0x82>
 3d0:	7902                	ld	s2,32(sp)
 3d2:	69e2                	ld	s3,24(sp)
}
 3d4:	70e2                	ld	ra,56(sp)
 3d6:	7442                	ld	s0,48(sp)
 3d8:	74a2                	ld	s1,40(sp)
 3da:	6121                	addi	sp,sp,64
 3dc:	8082                	ret
    x = -xx;
 3de:	40b005bb          	negw	a1,a1
    neg = 1;
 3e2:	4885                	li	a7,1
    x = -xx;
 3e4:	bf85                	j	354 <printint+0x16>

00000000000003e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3e6:	711d                	addi	sp,sp,-96
 3e8:	ec86                	sd	ra,88(sp)
 3ea:	e8a2                	sd	s0,80(sp)
 3ec:	e0ca                	sd	s2,64(sp)
 3ee:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3f0:	0005c903          	lbu	s2,0(a1)
 3f4:	26090863          	beqz	s2,664 <vprintf+0x27e>
 3f8:	e4a6                	sd	s1,72(sp)
 3fa:	fc4e                	sd	s3,56(sp)
 3fc:	f852                	sd	s4,48(sp)
 3fe:	f456                	sd	s5,40(sp)
 400:	f05a                	sd	s6,32(sp)
 402:	ec5e                	sd	s7,24(sp)
 404:	e862                	sd	s8,16(sp)
 406:	e466                	sd	s9,8(sp)
 408:	8b2a                	mv	s6,a0
 40a:	8a2e                	mv	s4,a1
 40c:	8bb2                	mv	s7,a2
  state = 0;
 40e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 410:	4481                	li	s1,0
 412:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 414:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 418:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 41c:	06c00c93          	li	s9,108
 420:	a005                	j	440 <vprintf+0x5a>
        putc(fd, c0);
 422:	85ca                	mv	a1,s2
 424:	855a                	mv	a0,s6
 426:	efbff0ef          	jal	320 <putc>
 42a:	a019                	j	430 <vprintf+0x4a>
    } else if(state == '%'){
 42c:	03598263          	beq	s3,s5,450 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 430:	2485                	addiw	s1,s1,1
 432:	8726                	mv	a4,s1
 434:	009a07b3          	add	a5,s4,s1
 438:	0007c903          	lbu	s2,0(a5)
 43c:	20090c63          	beqz	s2,654 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 440:	0009079b          	sext.w	a5,s2
    if(state == 0){
 444:	fe0994e3          	bnez	s3,42c <vprintf+0x46>
      if(c0 == '%'){
 448:	fd579de3          	bne	a5,s5,422 <vprintf+0x3c>
        state = '%';
 44c:	89be                	mv	s3,a5
 44e:	b7cd                	j	430 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 450:	00ea06b3          	add	a3,s4,a4
 454:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 458:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 45a:	c681                	beqz	a3,462 <vprintf+0x7c>
 45c:	9752                	add	a4,a4,s4
 45e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 462:	03878f63          	beq	a5,s8,4a0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 466:	05978963          	beq	a5,s9,4b8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 46a:	07500713          	li	a4,117
 46e:	0ee78363          	beq	a5,a4,554 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 472:	07800713          	li	a4,120
 476:	12e78563          	beq	a5,a4,5a0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 47a:	07000713          	li	a4,112
 47e:	14e78a63          	beq	a5,a4,5d2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 482:	07300713          	li	a4,115
 486:	18e78a63          	beq	a5,a4,61a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 48a:	02500713          	li	a4,37
 48e:	04e79563          	bne	a5,a4,4d8 <vprintf+0xf2>
        putc(fd, '%');
 492:	02500593          	li	a1,37
 496:	855a                	mv	a0,s6
 498:	e89ff0ef          	jal	320 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 49c:	4981                	li	s3,0
 49e:	bf49                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4a0:	008b8913          	addi	s2,s7,8
 4a4:	4685                	li	a3,1
 4a6:	4629                	li	a2,10
 4a8:	000ba583          	lw	a1,0(s7)
 4ac:	855a                	mv	a0,s6
 4ae:	e91ff0ef          	jal	33e <printint>
 4b2:	8bca                	mv	s7,s2
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	bfad                	j	430 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4b8:	06400793          	li	a5,100
 4bc:	02f68963          	beq	a3,a5,4ee <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4c0:	06c00793          	li	a5,108
 4c4:	04f68263          	beq	a3,a5,508 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4c8:	07500793          	li	a5,117
 4cc:	0af68063          	beq	a3,a5,56c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4d0:	07800793          	li	a5,120
 4d4:	0ef68263          	beq	a3,a5,5b8 <vprintf+0x1d2>
        putc(fd, '%');
 4d8:	02500593          	li	a1,37
 4dc:	855a                	mv	a0,s6
 4de:	e43ff0ef          	jal	320 <putc>
        putc(fd, c0);
 4e2:	85ca                	mv	a1,s2
 4e4:	855a                	mv	a0,s6
 4e6:	e3bff0ef          	jal	320 <putc>
      state = 0;
 4ea:	4981                	li	s3,0
 4ec:	b791                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ee:	008b8913          	addi	s2,s7,8
 4f2:	4685                	li	a3,1
 4f4:	4629                	li	a2,10
 4f6:	000ba583          	lw	a1,0(s7)
 4fa:	855a                	mv	a0,s6
 4fc:	e43ff0ef          	jal	33e <printint>
        i += 1;
 500:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 502:	8bca                	mv	s7,s2
      state = 0;
 504:	4981                	li	s3,0
        i += 1;
 506:	b72d                	j	430 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 508:	06400793          	li	a5,100
 50c:	02f60763          	beq	a2,a5,53a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 510:	07500793          	li	a5,117
 514:	06f60963          	beq	a2,a5,586 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 518:	07800793          	li	a5,120
 51c:	faf61ee3          	bne	a2,a5,4d8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 520:	008b8913          	addi	s2,s7,8
 524:	4681                	li	a3,0
 526:	4641                	li	a2,16
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	e11ff0ef          	jal	33e <printint>
        i += 2;
 532:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 534:	8bca                	mv	s7,s2
      state = 0;
 536:	4981                	li	s3,0
        i += 2;
 538:	bde5                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000ba583          	lw	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	df7ff0ef          	jal	33e <printint>
        i += 2;
 54c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 54e:	8bca                	mv	s7,s2
      state = 0;
 550:	4981                	li	s3,0
        i += 2;
 552:	bdf9                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 554:	008b8913          	addi	s2,s7,8
 558:	4681                	li	a3,0
 55a:	4629                	li	a2,10
 55c:	000ba583          	lw	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	dddff0ef          	jal	33e <printint>
 566:	8bca                	mv	s7,s2
      state = 0;
 568:	4981                	li	s3,0
 56a:	b5d9                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	008b8913          	addi	s2,s7,8
 570:	4681                	li	a3,0
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	dc5ff0ef          	jal	33e <printint>
        i += 1;
 57e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
        i += 1;
 584:	b575                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	008b8913          	addi	s2,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	dabff0ef          	jal	33e <printint>
        i += 2;
 598:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 2;
 59e:	bd49                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4641                	li	a2,16
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	d91ff0ef          	jal	33e <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bdad                	j	430 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	d79ff0ef          	jal	33e <printint>
        i += 1;
 5ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 1;
 5d0:	b585                	j	430 <vprintf+0x4a>
 5d2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5d4:	008b8d13          	addi	s10,s7,8
 5d8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5dc:	03000593          	li	a1,48
 5e0:	855a                	mv	a0,s6
 5e2:	d3fff0ef          	jal	320 <putc>
  putc(fd, 'x');
 5e6:	07800593          	li	a1,120
 5ea:	855a                	mv	a0,s6
 5ec:	d35ff0ef          	jal	320 <putc>
 5f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f2:	00000b97          	auipc	s7,0x0
 5f6:	266b8b93          	addi	s7,s7,614 # 858 <digits>
 5fa:	03c9d793          	srli	a5,s3,0x3c
 5fe:	97de                	add	a5,a5,s7
 600:	0007c583          	lbu	a1,0(a5)
 604:	855a                	mv	a0,s6
 606:	d1bff0ef          	jal	320 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60a:	0992                	slli	s3,s3,0x4
 60c:	397d                	addiw	s2,s2,-1
 60e:	fe0916e3          	bnez	s2,5fa <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 612:	8bea                	mv	s7,s10
      state = 0;
 614:	4981                	li	s3,0
 616:	6d02                	ld	s10,0(sp)
 618:	bd21                	j	430 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 61a:	008b8993          	addi	s3,s7,8
 61e:	000bb903          	ld	s2,0(s7)
 622:	00090f63          	beqz	s2,640 <vprintf+0x25a>
        for(; *s; s++)
 626:	00094583          	lbu	a1,0(s2)
 62a:	c195                	beqz	a1,64e <vprintf+0x268>
          putc(fd, *s);
 62c:	855a                	mv	a0,s6
 62e:	cf3ff0ef          	jal	320 <putc>
        for(; *s; s++)
 632:	0905                	addi	s2,s2,1
 634:	00094583          	lbu	a1,0(s2)
 638:	f9f5                	bnez	a1,62c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 63a:	8bce                	mv	s7,s3
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bbcd                	j	430 <vprintf+0x4a>
          s = "(null)";
 640:	00000917          	auipc	s2,0x0
 644:	21090913          	addi	s2,s2,528 # 850 <malloc+0x104>
        for(; *s; s++)
 648:	02800593          	li	a1,40
 64c:	b7c5                	j	62c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 64e:	8bce                	mv	s7,s3
      state = 0;
 650:	4981                	li	s3,0
 652:	bbf9                	j	430 <vprintf+0x4a>
 654:	64a6                	ld	s1,72(sp)
 656:	79e2                	ld	s3,56(sp)
 658:	7a42                	ld	s4,48(sp)
 65a:	7aa2                	ld	s5,40(sp)
 65c:	7b02                	ld	s6,32(sp)
 65e:	6be2                	ld	s7,24(sp)
 660:	6c42                	ld	s8,16(sp)
 662:	6ca2                	ld	s9,8(sp)
    }
  }
}
 664:	60e6                	ld	ra,88(sp)
 666:	6446                	ld	s0,80(sp)
 668:	6906                	ld	s2,64(sp)
 66a:	6125                	addi	sp,sp,96
 66c:	8082                	ret

000000000000066e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 66e:	715d                	addi	sp,sp,-80
 670:	ec06                	sd	ra,24(sp)
 672:	e822                	sd	s0,16(sp)
 674:	1000                	addi	s0,sp,32
 676:	e010                	sd	a2,0(s0)
 678:	e414                	sd	a3,8(s0)
 67a:	e818                	sd	a4,16(s0)
 67c:	ec1c                	sd	a5,24(s0)
 67e:	03043023          	sd	a6,32(s0)
 682:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 686:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68a:	8622                	mv	a2,s0
 68c:	d5bff0ef          	jal	3e6 <vprintf>
}
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6161                	addi	sp,sp,80
 696:	8082                	ret

0000000000000698 <printf>:

void
printf(const char *fmt, ...)
{
 698:	711d                	addi	sp,sp,-96
 69a:	ec06                	sd	ra,24(sp)
 69c:	e822                	sd	s0,16(sp)
 69e:	1000                	addi	s0,sp,32
 6a0:	e40c                	sd	a1,8(s0)
 6a2:	e810                	sd	a2,16(s0)
 6a4:	ec14                	sd	a3,24(s0)
 6a6:	f018                	sd	a4,32(s0)
 6a8:	f41c                	sd	a5,40(s0)
 6aa:	03043823          	sd	a6,48(s0)
 6ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b2:	00840613          	addi	a2,s0,8
 6b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ba:	85aa                	mv	a1,a0
 6bc:	4505                	li	a0,1
 6be:	d29ff0ef          	jal	3e6 <vprintf>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6125                	addi	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ca:	1141                	addi	sp,sp,-16
 6cc:	e422                	sd	s0,8(sp)
 6ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	00001797          	auipc	a5,0x1
 6d8:	92c7b783          	ld	a5,-1748(a5) # 1000 <freep>
 6dc:	a02d                	j	706 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6de:	4618                	lw	a4,8(a2)
 6e0:	9f2d                	addw	a4,a4,a1
 6e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	6398                	ld	a4,0(a5)
 6e8:	6310                	ld	a2,0(a4)
 6ea:	a83d                	j	728 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ec:	ff852703          	lw	a4,-8(a0)
 6f0:	9f31                	addw	a4,a4,a2
 6f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6f4:	ff053683          	ld	a3,-16(a0)
 6f8:	a091                	j	73c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fa:	6398                	ld	a4,0(a5)
 6fc:	00e7e463          	bltu	a5,a4,704 <free+0x3a>
 700:	00e6ea63          	bltu	a3,a4,714 <free+0x4a>
{
 704:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 706:	fed7fae3          	bgeu	a5,a3,6fa <free+0x30>
 70a:	6398                	ld	a4,0(a5)
 70c:	00e6e463          	bltu	a3,a4,714 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	fee7eae3          	bltu	a5,a4,704 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 714:	ff852583          	lw	a1,-8(a0)
 718:	6390                	ld	a2,0(a5)
 71a:	02059813          	slli	a6,a1,0x20
 71e:	01c85713          	srli	a4,a6,0x1c
 722:	9736                	add	a4,a4,a3
 724:	fae60de3          	beq	a2,a4,6de <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 72c:	4790                	lw	a2,8(a5)
 72e:	02061593          	slli	a1,a2,0x20
 732:	01c5d713          	srli	a4,a1,0x1c
 736:	973e                	add	a4,a4,a5
 738:	fae68ae3          	beq	a3,a4,6ec <free+0x22>
    p->s.ptr = bp->s.ptr;
 73c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 73e:	00001717          	auipc	a4,0x1
 742:	8cf73123          	sd	a5,-1854(a4) # 1000 <freep>
}
 746:	6422                	ld	s0,8(sp)
 748:	0141                	addi	sp,sp,16
 74a:	8082                	ret

000000000000074c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 74c:	7139                	addi	sp,sp,-64
 74e:	fc06                	sd	ra,56(sp)
 750:	f822                	sd	s0,48(sp)
 752:	f426                	sd	s1,40(sp)
 754:	ec4e                	sd	s3,24(sp)
 756:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	02051493          	slli	s1,a0,0x20
 75c:	9081                	srli	s1,s1,0x20
 75e:	04bd                	addi	s1,s1,15
 760:	8091                	srli	s1,s1,0x4
 762:	0014899b          	addiw	s3,s1,1
 766:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 768:	00001517          	auipc	a0,0x1
 76c:	89853503          	ld	a0,-1896(a0) # 1000 <freep>
 770:	c915                	beqz	a0,7a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 774:	4798                	lw	a4,8(a5)
 776:	08977a63          	bgeu	a4,s1,80a <malloc+0xbe>
 77a:	f04a                	sd	s2,32(sp)
 77c:	e852                	sd	s4,16(sp)
 77e:	e456                	sd	s5,8(sp)
 780:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 782:	8a4e                	mv	s4,s3
 784:	0009871b          	sext.w	a4,s3
 788:	6685                	lui	a3,0x1
 78a:	00d77363          	bgeu	a4,a3,790 <malloc+0x44>
 78e:	6a05                	lui	s4,0x1
 790:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 794:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 798:	00001917          	auipc	s2,0x1
 79c:	86890913          	addi	s2,s2,-1944 # 1000 <freep>
  if(p == (char*)-1)
 7a0:	5afd                	li	s5,-1
 7a2:	a081                	j	7e2 <malloc+0x96>
 7a4:	f04a                	sd	s2,32(sp)
 7a6:	e852                	sd	s4,16(sp)
 7a8:	e456                	sd	s5,8(sp)
 7aa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ac:	00001797          	auipc	a5,0x1
 7b0:	86478793          	addi	a5,a5,-1948 # 1010 <base>
 7b4:	00001717          	auipc	a4,0x1
 7b8:	84f73623          	sd	a5,-1972(a4) # 1000 <freep>
 7bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c2:	b7c1                	j	782 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7c4:	6398                	ld	a4,0(a5)
 7c6:	e118                	sd	a4,0(a0)
 7c8:	a8a9                	j	822 <malloc+0xd6>
  hp->s.size = nu;
 7ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ce:	0541                	addi	a0,a0,16
 7d0:	efbff0ef          	jal	6ca <free>
  return freep;
 7d4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7d8:	c12d                	beqz	a0,83a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7dc:	4798                	lw	a4,8(a5)
 7de:	02977263          	bgeu	a4,s1,802 <malloc+0xb6>
    if(p == freep)
 7e2:	00093703          	ld	a4,0(s2)
 7e6:	853e                	mv	a0,a5
 7e8:	fef719e3          	bne	a4,a5,7da <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7ec:	8552                	mv	a0,s4
 7ee:	b13ff0ef          	jal	300 <sbrk>
  if(p == (char*)-1)
 7f2:	fd551ce3          	bne	a0,s5,7ca <malloc+0x7e>
        return 0;
 7f6:	4501                	li	a0,0
 7f8:	7902                	ld	s2,32(sp)
 7fa:	6a42                	ld	s4,16(sp)
 7fc:	6aa2                	ld	s5,8(sp)
 7fe:	6b02                	ld	s6,0(sp)
 800:	a03d                	j	82e <malloc+0xe2>
 802:	7902                	ld	s2,32(sp)
 804:	6a42                	ld	s4,16(sp)
 806:	6aa2                	ld	s5,8(sp)
 808:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 80a:	fae48de3          	beq	s1,a4,7c4 <malloc+0x78>
        p->s.size -= nunits;
 80e:	4137073b          	subw	a4,a4,s3
 812:	c798                	sw	a4,8(a5)
        p += p->s.size;
 814:	02071693          	slli	a3,a4,0x20
 818:	01c6d713          	srli	a4,a3,0x1c
 81c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 822:	00000717          	auipc	a4,0x0
 826:	7ca73f23          	sd	a0,2014(a4) # 1000 <freep>
      return (void*)(p + 1);
 82a:	01078513          	addi	a0,a5,16
  }
}
 82e:	70e2                	ld	ra,56(sp)
 830:	7442                	ld	s0,48(sp)
 832:	74a2                	ld	s1,40(sp)
 834:	69e2                	ld	s3,24(sp)
 836:	6121                	addi	sp,sp,64
 838:	8082                	ret
 83a:	7902                	ld	s2,32(sp)
 83c:	6a42                	ld	s4,16(sp)
 83e:	6aa2                	ld	s5,8(sp)
 840:	6b02                	ld	s6,0(sp)
 842:	b7f5                	j	82e <malloc+0xe2>
