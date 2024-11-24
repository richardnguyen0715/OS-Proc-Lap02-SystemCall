
user/_sysinfotest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	5de000ef          	jal	5e6 <sysinfo>
   c:	00054663          	bltz	a0,18 <sinfo+0x18>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  10:	60a2                	ld	ra,8(sp)
  12:	6402                	ld	s0,0(sp)
  14:	0141                	addi	sp,sp,16
  16:	8082                	ret
    printf("FAIL: sysinfo failed");
  18:	00001517          	auipc	a0,0x1
  1c:	b0850513          	addi	a0,a0,-1272 # b20 <malloc+0x106>
  20:	147000ef          	jal	966 <printf>
    exit(1);
  24:	4505                	li	a0,1
  26:	520000ef          	jal	546 <exit>

000000000000002a <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  2a:	7139                	addi	sp,sp,-64
  2c:	fc06                	sd	ra,56(sp)
  2e:	f822                	sd	s0,48(sp)
  30:	f426                	sd	s1,40(sp)
  32:	f04a                	sd	s2,32(sp)
  34:	ec4e                	sd	s3,24(sp)
  36:	e852                	sd	s4,16(sp)
  38:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  3a:	4501                	li	a0,0
  3c:	592000ef          	jal	5ce <sbrk>
  40:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  42:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  44:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  46:	6985                	lui	s3,0x1
  48:	a019                	j	4e <countfree+0x24>
  4a:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  4e:	6505                	lui	a0,0x1
  50:	57e000ef          	jal	5ce <sbrk>
  54:	ff251be3          	bne	a0,s2,4a <countfree+0x20>
  }
  sinfo(&info);
  58:	fc040513          	addi	a0,s0,-64
  5c:	fa5ff0ef          	jal	0 <sinfo>
  if (info.freemem != 0) {
  60:	fc043583          	ld	a1,-64(s0)
  64:	e18d                	bnez	a1,86 <countfree+0x5c>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%ld\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  66:	4501                	li	a0,0
  68:	566000ef          	jal	5ce <sbrk>
  6c:	40aa053b          	subw	a0,s4,a0
  70:	55e000ef          	jal	5ce <sbrk>
  return n;
}
  74:	8526                	mv	a0,s1
  76:	70e2                	ld	ra,56(sp)
  78:	7442                	ld	s0,48(sp)
  7a:	74a2                	ld	s1,40(sp)
  7c:	7902                	ld	s2,32(sp)
  7e:	69e2                	ld	s3,24(sp)
  80:	6a42                	ld	s4,16(sp)
  82:	6121                	addi	sp,sp,64
  84:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%ld\n",
  86:	00001517          	auipc	a0,0x1
  8a:	ab250513          	addi	a0,a0,-1358 # b38 <malloc+0x11e>
  8e:	0d9000ef          	jal	966 <printf>
    exit(1);
  92:	4505                	li	a0,1
  94:	4b2000ef          	jal	546 <exit>

0000000000000098 <testmem>:

void
testmem() {
  98:	7179                	addi	sp,sp,-48
  9a:	f406                	sd	ra,40(sp)
  9c:	f022                	sd	s0,32(sp)
  9e:	ec26                	sd	s1,24(sp)
  a0:	e84a                	sd	s2,16(sp)
  a2:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  a4:	f87ff0ef          	jal	2a <countfree>
  a8:	84aa                	mv	s1,a0
  
  sinfo(&info);
  aa:	fd040513          	addi	a0,s0,-48
  ae:	f53ff0ef          	jal	0 <sinfo>

  if (info.freemem!= n) {
  b2:	fd043583          	ld	a1,-48(s0)
  b6:	04959663          	bne	a1,s1,102 <testmem+0x6a>
    printf("FAIL: free mem %ld (bytes) instead of %ld\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ba:	6505                	lui	a0,0x1
  bc:	512000ef          	jal	5ce <sbrk>
  c0:	57fd                	li	a5,-1
  c2:	04f50a63          	beq	a0,a5,116 <testmem+0x7e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  c6:	fd040513          	addi	a0,s0,-48
  ca:	f37ff0ef          	jal	0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
  ce:	fd043603          	ld	a2,-48(s0)
  d2:	75fd                	lui	a1,0xfffff
  d4:	95a6                	add	a1,a1,s1
  d6:	04b61963          	bne	a2,a1,128 <testmem+0x90>
    printf("FAIL: free mem %ld (bytes) instead of %ld\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
  da:	757d                	lui	a0,0xfffff
  dc:	4f2000ef          	jal	5ce <sbrk>
  e0:	57fd                	li	a5,-1
  e2:	04f50c63          	beq	a0,a5,13a <testmem+0xa2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  e6:	fd040513          	addi	a0,s0,-48
  ea:	f17ff0ef          	jal	0 <sinfo>
    
  if (info.freemem != n) {
  ee:	fd043603          	ld	a2,-48(s0)
  f2:	04961d63          	bne	a2,s1,14c <testmem+0xb4>
    printf("FAIL: free mem %ld (bytes) instead of %ld\n", n, info.freemem);
    exit(1);
  }
}
  f6:	70a2                	ld	ra,40(sp)
  f8:	7402                	ld	s0,32(sp)
  fa:	64e2                	ld	s1,24(sp)
  fc:	6942                	ld	s2,16(sp)
  fe:	6145                	addi	sp,sp,48
 100:	8082                	ret
    printf("FAIL: free mem %ld (bytes) instead of %ld\n", info.freemem, n);
 102:	8626                	mv	a2,s1
 104:	00001517          	auipc	a0,0x1
 108:	a6c50513          	addi	a0,a0,-1428 # b70 <malloc+0x156>
 10c:	05b000ef          	jal	966 <printf>
    exit(1);
 110:	4505                	li	a0,1
 112:	434000ef          	jal	546 <exit>
    printf("sbrk failed");
 116:	00001517          	auipc	a0,0x1
 11a:	a8a50513          	addi	a0,a0,-1398 # ba0 <malloc+0x186>
 11e:	049000ef          	jal	966 <printf>
    exit(1);
 122:	4505                	li	a0,1
 124:	422000ef          	jal	546 <exit>
    printf("FAIL: free mem %ld (bytes) instead of %ld\n", n-PGSIZE, info.freemem);
 128:	00001517          	auipc	a0,0x1
 12c:	a4850513          	addi	a0,a0,-1464 # b70 <malloc+0x156>
 130:	037000ef          	jal	966 <printf>
    exit(1);
 134:	4505                	li	a0,1
 136:	410000ef          	jal	546 <exit>
    printf("sbrk failed");
 13a:	00001517          	auipc	a0,0x1
 13e:	a6650513          	addi	a0,a0,-1434 # ba0 <malloc+0x186>
 142:	025000ef          	jal	966 <printf>
    exit(1);
 146:	4505                	li	a0,1
 148:	3fe000ef          	jal	546 <exit>
    printf("FAIL: free mem %ld (bytes) instead of %ld\n", n, info.freemem);
 14c:	85a6                	mv	a1,s1
 14e:	00001517          	auipc	a0,0x1
 152:	a2250513          	addi	a0,a0,-1502 # b70 <malloc+0x156>
 156:	011000ef          	jal	966 <printf>
    exit(1);
 15a:	4505                	li	a0,1
 15c:	3ea000ef          	jal	546 <exit>

0000000000000160 <testcall>:

void
testcall() {
 160:	1101                	addi	sp,sp,-32
 162:	ec06                	sd	ra,24(sp)
 164:	e822                	sd	s0,16(sp)
 166:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 168:	fe040513          	addi	a0,s0,-32
 16c:	47a000ef          	jal	5e6 <sysinfo>
 170:	02054463          	bltz	a0,198 <testcall+0x38>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 174:	eaeb1537          	lui	a0,0xeaeb1
 178:	b5b50513          	addi	a0,a0,-1189 # ffffffffeaeb0b5b <base+0xffffffffeaeaeb4b>
 17c:	0552                	slli	a0,a0,0x14
 17e:	050d                	addi	a0,a0,3
 180:	0532                	slli	a0,a0,0xc
 182:	f5e50513          	addi	a0,a0,-162
 186:	460000ef          	jal	5e6 <sysinfo>
 18a:	57fd                	li	a5,-1
 18c:	00f51f63          	bne	a0,a5,1aa <testcall+0x4a>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 198:	00001517          	auipc	a0,0x1
 19c:	a1850513          	addi	a0,a0,-1512 # bb0 <malloc+0x196>
 1a0:	7c6000ef          	jal	966 <printf>
    exit(1);
 1a4:	4505                	li	a0,1
 1a6:	3a0000ef          	jal	546 <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	a1e50513          	addi	a0,a0,-1506 # bc8 <malloc+0x1ae>
 1b2:	7b4000ef          	jal	966 <printf>
    exit(1);
 1b6:	4505                	li	a0,1
 1b8:	38e000ef          	jal	546 <exit>

00000000000001bc <testproc>:

void testproc() {
 1bc:	7139                	addi	sp,sp,-64
 1be:	fc06                	sd	ra,56(sp)
 1c0:	f822                	sd	s0,48(sp)
 1c2:	f426                	sd	s1,40(sp)
 1c4:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 1c6:	fd040513          	addi	a0,s0,-48
 1ca:	e37ff0ef          	jal	0 <sinfo>
  nproc = info.nproc;
 1ce:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 1d2:	36c000ef          	jal	53e <fork>
  if(pid < 0){
 1d6:	02054663          	bltz	a0,202 <testproc+0x46>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 1da:	e121                	bnez	a0,21a <testproc+0x5e>
    sinfo(&info);
 1dc:	fd040513          	addi	a0,s0,-48
 1e0:	e21ff0ef          	jal	0 <sinfo>
    if(info.nproc != nproc+1) {
 1e4:	fd843583          	ld	a1,-40(s0)
 1e8:	00148613          	addi	a2,s1,1
 1ec:	02c58463          	beq	a1,a2,214 <testproc+0x58>
      printf("sysinfotest: FAIL nproc is %ld instead of %ld\n", info.nproc, nproc+1);
 1f0:	00001517          	auipc	a0,0x1
 1f4:	a2850513          	addi	a0,a0,-1496 # c18 <malloc+0x1fe>
 1f8:	76e000ef          	jal	966 <printf>
      exit(1);
 1fc:	4505                	li	a0,1
 1fe:	348000ef          	jal	546 <exit>
    printf("sysinfotest: fork failed\n");
 202:	00001517          	auipc	a0,0x1
 206:	9f650513          	addi	a0,a0,-1546 # bf8 <malloc+0x1de>
 20a:	75c000ef          	jal	966 <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	336000ef          	jal	546 <exit>
    }
    exit(0);
 214:	4501                	li	a0,0
 216:	330000ef          	jal	546 <exit>
  }
  wait(&status);
 21a:	fcc40513          	addi	a0,s0,-52
 21e:	330000ef          	jal	54e <wait>
  sinfo(&info);
 222:	fd040513          	addi	a0,s0,-48
 226:	ddbff0ef          	jal	0 <sinfo>
  if(info.nproc != nproc) {
 22a:	fd843583          	ld	a1,-40(s0)
 22e:	00959763          	bne	a1,s1,23c <testproc+0x80>
      printf("sysinfotest: FAIL nproc is %ld instead of %ld\n", info.nproc, nproc);
      exit(1);
  }
}
 232:	70e2                	ld	ra,56(sp)
 234:	7442                	ld	s0,48(sp)
 236:	74a2                	ld	s1,40(sp)
 238:	6121                	addi	sp,sp,64
 23a:	8082                	ret
      printf("sysinfotest: FAIL nproc is %ld instead of %ld\n", info.nproc, nproc);
 23c:	8626                	mv	a2,s1
 23e:	00001517          	auipc	a0,0x1
 242:	9da50513          	addi	a0,a0,-1574 # c18 <malloc+0x1fe>
 246:	720000ef          	jal	966 <printf>
      exit(1);
 24a:	4505                	li	a0,1
 24c:	2fa000ef          	jal	546 <exit>

0000000000000250 <testbad>:

void testbad() {
 250:	1101                	addi	sp,sp,-32
 252:	ec06                	sd	ra,24(sp)
 254:	e822                	sd	s0,16(sp)
 256:	1000                	addi	s0,sp,32
  int pid = fork();
 258:	2e6000ef          	jal	53e <fork>
  int xstatus;
  
  if(pid < 0){
 25c:	00054863          	bltz	a0,26c <testbad+0x1c>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 260:	ed19                	bnez	a0,27e <testbad+0x2e>
      sinfo(0x0);
 262:	d9fff0ef          	jal	0 <sinfo>
      exit(0);
 266:	4501                	li	a0,0
 268:	2de000ef          	jal	546 <exit>
    printf("sysinfotest: fork failed\n");
 26c:	00001517          	auipc	a0,0x1
 270:	98c50513          	addi	a0,a0,-1652 # bf8 <malloc+0x1de>
 274:	6f2000ef          	jal	966 <printf>
    exit(1);
 278:	4505                	li	a0,1
 27a:	2cc000ef          	jal	546 <exit>
  }
  wait(&xstatus);
 27e:	fec40513          	addi	a0,s0,-20
 282:	2cc000ef          	jal	54e <wait>
  if(xstatus == -1)  // kernel killed child?
 286:	fec42583          	lw	a1,-20(s0)
 28a:	57fd                	li	a5,-1
 28c:	00f58c63          	beq	a1,a5,2a4 <testbad+0x54>
    exit(0);
  else {
    printf("sysinfotest: testbad succeeded %d\n", xstatus);
 290:	00001517          	auipc	a0,0x1
 294:	9b850513          	addi	a0,a0,-1608 # c48 <malloc+0x22e>
 298:	6ce000ef          	jal	966 <printf>
    exit(xstatus);
 29c:	fec42503          	lw	a0,-20(s0)
 2a0:	2a6000ef          	jal	546 <exit>
    exit(0);
 2a4:	4501                	li	a0,0
 2a6:	2a0000ef          	jal	546 <exit>

00000000000002aa <main>:
  }
}

int
main(int argc, char *argv[])
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 2b2:	00001517          	auipc	a0,0x1
 2b6:	9be50513          	addi	a0,a0,-1602 # c70 <malloc+0x256>
 2ba:	6ac000ef          	jal	966 <printf>
  testcall();
 2be:	ea3ff0ef          	jal	160 <testcall>
  testmem();
 2c2:	dd7ff0ef          	jal	98 <testmem>
  testproc();
 2c6:	ef7ff0ef          	jal	1bc <testproc>
  printf("sysinfotest: OK\n");
 2ca:	00001517          	auipc	a0,0x1
 2ce:	9be50513          	addi	a0,a0,-1602 # c88 <malloc+0x26e>
 2d2:	694000ef          	jal	966 <printf>
  exit(0);
 2d6:	4501                	li	a0,0
 2d8:	26e000ef          	jal	546 <exit>

00000000000002dc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e4:	fc7ff0ef          	jal	2aa <main>
  exit(0);
 2e8:	4501                	li	a0,0
 2ea:	25c000ef          	jal	546 <exit>

00000000000002ee <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f4:	87aa                	mv	a5,a0
 2f6:	0585                	addi	a1,a1,1 # fffffffffffff001 <base+0xffffffffffffcff1>
 2f8:	0785                	addi	a5,a5,1
 2fa:	fff5c703          	lbu	a4,-1(a1)
 2fe:	fee78fa3          	sb	a4,-1(a5)
 302:	fb75                	bnez	a4,2f6 <strcpy+0x8>
    ;
  return os;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 310:	00054783          	lbu	a5,0(a0)
 314:	cb91                	beqz	a5,328 <strcmp+0x1e>
 316:	0005c703          	lbu	a4,0(a1)
 31a:	00f71763          	bne	a4,a5,328 <strcmp+0x1e>
    p++, q++;
 31e:	0505                	addi	a0,a0,1
 320:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 322:	00054783          	lbu	a5,0(a0)
 326:	fbe5                	bnez	a5,316 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 328:	0005c503          	lbu	a0,0(a1)
}
 32c:	40a7853b          	subw	a0,a5,a0
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strlen>:

uint
strlen(const char *s)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cf91                	beqz	a5,35c <strlen+0x26>
 342:	0505                	addi	a0,a0,1
 344:	87aa                	mv	a5,a0
 346:	86be                	mv	a3,a5
 348:	0785                	addi	a5,a5,1
 34a:	fff7c703          	lbu	a4,-1(a5)
 34e:	ff65                	bnez	a4,346 <strlen+0x10>
 350:	40a6853b          	subw	a0,a3,a0
 354:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
  for(n = 0; s[n]; n++)
 35c:	4501                	li	a0,0
 35e:	bfe5                	j	356 <strlen+0x20>

0000000000000360 <memset>:

void*
memset(void *dst, int c, uint n)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 366:	ca19                	beqz	a2,37c <memset+0x1c>
 368:	87aa                	mv	a5,a0
 36a:	1602                	slli	a2,a2,0x20
 36c:	9201                	srli	a2,a2,0x20
 36e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 372:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 376:	0785                	addi	a5,a5,1
 378:	fee79de3          	bne	a5,a4,372 <memset+0x12>
  }
  return dst;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <strchr>:

char*
strchr(const char *s, char c)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  for(; *s; s++)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cb99                	beqz	a5,3a2 <strchr+0x20>
    if(*s == c)
 38e:	00f58763          	beq	a1,a5,39c <strchr+0x1a>
  for(; *s; s++)
 392:	0505                	addi	a0,a0,1
 394:	00054783          	lbu	a5,0(a0)
 398:	fbfd                	bnez	a5,38e <strchr+0xc>
      return (char*)s;
  return 0;
 39a:	4501                	li	a0,0
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfe5                	j	39c <strchr+0x1a>

00000000000003a6 <gets>:

char*
gets(char *buf, int max)
{
 3a6:	711d                	addi	sp,sp,-96
 3a8:	ec86                	sd	ra,88(sp)
 3aa:	e8a2                	sd	s0,80(sp)
 3ac:	e4a6                	sd	s1,72(sp)
 3ae:	e0ca                	sd	s2,64(sp)
 3b0:	fc4e                	sd	s3,56(sp)
 3b2:	f852                	sd	s4,48(sp)
 3b4:	f456                	sd	s5,40(sp)
 3b6:	f05a                	sd	s6,32(sp)
 3b8:	ec5e                	sd	s7,24(sp)
 3ba:	1080                	addi	s0,sp,96
 3bc:	8baa                	mv	s7,a0
 3be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c0:	892a                	mv	s2,a0
 3c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c4:	4aa9                	li	s5,10
 3c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3c8:	89a6                	mv	s3,s1
 3ca:	2485                	addiw	s1,s1,1
 3cc:	0344d663          	bge	s1,s4,3f8 <gets+0x52>
    cc = read(0, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	faf40593          	addi	a1,s0,-81
 3d6:	4501                	li	a0,0
 3d8:	186000ef          	jal	55e <read>
    if(cc < 1)
 3dc:	00a05e63          	blez	a0,3f8 <gets+0x52>
    buf[i++] = c;
 3e0:	faf44783          	lbu	a5,-81(s0)
 3e4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3e8:	01578763          	beq	a5,s5,3f6 <gets+0x50>
 3ec:	0905                	addi	s2,s2,1
 3ee:	fd679de3          	bne	a5,s6,3c8 <gets+0x22>
    buf[i++] = c;
 3f2:	89a6                	mv	s3,s1
 3f4:	a011                	j	3f8 <gets+0x52>
 3f6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3f8:	99de                	add	s3,s3,s7
 3fa:	00098023          	sb	zero,0(s3) # 1000 <digits+0x358>
  return buf;
}
 3fe:	855e                	mv	a0,s7
 400:	60e6                	ld	ra,88(sp)
 402:	6446                	ld	s0,80(sp)
 404:	64a6                	ld	s1,72(sp)
 406:	6906                	ld	s2,64(sp)
 408:	79e2                	ld	s3,56(sp)
 40a:	7a42                	ld	s4,48(sp)
 40c:	7aa2                	ld	s5,40(sp)
 40e:	7b02                	ld	s6,32(sp)
 410:	6be2                	ld	s7,24(sp)
 412:	6125                	addi	sp,sp,96
 414:	8082                	ret

0000000000000416 <stat>:

int
stat(const char *n, struct stat *st)
{
 416:	1101                	addi	sp,sp,-32
 418:	ec06                	sd	ra,24(sp)
 41a:	e822                	sd	s0,16(sp)
 41c:	e04a                	sd	s2,0(sp)
 41e:	1000                	addi	s0,sp,32
 420:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 422:	4581                	li	a1,0
 424:	162000ef          	jal	586 <open>
  if(fd < 0)
 428:	02054263          	bltz	a0,44c <stat+0x36>
 42c:	e426                	sd	s1,8(sp)
 42e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 430:	85ca                	mv	a1,s2
 432:	16c000ef          	jal	59e <fstat>
 436:	892a                	mv	s2,a0
  close(fd);
 438:	8526                	mv	a0,s1
 43a:	134000ef          	jal	56e <close>
  return r;
 43e:	64a2                	ld	s1,8(sp)
}
 440:	854a                	mv	a0,s2
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6902                	ld	s2,0(sp)
 448:	6105                	addi	sp,sp,32
 44a:	8082                	ret
    return -1;
 44c:	597d                	li	s2,-1
 44e:	bfcd                	j	440 <stat+0x2a>

0000000000000450 <atoi>:

int
atoi(const char *s)
{
 450:	1141                	addi	sp,sp,-16
 452:	e422                	sd	s0,8(sp)
 454:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 456:	00054683          	lbu	a3,0(a0)
 45a:	fd06879b          	addiw	a5,a3,-48
 45e:	0ff7f793          	zext.b	a5,a5
 462:	4625                	li	a2,9
 464:	02f66863          	bltu	a2,a5,494 <atoi+0x44>
 468:	872a                	mv	a4,a0
  n = 0;
 46a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 46c:	0705                	addi	a4,a4,1
 46e:	0025179b          	slliw	a5,a0,0x2
 472:	9fa9                	addw	a5,a5,a0
 474:	0017979b          	slliw	a5,a5,0x1
 478:	9fb5                	addw	a5,a5,a3
 47a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 47e:	00074683          	lbu	a3,0(a4)
 482:	fd06879b          	addiw	a5,a3,-48
 486:	0ff7f793          	zext.b	a5,a5
 48a:	fef671e3          	bgeu	a2,a5,46c <atoi+0x1c>
  return n;
}
 48e:	6422                	ld	s0,8(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret
  n = 0;
 494:	4501                	li	a0,0
 496:	bfe5                	j	48e <atoi+0x3e>

0000000000000498 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 498:	1141                	addi	sp,sp,-16
 49a:	e422                	sd	s0,8(sp)
 49c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 49e:	02b57463          	bgeu	a0,a1,4c6 <memmove+0x2e>
    while(n-- > 0)
 4a2:	00c05f63          	blez	a2,4c0 <memmove+0x28>
 4a6:	1602                	slli	a2,a2,0x20
 4a8:	9201                	srli	a2,a2,0x20
 4aa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 4b0:	0585                	addi	a1,a1,1
 4b2:	0705                	addi	a4,a4,1
 4b4:	fff5c683          	lbu	a3,-1(a1)
 4b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4bc:	fef71ae3          	bne	a4,a5,4b0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4c0:	6422                	ld	s0,8(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
    dst += n;
 4c6:	00c50733          	add	a4,a0,a2
    src += n;
 4ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4cc:	fec05ae3          	blez	a2,4c0 <memmove+0x28>
 4d0:	fff6079b          	addiw	a5,a2,-1
 4d4:	1782                	slli	a5,a5,0x20
 4d6:	9381                	srli	a5,a5,0x20
 4d8:	fff7c793          	not	a5,a5
 4dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4de:	15fd                	addi	a1,a1,-1
 4e0:	177d                	addi	a4,a4,-1
 4e2:	0005c683          	lbu	a3,0(a1)
 4e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ea:	fee79ae3          	bne	a5,a4,4de <memmove+0x46>
 4ee:	bfc9                	j	4c0 <memmove+0x28>

00000000000004f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f6:	ca05                	beqz	a2,526 <memcmp+0x36>
 4f8:	fff6069b          	addiw	a3,a2,-1
 4fc:	1682                	slli	a3,a3,0x20
 4fe:	9281                	srli	a3,a3,0x20
 500:	0685                	addi	a3,a3,1
 502:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 504:	00054783          	lbu	a5,0(a0)
 508:	0005c703          	lbu	a4,0(a1)
 50c:	00e79863          	bne	a5,a4,51c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 510:	0505                	addi	a0,a0,1
    p2++;
 512:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 514:	fed518e3          	bne	a0,a3,504 <memcmp+0x14>
  }
  return 0;
 518:	4501                	li	a0,0
 51a:	a019                	j	520 <memcmp+0x30>
      return *p1 - *p2;
 51c:	40e7853b          	subw	a0,a5,a4
}
 520:	6422                	ld	s0,8(sp)
 522:	0141                	addi	sp,sp,16
 524:	8082                	ret
  return 0;
 526:	4501                	li	a0,0
 528:	bfe5                	j	520 <memcmp+0x30>

000000000000052a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 52a:	1141                	addi	sp,sp,-16
 52c:	e406                	sd	ra,8(sp)
 52e:	e022                	sd	s0,0(sp)
 530:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 532:	f67ff0ef          	jal	498 <memmove>
}
 536:	60a2                	ld	ra,8(sp)
 538:	6402                	ld	s0,0(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret

000000000000053e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53e:	4885                	li	a7,1
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exit>:
.global exit
exit:
 li a7, SYS_exit
 546:	4889                	li	a7,2
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <wait>:
.global wait
wait:
 li a7, SYS_wait
 54e:	488d                	li	a7,3
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 556:	4891                	li	a7,4
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <read>:
.global read
read:
 li a7, SYS_read
 55e:	4895                	li	a7,5
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <write>:
.global write
write:
 li a7, SYS_write
 566:	48c1                	li	a7,16
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <close>:
.global close
close:
 li a7, SYS_close
 56e:	48d5                	li	a7,21
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <kill>:
.global kill
kill:
 li a7, SYS_kill
 576:	4899                	li	a7,6
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exec>:
.global exec
exec:
 li a7, SYS_exec
 57e:	489d                	li	a7,7
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <open>:
.global open
open:
 li a7, SYS_open
 586:	48bd                	li	a7,15
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58e:	48c5                	li	a7,17
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 596:	48c9                	li	a7,18
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59e:	48a1                	li	a7,8
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <link>:
.global link
link:
 li a7, SYS_link
 5a6:	48cd                	li	a7,19
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ae:	48d1                	li	a7,20
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b6:	48a5                	li	a7,9
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <dup>:
.global dup
dup:
 li a7, SYS_dup
 5be:	48a9                	li	a7,10
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c6:	48ad                	li	a7,11
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ce:	48b1                	li	a7,12
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d6:	48b5                	li	a7,13
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5de:	48b9                	li	a7,14
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5e6:	48dd                	li	a7,23
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ee:	1101                	addi	sp,sp,-32
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5fa:	4605                	li	a2,1
 5fc:	fef40593          	addi	a1,s0,-17
 600:	f67ff0ef          	jal	566 <write>
}
 604:	60e2                	ld	ra,24(sp)
 606:	6442                	ld	s0,16(sp)
 608:	6105                	addi	sp,sp,32
 60a:	8082                	ret

000000000000060c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60c:	7139                	addi	sp,sp,-64
 60e:	fc06                	sd	ra,56(sp)
 610:	f822                	sd	s0,48(sp)
 612:	f426                	sd	s1,40(sp)
 614:	0080                	addi	s0,sp,64
 616:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 618:	c299                	beqz	a3,61e <printint+0x12>
 61a:	0805c963          	bltz	a1,6ac <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 61e:	2581                	sext.w	a1,a1
  neg = 0;
 620:	4881                	li	a7,0
 622:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 626:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 628:	2601                	sext.w	a2,a2
 62a:	00000517          	auipc	a0,0x0
 62e:	67e50513          	addi	a0,a0,1662 # ca8 <digits>
 632:	883a                	mv	a6,a4
 634:	2705                	addiw	a4,a4,1
 636:	02c5f7bb          	remuw	a5,a1,a2
 63a:	1782                	slli	a5,a5,0x20
 63c:	9381                	srli	a5,a5,0x20
 63e:	97aa                	add	a5,a5,a0
 640:	0007c783          	lbu	a5,0(a5)
 644:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 648:	0005879b          	sext.w	a5,a1
 64c:	02c5d5bb          	divuw	a1,a1,a2
 650:	0685                	addi	a3,a3,1
 652:	fec7f0e3          	bgeu	a5,a2,632 <printint+0x26>
  if(neg)
 656:	00088c63          	beqz	a7,66e <printint+0x62>
    buf[i++] = '-';
 65a:	fd070793          	addi	a5,a4,-48
 65e:	00878733          	add	a4,a5,s0
 662:	02d00793          	li	a5,45
 666:	fef70823          	sb	a5,-16(a4)
 66a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 66e:	02e05a63          	blez	a4,6a2 <printint+0x96>
 672:	f04a                	sd	s2,32(sp)
 674:	ec4e                	sd	s3,24(sp)
 676:	fc040793          	addi	a5,s0,-64
 67a:	00e78933          	add	s2,a5,a4
 67e:	fff78993          	addi	s3,a5,-1
 682:	99ba                	add	s3,s3,a4
 684:	377d                	addiw	a4,a4,-1
 686:	1702                	slli	a4,a4,0x20
 688:	9301                	srli	a4,a4,0x20
 68a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 68e:	fff94583          	lbu	a1,-1(s2)
 692:	8526                	mv	a0,s1
 694:	f5bff0ef          	jal	5ee <putc>
  while(--i >= 0)
 698:	197d                	addi	s2,s2,-1
 69a:	ff391ae3          	bne	s2,s3,68e <printint+0x82>
 69e:	7902                	ld	s2,32(sp)
 6a0:	69e2                	ld	s3,24(sp)
}
 6a2:	70e2                	ld	ra,56(sp)
 6a4:	7442                	ld	s0,48(sp)
 6a6:	74a2                	ld	s1,40(sp)
 6a8:	6121                	addi	sp,sp,64
 6aa:	8082                	ret
    x = -xx;
 6ac:	40b005bb          	negw	a1,a1
    neg = 1;
 6b0:	4885                	li	a7,1
    x = -xx;
 6b2:	bf85                	j	622 <printint+0x16>

00000000000006b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b4:	711d                	addi	sp,sp,-96
 6b6:	ec86                	sd	ra,88(sp)
 6b8:	e8a2                	sd	s0,80(sp)
 6ba:	e0ca                	sd	s2,64(sp)
 6bc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6be:	0005c903          	lbu	s2,0(a1)
 6c2:	26090863          	beqz	s2,932 <vprintf+0x27e>
 6c6:	e4a6                	sd	s1,72(sp)
 6c8:	fc4e                	sd	s3,56(sp)
 6ca:	f852                	sd	s4,48(sp)
 6cc:	f456                	sd	s5,40(sp)
 6ce:	f05a                	sd	s6,32(sp)
 6d0:	ec5e                	sd	s7,24(sp)
 6d2:	e862                	sd	s8,16(sp)
 6d4:	e466                	sd	s9,8(sp)
 6d6:	8b2a                	mv	s6,a0
 6d8:	8a2e                	mv	s4,a1
 6da:	8bb2                	mv	s7,a2
  state = 0;
 6dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6de:	4481                	li	s1,0
 6e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6ea:	06c00c93          	li	s9,108
 6ee:	a005                	j	70e <vprintf+0x5a>
        putc(fd, c0);
 6f0:	85ca                	mv	a1,s2
 6f2:	855a                	mv	a0,s6
 6f4:	efbff0ef          	jal	5ee <putc>
 6f8:	a019                	j	6fe <vprintf+0x4a>
    } else if(state == '%'){
 6fa:	03598263          	beq	s3,s5,71e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6fe:	2485                	addiw	s1,s1,1
 700:	8726                	mv	a4,s1
 702:	009a07b3          	add	a5,s4,s1
 706:	0007c903          	lbu	s2,0(a5)
 70a:	20090c63          	beqz	s2,922 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 70e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 712:	fe0994e3          	bnez	s3,6fa <vprintf+0x46>
      if(c0 == '%'){
 716:	fd579de3          	bne	a5,s5,6f0 <vprintf+0x3c>
        state = '%';
 71a:	89be                	mv	s3,a5
 71c:	b7cd                	j	6fe <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 71e:	00ea06b3          	add	a3,s4,a4
 722:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 726:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 728:	c681                	beqz	a3,730 <vprintf+0x7c>
 72a:	9752                	add	a4,a4,s4
 72c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 730:	03878f63          	beq	a5,s8,76e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 734:	05978963          	beq	a5,s9,786 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 738:	07500713          	li	a4,117
 73c:	0ee78363          	beq	a5,a4,822 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 740:	07800713          	li	a4,120
 744:	12e78563          	beq	a5,a4,86e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 748:	07000713          	li	a4,112
 74c:	14e78a63          	beq	a5,a4,8a0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 750:	07300713          	li	a4,115
 754:	18e78a63          	beq	a5,a4,8e8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 758:	02500713          	li	a4,37
 75c:	04e79563          	bne	a5,a4,7a6 <vprintf+0xf2>
        putc(fd, '%');
 760:	02500593          	li	a1,37
 764:	855a                	mv	a0,s6
 766:	e89ff0ef          	jal	5ee <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bf49                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 76e:	008b8913          	addi	s2,s7,8
 772:	4685                	li	a3,1
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	e91ff0ef          	jal	60c <printint>
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
 784:	bfad                	j	6fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 786:	06400793          	li	a5,100
 78a:	02f68963          	beq	a3,a5,7bc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78e:	06c00793          	li	a5,108
 792:	04f68263          	beq	a3,a5,7d6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 796:	07500793          	li	a5,117
 79a:	0af68063          	beq	a3,a5,83a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 79e:	07800793          	li	a5,120
 7a2:	0ef68263          	beq	a3,a5,886 <vprintf+0x1d2>
        putc(fd, '%');
 7a6:	02500593          	li	a1,37
 7aa:	855a                	mv	a0,s6
 7ac:	e43ff0ef          	jal	5ee <putc>
        putc(fd, c0);
 7b0:	85ca                	mv	a1,s2
 7b2:	855a                	mv	a0,s6
 7b4:	e3bff0ef          	jal	5ee <putc>
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b791                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7bc:	008b8913          	addi	s2,s7,8
 7c0:	4685                	li	a3,1
 7c2:	4629                	li	a2,10
 7c4:	000ba583          	lw	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	e43ff0ef          	jal	60c <printint>
        i += 1;
 7ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
        i += 1;
 7d4:	b72d                	j	6fe <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7d6:	06400793          	li	a5,100
 7da:	02f60763          	beq	a2,a5,808 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7de:	07500793          	li	a5,117
 7e2:	06f60963          	beq	a2,a5,854 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7e6:	07800793          	li	a5,120
 7ea:	faf61ee3          	bne	a2,a5,7a6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ee:	008b8913          	addi	s2,s7,8
 7f2:	4681                	li	a3,0
 7f4:	4641                	li	a2,16
 7f6:	000ba583          	lw	a1,0(s7)
 7fa:	855a                	mv	a0,s6
 7fc:	e11ff0ef          	jal	60c <printint>
        i += 2;
 800:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 802:	8bca                	mv	s7,s2
      state = 0;
 804:	4981                	li	s3,0
        i += 2;
 806:	bde5                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 808:	008b8913          	addi	s2,s7,8
 80c:	4685                	li	a3,1
 80e:	4629                	li	a2,10
 810:	000ba583          	lw	a1,0(s7)
 814:	855a                	mv	a0,s6
 816:	df7ff0ef          	jal	60c <printint>
        i += 2;
 81a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 81c:	8bca                	mv	s7,s2
      state = 0;
 81e:	4981                	li	s3,0
        i += 2;
 820:	bdf9                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 822:	008b8913          	addi	s2,s7,8
 826:	4681                	li	a3,0
 828:	4629                	li	a2,10
 82a:	000ba583          	lw	a1,0(s7)
 82e:	855a                	mv	a0,s6
 830:	dddff0ef          	jal	60c <printint>
 834:	8bca                	mv	s7,s2
      state = 0;
 836:	4981                	li	s3,0
 838:	b5d9                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 83a:	008b8913          	addi	s2,s7,8
 83e:	4681                	li	a3,0
 840:	4629                	li	a2,10
 842:	000ba583          	lw	a1,0(s7)
 846:	855a                	mv	a0,s6
 848:	dc5ff0ef          	jal	60c <printint>
        i += 1;
 84c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 84e:	8bca                	mv	s7,s2
      state = 0;
 850:	4981                	li	s3,0
        i += 1;
 852:	b575                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 854:	008b8913          	addi	s2,s7,8
 858:	4681                	li	a3,0
 85a:	4629                	li	a2,10
 85c:	000ba583          	lw	a1,0(s7)
 860:	855a                	mv	a0,s6
 862:	dabff0ef          	jal	60c <printint>
        i += 2;
 866:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 868:	8bca                	mv	s7,s2
      state = 0;
 86a:	4981                	li	s3,0
        i += 2;
 86c:	bd49                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 86e:	008b8913          	addi	s2,s7,8
 872:	4681                	li	a3,0
 874:	4641                	li	a2,16
 876:	000ba583          	lw	a1,0(s7)
 87a:	855a                	mv	a0,s6
 87c:	d91ff0ef          	jal	60c <printint>
 880:	8bca                	mv	s7,s2
      state = 0;
 882:	4981                	li	s3,0
 884:	bdad                	j	6fe <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 886:	008b8913          	addi	s2,s7,8
 88a:	4681                	li	a3,0
 88c:	4641                	li	a2,16
 88e:	000ba583          	lw	a1,0(s7)
 892:	855a                	mv	a0,s6
 894:	d79ff0ef          	jal	60c <printint>
        i += 1;
 898:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 89a:	8bca                	mv	s7,s2
      state = 0;
 89c:	4981                	li	s3,0
        i += 1;
 89e:	b585                	j	6fe <vprintf+0x4a>
 8a0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8a2:	008b8d13          	addi	s10,s7,8
 8a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8aa:	03000593          	li	a1,48
 8ae:	855a                	mv	a0,s6
 8b0:	d3fff0ef          	jal	5ee <putc>
  putc(fd, 'x');
 8b4:	07800593          	li	a1,120
 8b8:	855a                	mv	a0,s6
 8ba:	d35ff0ef          	jal	5ee <putc>
 8be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c0:	00000b97          	auipc	s7,0x0
 8c4:	3e8b8b93          	addi	s7,s7,1000 # ca8 <digits>
 8c8:	03c9d793          	srli	a5,s3,0x3c
 8cc:	97de                	add	a5,a5,s7
 8ce:	0007c583          	lbu	a1,0(a5)
 8d2:	855a                	mv	a0,s6
 8d4:	d1bff0ef          	jal	5ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d8:	0992                	slli	s3,s3,0x4
 8da:	397d                	addiw	s2,s2,-1
 8dc:	fe0916e3          	bnez	s2,8c8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8e0:	8bea                	mv	s7,s10
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	6d02                	ld	s10,0(sp)
 8e6:	bd21                	j	6fe <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8e8:	008b8993          	addi	s3,s7,8
 8ec:	000bb903          	ld	s2,0(s7)
 8f0:	00090f63          	beqz	s2,90e <vprintf+0x25a>
        for(; *s; s++)
 8f4:	00094583          	lbu	a1,0(s2)
 8f8:	c195                	beqz	a1,91c <vprintf+0x268>
          putc(fd, *s);
 8fa:	855a                	mv	a0,s6
 8fc:	cf3ff0ef          	jal	5ee <putc>
        for(; *s; s++)
 900:	0905                	addi	s2,s2,1
 902:	00094583          	lbu	a1,0(s2)
 906:	f9f5                	bnez	a1,8fa <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 908:	8bce                	mv	s7,s3
      state = 0;
 90a:	4981                	li	s3,0
 90c:	bbcd                	j	6fe <vprintf+0x4a>
          s = "(null)";
 90e:	00000917          	auipc	s2,0x0
 912:	39290913          	addi	s2,s2,914 # ca0 <malloc+0x286>
        for(; *s; s++)
 916:	02800593          	li	a1,40
 91a:	b7c5                	j	8fa <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 91c:	8bce                	mv	s7,s3
      state = 0;
 91e:	4981                	li	s3,0
 920:	bbf9                	j	6fe <vprintf+0x4a>
 922:	64a6                	ld	s1,72(sp)
 924:	79e2                	ld	s3,56(sp)
 926:	7a42                	ld	s4,48(sp)
 928:	7aa2                	ld	s5,40(sp)
 92a:	7b02                	ld	s6,32(sp)
 92c:	6be2                	ld	s7,24(sp)
 92e:	6c42                	ld	s8,16(sp)
 930:	6ca2                	ld	s9,8(sp)
    }
  }
}
 932:	60e6                	ld	ra,88(sp)
 934:	6446                	ld	s0,80(sp)
 936:	6906                	ld	s2,64(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 93c:	715d                	addi	sp,sp,-80
 93e:	ec06                	sd	ra,24(sp)
 940:	e822                	sd	s0,16(sp)
 942:	1000                	addi	s0,sp,32
 944:	e010                	sd	a2,0(s0)
 946:	e414                	sd	a3,8(s0)
 948:	e818                	sd	a4,16(s0)
 94a:	ec1c                	sd	a5,24(s0)
 94c:	03043023          	sd	a6,32(s0)
 950:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 954:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 958:	8622                	mv	a2,s0
 95a:	d5bff0ef          	jal	6b4 <vprintf>
}
 95e:	60e2                	ld	ra,24(sp)
 960:	6442                	ld	s0,16(sp)
 962:	6161                	addi	sp,sp,80
 964:	8082                	ret

0000000000000966 <printf>:

void
printf(const char *fmt, ...)
{
 966:	711d                	addi	sp,sp,-96
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	1000                	addi	s0,sp,32
 96e:	e40c                	sd	a1,8(s0)
 970:	e810                	sd	a2,16(s0)
 972:	ec14                	sd	a3,24(s0)
 974:	f018                	sd	a4,32(s0)
 976:	f41c                	sd	a5,40(s0)
 978:	03043823          	sd	a6,48(s0)
 97c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 980:	00840613          	addi	a2,s0,8
 984:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 988:	85aa                	mv	a1,a0
 98a:	4505                	li	a0,1
 98c:	d29ff0ef          	jal	6b4 <vprintf>
}
 990:	60e2                	ld	ra,24(sp)
 992:	6442                	ld	s0,16(sp)
 994:	6125                	addi	sp,sp,96
 996:	8082                	ret

0000000000000998 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 998:	1141                	addi	sp,sp,-16
 99a:	e422                	sd	s0,8(sp)
 99c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	00001797          	auipc	a5,0x1
 9a6:	65e7b783          	ld	a5,1630(a5) # 2000 <freep>
 9aa:	a02d                	j	9d4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ac:	4618                	lw	a4,8(a2)
 9ae:	9f2d                	addw	a4,a4,a1
 9b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	6398                	ld	a4,0(a5)
 9b6:	6310                	ld	a2,0(a4)
 9b8:	a83d                	j	9f6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9ba:	ff852703          	lw	a4,-8(a0)
 9be:	9f31                	addw	a4,a4,a2
 9c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9c2:	ff053683          	ld	a3,-16(a0)
 9c6:	a091                	j	a0a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c8:	6398                	ld	a4,0(a5)
 9ca:	00e7e463          	bltu	a5,a4,9d2 <free+0x3a>
 9ce:	00e6ea63          	bltu	a3,a4,9e2 <free+0x4a>
{
 9d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d4:	fed7fae3          	bgeu	a5,a3,9c8 <free+0x30>
 9d8:	6398                	ld	a4,0(a5)
 9da:	00e6e463          	bltu	a3,a4,9e2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9de:	fee7eae3          	bltu	a5,a4,9d2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9e2:	ff852583          	lw	a1,-8(a0)
 9e6:	6390                	ld	a2,0(a5)
 9e8:	02059813          	slli	a6,a1,0x20
 9ec:	01c85713          	srli	a4,a6,0x1c
 9f0:	9736                	add	a4,a4,a3
 9f2:	fae60de3          	beq	a2,a4,9ac <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9f6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9fa:	4790                	lw	a2,8(a5)
 9fc:	02061593          	slli	a1,a2,0x20
 a00:	01c5d713          	srli	a4,a1,0x1c
 a04:	973e                	add	a4,a4,a5
 a06:	fae68ae3          	beq	a3,a4,9ba <free+0x22>
    p->s.ptr = bp->s.ptr;
 a0a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a0c:	00001717          	auipc	a4,0x1
 a10:	5ef73a23          	sd	a5,1524(a4) # 2000 <freep>
}
 a14:	6422                	ld	s0,8(sp)
 a16:	0141                	addi	sp,sp,16
 a18:	8082                	ret

0000000000000a1a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a1a:	7139                	addi	sp,sp,-64
 a1c:	fc06                	sd	ra,56(sp)
 a1e:	f822                	sd	s0,48(sp)
 a20:	f426                	sd	s1,40(sp)
 a22:	ec4e                	sd	s3,24(sp)
 a24:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a26:	02051493          	slli	s1,a0,0x20
 a2a:	9081                	srli	s1,s1,0x20
 a2c:	04bd                	addi	s1,s1,15
 a2e:	8091                	srli	s1,s1,0x4
 a30:	0014899b          	addiw	s3,s1,1
 a34:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a36:	00001517          	auipc	a0,0x1
 a3a:	5ca53503          	ld	a0,1482(a0) # 2000 <freep>
 a3e:	c915                	beqz	a0,a72 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a42:	4798                	lw	a4,8(a5)
 a44:	08977a63          	bgeu	a4,s1,ad8 <malloc+0xbe>
 a48:	f04a                	sd	s2,32(sp)
 a4a:	e852                	sd	s4,16(sp)
 a4c:	e456                	sd	s5,8(sp)
 a4e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a50:	8a4e                	mv	s4,s3
 a52:	0009871b          	sext.w	a4,s3
 a56:	6685                	lui	a3,0x1
 a58:	00d77363          	bgeu	a4,a3,a5e <malloc+0x44>
 a5c:	6a05                	lui	s4,0x1
 a5e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a62:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a66:	00001917          	auipc	s2,0x1
 a6a:	59a90913          	addi	s2,s2,1434 # 2000 <freep>
  if(p == (char*)-1)
 a6e:	5afd                	li	s5,-1
 a70:	a081                	j	ab0 <malloc+0x96>
 a72:	f04a                	sd	s2,32(sp)
 a74:	e852                	sd	s4,16(sp)
 a76:	e456                	sd	s5,8(sp)
 a78:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a7a:	00001797          	auipc	a5,0x1
 a7e:	59678793          	addi	a5,a5,1430 # 2010 <base>
 a82:	00001717          	auipc	a4,0x1
 a86:	56f73f23          	sd	a5,1406(a4) # 2000 <freep>
 a8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a90:	b7c1                	j	a50 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a92:	6398                	ld	a4,0(a5)
 a94:	e118                	sd	a4,0(a0)
 a96:	a8a9                	j	af0 <malloc+0xd6>
  hp->s.size = nu;
 a98:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a9c:	0541                	addi	a0,a0,16
 a9e:	efbff0ef          	jal	998 <free>
  return freep;
 aa2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa6:	c12d                	beqz	a0,b08 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aaa:	4798                	lw	a4,8(a5)
 aac:	02977263          	bgeu	a4,s1,ad0 <malloc+0xb6>
    if(p == freep)
 ab0:	00093703          	ld	a4,0(s2)
 ab4:	853e                	mv	a0,a5
 ab6:	fef719e3          	bne	a4,a5,aa8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 aba:	8552                	mv	a0,s4
 abc:	b13ff0ef          	jal	5ce <sbrk>
  if(p == (char*)-1)
 ac0:	fd551ce3          	bne	a0,s5,a98 <malloc+0x7e>
        return 0;
 ac4:	4501                	li	a0,0
 ac6:	7902                	ld	s2,32(sp)
 ac8:	6a42                	ld	s4,16(sp)
 aca:	6aa2                	ld	s5,8(sp)
 acc:	6b02                	ld	s6,0(sp)
 ace:	a03d                	j	afc <malloc+0xe2>
 ad0:	7902                	ld	s2,32(sp)
 ad2:	6a42                	ld	s4,16(sp)
 ad4:	6aa2                	ld	s5,8(sp)
 ad6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad8:	fae48de3          	beq	s1,a4,a92 <malloc+0x78>
        p->s.size -= nunits;
 adc:	4137073b          	subw	a4,a4,s3
 ae0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae2:	02071693          	slli	a3,a4,0x20
 ae6:	01c6d713          	srli	a4,a3,0x1c
 aea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 af0:	00001717          	auipc	a4,0x1
 af4:	50a73823          	sd	a0,1296(a4) # 2000 <freep>
      return (void*)(p + 1);
 af8:	01078513          	addi	a0,a5,16
  }
}
 afc:	70e2                	ld	ra,56(sp)
 afe:	7442                	ld	s0,48(sp)
 b00:	74a2                	ld	s1,40(sp)
 b02:	69e2                	ld	s3,24(sp)
 b04:	6121                	addi	sp,sp,64
 b06:	8082                	ret
 b08:	7902                	ld	s2,32(sp)
 b0a:	6a42                	ld	s4,16(sp)
 b0c:	6aa2                	ld	s5,8(sp)
 b0e:	6b02                	ld	s6,0(sp)
 b10:	b7f5                	j	afc <malloc+0xe2>