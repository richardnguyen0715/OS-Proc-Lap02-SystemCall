
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	1d013103          	ld	sp,464(sp) # 8000a1d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	499040ef          	jal	80004cae <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	52078793          	addi	a5,a5,1312 # 80023550 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	1dc90913          	addi	s2,s2,476 # 8000a220 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	6c2050ef          	jal	80005710 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	74a050ef          	jal	800057a8 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	36c050ef          	jal	800053e2 <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	6985                	lui	s3,0x1
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	14e50513          	addi	a0,a0,334 # 8000a220 <kmem>
    800000da:	5b6050ef          	jal	80005690 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00023517          	auipc	a0,0x23
    800000e6:	46e50513          	addi	a0,a0,1134 # 80023550 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	12048493          	addi	s1,s1,288 # 8000a220 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	606050ef          	jal	80005710 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	12f73223          	sd	a5,292(a4) # 8000a238 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	10450513          	addi	a0,a0,260 # 8000a220 <kmem>
    80000124:	684050ef          	jal	800057a8 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000134:	1141                	addi	sp,sp,-16
    80000136:	e422                	sd	s0,8(sp)
    80000138:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000013a:	ca19                	beqz	a2,80000150 <memset+0x1c>
    8000013c:	87aa                	mv	a5,a0
    8000013e:	1602                	slli	a2,a2,0x20
    80000140:	9201                	srli	a2,a2,0x20
    80000142:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000146:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000014a:	0785                	addi	a5,a5,1
    8000014c:	fee79de3          	bne	a5,a4,80000146 <memset+0x12>
  }
  return dst;
}
    80000150:	6422                	ld	s0,8(sp)
    80000152:	0141                	addi	sp,sp,16
    80000154:	8082                	ret

0000000080000156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000156:	1141                	addi	sp,sp,-16
    80000158:	e422                	sd	s0,8(sp)
    8000015a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000015c:	ca05                	beqz	a2,8000018c <memcmp+0x36>
    8000015e:	fff6069b          	addiw	a3,a2,-1
    80000162:	1682                	slli	a3,a3,0x20
    80000164:	9281                	srli	a3,a3,0x20
    80000166:	0685                	addi	a3,a3,1
    80000168:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000016a:	00054783          	lbu	a5,0(a0)
    8000016e:	0005c703          	lbu	a4,0(a1)
    80000172:	00e79863          	bne	a5,a4,80000182 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000176:	0505                	addi	a0,a0,1
    80000178:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000017a:	fed518e3          	bne	a0,a3,8000016a <memcmp+0x14>
  }

  return 0;
    8000017e:	4501                	li	a0,0
    80000180:	a019                	j	80000186 <memcmp+0x30>
      return *s1 - *s2;
    80000182:	40e7853b          	subw	a0,a5,a4
}
    80000186:	6422                	ld	s0,8(sp)
    80000188:	0141                	addi	sp,sp,16
    8000018a:	8082                	ret
  return 0;
    8000018c:	4501                	li	a0,0
    8000018e:	bfe5                	j	80000186 <memcmp+0x30>

0000000080000190 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000196:	c205                	beqz	a2,800001b6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000198:	02a5e263          	bltu	a1,a0,800001bc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000019c:	1602                	slli	a2,a2,0x20
    8000019e:	9201                	srli	a2,a2,0x20
    800001a0:	00c587b3          	add	a5,a1,a2
{
    800001a4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001a6:	0585                	addi	a1,a1,1
    800001a8:	0705                	addi	a4,a4,1
    800001aa:	fff5c683          	lbu	a3,-1(a1)
    800001ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001b2:	feb79ae3          	bne	a5,a1,800001a6 <memmove+0x16>

  return dst;
}
    800001b6:	6422                	ld	s0,8(sp)
    800001b8:	0141                	addi	sp,sp,16
    800001ba:	8082                	ret
  if(s < d && s + n > d){
    800001bc:	02061693          	slli	a3,a2,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	00d58733          	add	a4,a1,a3
    800001c6:	fce57be3          	bgeu	a0,a4,8000019c <memmove+0xc>
    d += n;
    800001ca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001cc:	fff6079b          	addiw	a5,a2,-1
    800001d0:	1782                	slli	a5,a5,0x20
    800001d2:	9381                	srli	a5,a5,0x20
    800001d4:	fff7c793          	not	a5,a5
    800001d8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001da:	177d                	addi	a4,a4,-1
    800001dc:	16fd                	addi	a3,a3,-1
    800001de:	00074603          	lbu	a2,0(a4)
    800001e2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001e6:	fef71ae3          	bne	a4,a5,800001da <memmove+0x4a>
    800001ea:	b7f1                	j	800001b6 <memmove+0x26>

00000000800001ec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e406                	sd	ra,8(sp)
    800001f0:	e022                	sd	s0,0(sp)
    800001f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800001f4:	f9dff0ef          	jal	80000190 <memmove>
}
    800001f8:	60a2                	ld	ra,8(sp)
    800001fa:	6402                	ld	s0,0(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret

0000000080000200 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000200:	1141                	addi	sp,sp,-16
    80000202:	e422                	sd	s0,8(sp)
    80000204:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000206:	ce11                	beqz	a2,80000222 <strncmp+0x22>
    80000208:	00054783          	lbu	a5,0(a0)
    8000020c:	cf89                	beqz	a5,80000226 <strncmp+0x26>
    8000020e:	0005c703          	lbu	a4,0(a1)
    80000212:	00f71a63          	bne	a4,a5,80000226 <strncmp+0x26>
    n--, p++, q++;
    80000216:	367d                	addiw	a2,a2,-1
    80000218:	0505                	addi	a0,a0,1
    8000021a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000021c:	f675                	bnez	a2,80000208 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000021e:	4501                	li	a0,0
    80000220:	a801                	j	80000230 <strncmp+0x30>
    80000222:	4501                	li	a0,0
    80000224:	a031                	j	80000230 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000226:	00054503          	lbu	a0,0(a0)
    8000022a:	0005c783          	lbu	a5,0(a1)
    8000022e:	9d1d                	subw	a0,a0,a5
}
    80000230:	6422                	ld	s0,8(sp)
    80000232:	0141                	addi	sp,sp,16
    80000234:	8082                	ret

0000000080000236 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000236:	1141                	addi	sp,sp,-16
    80000238:	e422                	sd	s0,8(sp)
    8000023a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000023c:	87aa                	mv	a5,a0
    8000023e:	86b2                	mv	a3,a2
    80000240:	367d                	addiw	a2,a2,-1
    80000242:	02d05563          	blez	a3,8000026c <strncpy+0x36>
    80000246:	0785                	addi	a5,a5,1
    80000248:	0005c703          	lbu	a4,0(a1)
    8000024c:	fee78fa3          	sb	a4,-1(a5)
    80000250:	0585                	addi	a1,a1,1
    80000252:	f775                	bnez	a4,8000023e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000254:	873e                	mv	a4,a5
    80000256:	9fb5                	addw	a5,a5,a3
    80000258:	37fd                	addiw	a5,a5,-1
    8000025a:	00c05963          	blez	a2,8000026c <strncpy+0x36>
    *s++ = 0;
    8000025e:	0705                	addi	a4,a4,1
    80000260:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000264:	40e786bb          	subw	a3,a5,a4
    80000268:	fed04be3          	bgtz	a3,8000025e <strncpy+0x28>
  return os;
}
    8000026c:	6422                	ld	s0,8(sp)
    8000026e:	0141                	addi	sp,sp,16
    80000270:	8082                	ret

0000000080000272 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000272:	1141                	addi	sp,sp,-16
    80000274:	e422                	sd	s0,8(sp)
    80000276:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000278:	02c05363          	blez	a2,8000029e <safestrcpy+0x2c>
    8000027c:	fff6069b          	addiw	a3,a2,-1
    80000280:	1682                	slli	a3,a3,0x20
    80000282:	9281                	srli	a3,a3,0x20
    80000284:	96ae                	add	a3,a3,a1
    80000286:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000288:	00d58963          	beq	a1,a3,8000029a <safestrcpy+0x28>
    8000028c:	0585                	addi	a1,a1,1
    8000028e:	0785                	addi	a5,a5,1
    80000290:	fff5c703          	lbu	a4,-1(a1)
    80000294:	fee78fa3          	sb	a4,-1(a5)
    80000298:	fb65                	bnez	a4,80000288 <safestrcpy+0x16>
    ;
  *s = 0;
    8000029a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000029e:	6422                	ld	s0,8(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret

00000000800002a4 <strlen>:

int
strlen(const char *s)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e422                	sd	s0,8(sp)
    800002a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	cf91                	beqz	a5,800002ca <strlen+0x26>
    800002b0:	0505                	addi	a0,a0,1
    800002b2:	87aa                	mv	a5,a0
    800002b4:	86be                	mv	a3,a5
    800002b6:	0785                	addi	a5,a5,1
    800002b8:	fff7c703          	lbu	a4,-1(a5)
    800002bc:	ff65                	bnez	a4,800002b4 <strlen+0x10>
    800002be:	40a6853b          	subw	a0,a3,a0
    800002c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret
  for(n = 0; s[n]; n++)
    800002ca:	4501                	li	a0,0
    800002cc:	bfe5                	j	800002c4 <strlen+0x20>

00000000800002ce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e406                	sd	ra,8(sp)
    800002d2:	e022                	sd	s0,0(sp)
    800002d4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002d6:	255000ef          	jal	80000d2a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002da:	0000a717          	auipc	a4,0xa
    800002de:	f1670713          	addi	a4,a4,-234 # 8000a1f0 <started>
  if(cpuid() == 0){
    800002e2:	c51d                	beqz	a0,80000310 <main+0x42>
    while(started == 0)
    800002e4:	431c                	lw	a5,0(a4)
    800002e6:	2781                	sext.w	a5,a5
    800002e8:	dff5                	beqz	a5,800002e4 <main+0x16>
      ;
    __sync_synchronize();
    800002ea:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800002ee:	23d000ef          	jal	80000d2a <cpuid>
    800002f2:	85aa                	mv	a1,a0
    800002f4:	00007517          	auipc	a0,0x7
    800002f8:	d4450513          	addi	a0,a0,-700 # 80007038 <etext+0x38>
    800002fc:	615040ef          	jal	80005110 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	542010ef          	jal	80001846 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	3c0040ef          	jal	800046c8 <plicinithart>
  }

  scheduler();        
    8000030c:	67f000ef          	jal	8000118a <scheduler>
    consoleinit();
    80000310:	52b040ef          	jal	8000503a <consoleinit>
    printfinit();
    80000314:	108050ef          	jal	8000541c <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	5f1040ef          	jal	80005110 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	5e5040ef          	jal	80005110 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	5d9040ef          	jal	80005110 <printf>
    kinit();         // physical page allocator
    8000033c:	d87ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000340:	2ca000ef          	jal	8000060a <kvminit>
    kvminithart();   // turn on paging
    80000344:	03c000ef          	jal	80000380 <kvminithart>
    procinit();      // process table
    80000348:	12d000ef          	jal	80000c74 <procinit>
    trapinit();      // trap vectors
    8000034c:	4d6010ef          	jal	80001822 <trapinit>
    trapinithart();  // install kernel trap vector
    80000350:	4f6010ef          	jal	80001846 <trapinithart>
    plicinit();      // set up interrupt controller
    80000354:	35a040ef          	jal	800046ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	370040ef          	jal	800046c8 <plicinithart>
    binit();         // buffer cache
    8000035c:	31d010ef          	jal	80001e78 <binit>
    iinit();         // inode table
    80000360:	10e020ef          	jal	8000246e <iinit>
    fileinit();      // file table
    80000364:	6bb020ef          	jal	8000321e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	450040ef          	jal	800047b8 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	453000ef          	jal	80000fbe <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	e6f72d23          	sw	a5,-390(a4) # 8000a1f0 <started>
    8000037e:	b779                	j	8000030c <main+0x3e>

0000000080000380 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000380:	1141                	addi	sp,sp,-16
    80000382:	e422                	sd	s0,8(sp)
    80000384:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000386:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000038a:	0000a797          	auipc	a5,0xa
    8000038e:	e6e7b783          	ld	a5,-402(a5) # 8000a1f8 <kernel_pagetable>
    80000392:	83b1                	srli	a5,a5,0xc
    80000394:	577d                	li	a4,-1
    80000396:	177e                	slli	a4,a4,0x3f
    80000398:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000039a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000039e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003a2:	6422                	ld	s0,8(sp)
    800003a4:	0141                	addi	sp,sp,16
    800003a6:	8082                	ret

00000000800003a8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003a8:	7139                	addi	sp,sp,-64
    800003aa:	fc06                	sd	ra,56(sp)
    800003ac:	f822                	sd	s0,48(sp)
    800003ae:	f426                	sd	s1,40(sp)
    800003b0:	f04a                	sd	s2,32(sp)
    800003b2:	ec4e                	sd	s3,24(sp)
    800003b4:	e852                	sd	s4,16(sp)
    800003b6:	e456                	sd	s5,8(sp)
    800003b8:	e05a                	sd	s6,0(sp)
    800003ba:	0080                	addi	s0,sp,64
    800003bc:	84aa                	mv	s1,a0
    800003be:	89ae                	mv	s3,a1
    800003c0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003c2:	57fd                	li	a5,-1
    800003c4:	83e9                	srli	a5,a5,0x1a
    800003c6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003c8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ca:	02b7fc63          	bgeu	a5,a1,80000402 <walk+0x5a>
    panic("walk");
    800003ce:	00007517          	auipc	a0,0x7
    800003d2:	c8250513          	addi	a0,a0,-894 # 80007050 <etext+0x50>
    800003d6:	00c050ef          	jal	800053e2 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003da:	060a8263          	beqz	s5,8000043e <walk+0x96>
    800003de:	d19ff0ef          	jal	800000f6 <kalloc>
    800003e2:	84aa                	mv	s1,a0
    800003e4:	c139                	beqz	a0,8000042a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800003e6:	6605                	lui	a2,0x1
    800003e8:	4581                	li	a1,0
    800003ea:	d4bff0ef          	jal	80000134 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003ee:	00c4d793          	srli	a5,s1,0xc
    800003f2:	07aa                	slli	a5,a5,0xa
    800003f4:	0017e793          	ori	a5,a5,1
    800003f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbaa7>
    800003fe:	036a0063          	beq	s4,s6,8000041e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000402:	0149d933          	srl	s2,s3,s4
    80000406:	1ff97913          	andi	s2,s2,511
    8000040a:	090e                	slli	s2,s2,0x3
    8000040c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000040e:	00093483          	ld	s1,0(s2)
    80000412:	0014f793          	andi	a5,s1,1
    80000416:	d3f1                	beqz	a5,800003da <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000418:	80a9                	srli	s1,s1,0xa
    8000041a:	04b2                	slli	s1,s1,0xc
    8000041c:	b7c5                	j	800003fc <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000041e:	00c9d513          	srli	a0,s3,0xc
    80000422:	1ff57513          	andi	a0,a0,511
    80000426:	050e                	slli	a0,a0,0x3
    80000428:	9526                	add	a0,a0,s1
}
    8000042a:	70e2                	ld	ra,56(sp)
    8000042c:	7442                	ld	s0,48(sp)
    8000042e:	74a2                	ld	s1,40(sp)
    80000430:	7902                	ld	s2,32(sp)
    80000432:	69e2                	ld	s3,24(sp)
    80000434:	6a42                	ld	s4,16(sp)
    80000436:	6aa2                	ld	s5,8(sp)
    80000438:	6b02                	ld	s6,0(sp)
    8000043a:	6121                	addi	sp,sp,64
    8000043c:	8082                	ret
        return 0;
    8000043e:	4501                	li	a0,0
    80000440:	b7ed                	j	8000042a <walk+0x82>

0000000080000442 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000442:	57fd                	li	a5,-1
    80000444:	83e9                	srli	a5,a5,0x1a
    80000446:	00b7f463          	bgeu	a5,a1,8000044e <walkaddr+0xc>
    return 0;
    8000044a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000044c:	8082                	ret
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000456:	4601                	li	a2,0
    80000458:	f51ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    8000045c:	c105                	beqz	a0,8000047c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000045e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000460:	0117f693          	andi	a3,a5,17
    80000464:	4745                	li	a4,17
    return 0;
    80000466:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000468:	00e68663          	beq	a3,a4,80000474 <walkaddr+0x32>
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret
  pa = PTE2PA(*pte);
    80000474:	83a9                	srli	a5,a5,0xa
    80000476:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000047a:	bfcd                	j	8000046c <walkaddr+0x2a>
    return 0;
    8000047c:	4501                	li	a0,0
    8000047e:	b7fd                	j	8000046c <walkaddr+0x2a>

0000000080000480 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000480:	715d                	addi	sp,sp,-80
    80000482:	e486                	sd	ra,72(sp)
    80000484:	e0a2                	sd	s0,64(sp)
    80000486:	fc26                	sd	s1,56(sp)
    80000488:	f84a                	sd	s2,48(sp)
    8000048a:	f44e                	sd	s3,40(sp)
    8000048c:	f052                	sd	s4,32(sp)
    8000048e:	ec56                	sd	s5,24(sp)
    80000490:	e85a                	sd	s6,16(sp)
    80000492:	e45e                	sd	s7,8(sp)
    80000494:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000496:	03459793          	slli	a5,a1,0x34
    8000049a:	e7a9                	bnez	a5,800004e4 <mappages+0x64>
    8000049c:	8aaa                	mv	s5,a0
    8000049e:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004a0:	03461793          	slli	a5,a2,0x34
    800004a4:	e7b1                	bnez	a5,800004f0 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004a6:	ca39                	beqz	a2,800004fc <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004a8:	77fd                	lui	a5,0xfffff
    800004aa:	963e                	add	a2,a2,a5
    800004ac:	00b609b3          	add	s3,a2,a1
  a = va;
    800004b0:	892e                	mv	s2,a1
    800004b2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004b6:	6b85                	lui	s7,0x1
    800004b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004bc:	4605                	li	a2,1
    800004be:	85ca                	mv	a1,s2
    800004c0:	8556                	mv	a0,s5
    800004c2:	ee7ff0ef          	jal	800003a8 <walk>
    800004c6:	c539                	beqz	a0,80000514 <mappages+0x94>
    if(*pte & PTE_V)
    800004c8:	611c                	ld	a5,0(a0)
    800004ca:	8b85                	andi	a5,a5,1
    800004cc:	ef95                	bnez	a5,80000508 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004ce:	80b1                	srli	s1,s1,0xc
    800004d0:	04aa                	slli	s1,s1,0xa
    800004d2:	0164e4b3          	or	s1,s1,s6
    800004d6:	0014e493          	ori	s1,s1,1
    800004da:	e104                	sd	s1,0(a0)
    if(a == last)
    800004dc:	05390863          	beq	s2,s3,8000052c <mappages+0xac>
    a += PGSIZE;
    800004e0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e2:	bfd9                	j	800004b8 <mappages+0x38>
    panic("mappages: va not aligned");
    800004e4:	00007517          	auipc	a0,0x7
    800004e8:	b7450513          	addi	a0,a0,-1164 # 80007058 <etext+0x58>
    800004ec:	6f7040ef          	jal	800053e2 <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	6eb040ef          	jal	800053e2 <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	6df040ef          	jal	800053e2 <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	6d3040ef          	jal	800053e2 <panic>
      return -1;
    80000514:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000516:	60a6                	ld	ra,72(sp)
    80000518:	6406                	ld	s0,64(sp)
    8000051a:	74e2                	ld	s1,56(sp)
    8000051c:	7942                	ld	s2,48(sp)
    8000051e:	79a2                	ld	s3,40(sp)
    80000520:	7a02                	ld	s4,32(sp)
    80000522:	6ae2                	ld	s5,24(sp)
    80000524:	6b42                	ld	s6,16(sp)
    80000526:	6ba2                	ld	s7,8(sp)
    80000528:	6161                	addi	sp,sp,80
    8000052a:	8082                	ret
  return 0;
    8000052c:	4501                	li	a0,0
    8000052e:	b7e5                	j	80000516 <mappages+0x96>

0000000080000530 <kvmmap>:
{
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
    80000538:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000053a:	86b2                	mv	a3,a2
    8000053c:	863e                	mv	a2,a5
    8000053e:	f43ff0ef          	jal	80000480 <mappages>
    80000542:	e509                	bnez	a0,8000054c <kvmmap+0x1c>
}
    80000544:	60a2                	ld	ra,8(sp)
    80000546:	6402                	ld	s0,0(sp)
    80000548:	0141                	addi	sp,sp,16
    8000054a:	8082                	ret
    panic("kvmmap");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b6c50513          	addi	a0,a0,-1172 # 800070b8 <etext+0xb8>
    80000554:	68f040ef          	jal	800053e2 <panic>

0000000080000558 <kvmmake>:
{
    80000558:	1101                	addi	sp,sp,-32
    8000055a:	ec06                	sd	ra,24(sp)
    8000055c:	e822                	sd	s0,16(sp)
    8000055e:	e426                	sd	s1,8(sp)
    80000560:	e04a                	sd	s2,0(sp)
    80000562:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000564:	b93ff0ef          	jal	800000f6 <kalloc>
    80000568:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000056a:	6605                	lui	a2,0x1
    8000056c:	4581                	li	a1,0
    8000056e:	bc7ff0ef          	jal	80000134 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000572:	4719                	li	a4,6
    80000574:	6685                	lui	a3,0x1
    80000576:	10000637          	lui	a2,0x10000
    8000057a:	100005b7          	lui	a1,0x10000
    8000057e:	8526                	mv	a0,s1
    80000580:	fb1ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000584:	4719                	li	a4,6
    80000586:	6685                	lui	a3,0x1
    80000588:	10001637          	lui	a2,0x10001
    8000058c:	100015b7          	lui	a1,0x10001
    80000590:	8526                	mv	a0,s1
    80000592:	f9fff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000596:	4719                	li	a4,6
    80000598:	040006b7          	lui	a3,0x4000
    8000059c:	0c000637          	lui	a2,0xc000
    800005a0:	0c0005b7          	lui	a1,0xc000
    800005a4:	8526                	mv	a0,s1
    800005a6:	f8bff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005aa:	00007917          	auipc	s2,0x7
    800005ae:	a5690913          	addi	s2,s2,-1450 # 80007000 <etext>
    800005b2:	4729                	li	a4,10
    800005b4:	80007697          	auipc	a3,0x80007
    800005b8:	a4c68693          	addi	a3,a3,-1460 # 7000 <_entry-0x7fff9000>
    800005bc:	4605                	li	a2,1
    800005be:	067e                	slli	a2,a2,0x1f
    800005c0:	85b2                	mv	a1,a2
    800005c2:	8526                	mv	a0,s1
    800005c4:	f6dff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005c8:	46c5                	li	a3,17
    800005ca:	06ee                	slli	a3,a3,0x1b
    800005cc:	4719                	li	a4,6
    800005ce:	412686b3          	sub	a3,a3,s2
    800005d2:	864a                	mv	a2,s2
    800005d4:	85ca                	mv	a1,s2
    800005d6:	8526                	mv	a0,s1
    800005d8:	f59ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005dc:	4729                	li	a4,10
    800005de:	6685                	lui	a3,0x1
    800005e0:	00006617          	auipc	a2,0x6
    800005e4:	a2060613          	addi	a2,a2,-1504 # 80006000 <_trampoline>
    800005e8:	040005b7          	lui	a1,0x4000
    800005ec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800005ee:	05b2                	slli	a1,a1,0xc
    800005f0:	8526                	mv	a0,s1
    800005f2:	f3fff0ef          	jal	80000530 <kvmmap>
  proc_mapstacks(kpgtbl);
    800005f6:	8526                	mv	a0,s1
    800005f8:	5e4000ef          	jal	80000bdc <proc_mapstacks>
}
    800005fc:	8526                	mv	a0,s1
    800005fe:	60e2                	ld	ra,24(sp)
    80000600:	6442                	ld	s0,16(sp)
    80000602:	64a2                	ld	s1,8(sp)
    80000604:	6902                	ld	s2,0(sp)
    80000606:	6105                	addi	sp,sp,32
    80000608:	8082                	ret

000000008000060a <kvminit>:
{
    8000060a:	1141                	addi	sp,sp,-16
    8000060c:	e406                	sd	ra,8(sp)
    8000060e:	e022                	sd	s0,0(sp)
    80000610:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000612:	f47ff0ef          	jal	80000558 <kvmmake>
    80000616:	0000a797          	auipc	a5,0xa
    8000061a:	bea7b123          	sd	a0,-1054(a5) # 8000a1f8 <kernel_pagetable>
}
    8000061e:	60a2                	ld	ra,8(sp)
    80000620:	6402                	ld	s0,0(sp)
    80000622:	0141                	addi	sp,sp,16
    80000624:	8082                	ret

0000000080000626 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000626:	715d                	addi	sp,sp,-80
    80000628:	e486                	sd	ra,72(sp)
    8000062a:	e0a2                	sd	s0,64(sp)
    8000062c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    8000062e:	03459793          	slli	a5,a1,0x34
    80000632:	e39d                	bnez	a5,80000658 <uvmunmap+0x32>
    80000634:	f84a                	sd	s2,48(sp)
    80000636:	f44e                	sd	s3,40(sp)
    80000638:	f052                	sd	s4,32(sp)
    8000063a:	ec56                	sd	s5,24(sp)
    8000063c:	e85a                	sd	s6,16(sp)
    8000063e:	e45e                	sd	s7,8(sp)
    80000640:	8a2a                	mv	s4,a0
    80000642:	892e                	mv	s2,a1
    80000644:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000646:	0632                	slli	a2,a2,0xc
    80000648:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000064c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000064e:	6b05                	lui	s6,0x1
    80000650:	0935f763          	bgeu	a1,s3,800006de <uvmunmap+0xb8>
    80000654:	fc26                	sd	s1,56(sp)
    80000656:	a8a1                	j	800006ae <uvmunmap+0x88>
    80000658:	fc26                	sd	s1,56(sp)
    8000065a:	f84a                	sd	s2,48(sp)
    8000065c:	f44e                	sd	s3,40(sp)
    8000065e:	f052                	sd	s4,32(sp)
    80000660:	ec56                	sd	s5,24(sp)
    80000662:	e85a                	sd	s6,16(sp)
    80000664:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000666:	00007517          	auipc	a0,0x7
    8000066a:	a5a50513          	addi	a0,a0,-1446 # 800070c0 <etext+0xc0>
    8000066e:	575040ef          	jal	800053e2 <panic>
      panic("uvmunmap: walk");
    80000672:	00007517          	auipc	a0,0x7
    80000676:	a6650513          	addi	a0,a0,-1434 # 800070d8 <etext+0xd8>
    8000067a:	569040ef          	jal	800053e2 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    8000067e:	85ca                	mv	a1,s2
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a6850513          	addi	a0,a0,-1432 # 800070e8 <etext+0xe8>
    80000688:	289040ef          	jal	80005110 <printf>
      panic("uvmunmap: not mapped");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a6c50513          	addi	a0,a0,-1428 # 800070f8 <etext+0xf8>
    80000694:	54f040ef          	jal	800053e2 <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a7850513          	addi	a0,a0,-1416 # 80007110 <etext+0x110>
    800006a0:	543040ef          	jal	800053e2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006a8:	995a                	add	s2,s2,s6
    800006aa:	03397963          	bgeu	s2,s3,800006dc <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006ae:	4601                	li	a2,0
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8552                	mv	a0,s4
    800006b4:	cf5ff0ef          	jal	800003a8 <walk>
    800006b8:	84aa                	mv	s1,a0
    800006ba:	dd45                	beqz	a0,80000672 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006bc:	6110                	ld	a2,0(a0)
    800006be:	00167793          	andi	a5,a2,1
    800006c2:	dfd5                	beqz	a5,8000067e <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006c4:	3ff67793          	andi	a5,a2,1023
    800006c8:	fd7788e3          	beq	a5,s7,80000698 <uvmunmap+0x72>
    if(do_free){
    800006cc:	fc0a8ce3          	beqz	s5,800006a4 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006d0:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006d2:	00c61513          	slli	a0,a2,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	b7e9                	j	800006a4 <uvmunmap+0x7e>
    800006dc:	74e2                	ld	s1,56(sp)
    800006de:	7942                	ld	s2,48(sp)
    800006e0:	79a2                	ld	s3,40(sp)
    800006e2:	7a02                	ld	s4,32(sp)
    800006e4:	6ae2                	ld	s5,24(sp)
    800006e6:	6b42                	ld	s6,16(sp)
    800006e8:	6ba2                	ld	s7,8(sp)
  }
}
    800006ea:	60a6                	ld	ra,72(sp)
    800006ec:	6406                	ld	s0,64(sp)
    800006ee:	6161                	addi	sp,sp,80
    800006f0:	8082                	ret

00000000800006f2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006f2:	1101                	addi	sp,sp,-32
    800006f4:	ec06                	sd	ra,24(sp)
    800006f6:	e822                	sd	s0,16(sp)
    800006f8:	e426                	sd	s1,8(sp)
    800006fa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006fc:	9fbff0ef          	jal	800000f6 <kalloc>
    80000700:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000702:	c509                	beqz	a0,8000070c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000704:	6605                	lui	a2,0x1
    80000706:	4581                	li	a1,0
    80000708:	a2dff0ef          	jal	80000134 <memset>
  return pagetable;
}
    8000070c:	8526                	mv	a0,s1
    8000070e:	60e2                	ld	ra,24(sp)
    80000710:	6442                	ld	s0,16(sp)
    80000712:	64a2                	ld	s1,8(sp)
    80000714:	6105                	addi	sp,sp,32
    80000716:	8082                	ret

0000000080000718 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000718:	7179                	addi	sp,sp,-48
    8000071a:	f406                	sd	ra,40(sp)
    8000071c:	f022                	sd	s0,32(sp)
    8000071e:	ec26                	sd	s1,24(sp)
    80000720:	e84a                	sd	s2,16(sp)
    80000722:	e44e                	sd	s3,8(sp)
    80000724:	e052                	sd	s4,0(sp)
    80000726:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000728:	6785                	lui	a5,0x1
    8000072a:	04f67063          	bgeu	a2,a5,8000076a <uvmfirst+0x52>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	89ae                	mv	s3,a1
    80000732:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000734:	9c3ff0ef          	jal	800000f6 <kalloc>
    80000738:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000073a:	6605                	lui	a2,0x1
    8000073c:	4581                	li	a1,0
    8000073e:	9f7ff0ef          	jal	80000134 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000742:	4779                	li	a4,30
    80000744:	86ca                	mv	a3,s2
    80000746:	6605                	lui	a2,0x1
    80000748:	4581                	li	a1,0
    8000074a:	8552                	mv	a0,s4
    8000074c:	d35ff0ef          	jal	80000480 <mappages>
  memmove(mem, src, sz);
    80000750:	8626                	mv	a2,s1
    80000752:	85ce                	mv	a1,s3
    80000754:	854a                	mv	a0,s2
    80000756:	a3bff0ef          	jal	80000190 <memmove>
}
    8000075a:	70a2                	ld	ra,40(sp)
    8000075c:	7402                	ld	s0,32(sp)
    8000075e:	64e2                	ld	s1,24(sp)
    80000760:	6942                	ld	s2,16(sp)
    80000762:	69a2                	ld	s3,8(sp)
    80000764:	6a02                	ld	s4,0(sp)
    80000766:	6145                	addi	sp,sp,48
    80000768:	8082                	ret
    panic("uvmfirst: more than a page");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	9be50513          	addi	a0,a0,-1602 # 80007128 <etext+0x128>
    80000772:	471040ef          	jal	800053e2 <panic>

0000000080000776 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000776:	1101                	addi	sp,sp,-32
    80000778:	ec06                	sd	ra,24(sp)
    8000077a:	e822                	sd	s0,16(sp)
    8000077c:	e426                	sd	s1,8(sp)
    8000077e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000780:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000782:	00b67d63          	bgeu	a2,a1,8000079c <uvmdealloc+0x26>
    80000786:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000788:	6785                	lui	a5,0x1
    8000078a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000078c:	00f60733          	add	a4,a2,a5
    80000790:	76fd                	lui	a3,0xfffff
    80000792:	8f75                	and	a4,a4,a3
    80000794:	97ae                	add	a5,a5,a1
    80000796:	8ff5                	and	a5,a5,a3
    80000798:	00f76863          	bltu	a4,a5,800007a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000079c:	8526                	mv	a0,s1
    8000079e:	60e2                	ld	ra,24(sp)
    800007a0:	6442                	ld	s0,16(sp)
    800007a2:	64a2                	ld	s1,8(sp)
    800007a4:	6105                	addi	sp,sp,32
    800007a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007a8:	8f99                	sub	a5,a5,a4
    800007aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ac:	4685                	li	a3,1
    800007ae:	0007861b          	sext.w	a2,a5
    800007b2:	85ba                	mv	a1,a4
    800007b4:	e73ff0ef          	jal	80000626 <uvmunmap>
    800007b8:	b7d5                	j	8000079c <uvmdealloc+0x26>

00000000800007ba <uvmalloc>:
  if(newsz < oldsz)
    800007ba:	08b66b63          	bltu	a2,a1,80000850 <uvmalloc+0x96>
{
    800007be:	7139                	addi	sp,sp,-64
    800007c0:	fc06                	sd	ra,56(sp)
    800007c2:	f822                	sd	s0,48(sp)
    800007c4:	ec4e                	sd	s3,24(sp)
    800007c6:	e852                	sd	s4,16(sp)
    800007c8:	e456                	sd	s5,8(sp)
    800007ca:	0080                	addi	s0,sp,64
    800007cc:	8aaa                	mv	s5,a0
    800007ce:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007d0:	6785                	lui	a5,0x1
    800007d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d4:	95be                	add	a1,a1,a5
    800007d6:	77fd                	lui	a5,0xfffff
    800007d8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    800007dc:	06c9fc63          	bgeu	s3,a2,80000854 <uvmalloc+0x9a>
    800007e0:	f426                	sd	s1,40(sp)
    800007e2:	f04a                	sd	s2,32(sp)
    800007e4:	e05a                	sd	s6,0(sp)
    800007e6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007e8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007ec:	90bff0ef          	jal	800000f6 <kalloc>
    800007f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800007f2:	c115                	beqz	a0,80000816 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f4:	875a                	mv	a4,s6
    800007f6:	86aa                	mv	a3,a0
    800007f8:	6605                	lui	a2,0x1
    800007fa:	85ca                	mv	a1,s2
    800007fc:	8556                	mv	a0,s5
    800007fe:	c83ff0ef          	jal	80000480 <mappages>
    80000802:	e915                	bnez	a0,80000836 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000804:	6785                	lui	a5,0x1
    80000806:	993e                	add	s2,s2,a5
    80000808:	ff4962e3          	bltu	s2,s4,800007ec <uvmalloc+0x32>
  return newsz;
    8000080c:	8552                	mv	a0,s4
    8000080e:	74a2                	ld	s1,40(sp)
    80000810:	7902                	ld	s2,32(sp)
    80000812:	6b02                	ld	s6,0(sp)
    80000814:	a811                	j	80000828 <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000816:	864e                	mv	a2,s3
    80000818:	85ca                	mv	a1,s2
    8000081a:	8556                	mv	a0,s5
    8000081c:	f5bff0ef          	jal	80000776 <uvmdealloc>
      return 0;
    80000820:	4501                	li	a0,0
    80000822:	74a2                	ld	s1,40(sp)
    80000824:	7902                	ld	s2,32(sp)
    80000826:	6b02                	ld	s6,0(sp)
}
    80000828:	70e2                	ld	ra,56(sp)
    8000082a:	7442                	ld	s0,48(sp)
    8000082c:	69e2                	ld	s3,24(sp)
    8000082e:	6a42                	ld	s4,16(sp)
    80000830:	6aa2                	ld	s5,8(sp)
    80000832:	6121                	addi	sp,sp,64
    80000834:	8082                	ret
      kfree(mem);
    80000836:	8526                	mv	a0,s1
    80000838:	fe4ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000083c:	864e                	mv	a2,s3
    8000083e:	85ca                	mv	a1,s2
    80000840:	8556                	mv	a0,s5
    80000842:	f35ff0ef          	jal	80000776 <uvmdealloc>
      return 0;
    80000846:	4501                	li	a0,0
    80000848:	74a2                	ld	s1,40(sp)
    8000084a:	7902                	ld	s2,32(sp)
    8000084c:	6b02                	ld	s6,0(sp)
    8000084e:	bfe9                	j	80000828 <uvmalloc+0x6e>
    return oldsz;
    80000850:	852e                	mv	a0,a1
}
    80000852:	8082                	ret
  return newsz;
    80000854:	8532                	mv	a0,a2
    80000856:	bfc9                	j	80000828 <uvmalloc+0x6e>

0000000080000858 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000858:	7179                	addi	sp,sp,-48
    8000085a:	f406                	sd	ra,40(sp)
    8000085c:	f022                	sd	s0,32(sp)
    8000085e:	ec26                	sd	s1,24(sp)
    80000860:	e84a                	sd	s2,16(sp)
    80000862:	e44e                	sd	s3,8(sp)
    80000864:	e052                	sd	s4,0(sp)
    80000866:	1800                	addi	s0,sp,48
    80000868:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000086a:	84aa                	mv	s1,a0
    8000086c:	6905                	lui	s2,0x1
    8000086e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000870:	4985                	li	s3,1
    80000872:	a819                	j	80000888 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000874:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000876:	00c79513          	slli	a0,a5,0xc
    8000087a:	fdfff0ef          	jal	80000858 <freewalk>
      pagetable[i] = 0;
    8000087e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000882:	04a1                	addi	s1,s1,8
    80000884:	01248f63          	beq	s1,s2,800008a2 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000888:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000088a:	00f7f713          	andi	a4,a5,15
    8000088e:	ff3703e3          	beq	a4,s3,80000874 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000892:	8b85                	andi	a5,a5,1
    80000894:	d7fd                	beqz	a5,80000882 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000896:	00007517          	auipc	a0,0x7
    8000089a:	8b250513          	addi	a0,a0,-1870 # 80007148 <etext+0x148>
    8000089e:	345040ef          	jal	800053e2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008a2:	8552                	mv	a0,s4
    800008a4:	f78ff0ef          	jal	8000001c <kfree>
}
    800008a8:	70a2                	ld	ra,40(sp)
    800008aa:	7402                	ld	s0,32(sp)
    800008ac:	64e2                	ld	s1,24(sp)
    800008ae:	6942                	ld	s2,16(sp)
    800008b0:	69a2                	ld	s3,8(sp)
    800008b2:	6a02                	ld	s4,0(sp)
    800008b4:	6145                	addi	sp,sp,48
    800008b6:	8082                	ret

00000000800008b8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b8:	1101                	addi	sp,sp,-32
    800008ba:	ec06                	sd	ra,24(sp)
    800008bc:	e822                	sd	s0,16(sp)
    800008be:	e426                	sd	s1,8(sp)
    800008c0:	1000                	addi	s0,sp,32
    800008c2:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c4:	e989                	bnez	a1,800008d6 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c6:	8526                	mv	a0,s1
    800008c8:	f91ff0ef          	jal	80000858 <freewalk>
}
    800008cc:	60e2                	ld	ra,24(sp)
    800008ce:	6442                	ld	s0,16(sp)
    800008d0:	64a2                	ld	s1,8(sp)
    800008d2:	6105                	addi	sp,sp,32
    800008d4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d6:	6785                	lui	a5,0x1
    800008d8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008da:	95be                	add	a1,a1,a5
    800008dc:	4685                	li	a3,1
    800008de:	00c5d613          	srli	a2,a1,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	d43ff0ef          	jal	80000626 <uvmunmap>
    800008e8:	bff9                	j	800008c6 <uvmfree+0xe>

00000000800008ea <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    800008ea:	c65d                	beqz	a2,80000998 <uvmcopy+0xae>
{
    800008ec:	715d                	addi	sp,sp,-80
    800008ee:	e486                	sd	ra,72(sp)
    800008f0:	e0a2                	sd	s0,64(sp)
    800008f2:	fc26                	sd	s1,56(sp)
    800008f4:	f84a                	sd	s2,48(sp)
    800008f6:	f44e                	sd	s3,40(sp)
    800008f8:	f052                	sd	s4,32(sp)
    800008fa:	ec56                	sd	s5,24(sp)
    800008fc:	e85a                	sd	s6,16(sp)
    800008fe:	e45e                	sd	s7,8(sp)
    80000900:	0880                	addi	s0,sp,80
    80000902:	8b2a                	mv	s6,a0
    80000904:	8aae                	mv	s5,a1
    80000906:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000908:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000090a:	4601                	li	a2,0
    8000090c:	85ce                	mv	a1,s3
    8000090e:	855a                	mv	a0,s6
    80000910:	a99ff0ef          	jal	800003a8 <walk>
    80000914:	c121                	beqz	a0,80000954 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000916:	6118                	ld	a4,0(a0)
    80000918:	00177793          	andi	a5,a4,1
    8000091c:	c3b1                	beqz	a5,80000960 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000091e:	00a75593          	srli	a1,a4,0xa
    80000922:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000926:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000092a:	fccff0ef          	jal	800000f6 <kalloc>
    8000092e:	892a                	mv	s2,a0
    80000930:	c129                	beqz	a0,80000972 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	85de                	mv	a1,s7
    80000936:	85bff0ef          	jal	80000190 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000093a:	8726                	mv	a4,s1
    8000093c:	86ca                	mv	a3,s2
    8000093e:	6605                	lui	a2,0x1
    80000940:	85ce                	mv	a1,s3
    80000942:	8556                	mv	a0,s5
    80000944:	b3dff0ef          	jal	80000480 <mappages>
    80000948:	e115                	bnez	a0,8000096c <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000094a:	6785                	lui	a5,0x1
    8000094c:	99be                	add	s3,s3,a5
    8000094e:	fb49eee3          	bltu	s3,s4,8000090a <uvmcopy+0x20>
    80000952:	a805                	j	80000982 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000954:	00007517          	auipc	a0,0x7
    80000958:	80450513          	addi	a0,a0,-2044 # 80007158 <etext+0x158>
    8000095c:	287040ef          	jal	800053e2 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	81850513          	addi	a0,a0,-2024 # 80007178 <etext+0x178>
    80000968:	27b040ef          	jal	800053e2 <panic>
      kfree(mem);
    8000096c:	854a                	mv	a0,s2
    8000096e:	eaeff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000972:	4685                	li	a3,1
    80000974:	00c9d613          	srli	a2,s3,0xc
    80000978:	4581                	li	a1,0
    8000097a:	8556                	mv	a0,s5
    8000097c:	cabff0ef          	jal	80000626 <uvmunmap>
  return -1;
    80000980:	557d                	li	a0,-1
}
    80000982:	60a6                	ld	ra,72(sp)
    80000984:	6406                	ld	s0,64(sp)
    80000986:	74e2                	ld	s1,56(sp)
    80000988:	7942                	ld	s2,48(sp)
    8000098a:	79a2                	ld	s3,40(sp)
    8000098c:	7a02                	ld	s4,32(sp)
    8000098e:	6ae2                	ld	s5,24(sp)
    80000990:	6b42                	ld	s6,16(sp)
    80000992:	6ba2                	ld	s7,8(sp)
    80000994:	6161                	addi	sp,sp,80
    80000996:	8082                	ret
  return 0;
    80000998:	4501                	li	a0,0
}
    8000099a:	8082                	ret

000000008000099c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000099c:	1141                	addi	sp,sp,-16
    8000099e:	e406                	sd	ra,8(sp)
    800009a0:	e022                	sd	s0,0(sp)
    800009a2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009a4:	4601                	li	a2,0
    800009a6:	a03ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    800009aa:	c901                	beqz	a0,800009ba <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ac:	611c                	ld	a5,0(a0)
    800009ae:	9bbd                	andi	a5,a5,-17
    800009b0:	e11c                	sd	a5,0(a0)
}
    800009b2:	60a2                	ld	ra,8(sp)
    800009b4:	6402                	ld	s0,0(sp)
    800009b6:	0141                	addi	sp,sp,16
    800009b8:	8082                	ret
    panic("uvmclear");
    800009ba:	00006517          	auipc	a0,0x6
    800009be:	7de50513          	addi	a0,a0,2014 # 80007198 <etext+0x198>
    800009c2:	221040ef          	jal	800053e2 <panic>

00000000800009c6 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009c6:	cac1                	beqz	a3,80000a56 <copyout+0x90>
{
    800009c8:	711d                	addi	sp,sp,-96
    800009ca:	ec86                	sd	ra,88(sp)
    800009cc:	e8a2                	sd	s0,80(sp)
    800009ce:	e4a6                	sd	s1,72(sp)
    800009d0:	fc4e                	sd	s3,56(sp)
    800009d2:	f852                	sd	s4,48(sp)
    800009d4:	f456                	sd	s5,40(sp)
    800009d6:	f05a                	sd	s6,32(sp)
    800009d8:	1080                	addi	s0,sp,96
    800009da:	8b2a                	mv	s6,a0
    800009dc:	8a2e                	mv	s4,a1
    800009de:	8ab2                	mv	s5,a2
    800009e0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009e2:	74fd                	lui	s1,0xfffff
    800009e4:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    800009e6:	57fd                	li	a5,-1
    800009e8:	83e9                	srli	a5,a5,0x1a
    800009ea:	0697e863          	bltu	a5,s1,80000a5a <copyout+0x94>
    800009ee:	e0ca                	sd	s2,64(sp)
    800009f0:	ec5e                	sd	s7,24(sp)
    800009f2:	e862                	sd	s8,16(sp)
    800009f4:	e466                	sd	s9,8(sp)
    800009f6:	6c05                	lui	s8,0x1
    800009f8:	8bbe                	mv	s7,a5
    800009fa:	a015                	j	80000a1e <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800009fc:	409a04b3          	sub	s1,s4,s1
    80000a00:	0009061b          	sext.w	a2,s2
    80000a04:	85d6                	mv	a1,s5
    80000a06:	9526                	add	a0,a0,s1
    80000a08:	f88ff0ef          	jal	80000190 <memmove>

    len -= n;
    80000a0c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a10:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a12:	02098c63          	beqz	s3,80000a4a <copyout+0x84>
    if (va0 >= MAXVA)
    80000a16:	059be463          	bltu	s7,s9,80000a5e <copyout+0x98>
    80000a1a:	84e6                	mv	s1,s9
    80000a1c:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a1e:	4601                	li	a2,0
    80000a20:	85a6                	mv	a1,s1
    80000a22:	855a                	mv	a0,s6
    80000a24:	985ff0ef          	jal	800003a8 <walk>
    80000a28:	c129                	beqz	a0,80000a6a <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a2a:	611c                	ld	a5,0(a0)
    80000a2c:	8b91                	andi	a5,a5,4
    80000a2e:	cfa1                	beqz	a5,80000a86 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a30:	85a6                	mv	a1,s1
    80000a32:	855a                	mv	a0,s6
    80000a34:	a0fff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000a38:	cd29                	beqz	a0,80000a92 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a3a:	01848cb3          	add	s9,s1,s8
    80000a3e:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a42:	fb29fde3          	bgeu	s3,s2,800009fc <copyout+0x36>
    80000a46:	894e                	mv	s2,s3
    80000a48:	bf55                	j	800009fc <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a4a:	4501                	li	a0,0
    80000a4c:	6906                	ld	s2,64(sp)
    80000a4e:	6be2                	ld	s7,24(sp)
    80000a50:	6c42                	ld	s8,16(sp)
    80000a52:	6ca2                	ld	s9,8(sp)
    80000a54:	a005                	j	80000a74 <copyout+0xae>
    80000a56:	4501                	li	a0,0
}
    80000a58:	8082                	ret
      return -1;
    80000a5a:	557d                	li	a0,-1
    80000a5c:	a821                	j	80000a74 <copyout+0xae>
    80000a5e:	557d                	li	a0,-1
    80000a60:	6906                	ld	s2,64(sp)
    80000a62:	6be2                	ld	s7,24(sp)
    80000a64:	6c42                	ld	s8,16(sp)
    80000a66:	6ca2                	ld	s9,8(sp)
    80000a68:	a031                	j	80000a74 <copyout+0xae>
      return -1;
    80000a6a:	557d                	li	a0,-1
    80000a6c:	6906                	ld	s2,64(sp)
    80000a6e:	6be2                	ld	s7,24(sp)
    80000a70:	6c42                	ld	s8,16(sp)
    80000a72:	6ca2                	ld	s9,8(sp)
}
    80000a74:	60e6                	ld	ra,88(sp)
    80000a76:	6446                	ld	s0,80(sp)
    80000a78:	64a6                	ld	s1,72(sp)
    80000a7a:	79e2                	ld	s3,56(sp)
    80000a7c:	7a42                	ld	s4,48(sp)
    80000a7e:	7aa2                	ld	s5,40(sp)
    80000a80:	7b02                	ld	s6,32(sp)
    80000a82:	6125                	addi	sp,sp,96
    80000a84:	8082                	ret
      return -1;
    80000a86:	557d                	li	a0,-1
    80000a88:	6906                	ld	s2,64(sp)
    80000a8a:	6be2                	ld	s7,24(sp)
    80000a8c:	6c42                	ld	s8,16(sp)
    80000a8e:	6ca2                	ld	s9,8(sp)
    80000a90:	b7d5                	j	80000a74 <copyout+0xae>
      return -1;
    80000a92:	557d                	li	a0,-1
    80000a94:	6906                	ld	s2,64(sp)
    80000a96:	6be2                	ld	s7,24(sp)
    80000a98:	6c42                	ld	s8,16(sp)
    80000a9a:	6ca2                	ld	s9,8(sp)
    80000a9c:	bfe1                	j	80000a74 <copyout+0xae>

0000000080000a9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000a9e:	c6a5                	beqz	a3,80000b06 <copyin+0x68>
{
    80000aa0:	715d                	addi	sp,sp,-80
    80000aa2:	e486                	sd	ra,72(sp)
    80000aa4:	e0a2                	sd	s0,64(sp)
    80000aa6:	fc26                	sd	s1,56(sp)
    80000aa8:	f84a                	sd	s2,48(sp)
    80000aaa:	f44e                	sd	s3,40(sp)
    80000aac:	f052                	sd	s4,32(sp)
    80000aae:	ec56                	sd	s5,24(sp)
    80000ab0:	e85a                	sd	s6,16(sp)
    80000ab2:	e45e                	sd	s7,8(sp)
    80000ab4:	e062                	sd	s8,0(sp)
    80000ab6:	0880                	addi	s0,sp,80
    80000ab8:	8b2a                	mv	s6,a0
    80000aba:	8a2e                	mv	s4,a1
    80000abc:	8c32                	mv	s8,a2
    80000abe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ac0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ac2:	6a85                	lui	s5,0x1
    80000ac4:	a00d                	j	80000ae6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ac6:	018505b3          	add	a1,a0,s8
    80000aca:	0004861b          	sext.w	a2,s1
    80000ace:	412585b3          	sub	a1,a1,s2
    80000ad2:	8552                	mv	a0,s4
    80000ad4:	ebcff0ef          	jal	80000190 <memmove>

    len -= n;
    80000ad8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000adc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ade:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ae2:	02098063          	beqz	s3,80000b02 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000ae6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000aea:	85ca                	mv	a1,s2
    80000aec:	855a                	mv	a0,s6
    80000aee:	955ff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000af2:	cd01                	beqz	a0,80000b0a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000af4:	418904b3          	sub	s1,s2,s8
    80000af8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000afa:	fc99f6e3          	bgeu	s3,s1,80000ac6 <copyin+0x28>
    80000afe:	84ce                	mv	s1,s3
    80000b00:	b7d9                	j	80000ac6 <copyin+0x28>
  }
  return 0;
    80000b02:	4501                	li	a0,0
    80000b04:	a021                	j	80000b0c <copyin+0x6e>
    80000b06:	4501                	li	a0,0
}
    80000b08:	8082                	ret
      return -1;
    80000b0a:	557d                	li	a0,-1
}
    80000b0c:	60a6                	ld	ra,72(sp)
    80000b0e:	6406                	ld	s0,64(sp)
    80000b10:	74e2                	ld	s1,56(sp)
    80000b12:	7942                	ld	s2,48(sp)
    80000b14:	79a2                	ld	s3,40(sp)
    80000b16:	7a02                	ld	s4,32(sp)
    80000b18:	6ae2                	ld	s5,24(sp)
    80000b1a:	6b42                	ld	s6,16(sp)
    80000b1c:	6ba2                	ld	s7,8(sp)
    80000b1e:	6c02                	ld	s8,0(sp)
    80000b20:	6161                	addi	sp,sp,80
    80000b22:	8082                	ret

0000000080000b24 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b24:	c6dd                	beqz	a3,80000bd2 <copyinstr+0xae>
{
    80000b26:	715d                	addi	sp,sp,-80
    80000b28:	e486                	sd	ra,72(sp)
    80000b2a:	e0a2                	sd	s0,64(sp)
    80000b2c:	fc26                	sd	s1,56(sp)
    80000b2e:	f84a                	sd	s2,48(sp)
    80000b30:	f44e                	sd	s3,40(sp)
    80000b32:	f052                	sd	s4,32(sp)
    80000b34:	ec56                	sd	s5,24(sp)
    80000b36:	e85a                	sd	s6,16(sp)
    80000b38:	e45e                	sd	s7,8(sp)
    80000b3a:	0880                	addi	s0,sp,80
    80000b3c:	8a2a                	mv	s4,a0
    80000b3e:	8b2e                	mv	s6,a1
    80000b40:	8bb2                	mv	s7,a2
    80000b42:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b44:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b46:	6985                	lui	s3,0x1
    80000b48:	a825                	j	80000b80 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b4a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b4e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b50:	37fd                	addiw	a5,a5,-1
    80000b52:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b56:	60a6                	ld	ra,72(sp)
    80000b58:	6406                	ld	s0,64(sp)
    80000b5a:	74e2                	ld	s1,56(sp)
    80000b5c:	7942                	ld	s2,48(sp)
    80000b5e:	79a2                	ld	s3,40(sp)
    80000b60:	7a02                	ld	s4,32(sp)
    80000b62:	6ae2                	ld	s5,24(sp)
    80000b64:	6b42                	ld	s6,16(sp)
    80000b66:	6ba2                	ld	s7,8(sp)
    80000b68:	6161                	addi	sp,sp,80
    80000b6a:	8082                	ret
    80000b6c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b70:	9742                	add	a4,a4,a6
      --max;
    80000b72:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b76:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b7a:	04e58463          	beq	a1,a4,80000bc2 <copyinstr+0x9e>
{
    80000b7e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000b80:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b84:	85a6                	mv	a1,s1
    80000b86:	8552                	mv	a0,s4
    80000b88:	8bbff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000b8c:	cd0d                	beqz	a0,80000bc6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b8e:	417486b3          	sub	a3,s1,s7
    80000b92:	96ce                	add	a3,a3,s3
    if(n > max)
    80000b94:	00d97363          	bgeu	s2,a3,80000b9a <copyinstr+0x76>
    80000b98:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000b9a:	955e                	add	a0,a0,s7
    80000b9c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000b9e:	c695                	beqz	a3,80000bca <copyinstr+0xa6>
    80000ba0:	87da                	mv	a5,s6
    80000ba2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ba4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ba8:	96da                	add	a3,a3,s6
    80000baa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bac:	00f60733          	add	a4,a2,a5
    80000bb0:	00074703          	lbu	a4,0(a4)
    80000bb4:	db59                	beqz	a4,80000b4a <copyinstr+0x26>
        *dst = *p;
    80000bb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bbc:	fed797e3          	bne	a5,a3,80000baa <copyinstr+0x86>
    80000bc0:	b775                	j	80000b6c <copyinstr+0x48>
    80000bc2:	4781                	li	a5,0
    80000bc4:	b771                	j	80000b50 <copyinstr+0x2c>
      return -1;
    80000bc6:	557d                	li	a0,-1
    80000bc8:	b779                	j	80000b56 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bca:	6b85                	lui	s7,0x1
    80000bcc:	9ba6                	add	s7,s7,s1
    80000bce:	87da                	mv	a5,s6
    80000bd0:	b77d                	j	80000b7e <copyinstr+0x5a>
  int got_null = 0;
    80000bd2:	4781                	li	a5,0
  if(got_null){
    80000bd4:	37fd                	addiw	a5,a5,-1
    80000bd6:	0007851b          	sext.w	a0,a5
}
    80000bda:	8082                	ret

0000000080000bdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bdc:	7139                	addi	sp,sp,-64
    80000bde:	fc06                	sd	ra,56(sp)
    80000be0:	f822                	sd	s0,48(sp)
    80000be2:	f426                	sd	s1,40(sp)
    80000be4:	f04a                	sd	s2,32(sp)
    80000be6:	ec4e                	sd	s3,24(sp)
    80000be8:	e852                	sd	s4,16(sp)
    80000bea:	e456                	sd	s5,8(sp)
    80000bec:	e05a                	sd	s6,0(sp)
    80000bee:	0080                	addi	s0,sp,64
    80000bf0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf2:	0000a497          	auipc	s1,0xa
    80000bf6:	a7e48493          	addi	s1,s1,-1410 # 8000a670 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfa:	8b26                	mv	s6,s1
    80000bfc:	04fa5937          	lui	s2,0x4fa5
    80000c00:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c04:	0932                	slli	s2,s2,0xc
    80000c06:	fa590913          	addi	s2,s2,-91
    80000c0a:	0932                	slli	s2,s2,0xc
    80000c0c:	fa590913          	addi	s2,s2,-91
    80000c10:	0932                	slli	s2,s2,0xc
    80000c12:	fa590913          	addi	s2,s2,-91
    80000c16:	040009b7          	lui	s3,0x4000
    80000c1a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c1c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	0000fa97          	auipc	s5,0xf
    80000c22:	452a8a93          	addi	s5,s5,1106 # 80010070 <tickslock>
    char *pa = kalloc();
    80000c26:	cd0ff0ef          	jal	800000f6 <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	cd15                	beqz	a0,80000c68 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	416485b3          	sub	a1,s1,s6
    80000c32:	858d                	srai	a1,a1,0x3
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	4719                	li	a4,6
    80000c40:	6685                	lui	a3,0x1
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	8e9ff0ef          	jal	80000530 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	16848493          	addi	s1,s1,360
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4a>
  }
}
    80000c54:	70e2                	ld	ra,56(sp)
    80000c56:	7442                	ld	s0,48(sp)
    80000c58:	74a2                	ld	s1,40(sp)
    80000c5a:	7902                	ld	s2,32(sp)
    80000c5c:	69e2                	ld	s3,24(sp)
    80000c5e:	6a42                	ld	s4,16(sp)
    80000c60:	6aa2                	ld	s5,8(sp)
    80000c62:	6b02                	ld	s6,0(sp)
    80000c64:	6121                	addi	sp,sp,64
    80000c66:	8082                	ret
      panic("kalloc");
    80000c68:	00006517          	auipc	a0,0x6
    80000c6c:	54050513          	addi	a0,a0,1344 # 800071a8 <etext+0x1a8>
    80000c70:	772040ef          	jal	800053e2 <panic>

0000000080000c74 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c74:	7139                	addi	sp,sp,-64
    80000c76:	fc06                	sd	ra,56(sp)
    80000c78:	f822                	sd	s0,48(sp)
    80000c7a:	f426                	sd	s1,40(sp)
    80000c7c:	f04a                	sd	s2,32(sp)
    80000c7e:	ec4e                	sd	s3,24(sp)
    80000c80:	e852                	sd	s4,16(sp)
    80000c82:	e456                	sd	s5,8(sp)
    80000c84:	e05a                	sd	s6,0(sp)
    80000c86:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c88:	00006597          	auipc	a1,0x6
    80000c8c:	52858593          	addi	a1,a1,1320 # 800071b0 <etext+0x1b0>
    80000c90:	00009517          	auipc	a0,0x9
    80000c94:	5b050513          	addi	a0,a0,1456 # 8000a240 <pid_lock>
    80000c98:	1f9040ef          	jal	80005690 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c9c:	00006597          	auipc	a1,0x6
    80000ca0:	51c58593          	addi	a1,a1,1308 # 800071b8 <etext+0x1b8>
    80000ca4:	00009517          	auipc	a0,0x9
    80000ca8:	5b450513          	addi	a0,a0,1460 # 8000a258 <wait_lock>
    80000cac:	1e5040ef          	jal	80005690 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb0:	0000a497          	auipc	s1,0xa
    80000cb4:	9c048493          	addi	s1,s1,-1600 # 8000a670 <proc>
      initlock(&p->lock, "proc");
    80000cb8:	00006b17          	auipc	s6,0x6
    80000cbc:	510b0b13          	addi	s6,s6,1296 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc0:	8aa6                	mv	s5,s1
    80000cc2:	04fa5937          	lui	s2,0x4fa5
    80000cc6:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000cca:	0932                	slli	s2,s2,0xc
    80000ccc:	fa590913          	addi	s2,s2,-91
    80000cd0:	0932                	slli	s2,s2,0xc
    80000cd2:	fa590913          	addi	s2,s2,-91
    80000cd6:	0932                	slli	s2,s2,0xc
    80000cd8:	fa590913          	addi	s2,s2,-91
    80000cdc:	040009b7          	lui	s3,0x4000
    80000ce0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce4:	0000fa17          	auipc	s4,0xf
    80000ce8:	38ca0a13          	addi	s4,s4,908 # 80010070 <tickslock>
      initlock(&p->lock, "proc");
    80000cec:	85da                	mv	a1,s6
    80000cee:	8526                	mv	a0,s1
    80000cf0:	1a1040ef          	jal	80005690 <initlock>
      p->state = UNUSED;
    80000cf4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf8:	415487b3          	sub	a5,s1,s5
    80000cfc:	878d                	srai	a5,a5,0x3
    80000cfe:	032787b3          	mul	a5,a5,s2
    80000d02:	2785                	addiw	a5,a5,1
    80000d04:	00d7979b          	slliw	a5,a5,0xd
    80000d08:	40f987b3          	sub	a5,s3,a5
    80000d0c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	16848493          	addi	s1,s1,360
    80000d12:	fd449de3          	bne	s1,s4,80000cec <procinit+0x78>
  }
}
    80000d16:	70e2                	ld	ra,56(sp)
    80000d18:	7442                	ld	s0,48(sp)
    80000d1a:	74a2                	ld	s1,40(sp)
    80000d1c:	7902                	ld	s2,32(sp)
    80000d1e:	69e2                	ld	s3,24(sp)
    80000d20:	6a42                	ld	s4,16(sp)
    80000d22:	6aa2                	ld	s5,8(sp)
    80000d24:	6b02                	ld	s6,0(sp)
    80000d26:	6121                	addi	sp,sp,64
    80000d28:	8082                	ret

0000000080000d2a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d2a:	1141                	addi	sp,sp,-16
    80000d2c:	e422                	sd	s0,8(sp)
    80000d2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d32:	2501                	sext.w	a0,a0
    80000d34:	6422                	ld	s0,8(sp)
    80000d36:	0141                	addi	sp,sp,16
    80000d38:	8082                	ret

0000000080000d3a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3a:	1141                	addi	sp,sp,-16
    80000d3c:	e422                	sd	s0,8(sp)
    80000d3e:	0800                	addi	s0,sp,16
    80000d40:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d42:	2781                	sext.w	a5,a5
    80000d44:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d46:	00009517          	auipc	a0,0x9
    80000d4a:	52a50513          	addi	a0,a0,1322 # 8000a270 <cpus>
    80000d4e:	953e                	add	a0,a0,a5
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d56:	1101                	addi	sp,sp,-32
    80000d58:	ec06                	sd	ra,24(sp)
    80000d5a:	e822                	sd	s0,16(sp)
    80000d5c:	e426                	sd	s1,8(sp)
    80000d5e:	1000                	addi	s0,sp,32
  push_off();
    80000d60:	171040ef          	jal	800056d0 <push_off>
    80000d64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
    80000d6a:	00009717          	auipc	a4,0x9
    80000d6e:	4d670713          	addi	a4,a4,1238 # 8000a240 <pid_lock>
    80000d72:	97ba                	add	a5,a5,a4
    80000d74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d76:	1df040ef          	jal	80005754 <pop_off>
  return p;
}
    80000d7a:	8526                	mv	a0,s1
    80000d7c:	60e2                	ld	ra,24(sp)
    80000d7e:	6442                	ld	s0,16(sp)
    80000d80:	64a2                	ld	s1,8(sp)
    80000d82:	6105                	addi	sp,sp,32
    80000d84:	8082                	ret

0000000080000d86 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d86:	1141                	addi	sp,sp,-16
    80000d88:	e406                	sd	ra,8(sp)
    80000d8a:	e022                	sd	s0,0(sp)
    80000d8c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d8e:	fc9ff0ef          	jal	80000d56 <myproc>
    80000d92:	217040ef          	jal	800057a8 <release>

  if (first) {
    80000d96:	00009797          	auipc	a5,0x9
    80000d9a:	3ea7a783          	lw	a5,1002(a5) # 8000a180 <first.1>
    80000d9e:	e799                	bnez	a5,80000dac <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da0:	2bf000ef          	jal	8000185e <usertrapret>
}
    80000da4:	60a2                	ld	ra,8(sp)
    80000da6:	6402                	ld	s0,0(sp)
    80000da8:	0141                	addi	sp,sp,16
    80000daa:	8082                	ret
    fsinit(ROOTDEV);
    80000dac:	4505                	li	a0,1
    80000dae:	654010ef          	jal	80002402 <fsinit>
    first = 0;
    80000db2:	00009797          	auipc	a5,0x9
    80000db6:	3c07a723          	sw	zero,974(a5) # 8000a180 <first.1>
    __sync_synchronize();
    80000dba:	0330000f          	fence	rw,rw
    80000dbe:	b7cd                	j	80000da0 <forkret+0x1a>

0000000080000dc0 <allocpid>:
{
    80000dc0:	1101                	addi	sp,sp,-32
    80000dc2:	ec06                	sd	ra,24(sp)
    80000dc4:	e822                	sd	s0,16(sp)
    80000dc6:	e426                	sd	s1,8(sp)
    80000dc8:	e04a                	sd	s2,0(sp)
    80000dca:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dcc:	00009917          	auipc	s2,0x9
    80000dd0:	47490913          	addi	s2,s2,1140 # 8000a240 <pid_lock>
    80000dd4:	854a                	mv	a0,s2
    80000dd6:	13b040ef          	jal	80005710 <acquire>
  pid = nextpid;
    80000dda:	00009797          	auipc	a5,0x9
    80000dde:	3aa78793          	addi	a5,a5,938 # 8000a184 <nextpid>
    80000de2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000de4:	0014871b          	addiw	a4,s1,1
    80000de8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000dea:	854a                	mv	a0,s2
    80000dec:	1bd040ef          	jal	800057a8 <release>
}
    80000df0:	8526                	mv	a0,s1
    80000df2:	60e2                	ld	ra,24(sp)
    80000df4:	6442                	ld	s0,16(sp)
    80000df6:	64a2                	ld	s1,8(sp)
    80000df8:	6902                	ld	s2,0(sp)
    80000dfa:	6105                	addi	sp,sp,32
    80000dfc:	8082                	ret

0000000080000dfe <proc_pagetable>:
{
    80000dfe:	1101                	addi	sp,sp,-32
    80000e00:	ec06                	sd	ra,24(sp)
    80000e02:	e822                	sd	s0,16(sp)
    80000e04:	e426                	sd	s1,8(sp)
    80000e06:	e04a                	sd	s2,0(sp)
    80000e08:	1000                	addi	s0,sp,32
    80000e0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e0c:	8e7ff0ef          	jal	800006f2 <uvmcreate>
    80000e10:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e12:	cd05                	beqz	a0,80000e4a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e14:	4729                	li	a4,10
    80000e16:	00005697          	auipc	a3,0x5
    80000e1a:	1ea68693          	addi	a3,a3,490 # 80006000 <_trampoline>
    80000e1e:	6605                	lui	a2,0x1
    80000e20:	040005b7          	lui	a1,0x4000
    80000e24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e26:	05b2                	slli	a1,a1,0xc
    80000e28:	e58ff0ef          	jal	80000480 <mappages>
    80000e2c:	02054663          	bltz	a0,80000e58 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e30:	4719                	li	a4,6
    80000e32:	05893683          	ld	a3,88(s2)
    80000e36:	6605                	lui	a2,0x1
    80000e38:	020005b7          	lui	a1,0x2000
    80000e3c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e3e:	05b6                	slli	a1,a1,0xd
    80000e40:	8526                	mv	a0,s1
    80000e42:	e3eff0ef          	jal	80000480 <mappages>
    80000e46:	00054f63          	bltz	a0,80000e64 <proc_pagetable+0x66>
}
    80000e4a:	8526                	mv	a0,s1
    80000e4c:	60e2                	ld	ra,24(sp)
    80000e4e:	6442                	ld	s0,16(sp)
    80000e50:	64a2                	ld	s1,8(sp)
    80000e52:	6902                	ld	s2,0(sp)
    80000e54:	6105                	addi	sp,sp,32
    80000e56:	8082                	ret
    uvmfree(pagetable, 0);
    80000e58:	4581                	li	a1,0
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	a5dff0ef          	jal	800008b8 <uvmfree>
    return 0;
    80000e60:	4481                	li	s1,0
    80000e62:	b7e5                	j	80000e4a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e64:	4681                	li	a3,0
    80000e66:	4605                	li	a2,1
    80000e68:	040005b7          	lui	a1,0x4000
    80000e6c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e6e:	05b2                	slli	a1,a1,0xc
    80000e70:	8526                	mv	a0,s1
    80000e72:	fb4ff0ef          	jal	80000626 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e76:	4581                	li	a1,0
    80000e78:	8526                	mv	a0,s1
    80000e7a:	a3fff0ef          	jal	800008b8 <uvmfree>
    return 0;
    80000e7e:	4481                	li	s1,0
    80000e80:	b7e9                	j	80000e4a <proc_pagetable+0x4c>

0000000080000e82 <proc_freepagetable>:
{
    80000e82:	1101                	addi	sp,sp,-32
    80000e84:	ec06                	sd	ra,24(sp)
    80000e86:	e822                	sd	s0,16(sp)
    80000e88:	e426                	sd	s1,8(sp)
    80000e8a:	e04a                	sd	s2,0(sp)
    80000e8c:	1000                	addi	s0,sp,32
    80000e8e:	84aa                	mv	s1,a0
    80000e90:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e92:	4681                	li	a3,0
    80000e94:	4605                	li	a2,1
    80000e96:	040005b7          	lui	a1,0x4000
    80000e9a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e9c:	05b2                	slli	a1,a1,0xc
    80000e9e:	f88ff0ef          	jal	80000626 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea2:	4681                	li	a3,0
    80000ea4:	4605                	li	a2,1
    80000ea6:	020005b7          	lui	a1,0x2000
    80000eaa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eac:	05b6                	slli	a1,a1,0xd
    80000eae:	8526                	mv	a0,s1
    80000eb0:	f76ff0ef          	jal	80000626 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eb4:	85ca                	mv	a1,s2
    80000eb6:	8526                	mv	a0,s1
    80000eb8:	a01ff0ef          	jal	800008b8 <uvmfree>
}
    80000ebc:	60e2                	ld	ra,24(sp)
    80000ebe:	6442                	ld	s0,16(sp)
    80000ec0:	64a2                	ld	s1,8(sp)
    80000ec2:	6902                	ld	s2,0(sp)
    80000ec4:	6105                	addi	sp,sp,32
    80000ec6:	8082                	ret

0000000080000ec8 <freeproc>:
{
    80000ec8:	1101                	addi	sp,sp,-32
    80000eca:	ec06                	sd	ra,24(sp)
    80000ecc:	e822                	sd	s0,16(sp)
    80000ece:	e426                	sd	s1,8(sp)
    80000ed0:	1000                	addi	s0,sp,32
    80000ed2:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000ed4:	6d28                	ld	a0,88(a0)
    80000ed6:	c119                	beqz	a0,80000edc <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ed8:	944ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000edc:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee0:	68a8                	ld	a0,80(s1)
    80000ee2:	c501                	beqz	a0,80000eea <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ee4:	64ac                	ld	a1,72(s1)
    80000ee6:	f9dff0ef          	jal	80000e82 <proc_freepagetable>
  p->pagetable = 0;
    80000eea:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000eee:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000ef6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000efa:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000efe:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f02:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f06:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f0a:	0004ac23          	sw	zero,24(s1)
}
    80000f0e:	60e2                	ld	ra,24(sp)
    80000f10:	6442                	ld	s0,16(sp)
    80000f12:	64a2                	ld	s1,8(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <allocproc>:
{
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f24:	00009497          	auipc	s1,0x9
    80000f28:	74c48493          	addi	s1,s1,1868 # 8000a670 <proc>
    80000f2c:	0000f917          	auipc	s2,0xf
    80000f30:	14490913          	addi	s2,s2,324 # 80010070 <tickslock>
    acquire(&p->lock);
    80000f34:	8526                	mv	a0,s1
    80000f36:	7da040ef          	jal	80005710 <acquire>
    if(p->state == UNUSED) {
    80000f3a:	4c9c                	lw	a5,24(s1)
    80000f3c:	cb91                	beqz	a5,80000f50 <allocproc+0x38>
      release(&p->lock);
    80000f3e:	8526                	mv	a0,s1
    80000f40:	069040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f44:	16848493          	addi	s1,s1,360
    80000f48:	ff2496e3          	bne	s1,s2,80000f34 <allocproc+0x1c>
  return 0;
    80000f4c:	4481                	li	s1,0
    80000f4e:	a089                	j	80000f90 <allocproc+0x78>
  p->pid = allocpid();
    80000f50:	e71ff0ef          	jal	80000dc0 <allocpid>
    80000f54:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f56:	4785                	li	a5,1
    80000f58:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f5a:	99cff0ef          	jal	800000f6 <kalloc>
    80000f5e:	892a                	mv	s2,a0
    80000f60:	eca8                	sd	a0,88(s1)
    80000f62:	cd15                	beqz	a0,80000f9e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f64:	8526                	mv	a0,s1
    80000f66:	e99ff0ef          	jal	80000dfe <proc_pagetable>
    80000f6a:	892a                	mv	s2,a0
    80000f6c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f6e:	c121                	beqz	a0,80000fae <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f70:	07000613          	li	a2,112
    80000f74:	4581                	li	a1,0
    80000f76:	06048513          	addi	a0,s1,96
    80000f7a:	9baff0ef          	jal	80000134 <memset>
  p->context.ra = (uint64)forkret;
    80000f7e:	00000797          	auipc	a5,0x0
    80000f82:	e0878793          	addi	a5,a5,-504 # 80000d86 <forkret>
    80000f86:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f88:	60bc                	ld	a5,64(s1)
    80000f8a:	6705                	lui	a4,0x1
    80000f8c:	97ba                	add	a5,a5,a4
    80000f8e:	f4bc                	sd	a5,104(s1)
}
    80000f90:	8526                	mv	a0,s1
    80000f92:	60e2                	ld	ra,24(sp)
    80000f94:	6442                	ld	s0,16(sp)
    80000f96:	64a2                	ld	s1,8(sp)
    80000f98:	6902                	ld	s2,0(sp)
    80000f9a:	6105                	addi	sp,sp,32
    80000f9c:	8082                	ret
    freeproc(p);
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	f29ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	003040ef          	jal	800057a8 <release>
    return 0;
    80000faa:	84ca                	mv	s1,s2
    80000fac:	b7d5                	j	80000f90 <allocproc+0x78>
    freeproc(p);
    80000fae:	8526                	mv	a0,s1
    80000fb0:	f19ff0ef          	jal	80000ec8 <freeproc>
    release(&p->lock);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	7f2040ef          	jal	800057a8 <release>
    return 0;
    80000fba:	84ca                	mv	s1,s2
    80000fbc:	bfd1                	j	80000f90 <allocproc+0x78>

0000000080000fbe <userinit>:
{
    80000fbe:	1101                	addi	sp,sp,-32
    80000fc0:	ec06                	sd	ra,24(sp)
    80000fc2:	e822                	sd	s0,16(sp)
    80000fc4:	e426                	sd	s1,8(sp)
    80000fc6:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fc8:	f51ff0ef          	jal	80000f18 <allocproc>
    80000fcc:	84aa                	mv	s1,a0
  initproc = p;
    80000fce:	00009797          	auipc	a5,0x9
    80000fd2:	22a7b923          	sd	a0,562(a5) # 8000a200 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fd6:	03400613          	li	a2,52
    80000fda:	00009597          	auipc	a1,0x9
    80000fde:	1b658593          	addi	a1,a1,438 # 8000a190 <initcode>
    80000fe2:	6928                	ld	a0,80(a0)
    80000fe4:	f34ff0ef          	jal	80000718 <uvmfirst>
  p->sz = PGSIZE;
    80000fe8:	6785                	lui	a5,0x1
    80000fea:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000fec:	6cb8                	ld	a4,88(s1)
    80000fee:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ff2:	6cb8                	ld	a4,88(s1)
    80000ff4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000ff6:	4641                	li	a2,16
    80000ff8:	00006597          	auipc	a1,0x6
    80000ffc:	1d858593          	addi	a1,a1,472 # 800071d0 <etext+0x1d0>
    80001000:	15848513          	addi	a0,s1,344
    80001004:	a6eff0ef          	jal	80000272 <safestrcpy>
  p->cwd = namei("/");
    80001008:	00006517          	auipc	a0,0x6
    8000100c:	1d850513          	addi	a0,a0,472 # 800071e0 <etext+0x1e0>
    80001010:	501010ef          	jal	80002d10 <namei>
    80001014:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001018:	478d                	li	a5,3
    8000101a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000101c:	8526                	mv	a0,s1
    8000101e:	78a040ef          	jal	800057a8 <release>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6105                	addi	sp,sp,32
    8000102a:	8082                	ret

000000008000102c <growproc>:
{
    8000102c:	1101                	addi	sp,sp,-32
    8000102e:	ec06                	sd	ra,24(sp)
    80001030:	e822                	sd	s0,16(sp)
    80001032:	e426                	sd	s1,8(sp)
    80001034:	e04a                	sd	s2,0(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000103a:	d1dff0ef          	jal	80000d56 <myproc>
    8000103e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001040:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001042:	01204c63          	bgtz	s2,8000105a <growproc+0x2e>
  } else if(n < 0){
    80001046:	02094463          	bltz	s2,8000106e <growproc+0x42>
  p->sz = sz;
    8000104a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000104c:	4501                	li	a0,0
}
    8000104e:	60e2                	ld	ra,24(sp)
    80001050:	6442                	ld	s0,16(sp)
    80001052:	64a2                	ld	s1,8(sp)
    80001054:	6902                	ld	s2,0(sp)
    80001056:	6105                	addi	sp,sp,32
    80001058:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000105a:	4691                	li	a3,4
    8000105c:	00b90633          	add	a2,s2,a1
    80001060:	6928                	ld	a0,80(a0)
    80001062:	f58ff0ef          	jal	800007ba <uvmalloc>
    80001066:	85aa                	mv	a1,a0
    80001068:	f16d                	bnez	a0,8000104a <growproc+0x1e>
      return -1;
    8000106a:	557d                	li	a0,-1
    8000106c:	b7cd                	j	8000104e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000106e:	00b90633          	add	a2,s2,a1
    80001072:	6928                	ld	a0,80(a0)
    80001074:	f02ff0ef          	jal	80000776 <uvmdealloc>
    80001078:	85aa                	mv	a1,a0
    8000107a:	bfc1                	j	8000104a <growproc+0x1e>

000000008000107c <fork>:
{
    8000107c:	7139                	addi	sp,sp,-64
    8000107e:	fc06                	sd	ra,56(sp)
    80001080:	f822                	sd	s0,48(sp)
    80001082:	f04a                	sd	s2,32(sp)
    80001084:	e456                	sd	s5,8(sp)
    80001086:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001088:	ccfff0ef          	jal	80000d56 <myproc>
    8000108c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000108e:	e8bff0ef          	jal	80000f18 <allocproc>
    80001092:	0e050a63          	beqz	a0,80001186 <fork+0x10a>
    80001096:	e852                	sd	s4,16(sp)
    80001098:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000109a:	048ab603          	ld	a2,72(s5)
    8000109e:	692c                	ld	a1,80(a0)
    800010a0:	050ab503          	ld	a0,80(s5)
    800010a4:	847ff0ef          	jal	800008ea <uvmcopy>
    800010a8:	04054a63          	bltz	a0,800010fc <fork+0x80>
    800010ac:	f426                	sd	s1,40(sp)
    800010ae:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010b0:	048ab783          	ld	a5,72(s5)
    800010b4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010b8:	058ab683          	ld	a3,88(s5)
    800010bc:	87b6                	mv	a5,a3
    800010be:	058a3703          	ld	a4,88(s4)
    800010c2:	12068693          	addi	a3,a3,288
    800010c6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010ca:	6788                	ld	a0,8(a5)
    800010cc:	6b8c                	ld	a1,16(a5)
    800010ce:	6f90                	ld	a2,24(a5)
    800010d0:	01073023          	sd	a6,0(a4)
    800010d4:	e708                	sd	a0,8(a4)
    800010d6:	eb0c                	sd	a1,16(a4)
    800010d8:	ef10                	sd	a2,24(a4)
    800010da:	02078793          	addi	a5,a5,32
    800010de:	02070713          	addi	a4,a4,32
    800010e2:	fed792e3          	bne	a5,a3,800010c6 <fork+0x4a>
  np->trapframe->a0 = 0;
    800010e6:	058a3783          	ld	a5,88(s4)
    800010ea:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010ee:	0d0a8493          	addi	s1,s5,208
    800010f2:	0d0a0913          	addi	s2,s4,208
    800010f6:	150a8993          	addi	s3,s5,336
    800010fa:	a831                	j	80001116 <fork+0x9a>
    freeproc(np);
    800010fc:	8552                	mv	a0,s4
    800010fe:	dcbff0ef          	jal	80000ec8 <freeproc>
    release(&np->lock);
    80001102:	8552                	mv	a0,s4
    80001104:	6a4040ef          	jal	800057a8 <release>
    return -1;
    80001108:	597d                	li	s2,-1
    8000110a:	6a42                	ld	s4,16(sp)
    8000110c:	a0b5                	j	80001178 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000110e:	04a1                	addi	s1,s1,8
    80001110:	0921                	addi	s2,s2,8
    80001112:	01348963          	beq	s1,s3,80001124 <fork+0xa8>
    if(p->ofile[i])
    80001116:	6088                	ld	a0,0(s1)
    80001118:	d97d                	beqz	a0,8000110e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000111a:	186020ef          	jal	800032a0 <filedup>
    8000111e:	00a93023          	sd	a0,0(s2)
    80001122:	b7f5                	j	8000110e <fork+0x92>
  np->cwd = idup(p->cwd);
    80001124:	150ab503          	ld	a0,336(s5)
    80001128:	4d8010ef          	jal	80002600 <idup>
    8000112c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001130:	4641                	li	a2,16
    80001132:	158a8593          	addi	a1,s5,344
    80001136:	158a0513          	addi	a0,s4,344
    8000113a:	938ff0ef          	jal	80000272 <safestrcpy>
  pid = np->pid;
    8000113e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001142:	8552                	mv	a0,s4
    80001144:	664040ef          	jal	800057a8 <release>
  acquire(&wait_lock);
    80001148:	00009497          	auipc	s1,0x9
    8000114c:	11048493          	addi	s1,s1,272 # 8000a258 <wait_lock>
    80001150:	8526                	mv	a0,s1
    80001152:	5be040ef          	jal	80005710 <acquire>
  np->parent = p;
    80001156:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000115a:	8526                	mv	a0,s1
    8000115c:	64c040ef          	jal	800057a8 <release>
  acquire(&np->lock);
    80001160:	8552                	mv	a0,s4
    80001162:	5ae040ef          	jal	80005710 <acquire>
  np->state = RUNNABLE;
    80001166:	478d                	li	a5,3
    80001168:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000116c:	8552                	mv	a0,s4
    8000116e:	63a040ef          	jal	800057a8 <release>
  return pid;
    80001172:	74a2                	ld	s1,40(sp)
    80001174:	69e2                	ld	s3,24(sp)
    80001176:	6a42                	ld	s4,16(sp)
}
    80001178:	854a                	mv	a0,s2
    8000117a:	70e2                	ld	ra,56(sp)
    8000117c:	7442                	ld	s0,48(sp)
    8000117e:	7902                	ld	s2,32(sp)
    80001180:	6aa2                	ld	s5,8(sp)
    80001182:	6121                	addi	sp,sp,64
    80001184:	8082                	ret
    return -1;
    80001186:	597d                	li	s2,-1
    80001188:	bfc5                	j	80001178 <fork+0xfc>

000000008000118a <scheduler>:
{
    8000118a:	715d                	addi	sp,sp,-80
    8000118c:	e486                	sd	ra,72(sp)
    8000118e:	e0a2                	sd	s0,64(sp)
    80001190:	fc26                	sd	s1,56(sp)
    80001192:	f84a                	sd	s2,48(sp)
    80001194:	f44e                	sd	s3,40(sp)
    80001196:	f052                	sd	s4,32(sp)
    80001198:	ec56                	sd	s5,24(sp)
    8000119a:	e85a                	sd	s6,16(sp)
    8000119c:	e45e                	sd	s7,8(sp)
    8000119e:	e062                	sd	s8,0(sp)
    800011a0:	0880                	addi	s0,sp,80
    800011a2:	8792                	mv	a5,tp
  int id = r_tp();
    800011a4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011a6:	00779b13          	slli	s6,a5,0x7
    800011aa:	00009717          	auipc	a4,0x9
    800011ae:	09670713          	addi	a4,a4,150 # 8000a240 <pid_lock>
    800011b2:	975a                	add	a4,a4,s6
    800011b4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011b8:	00009717          	auipc	a4,0x9
    800011bc:	0c070713          	addi	a4,a4,192 # 8000a278 <cpus+0x8>
    800011c0:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800011c2:	4c11                	li	s8,4
        c->proc = p;
    800011c4:	079e                	slli	a5,a5,0x7
    800011c6:	00009a17          	auipc	s4,0x9
    800011ca:	07aa0a13          	addi	s4,s4,122 # 8000a240 <pid_lock>
    800011ce:	9a3e                	add	s4,s4,a5
        found = 1;
    800011d0:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800011d2:	0000f997          	auipc	s3,0xf
    800011d6:	e9e98993          	addi	s3,s3,-354 # 80010070 <tickslock>
    800011da:	a0a9                	j	80001224 <scheduler+0x9a>
      release(&p->lock);
    800011dc:	8526                	mv	a0,s1
    800011de:	5ca040ef          	jal	800057a8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e2:	16848493          	addi	s1,s1,360
    800011e6:	03348563          	beq	s1,s3,80001210 <scheduler+0x86>
      acquire(&p->lock);
    800011ea:	8526                	mv	a0,s1
    800011ec:	524040ef          	jal	80005710 <acquire>
      if(p->state == RUNNABLE) {
    800011f0:	4c9c                	lw	a5,24(s1)
    800011f2:	ff2795e3          	bne	a5,s2,800011dc <scheduler+0x52>
        p->state = RUNNING;
    800011f6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800011fa:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800011fe:	06048593          	addi	a1,s1,96
    80001202:	855a                	mv	a0,s6
    80001204:	5b4000ef          	jal	800017b8 <swtch>
        c->proc = 0;
    80001208:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000120c:	8ade                	mv	s5,s7
    8000120e:	b7f9                	j	800011dc <scheduler+0x52>
    if(found == 0) {
    80001210:	000a9a63          	bnez	s5,80001224 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001214:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001218:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000121c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001220:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001224:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001228:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000122c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001230:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001232:	00009497          	auipc	s1,0x9
    80001236:	43e48493          	addi	s1,s1,1086 # 8000a670 <proc>
      if(p->state == RUNNABLE) {
    8000123a:	490d                	li	s2,3
    8000123c:	b77d                	j	800011ea <scheduler+0x60>

000000008000123e <sched>:
{
    8000123e:	7179                	addi	sp,sp,-48
    80001240:	f406                	sd	ra,40(sp)
    80001242:	f022                	sd	s0,32(sp)
    80001244:	ec26                	sd	s1,24(sp)
    80001246:	e84a                	sd	s2,16(sp)
    80001248:	e44e                	sd	s3,8(sp)
    8000124a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000124c:	b0bff0ef          	jal	80000d56 <myproc>
    80001250:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001252:	454040ef          	jal	800056a6 <holding>
    80001256:	c92d                	beqz	a0,800012c8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001258:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000125a:	2781                	sext.w	a5,a5
    8000125c:	079e                	slli	a5,a5,0x7
    8000125e:	00009717          	auipc	a4,0x9
    80001262:	fe270713          	addi	a4,a4,-30 # 8000a240 <pid_lock>
    80001266:	97ba                	add	a5,a5,a4
    80001268:	0a87a703          	lw	a4,168(a5)
    8000126c:	4785                	li	a5,1
    8000126e:	06f71363          	bne	a4,a5,800012d4 <sched+0x96>
  if(p->state == RUNNING)
    80001272:	4c98                	lw	a4,24(s1)
    80001274:	4791                	li	a5,4
    80001276:	06f70563          	beq	a4,a5,800012e0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000127e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001280:	e7b5                	bnez	a5,800012ec <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001282:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001284:	00009917          	auipc	s2,0x9
    80001288:	fbc90913          	addi	s2,s2,-68 # 8000a240 <pid_lock>
    8000128c:	2781                	sext.w	a5,a5
    8000128e:	079e                	slli	a5,a5,0x7
    80001290:	97ca                	add	a5,a5,s2
    80001292:	0ac7a983          	lw	s3,172(a5)
    80001296:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001298:	2781                	sext.w	a5,a5
    8000129a:	079e                	slli	a5,a5,0x7
    8000129c:	00009597          	auipc	a1,0x9
    800012a0:	fdc58593          	addi	a1,a1,-36 # 8000a278 <cpus+0x8>
    800012a4:	95be                	add	a1,a1,a5
    800012a6:	06048513          	addi	a0,s1,96
    800012aa:	50e000ef          	jal	800017b8 <swtch>
    800012ae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012b0:	2781                	sext.w	a5,a5
    800012b2:	079e                	slli	a5,a5,0x7
    800012b4:	993e                	add	s2,s2,a5
    800012b6:	0b392623          	sw	s3,172(s2)
}
    800012ba:	70a2                	ld	ra,40(sp)
    800012bc:	7402                	ld	s0,32(sp)
    800012be:	64e2                	ld	s1,24(sp)
    800012c0:	6942                	ld	s2,16(sp)
    800012c2:	69a2                	ld	s3,8(sp)
    800012c4:	6145                	addi	sp,sp,48
    800012c6:	8082                	ret
    panic("sched p->lock");
    800012c8:	00006517          	auipc	a0,0x6
    800012cc:	f2050513          	addi	a0,a0,-224 # 800071e8 <etext+0x1e8>
    800012d0:	112040ef          	jal	800053e2 <panic>
    panic("sched locks");
    800012d4:	00006517          	auipc	a0,0x6
    800012d8:	f2450513          	addi	a0,a0,-220 # 800071f8 <etext+0x1f8>
    800012dc:	106040ef          	jal	800053e2 <panic>
    panic("sched running");
    800012e0:	00006517          	auipc	a0,0x6
    800012e4:	f2850513          	addi	a0,a0,-216 # 80007208 <etext+0x208>
    800012e8:	0fa040ef          	jal	800053e2 <panic>
    panic("sched interruptible");
    800012ec:	00006517          	auipc	a0,0x6
    800012f0:	f2c50513          	addi	a0,a0,-212 # 80007218 <etext+0x218>
    800012f4:	0ee040ef          	jal	800053e2 <panic>

00000000800012f8 <yield>:
{
    800012f8:	1101                	addi	sp,sp,-32
    800012fa:	ec06                	sd	ra,24(sp)
    800012fc:	e822                	sd	s0,16(sp)
    800012fe:	e426                	sd	s1,8(sp)
    80001300:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001302:	a55ff0ef          	jal	80000d56 <myproc>
    80001306:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001308:	408040ef          	jal	80005710 <acquire>
  p->state = RUNNABLE;
    8000130c:	478d                	li	a5,3
    8000130e:	cc9c                	sw	a5,24(s1)
  sched();
    80001310:	f2fff0ef          	jal	8000123e <sched>
  release(&p->lock);
    80001314:	8526                	mv	a0,s1
    80001316:	492040ef          	jal	800057a8 <release>
}
    8000131a:	60e2                	ld	ra,24(sp)
    8000131c:	6442                	ld	s0,16(sp)
    8000131e:	64a2                	ld	s1,8(sp)
    80001320:	6105                	addi	sp,sp,32
    80001322:	8082                	ret

0000000080001324 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001324:	7179                	addi	sp,sp,-48
    80001326:	f406                	sd	ra,40(sp)
    80001328:	f022                	sd	s0,32(sp)
    8000132a:	ec26                	sd	s1,24(sp)
    8000132c:	e84a                	sd	s2,16(sp)
    8000132e:	e44e                	sd	s3,8(sp)
    80001330:	1800                	addi	s0,sp,48
    80001332:	89aa                	mv	s3,a0
    80001334:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001336:	a21ff0ef          	jal	80000d56 <myproc>
    8000133a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000133c:	3d4040ef          	jal	80005710 <acquire>
  release(lk);
    80001340:	854a                	mv	a0,s2
    80001342:	466040ef          	jal	800057a8 <release>

  // Go to sleep.
  p->chan = chan;
    80001346:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000134a:	4789                	li	a5,2
    8000134c:	cc9c                	sw	a5,24(s1)

  sched();
    8000134e:	ef1ff0ef          	jal	8000123e <sched>

  // Tidy up.
  p->chan = 0;
    80001352:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001356:	8526                	mv	a0,s1
    80001358:	450040ef          	jal	800057a8 <release>
  acquire(lk);
    8000135c:	854a                	mv	a0,s2
    8000135e:	3b2040ef          	jal	80005710 <acquire>
}
    80001362:	70a2                	ld	ra,40(sp)
    80001364:	7402                	ld	s0,32(sp)
    80001366:	64e2                	ld	s1,24(sp)
    80001368:	6942                	ld	s2,16(sp)
    8000136a:	69a2                	ld	s3,8(sp)
    8000136c:	6145                	addi	sp,sp,48
    8000136e:	8082                	ret

0000000080001370 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001370:	7139                	addi	sp,sp,-64
    80001372:	fc06                	sd	ra,56(sp)
    80001374:	f822                	sd	s0,48(sp)
    80001376:	f426                	sd	s1,40(sp)
    80001378:	f04a                	sd	s2,32(sp)
    8000137a:	ec4e                	sd	s3,24(sp)
    8000137c:	e852                	sd	s4,16(sp)
    8000137e:	e456                	sd	s5,8(sp)
    80001380:	0080                	addi	s0,sp,64
    80001382:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001384:	00009497          	auipc	s1,0x9
    80001388:	2ec48493          	addi	s1,s1,748 # 8000a670 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000138c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000138e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001390:	0000f917          	auipc	s2,0xf
    80001394:	ce090913          	addi	s2,s2,-800 # 80010070 <tickslock>
    80001398:	a801                	j	800013a8 <wakeup+0x38>
      }
      release(&p->lock);
    8000139a:	8526                	mv	a0,s1
    8000139c:	40c040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013a0:	16848493          	addi	s1,s1,360
    800013a4:	03248263          	beq	s1,s2,800013c8 <wakeup+0x58>
    if(p != myproc()){
    800013a8:	9afff0ef          	jal	80000d56 <myproc>
    800013ac:	fea48ae3          	beq	s1,a0,800013a0 <wakeup+0x30>
      acquire(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	35e040ef          	jal	80005710 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013b6:	4c9c                	lw	a5,24(s1)
    800013b8:	ff3791e3          	bne	a5,s3,8000139a <wakeup+0x2a>
    800013bc:	709c                	ld	a5,32(s1)
    800013be:	fd479ee3          	bne	a5,s4,8000139a <wakeup+0x2a>
        p->state = RUNNABLE;
    800013c2:	0154ac23          	sw	s5,24(s1)
    800013c6:	bfd1                	j	8000139a <wakeup+0x2a>
    }
  }
}
    800013c8:	70e2                	ld	ra,56(sp)
    800013ca:	7442                	ld	s0,48(sp)
    800013cc:	74a2                	ld	s1,40(sp)
    800013ce:	7902                	ld	s2,32(sp)
    800013d0:	69e2                	ld	s3,24(sp)
    800013d2:	6a42                	ld	s4,16(sp)
    800013d4:	6aa2                	ld	s5,8(sp)
    800013d6:	6121                	addi	sp,sp,64
    800013d8:	8082                	ret

00000000800013da <reparent>:
{
    800013da:	7179                	addi	sp,sp,-48
    800013dc:	f406                	sd	ra,40(sp)
    800013de:	f022                	sd	s0,32(sp)
    800013e0:	ec26                	sd	s1,24(sp)
    800013e2:	e84a                	sd	s2,16(sp)
    800013e4:	e44e                	sd	s3,8(sp)
    800013e6:	e052                	sd	s4,0(sp)
    800013e8:	1800                	addi	s0,sp,48
    800013ea:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013ec:	00009497          	auipc	s1,0x9
    800013f0:	28448493          	addi	s1,s1,644 # 8000a670 <proc>
      pp->parent = initproc;
    800013f4:	00009a17          	auipc	s4,0x9
    800013f8:	e0ca0a13          	addi	s4,s4,-500 # 8000a200 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013fc:	0000f997          	auipc	s3,0xf
    80001400:	c7498993          	addi	s3,s3,-908 # 80010070 <tickslock>
    80001404:	a029                	j	8000140e <reparent+0x34>
    80001406:	16848493          	addi	s1,s1,360
    8000140a:	01348b63          	beq	s1,s3,80001420 <reparent+0x46>
    if(pp->parent == p){
    8000140e:	7c9c                	ld	a5,56(s1)
    80001410:	ff279be3          	bne	a5,s2,80001406 <reparent+0x2c>
      pp->parent = initproc;
    80001414:	000a3503          	ld	a0,0(s4)
    80001418:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000141a:	f57ff0ef          	jal	80001370 <wakeup>
    8000141e:	b7e5                	j	80001406 <reparent+0x2c>
}
    80001420:	70a2                	ld	ra,40(sp)
    80001422:	7402                	ld	s0,32(sp)
    80001424:	64e2                	ld	s1,24(sp)
    80001426:	6942                	ld	s2,16(sp)
    80001428:	69a2                	ld	s3,8(sp)
    8000142a:	6a02                	ld	s4,0(sp)
    8000142c:	6145                	addi	sp,sp,48
    8000142e:	8082                	ret

0000000080001430 <exit>:
{
    80001430:	7179                	addi	sp,sp,-48
    80001432:	f406                	sd	ra,40(sp)
    80001434:	f022                	sd	s0,32(sp)
    80001436:	ec26                	sd	s1,24(sp)
    80001438:	e84a                	sd	s2,16(sp)
    8000143a:	e44e                	sd	s3,8(sp)
    8000143c:	e052                	sd	s4,0(sp)
    8000143e:	1800                	addi	s0,sp,48
    80001440:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001442:	915ff0ef          	jal	80000d56 <myproc>
    80001446:	89aa                	mv	s3,a0
  if(p == initproc)
    80001448:	00009797          	auipc	a5,0x9
    8000144c:	db87b783          	ld	a5,-584(a5) # 8000a200 <initproc>
    80001450:	0d050493          	addi	s1,a0,208
    80001454:	15050913          	addi	s2,a0,336
    80001458:	00a79f63          	bne	a5,a0,80001476 <exit+0x46>
    panic("init exiting");
    8000145c:	00006517          	auipc	a0,0x6
    80001460:	dd450513          	addi	a0,a0,-556 # 80007230 <etext+0x230>
    80001464:	77f030ef          	jal	800053e2 <panic>
      fileclose(f);
    80001468:	67f010ef          	jal	800032e6 <fileclose>
      p->ofile[fd] = 0;
    8000146c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001470:	04a1                	addi	s1,s1,8
    80001472:	01248563          	beq	s1,s2,8000147c <exit+0x4c>
    if(p->ofile[fd]){
    80001476:	6088                	ld	a0,0(s1)
    80001478:	f965                	bnez	a0,80001468 <exit+0x38>
    8000147a:	bfdd                	j	80001470 <exit+0x40>
  begin_op();
    8000147c:	251010ef          	jal	80002ecc <begin_op>
  iput(p->cwd);
    80001480:	1509b503          	ld	a0,336(s3)
    80001484:	334010ef          	jal	800027b8 <iput>
  end_op();
    80001488:	2af010ef          	jal	80002f36 <end_op>
  p->cwd = 0;
    8000148c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001490:	00009497          	auipc	s1,0x9
    80001494:	dc848493          	addi	s1,s1,-568 # 8000a258 <wait_lock>
    80001498:	8526                	mv	a0,s1
    8000149a:	276040ef          	jal	80005710 <acquire>
  reparent(p);
    8000149e:	854e                	mv	a0,s3
    800014a0:	f3bff0ef          	jal	800013da <reparent>
  wakeup(p->parent);
    800014a4:	0389b503          	ld	a0,56(s3)
    800014a8:	ec9ff0ef          	jal	80001370 <wakeup>
  acquire(&p->lock);
    800014ac:	854e                	mv	a0,s3
    800014ae:	262040ef          	jal	80005710 <acquire>
  p->xstate = status;
    800014b2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014b6:	4795                	li	a5,5
    800014b8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014bc:	8526                	mv	a0,s1
    800014be:	2ea040ef          	jal	800057a8 <release>
  sched();
    800014c2:	d7dff0ef          	jal	8000123e <sched>
  panic("zombie exit");
    800014c6:	00006517          	auipc	a0,0x6
    800014ca:	d7a50513          	addi	a0,a0,-646 # 80007240 <etext+0x240>
    800014ce:	715030ef          	jal	800053e2 <panic>

00000000800014d2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014d2:	7179                	addi	sp,sp,-48
    800014d4:	f406                	sd	ra,40(sp)
    800014d6:	f022                	sd	s0,32(sp)
    800014d8:	ec26                	sd	s1,24(sp)
    800014da:	e84a                	sd	s2,16(sp)
    800014dc:	e44e                	sd	s3,8(sp)
    800014de:	1800                	addi	s0,sp,48
    800014e0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014e2:	00009497          	auipc	s1,0x9
    800014e6:	18e48493          	addi	s1,s1,398 # 8000a670 <proc>
    800014ea:	0000f997          	auipc	s3,0xf
    800014ee:	b8698993          	addi	s3,s3,-1146 # 80010070 <tickslock>
    acquire(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	21c040ef          	jal	80005710 <acquire>
    if(p->pid == pid){
    800014f8:	589c                	lw	a5,48(s1)
    800014fa:	01278b63          	beq	a5,s2,80001510 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	2a8040ef          	jal	800057a8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001504:	16848493          	addi	s1,s1,360
    80001508:	ff3495e3          	bne	s1,s3,800014f2 <kill+0x20>
  }
  return -1;
    8000150c:	557d                	li	a0,-1
    8000150e:	a819                	j	80001524 <kill+0x52>
      p->killed = 1;
    80001510:	4785                	li	a5,1
    80001512:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001514:	4c98                	lw	a4,24(s1)
    80001516:	4789                	li	a5,2
    80001518:	00f70d63          	beq	a4,a5,80001532 <kill+0x60>
      release(&p->lock);
    8000151c:	8526                	mv	a0,s1
    8000151e:	28a040ef          	jal	800057a8 <release>
      return 0;
    80001522:	4501                	li	a0,0
}
    80001524:	70a2                	ld	ra,40(sp)
    80001526:	7402                	ld	s0,32(sp)
    80001528:	64e2                	ld	s1,24(sp)
    8000152a:	6942                	ld	s2,16(sp)
    8000152c:	69a2                	ld	s3,8(sp)
    8000152e:	6145                	addi	sp,sp,48
    80001530:	8082                	ret
        p->state = RUNNABLE;
    80001532:	478d                	li	a5,3
    80001534:	cc9c                	sw	a5,24(s1)
    80001536:	b7dd                	j	8000151c <kill+0x4a>

0000000080001538 <setkilled>:

void
setkilled(struct proc *p)
{
    80001538:	1101                	addi	sp,sp,-32
    8000153a:	ec06                	sd	ra,24(sp)
    8000153c:	e822                	sd	s0,16(sp)
    8000153e:	e426                	sd	s1,8(sp)
    80001540:	1000                	addi	s0,sp,32
    80001542:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001544:	1cc040ef          	jal	80005710 <acquire>
  p->killed = 1;
    80001548:	4785                	li	a5,1
    8000154a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	25a040ef          	jal	800057a8 <release>
}
    80001552:	60e2                	ld	ra,24(sp)
    80001554:	6442                	ld	s0,16(sp)
    80001556:	64a2                	ld	s1,8(sp)
    80001558:	6105                	addi	sp,sp,32
    8000155a:	8082                	ret

000000008000155c <killed>:

int
killed(struct proc *p)
{
    8000155c:	1101                	addi	sp,sp,-32
    8000155e:	ec06                	sd	ra,24(sp)
    80001560:	e822                	sd	s0,16(sp)
    80001562:	e426                	sd	s1,8(sp)
    80001564:	e04a                	sd	s2,0(sp)
    80001566:	1000                	addi	s0,sp,32
    80001568:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000156a:	1a6040ef          	jal	80005710 <acquire>
  k = p->killed;
    8000156e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001572:	8526                	mv	a0,s1
    80001574:	234040ef          	jal	800057a8 <release>
  return k;
}
    80001578:	854a                	mv	a0,s2
    8000157a:	60e2                	ld	ra,24(sp)
    8000157c:	6442                	ld	s0,16(sp)
    8000157e:	64a2                	ld	s1,8(sp)
    80001580:	6902                	ld	s2,0(sp)
    80001582:	6105                	addi	sp,sp,32
    80001584:	8082                	ret

0000000080001586 <wait>:
{
    80001586:	715d                	addi	sp,sp,-80
    80001588:	e486                	sd	ra,72(sp)
    8000158a:	e0a2                	sd	s0,64(sp)
    8000158c:	fc26                	sd	s1,56(sp)
    8000158e:	f84a                	sd	s2,48(sp)
    80001590:	f44e                	sd	s3,40(sp)
    80001592:	f052                	sd	s4,32(sp)
    80001594:	ec56                	sd	s5,24(sp)
    80001596:	e85a                	sd	s6,16(sp)
    80001598:	e45e                	sd	s7,8(sp)
    8000159a:	e062                	sd	s8,0(sp)
    8000159c:	0880                	addi	s0,sp,80
    8000159e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015a0:	fb6ff0ef          	jal	80000d56 <myproc>
    800015a4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015a6:	00009517          	auipc	a0,0x9
    800015aa:	cb250513          	addi	a0,a0,-846 # 8000a258 <wait_lock>
    800015ae:	162040ef          	jal	80005710 <acquire>
    havekids = 0;
    800015b2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015b4:	4a15                	li	s4,5
        havekids = 1;
    800015b6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015b8:	0000f997          	auipc	s3,0xf
    800015bc:	ab898993          	addi	s3,s3,-1352 # 80010070 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015c0:	00009c17          	auipc	s8,0x9
    800015c4:	c98c0c13          	addi	s8,s8,-872 # 8000a258 <wait_lock>
    800015c8:	a871                	j	80001664 <wait+0xde>
          pid = pp->pid;
    800015ca:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015ce:	000b0c63          	beqz	s6,800015e6 <wait+0x60>
    800015d2:	4691                	li	a3,4
    800015d4:	02c48613          	addi	a2,s1,44
    800015d8:	85da                	mv	a1,s6
    800015da:	05093503          	ld	a0,80(s2)
    800015de:	be8ff0ef          	jal	800009c6 <copyout>
    800015e2:	02054b63          	bltz	a0,80001618 <wait+0x92>
          freeproc(pp);
    800015e6:	8526                	mv	a0,s1
    800015e8:	8e1ff0ef          	jal	80000ec8 <freeproc>
          release(&pp->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	1ba040ef          	jal	800057a8 <release>
          release(&wait_lock);
    800015f2:	00009517          	auipc	a0,0x9
    800015f6:	c6650513          	addi	a0,a0,-922 # 8000a258 <wait_lock>
    800015fa:	1ae040ef          	jal	800057a8 <release>
}
    800015fe:	854e                	mv	a0,s3
    80001600:	60a6                	ld	ra,72(sp)
    80001602:	6406                	ld	s0,64(sp)
    80001604:	74e2                	ld	s1,56(sp)
    80001606:	7942                	ld	s2,48(sp)
    80001608:	79a2                	ld	s3,40(sp)
    8000160a:	7a02                	ld	s4,32(sp)
    8000160c:	6ae2                	ld	s5,24(sp)
    8000160e:	6b42                	ld	s6,16(sp)
    80001610:	6ba2                	ld	s7,8(sp)
    80001612:	6c02                	ld	s8,0(sp)
    80001614:	6161                	addi	sp,sp,80
    80001616:	8082                	ret
            release(&pp->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	18e040ef          	jal	800057a8 <release>
            release(&wait_lock);
    8000161e:	00009517          	auipc	a0,0x9
    80001622:	c3a50513          	addi	a0,a0,-966 # 8000a258 <wait_lock>
    80001626:	182040ef          	jal	800057a8 <release>
            return -1;
    8000162a:	59fd                	li	s3,-1
    8000162c:	bfc9                	j	800015fe <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000162e:	16848493          	addi	s1,s1,360
    80001632:	03348063          	beq	s1,s3,80001652 <wait+0xcc>
      if(pp->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <wait+0xa8>
        acquire(&pp->lock);
    8000163c:	8526                	mv	a0,s1
    8000163e:	0d2040ef          	jal	80005710 <acquire>
        if(pp->state == ZOMBIE){
    80001642:	4c9c                	lw	a5,24(s1)
    80001644:	f94783e3          	beq	a5,s4,800015ca <wait+0x44>
        release(&pp->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	15e040ef          	jal	800057a8 <release>
        havekids = 1;
    8000164e:	8756                	mv	a4,s5
    80001650:	bff9                	j	8000162e <wait+0xa8>
    if(!havekids || killed(p)){
    80001652:	cf19                	beqz	a4,80001670 <wait+0xea>
    80001654:	854a                	mv	a0,s2
    80001656:	f07ff0ef          	jal	8000155c <killed>
    8000165a:	e919                	bnez	a0,80001670 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000165c:	85e2                	mv	a1,s8
    8000165e:	854a                	mv	a0,s2
    80001660:	cc5ff0ef          	jal	80001324 <sleep>
    havekids = 0;
    80001664:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001666:	00009497          	auipc	s1,0x9
    8000166a:	00a48493          	addi	s1,s1,10 # 8000a670 <proc>
    8000166e:	b7e1                	j	80001636 <wait+0xb0>
      release(&wait_lock);
    80001670:	00009517          	auipc	a0,0x9
    80001674:	be850513          	addi	a0,a0,-1048 # 8000a258 <wait_lock>
    80001678:	130040ef          	jal	800057a8 <release>
      return -1;
    8000167c:	59fd                	li	s3,-1
    8000167e:	b741                	j	800015fe <wait+0x78>

0000000080001680 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001680:	7179                	addi	sp,sp,-48
    80001682:	f406                	sd	ra,40(sp)
    80001684:	f022                	sd	s0,32(sp)
    80001686:	ec26                	sd	s1,24(sp)
    80001688:	e84a                	sd	s2,16(sp)
    8000168a:	e44e                	sd	s3,8(sp)
    8000168c:	e052                	sd	s4,0(sp)
    8000168e:	1800                	addi	s0,sp,48
    80001690:	84aa                	mv	s1,a0
    80001692:	892e                	mv	s2,a1
    80001694:	89b2                	mv	s3,a2
    80001696:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001698:	ebeff0ef          	jal	80000d56 <myproc>
  if(user_dst){
    8000169c:	cc99                	beqz	s1,800016ba <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000169e:	86d2                	mv	a3,s4
    800016a0:	864e                	mv	a2,s3
    800016a2:	85ca                	mv	a1,s2
    800016a4:	6928                	ld	a0,80(a0)
    800016a6:	b20ff0ef          	jal	800009c6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6a02                	ld	s4,0(sp)
    800016b6:	6145                	addi	sp,sp,48
    800016b8:	8082                	ret
    memmove((char *)dst, src, len);
    800016ba:	000a061b          	sext.w	a2,s4
    800016be:	85ce                	mv	a1,s3
    800016c0:	854a                	mv	a0,s2
    800016c2:	acffe0ef          	jal	80000190 <memmove>
    return 0;
    800016c6:	8526                	mv	a0,s1
    800016c8:	b7cd                	j	800016aa <either_copyout+0x2a>

00000000800016ca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016ca:	7179                	addi	sp,sp,-48
    800016cc:	f406                	sd	ra,40(sp)
    800016ce:	f022                	sd	s0,32(sp)
    800016d0:	ec26                	sd	s1,24(sp)
    800016d2:	e84a                	sd	s2,16(sp)
    800016d4:	e44e                	sd	s3,8(sp)
    800016d6:	e052                	sd	s4,0(sp)
    800016d8:	1800                	addi	s0,sp,48
    800016da:	892a                	mv	s2,a0
    800016dc:	84ae                	mv	s1,a1
    800016de:	89b2                	mv	s3,a2
    800016e0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e2:	e74ff0ef          	jal	80000d56 <myproc>
  if(user_src){
    800016e6:	cc99                	beqz	s1,80001704 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016e8:	86d2                	mv	a3,s4
    800016ea:	864e                	mv	a2,s3
    800016ec:	85ca                	mv	a1,s2
    800016ee:	6928                	ld	a0,80(a0)
    800016f0:	baeff0ef          	jal	80000a9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016f4:	70a2                	ld	ra,40(sp)
    800016f6:	7402                	ld	s0,32(sp)
    800016f8:	64e2                	ld	s1,24(sp)
    800016fa:	6942                	ld	s2,16(sp)
    800016fc:	69a2                	ld	s3,8(sp)
    800016fe:	6a02                	ld	s4,0(sp)
    80001700:	6145                	addi	sp,sp,48
    80001702:	8082                	ret
    memmove(dst, (char*)src, len);
    80001704:	000a061b          	sext.w	a2,s4
    80001708:	85ce                	mv	a1,s3
    8000170a:	854a                	mv	a0,s2
    8000170c:	a85fe0ef          	jal	80000190 <memmove>
    return 0;
    80001710:	8526                	mv	a0,s1
    80001712:	b7cd                	j	800016f4 <either_copyin+0x2a>

0000000080001714 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000172a:	00006517          	auipc	a0,0x6
    8000172e:	8ee50513          	addi	a0,a0,-1810 # 80007018 <etext+0x18>
    80001732:	1df030ef          	jal	80005110 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001736:	00009497          	auipc	s1,0x9
    8000173a:	09248493          	addi	s1,s1,146 # 8000a7c8 <proc+0x158>
    8000173e:	0000f917          	auipc	s2,0xf
    80001742:	a8a90913          	addi	s2,s2,-1398 # 800101c8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001746:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001748:	00006997          	auipc	s3,0x6
    8000174c:	b0898993          	addi	s3,s3,-1272 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    80001750:	00006a97          	auipc	s5,0x6
    80001754:	b08a8a93          	addi	s5,s5,-1272 # 80007258 <etext+0x258>
    printf("\n");
    80001758:	00006a17          	auipc	s4,0x6
    8000175c:	8c0a0a13          	addi	s4,s4,-1856 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001760:	00006b97          	auipc	s7,0x6
    80001764:	020b8b93          	addi	s7,s7,32 # 80007780 <states.0>
    80001768:	a829                	j	80001782 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000176a:	ed86a583          	lw	a1,-296(a3)
    8000176e:	8556                	mv	a0,s5
    80001770:	1a1030ef          	jal	80005110 <printf>
    printf("\n");
    80001774:	8552                	mv	a0,s4
    80001776:	19b030ef          	jal	80005110 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000177a:	16848493          	addi	s1,s1,360
    8000177e:	03248263          	beq	s1,s2,800017a2 <procdump+0x8e>
    if(p->state == UNUSED)
    80001782:	86a6                	mv	a3,s1
    80001784:	ec04a783          	lw	a5,-320(s1)
    80001788:	dbed                	beqz	a5,8000177a <procdump+0x66>
      state = "???";
    8000178a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000178c:	fcfb6fe3          	bltu	s6,a5,8000176a <procdump+0x56>
    80001790:	02079713          	slli	a4,a5,0x20
    80001794:	01d75793          	srli	a5,a4,0x1d
    80001798:	97de                	add	a5,a5,s7
    8000179a:	6390                	ld	a2,0(a5)
    8000179c:	f679                	bnez	a2,8000176a <procdump+0x56>
      state = "???";
    8000179e:	864e                	mv	a2,s3
    800017a0:	b7e9                	j	8000176a <procdump+0x56>
  }
}
    800017a2:	60a6                	ld	ra,72(sp)
    800017a4:	6406                	ld	s0,64(sp)
    800017a6:	74e2                	ld	s1,56(sp)
    800017a8:	7942                	ld	s2,48(sp)
    800017aa:	79a2                	ld	s3,40(sp)
    800017ac:	7a02                	ld	s4,32(sp)
    800017ae:	6ae2                	ld	s5,24(sp)
    800017b0:	6b42                	ld	s6,16(sp)
    800017b2:	6ba2                	ld	s7,8(sp)
    800017b4:	6161                	addi	sp,sp,80
    800017b6:	8082                	ret

00000000800017b8 <swtch>:
    800017b8:	00153023          	sd	ra,0(a0)
    800017bc:	00253423          	sd	sp,8(a0)
    800017c0:	e900                	sd	s0,16(a0)
    800017c2:	ed04                	sd	s1,24(a0)
    800017c4:	03253023          	sd	s2,32(a0)
    800017c8:	03353423          	sd	s3,40(a0)
    800017cc:	03453823          	sd	s4,48(a0)
    800017d0:	03553c23          	sd	s5,56(a0)
    800017d4:	05653023          	sd	s6,64(a0)
    800017d8:	05753423          	sd	s7,72(a0)
    800017dc:	05853823          	sd	s8,80(a0)
    800017e0:	05953c23          	sd	s9,88(a0)
    800017e4:	07a53023          	sd	s10,96(a0)
    800017e8:	07b53423          	sd	s11,104(a0)
    800017ec:	0005b083          	ld	ra,0(a1)
    800017f0:	0085b103          	ld	sp,8(a1)
    800017f4:	6980                	ld	s0,16(a1)
    800017f6:	6d84                	ld	s1,24(a1)
    800017f8:	0205b903          	ld	s2,32(a1)
    800017fc:	0285b983          	ld	s3,40(a1)
    80001800:	0305ba03          	ld	s4,48(a1)
    80001804:	0385ba83          	ld	s5,56(a1)
    80001808:	0405bb03          	ld	s6,64(a1)
    8000180c:	0485bb83          	ld	s7,72(a1)
    80001810:	0505bc03          	ld	s8,80(a1)
    80001814:	0585bc83          	ld	s9,88(a1)
    80001818:	0605bd03          	ld	s10,96(a1)
    8000181c:	0685bd83          	ld	s11,104(a1)
    80001820:	8082                	ret

0000000080001822 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001822:	1141                	addi	sp,sp,-16
    80001824:	e406                	sd	ra,8(sp)
    80001826:	e022                	sd	s0,0(sp)
    80001828:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000182a:	00006597          	auipc	a1,0x6
    8000182e:	a6e58593          	addi	a1,a1,-1426 # 80007298 <etext+0x298>
    80001832:	0000f517          	auipc	a0,0xf
    80001836:	83e50513          	addi	a0,a0,-1986 # 80010070 <tickslock>
    8000183a:	657030ef          	jal	80005690 <initlock>
}
    8000183e:	60a2                	ld	ra,8(sp)
    80001840:	6402                	ld	s0,0(sp)
    80001842:	0141                	addi	sp,sp,16
    80001844:	8082                	ret

0000000080001846 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001846:	1141                	addi	sp,sp,-16
    80001848:	e422                	sd	s0,8(sp)
    8000184a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000184c:	00003797          	auipc	a5,0x3
    80001850:	e0478793          	addi	a5,a5,-508 # 80004650 <kernelvec>
    80001854:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001858:	6422                	ld	s0,8(sp)
    8000185a:	0141                	addi	sp,sp,16
    8000185c:	8082                	ret

000000008000185e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000185e:	1141                	addi	sp,sp,-16
    80001860:	e406                	sd	ra,8(sp)
    80001862:	e022                	sd	s0,0(sp)
    80001864:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001866:	cf0ff0ef          	jal	80000d56 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000186a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000186e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001870:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001874:	00004697          	auipc	a3,0x4
    80001878:	78c68693          	addi	a3,a3,1932 # 80006000 <_trampoline>
    8000187c:	00004717          	auipc	a4,0x4
    80001880:	78470713          	addi	a4,a4,1924 # 80006000 <_trampoline>
    80001884:	8f15                	sub	a4,a4,a3
    80001886:	040007b7          	lui	a5,0x4000
    8000188a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	07b2                	slli	a5,a5,0xc
    8000188e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001890:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001894:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001896:	18002673          	csrr	a2,satp
    8000189a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000189c:	6d30                	ld	a2,88(a0)
    8000189e:	6138                	ld	a4,64(a0)
    800018a0:	6585                	lui	a1,0x1
    800018a2:	972e                	add	a4,a4,a1
    800018a4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018a6:	6d38                	ld	a4,88(a0)
    800018a8:	00000617          	auipc	a2,0x0
    800018ac:	11060613          	addi	a2,a2,272 # 800019b8 <usertrap>
    800018b0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018b2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018b4:	8612                	mv	a2,tp
    800018b6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018b8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018bc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018c0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018c4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018c8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018ca:	6f18                	ld	a4,24(a4)
    800018cc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018d0:	6928                	ld	a0,80(a0)
    800018d2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018d4:	00004717          	auipc	a4,0x4
    800018d8:	7c870713          	addi	a4,a4,1992 # 8000609c <userret>
    800018dc:	8f15                	sub	a4,a4,a3
    800018de:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018e0:	577d                	li	a4,-1
    800018e2:	177e                	slli	a4,a4,0x3f
    800018e4:	8d59                	or	a0,a0,a4
    800018e6:	9782                	jalr	a5
}
    800018e8:	60a2                	ld	ra,8(sp)
    800018ea:	6402                	ld	s0,0(sp)
    800018ec:	0141                	addi	sp,sp,16
    800018ee:	8082                	ret

00000000800018f0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018f0:	1101                	addi	sp,sp,-32
    800018f2:	ec06                	sd	ra,24(sp)
    800018f4:	e822                	sd	s0,16(sp)
    800018f6:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018f8:	c32ff0ef          	jal	80000d2a <cpuid>
    800018fc:	cd11                	beqz	a0,80001918 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800018fe:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001902:	000f4737          	lui	a4,0xf4
    80001906:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000190a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000190c:	14d79073          	csrw	stimecmp,a5
}
    80001910:	60e2                	ld	ra,24(sp)
    80001912:	6442                	ld	s0,16(sp)
    80001914:	6105                	addi	sp,sp,32
    80001916:	8082                	ret
    80001918:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000191a:	0000e497          	auipc	s1,0xe
    8000191e:	75648493          	addi	s1,s1,1878 # 80010070 <tickslock>
    80001922:	8526                	mv	a0,s1
    80001924:	5ed030ef          	jal	80005710 <acquire>
    ticks++;
    80001928:	00009517          	auipc	a0,0x9
    8000192c:	8e050513          	addi	a0,a0,-1824 # 8000a208 <ticks>
    80001930:	411c                	lw	a5,0(a0)
    80001932:	2785                	addiw	a5,a5,1
    80001934:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001936:	a3bff0ef          	jal	80001370 <wakeup>
    release(&tickslock);
    8000193a:	8526                	mv	a0,s1
    8000193c:	66d030ef          	jal	800057a8 <release>
    80001940:	64a2                	ld	s1,8(sp)
    80001942:	bf75                	j	800018fe <clockintr+0xe>

0000000080001944 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001944:	1101                	addi	sp,sp,-32
    80001946:	ec06                	sd	ra,24(sp)
    80001948:	e822                	sd	s0,16(sp)
    8000194a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000194c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001950:	57fd                	li	a5,-1
    80001952:	17fe                	slli	a5,a5,0x3f
    80001954:	07a5                	addi	a5,a5,9
    80001956:	00f70c63          	beq	a4,a5,8000196e <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000195a:	57fd                	li	a5,-1
    8000195c:	17fe                	slli	a5,a5,0x3f
    8000195e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001960:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001962:	04f70763          	beq	a4,a5,800019b0 <devintr+0x6c>
  }
}
    80001966:	60e2                	ld	ra,24(sp)
    80001968:	6442                	ld	s0,16(sp)
    8000196a:	6105                	addi	sp,sp,32
    8000196c:	8082                	ret
    8000196e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001970:	58d020ef          	jal	800046fc <plic_claim>
    80001974:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001976:	47a9                	li	a5,10
    80001978:	00f50963          	beq	a0,a5,8000198a <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000197c:	4785                	li	a5,1
    8000197e:	00f50963          	beq	a0,a5,80001990 <devintr+0x4c>
    return 1;
    80001982:	4505                	li	a0,1
    } else if(irq){
    80001984:	e889                	bnez	s1,80001996 <devintr+0x52>
    80001986:	64a2                	ld	s1,8(sp)
    80001988:	bff9                	j	80001966 <devintr+0x22>
      uartintr();
    8000198a:	4cb030ef          	jal	80005654 <uartintr>
    if(irq)
    8000198e:	a819                	j	800019a4 <devintr+0x60>
      virtio_disk_intr();
    80001990:	232030ef          	jal	80004bc2 <virtio_disk_intr>
    if(irq)
    80001994:	a801                	j	800019a4 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001996:	85a6                	mv	a1,s1
    80001998:	00006517          	auipc	a0,0x6
    8000199c:	90850513          	addi	a0,a0,-1784 # 800072a0 <etext+0x2a0>
    800019a0:	770030ef          	jal	80005110 <printf>
      plic_complete(irq);
    800019a4:	8526                	mv	a0,s1
    800019a6:	577020ef          	jal	8000471c <plic_complete>
    return 1;
    800019aa:	4505                	li	a0,1
    800019ac:	64a2                	ld	s1,8(sp)
    800019ae:	bf65                	j	80001966 <devintr+0x22>
    clockintr();
    800019b0:	f41ff0ef          	jal	800018f0 <clockintr>
    return 2;
    800019b4:	4509                	li	a0,2
    800019b6:	bf45                	j	80001966 <devintr+0x22>

00000000800019b8 <usertrap>:
{
    800019b8:	1101                	addi	sp,sp,-32
    800019ba:	ec06                	sd	ra,24(sp)
    800019bc:	e822                	sd	s0,16(sp)
    800019be:	e426                	sd	s1,8(sp)
    800019c0:	e04a                	sd	s2,0(sp)
    800019c2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019c8:	1007f793          	andi	a5,a5,256
    800019cc:	ef85                	bnez	a5,80001a04 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019ce:	00003797          	auipc	a5,0x3
    800019d2:	c8278793          	addi	a5,a5,-894 # 80004650 <kernelvec>
    800019d6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019da:	b7cff0ef          	jal	80000d56 <myproc>
    800019de:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019e0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019e2:	14102773          	csrr	a4,sepc
    800019e6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019e8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019ec:	47a1                	li	a5,8
    800019ee:	02f70163          	beq	a4,a5,80001a10 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019f2:	f53ff0ef          	jal	80001944 <devintr>
    800019f6:	892a                	mv	s2,a0
    800019f8:	c135                	beqz	a0,80001a5c <usertrap+0xa4>
  if(killed(p))
    800019fa:	8526                	mv	a0,s1
    800019fc:	b61ff0ef          	jal	8000155c <killed>
    80001a00:	cd1d                	beqz	a0,80001a3e <usertrap+0x86>
    80001a02:	a81d                	j	80001a38 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a04:	00006517          	auipc	a0,0x6
    80001a08:	8bc50513          	addi	a0,a0,-1860 # 800072c0 <etext+0x2c0>
    80001a0c:	1d7030ef          	jal	800053e2 <panic>
    if(killed(p))
    80001a10:	b4dff0ef          	jal	8000155c <killed>
    80001a14:	e121                	bnez	a0,80001a54 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a16:	6cb8                	ld	a4,88(s1)
    80001a18:	6f1c                	ld	a5,24(a4)
    80001a1a:	0791                	addi	a5,a5,4
    80001a1c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a22:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a26:	10079073          	csrw	sstatus,a5
    syscall();
    80001a2a:	248000ef          	jal	80001c72 <syscall>
  if(killed(p))
    80001a2e:	8526                	mv	a0,s1
    80001a30:	b2dff0ef          	jal	8000155c <killed>
    80001a34:	c901                	beqz	a0,80001a44 <usertrap+0x8c>
    80001a36:	4901                	li	s2,0
    exit(-1);
    80001a38:	557d                	li	a0,-1
    80001a3a:	9f7ff0ef          	jal	80001430 <exit>
  if(which_dev == 2)
    80001a3e:	4789                	li	a5,2
    80001a40:	04f90563          	beq	s2,a5,80001a8a <usertrap+0xd2>
  usertrapret();
    80001a44:	e1bff0ef          	jal	8000185e <usertrapret>
}
    80001a48:	60e2                	ld	ra,24(sp)
    80001a4a:	6442                	ld	s0,16(sp)
    80001a4c:	64a2                	ld	s1,8(sp)
    80001a4e:	6902                	ld	s2,0(sp)
    80001a50:	6105                	addi	sp,sp,32
    80001a52:	8082                	ret
      exit(-1);
    80001a54:	557d                	li	a0,-1
    80001a56:	9dbff0ef          	jal	80001430 <exit>
    80001a5a:	bf75                	j	80001a16 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a5c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a60:	5890                	lw	a2,48(s1)
    80001a62:	00006517          	auipc	a0,0x6
    80001a66:	87e50513          	addi	a0,a0,-1922 # 800072e0 <etext+0x2e0>
    80001a6a:	6a6030ef          	jal	80005110 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a6e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a72:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a76:	00006517          	auipc	a0,0x6
    80001a7a:	89a50513          	addi	a0,a0,-1894 # 80007310 <etext+0x310>
    80001a7e:	692030ef          	jal	80005110 <printf>
    setkilled(p);
    80001a82:	8526                	mv	a0,s1
    80001a84:	ab5ff0ef          	jal	80001538 <setkilled>
    80001a88:	b75d                	j	80001a2e <usertrap+0x76>
    yield();
    80001a8a:	86fff0ef          	jal	800012f8 <yield>
    80001a8e:	bf5d                	j	80001a44 <usertrap+0x8c>

0000000080001a90 <kerneltrap>:
{
    80001a90:	7179                	addi	sp,sp,-48
    80001a92:	f406                	sd	ra,40(sp)
    80001a94:	f022                	sd	s0,32(sp)
    80001a96:	ec26                	sd	s1,24(sp)
    80001a98:	e84a                	sd	s2,16(sp)
    80001a9a:	e44e                	sd	s3,8(sp)
    80001a9c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a9e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aa2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aaa:	1004f793          	andi	a5,s1,256
    80001aae:	c795                	beqz	a5,80001ada <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ab4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ab6:	eb85                	bnez	a5,80001ae6 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ab8:	e8dff0ef          	jal	80001944 <devintr>
    80001abc:	c91d                	beqz	a0,80001af2 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001abe:	4789                	li	a5,2
    80001ac0:	04f50a63          	beq	a0,a5,80001b14 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ac4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac8:	10049073          	csrw	sstatus,s1
}
    80001acc:	70a2                	ld	ra,40(sp)
    80001ace:	7402                	ld	s0,32(sp)
    80001ad0:	64e2                	ld	s1,24(sp)
    80001ad2:	6942                	ld	s2,16(sp)
    80001ad4:	69a2                	ld	s3,8(sp)
    80001ad6:	6145                	addi	sp,sp,48
    80001ad8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ada:	00006517          	auipc	a0,0x6
    80001ade:	85e50513          	addi	a0,a0,-1954 # 80007338 <etext+0x338>
    80001ae2:	101030ef          	jal	800053e2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ae6:	00006517          	auipc	a0,0x6
    80001aea:	87a50513          	addi	a0,a0,-1926 # 80007360 <etext+0x360>
    80001aee:	0f5030ef          	jal	800053e2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001afa:	85ce                	mv	a1,s3
    80001afc:	00006517          	auipc	a0,0x6
    80001b00:	88450513          	addi	a0,a0,-1916 # 80007380 <etext+0x380>
    80001b04:	60c030ef          	jal	80005110 <printf>
    panic("kerneltrap");
    80001b08:	00006517          	auipc	a0,0x6
    80001b0c:	8a050513          	addi	a0,a0,-1888 # 800073a8 <etext+0x3a8>
    80001b10:	0d3030ef          	jal	800053e2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b14:	a42ff0ef          	jal	80000d56 <myproc>
    80001b18:	d555                	beqz	a0,80001ac4 <kerneltrap+0x34>
    yield();
    80001b1a:	fdeff0ef          	jal	800012f8 <yield>
    80001b1e:	b75d                	j	80001ac4 <kerneltrap+0x34>

0000000080001b20 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b20:	1101                	addi	sp,sp,-32
    80001b22:	ec06                	sd	ra,24(sp)
    80001b24:	e822                	sd	s0,16(sp)
    80001b26:	e426                	sd	s1,8(sp)
    80001b28:	1000                	addi	s0,sp,32
    80001b2a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b2c:	a2aff0ef          	jal	80000d56 <myproc>
  switch (n) {
    80001b30:	4795                	li	a5,5
    80001b32:	0497e163          	bltu	a5,s1,80001b74 <argraw+0x54>
    80001b36:	048a                	slli	s1,s1,0x2
    80001b38:	00006717          	auipc	a4,0x6
    80001b3c:	c7870713          	addi	a4,a4,-904 # 800077b0 <states.0+0x30>
    80001b40:	94ba                	add	s1,s1,a4
    80001b42:	409c                	lw	a5,0(s1)
    80001b44:	97ba                	add	a5,a5,a4
    80001b46:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b48:	6d3c                	ld	a5,88(a0)
    80001b4a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b4c:	60e2                	ld	ra,24(sp)
    80001b4e:	6442                	ld	s0,16(sp)
    80001b50:	64a2                	ld	s1,8(sp)
    80001b52:	6105                	addi	sp,sp,32
    80001b54:	8082                	ret
    return p->trapframe->a1;
    80001b56:	6d3c                	ld	a5,88(a0)
    80001b58:	7fa8                	ld	a0,120(a5)
    80001b5a:	bfcd                	j	80001b4c <argraw+0x2c>
    return p->trapframe->a2;
    80001b5c:	6d3c                	ld	a5,88(a0)
    80001b5e:	63c8                	ld	a0,128(a5)
    80001b60:	b7f5                	j	80001b4c <argraw+0x2c>
    return p->trapframe->a3;
    80001b62:	6d3c                	ld	a5,88(a0)
    80001b64:	67c8                	ld	a0,136(a5)
    80001b66:	b7dd                	j	80001b4c <argraw+0x2c>
    return p->trapframe->a4;
    80001b68:	6d3c                	ld	a5,88(a0)
    80001b6a:	6bc8                	ld	a0,144(a5)
    80001b6c:	b7c5                	j	80001b4c <argraw+0x2c>
    return p->trapframe->a5;
    80001b6e:	6d3c                	ld	a5,88(a0)
    80001b70:	6fc8                	ld	a0,152(a5)
    80001b72:	bfe9                	j	80001b4c <argraw+0x2c>
  panic("argraw");
    80001b74:	00006517          	auipc	a0,0x6
    80001b78:	84450513          	addi	a0,a0,-1980 # 800073b8 <etext+0x3b8>
    80001b7c:	067030ef          	jal	800053e2 <panic>

0000000080001b80 <fetchaddr>:
{
    80001b80:	1101                	addi	sp,sp,-32
    80001b82:	ec06                	sd	ra,24(sp)
    80001b84:	e822                	sd	s0,16(sp)
    80001b86:	e426                	sd	s1,8(sp)
    80001b88:	e04a                	sd	s2,0(sp)
    80001b8a:	1000                	addi	s0,sp,32
    80001b8c:	84aa                	mv	s1,a0
    80001b8e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b90:	9c6ff0ef          	jal	80000d56 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b94:	653c                	ld	a5,72(a0)
    80001b96:	02f4f663          	bgeu	s1,a5,80001bc2 <fetchaddr+0x42>
    80001b9a:	00848713          	addi	a4,s1,8
    80001b9e:	02e7e463          	bltu	a5,a4,80001bc6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ba2:	46a1                	li	a3,8
    80001ba4:	8626                	mv	a2,s1
    80001ba6:	85ca                	mv	a1,s2
    80001ba8:	6928                	ld	a0,80(a0)
    80001baa:	ef5fe0ef          	jal	80000a9e <copyin>
    80001bae:	00a03533          	snez	a0,a0
    80001bb2:	40a00533          	neg	a0,a0
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6902                	ld	s2,0(sp)
    80001bbe:	6105                	addi	sp,sp,32
    80001bc0:	8082                	ret
    return -1;
    80001bc2:	557d                	li	a0,-1
    80001bc4:	bfcd                	j	80001bb6 <fetchaddr+0x36>
    80001bc6:	557d                	li	a0,-1
    80001bc8:	b7fd                	j	80001bb6 <fetchaddr+0x36>

0000000080001bca <fetchstr>:
{
    80001bca:	7179                	addi	sp,sp,-48
    80001bcc:	f406                	sd	ra,40(sp)
    80001bce:	f022                	sd	s0,32(sp)
    80001bd0:	ec26                	sd	s1,24(sp)
    80001bd2:	e84a                	sd	s2,16(sp)
    80001bd4:	e44e                	sd	s3,8(sp)
    80001bd6:	1800                	addi	s0,sp,48
    80001bd8:	892a                	mv	s2,a0
    80001bda:	84ae                	mv	s1,a1
    80001bdc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bde:	978ff0ef          	jal	80000d56 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001be2:	86ce                	mv	a3,s3
    80001be4:	864a                	mv	a2,s2
    80001be6:	85a6                	mv	a1,s1
    80001be8:	6928                	ld	a0,80(a0)
    80001bea:	f3bfe0ef          	jal	80000b24 <copyinstr>
    80001bee:	00054c63          	bltz	a0,80001c06 <fetchstr+0x3c>
  return strlen(buf);
    80001bf2:	8526                	mv	a0,s1
    80001bf4:	eb0fe0ef          	jal	800002a4 <strlen>
}
    80001bf8:	70a2                	ld	ra,40(sp)
    80001bfa:	7402                	ld	s0,32(sp)
    80001bfc:	64e2                	ld	s1,24(sp)
    80001bfe:	6942                	ld	s2,16(sp)
    80001c00:	69a2                	ld	s3,8(sp)
    80001c02:	6145                	addi	sp,sp,48
    80001c04:	8082                	ret
    return -1;
    80001c06:	557d                	li	a0,-1
    80001c08:	bfc5                	j	80001bf8 <fetchstr+0x2e>

0000000080001c0a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c0a:	1101                	addi	sp,sp,-32
    80001c0c:	ec06                	sd	ra,24(sp)
    80001c0e:	e822                	sd	s0,16(sp)
    80001c10:	e426                	sd	s1,8(sp)
    80001c12:	1000                	addi	s0,sp,32
    80001c14:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c16:	f0bff0ef          	jal	80001b20 <argraw>
    80001c1a:	c088                	sw	a0,0(s1)
}
    80001c1c:	60e2                	ld	ra,24(sp)
    80001c1e:	6442                	ld	s0,16(sp)
    80001c20:	64a2                	ld	s1,8(sp)
    80001c22:	6105                	addi	sp,sp,32
    80001c24:	8082                	ret

0000000080001c26 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c26:	1101                	addi	sp,sp,-32
    80001c28:	ec06                	sd	ra,24(sp)
    80001c2a:	e822                	sd	s0,16(sp)
    80001c2c:	e426                	sd	s1,8(sp)
    80001c2e:	1000                	addi	s0,sp,32
    80001c30:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c32:	eefff0ef          	jal	80001b20 <argraw>
    80001c36:	e088                	sd	a0,0(s1)
}
    80001c38:	60e2                	ld	ra,24(sp)
    80001c3a:	6442                	ld	s0,16(sp)
    80001c3c:	64a2                	ld	s1,8(sp)
    80001c3e:	6105                	addi	sp,sp,32
    80001c40:	8082                	ret

0000000080001c42 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c42:	7179                	addi	sp,sp,-48
    80001c44:	f406                	sd	ra,40(sp)
    80001c46:	f022                	sd	s0,32(sp)
    80001c48:	ec26                	sd	s1,24(sp)
    80001c4a:	e84a                	sd	s2,16(sp)
    80001c4c:	1800                	addi	s0,sp,48
    80001c4e:	84ae                	mv	s1,a1
    80001c50:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c52:	fd840593          	addi	a1,s0,-40
    80001c56:	fd1ff0ef          	jal	80001c26 <argaddr>
  return fetchstr(addr, buf, max);
    80001c5a:	864a                	mv	a2,s2
    80001c5c:	85a6                	mv	a1,s1
    80001c5e:	fd843503          	ld	a0,-40(s0)
    80001c62:	f69ff0ef          	jal	80001bca <fetchstr>
}
    80001c66:	70a2                	ld	ra,40(sp)
    80001c68:	7402                	ld	s0,32(sp)
    80001c6a:	64e2                	ld	s1,24(sp)
    80001c6c:	6942                	ld	s2,16(sp)
    80001c6e:	6145                	addi	sp,sp,48
    80001c70:	8082                	ret

0000000080001c72 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c72:	1101                	addi	sp,sp,-32
    80001c74:	ec06                	sd	ra,24(sp)
    80001c76:	e822                	sd	s0,16(sp)
    80001c78:	e426                	sd	s1,8(sp)
    80001c7a:	e04a                	sd	s2,0(sp)
    80001c7c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c7e:	8d8ff0ef          	jal	80000d56 <myproc>
    80001c82:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c84:	05853903          	ld	s2,88(a0)
    80001c88:	0a893783          	ld	a5,168(s2)
    80001c8c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c90:	37fd                	addiw	a5,a5,-1
    80001c92:	4751                	li	a4,20
    80001c94:	00f76f63          	bltu	a4,a5,80001cb2 <syscall+0x40>
    80001c98:	00369713          	slli	a4,a3,0x3
    80001c9c:	00006797          	auipc	a5,0x6
    80001ca0:	b2c78793          	addi	a5,a5,-1236 # 800077c8 <syscalls>
    80001ca4:	97ba                	add	a5,a5,a4
    80001ca6:	639c                	ld	a5,0(a5)
    80001ca8:	c789                	beqz	a5,80001cb2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001caa:	9782                	jalr	a5
    80001cac:	06a93823          	sd	a0,112(s2)
    80001cb0:	a829                	j	80001cca <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001cb2:	15848613          	addi	a2,s1,344
    80001cb6:	588c                	lw	a1,48(s1)
    80001cb8:	00005517          	auipc	a0,0x5
    80001cbc:	70850513          	addi	a0,a0,1800 # 800073c0 <etext+0x3c0>
    80001cc0:	450030ef          	jal	80005110 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cc4:	6cbc                	ld	a5,88(s1)
    80001cc6:	577d                	li	a4,-1
    80001cc8:	fbb8                	sd	a4,112(a5)
  }
}
    80001cca:	60e2                	ld	ra,24(sp)
    80001ccc:	6442                	ld	s0,16(sp)
    80001cce:	64a2                	ld	s1,8(sp)
    80001cd0:	6902                	ld	s2,0(sp)
    80001cd2:	6105                	addi	sp,sp,32
    80001cd4:	8082                	ret

0000000080001cd6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001cd6:	1101                	addi	sp,sp,-32
    80001cd8:	ec06                	sd	ra,24(sp)
    80001cda:	e822                	sd	s0,16(sp)
    80001cdc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cde:	fec40593          	addi	a1,s0,-20
    80001ce2:	4501                	li	a0,0
    80001ce4:	f27ff0ef          	jal	80001c0a <argint>
  exit(n);
    80001ce8:	fec42503          	lw	a0,-20(s0)
    80001cec:	f44ff0ef          	jal	80001430 <exit>
  return 0;  // not reached
}
    80001cf0:	4501                	li	a0,0
    80001cf2:	60e2                	ld	ra,24(sp)
    80001cf4:	6442                	ld	s0,16(sp)
    80001cf6:	6105                	addi	sp,sp,32
    80001cf8:	8082                	ret

0000000080001cfa <sys_getpid>:

uint64
sys_getpid(void)
{
    80001cfa:	1141                	addi	sp,sp,-16
    80001cfc:	e406                	sd	ra,8(sp)
    80001cfe:	e022                	sd	s0,0(sp)
    80001d00:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d02:	854ff0ef          	jal	80000d56 <myproc>
}
    80001d06:	5908                	lw	a0,48(a0)
    80001d08:	60a2                	ld	ra,8(sp)
    80001d0a:	6402                	ld	s0,0(sp)
    80001d0c:	0141                	addi	sp,sp,16
    80001d0e:	8082                	ret

0000000080001d10 <sys_fork>:

uint64
sys_fork(void)
{
    80001d10:	1141                	addi	sp,sp,-16
    80001d12:	e406                	sd	ra,8(sp)
    80001d14:	e022                	sd	s0,0(sp)
    80001d16:	0800                	addi	s0,sp,16
  return fork();
    80001d18:	b64ff0ef          	jal	8000107c <fork>
}
    80001d1c:	60a2                	ld	ra,8(sp)
    80001d1e:	6402                	ld	s0,0(sp)
    80001d20:	0141                	addi	sp,sp,16
    80001d22:	8082                	ret

0000000080001d24 <sys_wait>:

uint64
sys_wait(void)
{
    80001d24:	1101                	addi	sp,sp,-32
    80001d26:	ec06                	sd	ra,24(sp)
    80001d28:	e822                	sd	s0,16(sp)
    80001d2a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d2c:	fe840593          	addi	a1,s0,-24
    80001d30:	4501                	li	a0,0
    80001d32:	ef5ff0ef          	jal	80001c26 <argaddr>
  return wait(p);
    80001d36:	fe843503          	ld	a0,-24(s0)
    80001d3a:	84dff0ef          	jal	80001586 <wait>
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	6105                	addi	sp,sp,32
    80001d44:	8082                	ret

0000000080001d46 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d46:	7179                	addi	sp,sp,-48
    80001d48:	f406                	sd	ra,40(sp)
    80001d4a:	f022                	sd	s0,32(sp)
    80001d4c:	ec26                	sd	s1,24(sp)
    80001d4e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d50:	fdc40593          	addi	a1,s0,-36
    80001d54:	4501                	li	a0,0
    80001d56:	eb5ff0ef          	jal	80001c0a <argint>
  addr = myproc()->sz;
    80001d5a:	ffdfe0ef          	jal	80000d56 <myproc>
    80001d5e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d60:	fdc42503          	lw	a0,-36(s0)
    80001d64:	ac8ff0ef          	jal	8000102c <growproc>
    80001d68:	00054863          	bltz	a0,80001d78 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	70a2                	ld	ra,40(sp)
    80001d70:	7402                	ld	s0,32(sp)
    80001d72:	64e2                	ld	s1,24(sp)
    80001d74:	6145                	addi	sp,sp,48
    80001d76:	8082                	ret
    return -1;
    80001d78:	54fd                	li	s1,-1
    80001d7a:	bfcd                	j	80001d6c <sys_sbrk+0x26>

0000000080001d7c <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d7c:	7139                	addi	sp,sp,-64
    80001d7e:	fc06                	sd	ra,56(sp)
    80001d80:	f822                	sd	s0,48(sp)
    80001d82:	f04a                	sd	s2,32(sp)
    80001d84:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d86:	fcc40593          	addi	a1,s0,-52
    80001d8a:	4501                	li	a0,0
    80001d8c:	e7fff0ef          	jal	80001c0a <argint>
  if(n < 0)
    80001d90:	fcc42783          	lw	a5,-52(s0)
    80001d94:	0607c763          	bltz	a5,80001e02 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d98:	0000e517          	auipc	a0,0xe
    80001d9c:	2d850513          	addi	a0,a0,728 # 80010070 <tickslock>
    80001da0:	171030ef          	jal	80005710 <acquire>
  ticks0 = ticks;
    80001da4:	00008917          	auipc	s2,0x8
    80001da8:	46492903          	lw	s2,1124(s2) # 8000a208 <ticks>
  while(ticks - ticks0 < n){
    80001dac:	fcc42783          	lw	a5,-52(s0)
    80001db0:	cf8d                	beqz	a5,80001dea <sys_sleep+0x6e>
    80001db2:	f426                	sd	s1,40(sp)
    80001db4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001db6:	0000e997          	auipc	s3,0xe
    80001dba:	2ba98993          	addi	s3,s3,698 # 80010070 <tickslock>
    80001dbe:	00008497          	auipc	s1,0x8
    80001dc2:	44a48493          	addi	s1,s1,1098 # 8000a208 <ticks>
    if(killed(myproc())){
    80001dc6:	f91fe0ef          	jal	80000d56 <myproc>
    80001dca:	f92ff0ef          	jal	8000155c <killed>
    80001dce:	ed0d                	bnez	a0,80001e08 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001dd0:	85ce                	mv	a1,s3
    80001dd2:	8526                	mv	a0,s1
    80001dd4:	d50ff0ef          	jal	80001324 <sleep>
  while(ticks - ticks0 < n){
    80001dd8:	409c                	lw	a5,0(s1)
    80001dda:	412787bb          	subw	a5,a5,s2
    80001dde:	fcc42703          	lw	a4,-52(s0)
    80001de2:	fee7e2e3          	bltu	a5,a4,80001dc6 <sys_sleep+0x4a>
    80001de6:	74a2                	ld	s1,40(sp)
    80001de8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001dea:	0000e517          	auipc	a0,0xe
    80001dee:	28650513          	addi	a0,a0,646 # 80010070 <tickslock>
    80001df2:	1b7030ef          	jal	800057a8 <release>
  return 0;
    80001df6:	4501                	li	a0,0
}
    80001df8:	70e2                	ld	ra,56(sp)
    80001dfa:	7442                	ld	s0,48(sp)
    80001dfc:	7902                	ld	s2,32(sp)
    80001dfe:	6121                	addi	sp,sp,64
    80001e00:	8082                	ret
    n = 0;
    80001e02:	fc042623          	sw	zero,-52(s0)
    80001e06:	bf49                	j	80001d98 <sys_sleep+0x1c>
      release(&tickslock);
    80001e08:	0000e517          	auipc	a0,0xe
    80001e0c:	26850513          	addi	a0,a0,616 # 80010070 <tickslock>
    80001e10:	199030ef          	jal	800057a8 <release>
      return -1;
    80001e14:	557d                	li	a0,-1
    80001e16:	74a2                	ld	s1,40(sp)
    80001e18:	69e2                	ld	s3,24(sp)
    80001e1a:	bff9                	j	80001df8 <sys_sleep+0x7c>

0000000080001e1c <sys_kill>:

uint64
sys_kill(void)
{
    80001e1c:	1101                	addi	sp,sp,-32
    80001e1e:	ec06                	sd	ra,24(sp)
    80001e20:	e822                	sd	s0,16(sp)
    80001e22:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e24:	fec40593          	addi	a1,s0,-20
    80001e28:	4501                	li	a0,0
    80001e2a:	de1ff0ef          	jal	80001c0a <argint>
  return kill(pid);
    80001e2e:	fec42503          	lw	a0,-20(s0)
    80001e32:	ea0ff0ef          	jal	800014d2 <kill>
}
    80001e36:	60e2                	ld	ra,24(sp)
    80001e38:	6442                	ld	s0,16(sp)
    80001e3a:	6105                	addi	sp,sp,32
    80001e3c:	8082                	ret

0000000080001e3e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e3e:	1101                	addi	sp,sp,-32
    80001e40:	ec06                	sd	ra,24(sp)
    80001e42:	e822                	sd	s0,16(sp)
    80001e44:	e426                	sd	s1,8(sp)
    80001e46:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e48:	0000e517          	auipc	a0,0xe
    80001e4c:	22850513          	addi	a0,a0,552 # 80010070 <tickslock>
    80001e50:	0c1030ef          	jal	80005710 <acquire>
  xticks = ticks;
    80001e54:	00008497          	auipc	s1,0x8
    80001e58:	3b44a483          	lw	s1,948(s1) # 8000a208 <ticks>
  release(&tickslock);
    80001e5c:	0000e517          	auipc	a0,0xe
    80001e60:	21450513          	addi	a0,a0,532 # 80010070 <tickslock>
    80001e64:	145030ef          	jal	800057a8 <release>
  return xticks;
}
    80001e68:	02049513          	slli	a0,s1,0x20
    80001e6c:	9101                	srli	a0,a0,0x20
    80001e6e:	60e2                	ld	ra,24(sp)
    80001e70:	6442                	ld	s0,16(sp)
    80001e72:	64a2                	ld	s1,8(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret

0000000080001e78 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e78:	7179                	addi	sp,sp,-48
    80001e7a:	f406                	sd	ra,40(sp)
    80001e7c:	f022                	sd	s0,32(sp)
    80001e7e:	ec26                	sd	s1,24(sp)
    80001e80:	e84a                	sd	s2,16(sp)
    80001e82:	e44e                	sd	s3,8(sp)
    80001e84:	e052                	sd	s4,0(sp)
    80001e86:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e88:	00005597          	auipc	a1,0x5
    80001e8c:	55858593          	addi	a1,a1,1368 # 800073e0 <etext+0x3e0>
    80001e90:	0000e517          	auipc	a0,0xe
    80001e94:	1f850513          	addi	a0,a0,504 # 80010088 <bcache>
    80001e98:	7f8030ef          	jal	80005690 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e9c:	00016797          	auipc	a5,0x16
    80001ea0:	1ec78793          	addi	a5,a5,492 # 80018088 <bcache+0x8000>
    80001ea4:	00016717          	auipc	a4,0x16
    80001ea8:	44c70713          	addi	a4,a4,1100 # 800182f0 <bcache+0x8268>
    80001eac:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001eb0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001eb4:	0000e497          	auipc	s1,0xe
    80001eb8:	1ec48493          	addi	s1,s1,492 # 800100a0 <bcache+0x18>
    b->next = bcache.head.next;
    80001ebc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001ebe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001ec0:	00005a17          	auipc	s4,0x5
    80001ec4:	528a0a13          	addi	s4,s4,1320 # 800073e8 <etext+0x3e8>
    b->next = bcache.head.next;
    80001ec8:	2b893783          	ld	a5,696(s2)
    80001ecc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ece:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ed2:	85d2                	mv	a1,s4
    80001ed4:	01048513          	addi	a0,s1,16
    80001ed8:	248010ef          	jal	80003120 <initsleeplock>
    bcache.head.next->prev = b;
    80001edc:	2b893783          	ld	a5,696(s2)
    80001ee0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ee2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ee6:	45848493          	addi	s1,s1,1112
    80001eea:	fd349fe3          	bne	s1,s3,80001ec8 <binit+0x50>
  }
}
    80001eee:	70a2                	ld	ra,40(sp)
    80001ef0:	7402                	ld	s0,32(sp)
    80001ef2:	64e2                	ld	s1,24(sp)
    80001ef4:	6942                	ld	s2,16(sp)
    80001ef6:	69a2                	ld	s3,8(sp)
    80001ef8:	6a02                	ld	s4,0(sp)
    80001efa:	6145                	addi	sp,sp,48
    80001efc:	8082                	ret

0000000080001efe <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001efe:	7179                	addi	sp,sp,-48
    80001f00:	f406                	sd	ra,40(sp)
    80001f02:	f022                	sd	s0,32(sp)
    80001f04:	ec26                	sd	s1,24(sp)
    80001f06:	e84a                	sd	s2,16(sp)
    80001f08:	e44e                	sd	s3,8(sp)
    80001f0a:	1800                	addi	s0,sp,48
    80001f0c:	892a                	mv	s2,a0
    80001f0e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f10:	0000e517          	auipc	a0,0xe
    80001f14:	17850513          	addi	a0,a0,376 # 80010088 <bcache>
    80001f18:	7f8030ef          	jal	80005710 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f1c:	00016497          	auipc	s1,0x16
    80001f20:	4244b483          	ld	s1,1060(s1) # 80018340 <bcache+0x82b8>
    80001f24:	00016797          	auipc	a5,0x16
    80001f28:	3cc78793          	addi	a5,a5,972 # 800182f0 <bcache+0x8268>
    80001f2c:	02f48b63          	beq	s1,a5,80001f62 <bread+0x64>
    80001f30:	873e                	mv	a4,a5
    80001f32:	a021                	j	80001f3a <bread+0x3c>
    80001f34:	68a4                	ld	s1,80(s1)
    80001f36:	02e48663          	beq	s1,a4,80001f62 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f3a:	449c                	lw	a5,8(s1)
    80001f3c:	ff279ce3          	bne	a5,s2,80001f34 <bread+0x36>
    80001f40:	44dc                	lw	a5,12(s1)
    80001f42:	ff3799e3          	bne	a5,s3,80001f34 <bread+0x36>
      b->refcnt++;
    80001f46:	40bc                	lw	a5,64(s1)
    80001f48:	2785                	addiw	a5,a5,1
    80001f4a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f4c:	0000e517          	auipc	a0,0xe
    80001f50:	13c50513          	addi	a0,a0,316 # 80010088 <bcache>
    80001f54:	055030ef          	jal	800057a8 <release>
      acquiresleep(&b->lock);
    80001f58:	01048513          	addi	a0,s1,16
    80001f5c:	1fa010ef          	jal	80003156 <acquiresleep>
      return b;
    80001f60:	a889                	j	80001fb2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f62:	00016497          	auipc	s1,0x16
    80001f66:	3d64b483          	ld	s1,982(s1) # 80018338 <bcache+0x82b0>
    80001f6a:	00016797          	auipc	a5,0x16
    80001f6e:	38678793          	addi	a5,a5,902 # 800182f0 <bcache+0x8268>
    80001f72:	00f48863          	beq	s1,a5,80001f82 <bread+0x84>
    80001f76:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f78:	40bc                	lw	a5,64(s1)
    80001f7a:	cb91                	beqz	a5,80001f8e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f7c:	64a4                	ld	s1,72(s1)
    80001f7e:	fee49de3          	bne	s1,a4,80001f78 <bread+0x7a>
  panic("bget: no buffers");
    80001f82:	00005517          	auipc	a0,0x5
    80001f86:	46e50513          	addi	a0,a0,1134 # 800073f0 <etext+0x3f0>
    80001f8a:	458030ef          	jal	800053e2 <panic>
      b->dev = dev;
    80001f8e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f92:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001f96:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f9a:	4785                	li	a5,1
    80001f9c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f9e:	0000e517          	auipc	a0,0xe
    80001fa2:	0ea50513          	addi	a0,a0,234 # 80010088 <bcache>
    80001fa6:	003030ef          	jal	800057a8 <release>
      acquiresleep(&b->lock);
    80001faa:	01048513          	addi	a0,s1,16
    80001fae:	1a8010ef          	jal	80003156 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fb2:	409c                	lw	a5,0(s1)
    80001fb4:	cb89                	beqz	a5,80001fc6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	70a2                	ld	ra,40(sp)
    80001fba:	7402                	ld	s0,32(sp)
    80001fbc:	64e2                	ld	s1,24(sp)
    80001fbe:	6942                	ld	s2,16(sp)
    80001fc0:	69a2                	ld	s3,8(sp)
    80001fc2:	6145                	addi	sp,sp,48
    80001fc4:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fc6:	4581                	li	a1,0
    80001fc8:	8526                	mv	a0,s1
    80001fca:	1e7020ef          	jal	800049b0 <virtio_disk_rw>
    b->valid = 1;
    80001fce:	4785                	li	a5,1
    80001fd0:	c09c                	sw	a5,0(s1)
  return b;
    80001fd2:	b7d5                	j	80001fb6 <bread+0xb8>

0000000080001fd4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	e426                	sd	s1,8(sp)
    80001fdc:	1000                	addi	s0,sp,32
    80001fde:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fe0:	0541                	addi	a0,a0,16
    80001fe2:	1f2010ef          	jal	800031d4 <holdingsleep>
    80001fe6:	c911                	beqz	a0,80001ffa <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001fe8:	4585                	li	a1,1
    80001fea:	8526                	mv	a0,s1
    80001fec:	1c5020ef          	jal	800049b0 <virtio_disk_rw>
}
    80001ff0:	60e2                	ld	ra,24(sp)
    80001ff2:	6442                	ld	s0,16(sp)
    80001ff4:	64a2                	ld	s1,8(sp)
    80001ff6:	6105                	addi	sp,sp,32
    80001ff8:	8082                	ret
    panic("bwrite");
    80001ffa:	00005517          	auipc	a0,0x5
    80001ffe:	40e50513          	addi	a0,a0,1038 # 80007408 <etext+0x408>
    80002002:	3e0030ef          	jal	800053e2 <panic>

0000000080002006 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002006:	1101                	addi	sp,sp,-32
    80002008:	ec06                	sd	ra,24(sp)
    8000200a:	e822                	sd	s0,16(sp)
    8000200c:	e426                	sd	s1,8(sp)
    8000200e:	e04a                	sd	s2,0(sp)
    80002010:	1000                	addi	s0,sp,32
    80002012:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002014:	01050913          	addi	s2,a0,16
    80002018:	854a                	mv	a0,s2
    8000201a:	1ba010ef          	jal	800031d4 <holdingsleep>
    8000201e:	c135                	beqz	a0,80002082 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002020:	854a                	mv	a0,s2
    80002022:	17a010ef          	jal	8000319c <releasesleep>

  acquire(&bcache.lock);
    80002026:	0000e517          	auipc	a0,0xe
    8000202a:	06250513          	addi	a0,a0,98 # 80010088 <bcache>
    8000202e:	6e2030ef          	jal	80005710 <acquire>
  b->refcnt--;
    80002032:	40bc                	lw	a5,64(s1)
    80002034:	37fd                	addiw	a5,a5,-1
    80002036:	0007871b          	sext.w	a4,a5
    8000203a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000203c:	e71d                	bnez	a4,8000206a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000203e:	68b8                	ld	a4,80(s1)
    80002040:	64bc                	ld	a5,72(s1)
    80002042:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002044:	68b8                	ld	a4,80(s1)
    80002046:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002048:	00016797          	auipc	a5,0x16
    8000204c:	04078793          	addi	a5,a5,64 # 80018088 <bcache+0x8000>
    80002050:	2b87b703          	ld	a4,696(a5)
    80002054:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002056:	00016717          	auipc	a4,0x16
    8000205a:	29a70713          	addi	a4,a4,666 # 800182f0 <bcache+0x8268>
    8000205e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002060:	2b87b703          	ld	a4,696(a5)
    80002064:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002066:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000206a:	0000e517          	auipc	a0,0xe
    8000206e:	01e50513          	addi	a0,a0,30 # 80010088 <bcache>
    80002072:	736030ef          	jal	800057a8 <release>
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6902                	ld	s2,0(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret
    panic("brelse");
    80002082:	00005517          	auipc	a0,0x5
    80002086:	38e50513          	addi	a0,a0,910 # 80007410 <etext+0x410>
    8000208a:	358030ef          	jal	800053e2 <panic>

000000008000208e <bpin>:

void
bpin(struct buf *b) {
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	e426                	sd	s1,8(sp)
    80002096:	1000                	addi	s0,sp,32
    80002098:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000209a:	0000e517          	auipc	a0,0xe
    8000209e:	fee50513          	addi	a0,a0,-18 # 80010088 <bcache>
    800020a2:	66e030ef          	jal	80005710 <acquire>
  b->refcnt++;
    800020a6:	40bc                	lw	a5,64(s1)
    800020a8:	2785                	addiw	a5,a5,1
    800020aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020ac:	0000e517          	auipc	a0,0xe
    800020b0:	fdc50513          	addi	a0,a0,-36 # 80010088 <bcache>
    800020b4:	6f4030ef          	jal	800057a8 <release>
}
    800020b8:	60e2                	ld	ra,24(sp)
    800020ba:	6442                	ld	s0,16(sp)
    800020bc:	64a2                	ld	s1,8(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret

00000000800020c2 <bunpin>:

void
bunpin(struct buf *b) {
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	e426                	sd	s1,8(sp)
    800020ca:	1000                	addi	s0,sp,32
    800020cc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020ce:	0000e517          	auipc	a0,0xe
    800020d2:	fba50513          	addi	a0,a0,-70 # 80010088 <bcache>
    800020d6:	63a030ef          	jal	80005710 <acquire>
  b->refcnt--;
    800020da:	40bc                	lw	a5,64(s1)
    800020dc:	37fd                	addiw	a5,a5,-1
    800020de:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020e0:	0000e517          	auipc	a0,0xe
    800020e4:	fa850513          	addi	a0,a0,-88 # 80010088 <bcache>
    800020e8:	6c0030ef          	jal	800057a8 <release>
}
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret

00000000800020f6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	e04a                	sd	s2,0(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002104:	00d5d59b          	srliw	a1,a1,0xd
    80002108:	00016797          	auipc	a5,0x16
    8000210c:	65c7a783          	lw	a5,1628(a5) # 80018764 <sb+0x1c>
    80002110:	9dbd                	addw	a1,a1,a5
    80002112:	dedff0ef          	jal	80001efe <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002116:	0074f713          	andi	a4,s1,7
    8000211a:	4785                	li	a5,1
    8000211c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002120:	14ce                	slli	s1,s1,0x33
    80002122:	90d9                	srli	s1,s1,0x36
    80002124:	00950733          	add	a4,a0,s1
    80002128:	05874703          	lbu	a4,88(a4)
    8000212c:	00e7f6b3          	and	a3,a5,a4
    80002130:	c29d                	beqz	a3,80002156 <bfree+0x60>
    80002132:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002134:	94aa                	add	s1,s1,a0
    80002136:	fff7c793          	not	a5,a5
    8000213a:	8f7d                	and	a4,a4,a5
    8000213c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002140:	711000ef          	jal	80003050 <log_write>
  brelse(bp);
    80002144:	854a                	mv	a0,s2
    80002146:	ec1ff0ef          	jal	80002006 <brelse>
}
    8000214a:	60e2                	ld	ra,24(sp)
    8000214c:	6442                	ld	s0,16(sp)
    8000214e:	64a2                	ld	s1,8(sp)
    80002150:	6902                	ld	s2,0(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret
    panic("freeing free block");
    80002156:	00005517          	auipc	a0,0x5
    8000215a:	2c250513          	addi	a0,a0,706 # 80007418 <etext+0x418>
    8000215e:	284030ef          	jal	800053e2 <panic>

0000000080002162 <balloc>:
{
    80002162:	711d                	addi	sp,sp,-96
    80002164:	ec86                	sd	ra,88(sp)
    80002166:	e8a2                	sd	s0,80(sp)
    80002168:	e4a6                	sd	s1,72(sp)
    8000216a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000216c:	00016797          	auipc	a5,0x16
    80002170:	5e07a783          	lw	a5,1504(a5) # 8001874c <sb+0x4>
    80002174:	0e078f63          	beqz	a5,80002272 <balloc+0x110>
    80002178:	e0ca                	sd	s2,64(sp)
    8000217a:	fc4e                	sd	s3,56(sp)
    8000217c:	f852                	sd	s4,48(sp)
    8000217e:	f456                	sd	s5,40(sp)
    80002180:	f05a                	sd	s6,32(sp)
    80002182:	ec5e                	sd	s7,24(sp)
    80002184:	e862                	sd	s8,16(sp)
    80002186:	e466                	sd	s9,8(sp)
    80002188:	8baa                	mv	s7,a0
    8000218a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000218c:	00016b17          	auipc	s6,0x16
    80002190:	5bcb0b13          	addi	s6,s6,1468 # 80018748 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002194:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002196:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002198:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000219a:	6c89                	lui	s9,0x2
    8000219c:	a0b5                	j	80002208 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000219e:	97ca                	add	a5,a5,s2
    800021a0:	8e55                	or	a2,a2,a3
    800021a2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800021a6:	854a                	mv	a0,s2
    800021a8:	6a9000ef          	jal	80003050 <log_write>
        brelse(bp);
    800021ac:	854a                	mv	a0,s2
    800021ae:	e59ff0ef          	jal	80002006 <brelse>
  bp = bread(dev, bno);
    800021b2:	85a6                	mv	a1,s1
    800021b4:	855e                	mv	a0,s7
    800021b6:	d49ff0ef          	jal	80001efe <bread>
    800021ba:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021bc:	40000613          	li	a2,1024
    800021c0:	4581                	li	a1,0
    800021c2:	05850513          	addi	a0,a0,88
    800021c6:	f6ffd0ef          	jal	80000134 <memset>
  log_write(bp);
    800021ca:	854a                	mv	a0,s2
    800021cc:	685000ef          	jal	80003050 <log_write>
  brelse(bp);
    800021d0:	854a                	mv	a0,s2
    800021d2:	e35ff0ef          	jal	80002006 <brelse>
}
    800021d6:	6906                	ld	s2,64(sp)
    800021d8:	79e2                	ld	s3,56(sp)
    800021da:	7a42                	ld	s4,48(sp)
    800021dc:	7aa2                	ld	s5,40(sp)
    800021de:	7b02                	ld	s6,32(sp)
    800021e0:	6be2                	ld	s7,24(sp)
    800021e2:	6c42                	ld	s8,16(sp)
    800021e4:	6ca2                	ld	s9,8(sp)
}
    800021e6:	8526                	mv	a0,s1
    800021e8:	60e6                	ld	ra,88(sp)
    800021ea:	6446                	ld	s0,80(sp)
    800021ec:	64a6                	ld	s1,72(sp)
    800021ee:	6125                	addi	sp,sp,96
    800021f0:	8082                	ret
    brelse(bp);
    800021f2:	854a                	mv	a0,s2
    800021f4:	e13ff0ef          	jal	80002006 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021f8:	015c87bb          	addw	a5,s9,s5
    800021fc:	00078a9b          	sext.w	s5,a5
    80002200:	004b2703          	lw	a4,4(s6)
    80002204:	04eaff63          	bgeu	s5,a4,80002262 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002208:	41fad79b          	sraiw	a5,s5,0x1f
    8000220c:	0137d79b          	srliw	a5,a5,0x13
    80002210:	015787bb          	addw	a5,a5,s5
    80002214:	40d7d79b          	sraiw	a5,a5,0xd
    80002218:	01cb2583          	lw	a1,28(s6)
    8000221c:	9dbd                	addw	a1,a1,a5
    8000221e:	855e                	mv	a0,s7
    80002220:	cdfff0ef          	jal	80001efe <bread>
    80002224:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002226:	004b2503          	lw	a0,4(s6)
    8000222a:	000a849b          	sext.w	s1,s5
    8000222e:	8762                	mv	a4,s8
    80002230:	fca4f1e3          	bgeu	s1,a0,800021f2 <balloc+0x90>
      m = 1 << (bi % 8);
    80002234:	00777693          	andi	a3,a4,7
    80002238:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000223c:	41f7579b          	sraiw	a5,a4,0x1f
    80002240:	01d7d79b          	srliw	a5,a5,0x1d
    80002244:	9fb9                	addw	a5,a5,a4
    80002246:	4037d79b          	sraiw	a5,a5,0x3
    8000224a:	00f90633          	add	a2,s2,a5
    8000224e:	05864603          	lbu	a2,88(a2)
    80002252:	00c6f5b3          	and	a1,a3,a2
    80002256:	d5a1                	beqz	a1,8000219e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002258:	2705                	addiw	a4,a4,1
    8000225a:	2485                	addiw	s1,s1,1
    8000225c:	fd471ae3          	bne	a4,s4,80002230 <balloc+0xce>
    80002260:	bf49                	j	800021f2 <balloc+0x90>
    80002262:	6906                	ld	s2,64(sp)
    80002264:	79e2                	ld	s3,56(sp)
    80002266:	7a42                	ld	s4,48(sp)
    80002268:	7aa2                	ld	s5,40(sp)
    8000226a:	7b02                	ld	s6,32(sp)
    8000226c:	6be2                	ld	s7,24(sp)
    8000226e:	6c42                	ld	s8,16(sp)
    80002270:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002272:	00005517          	auipc	a0,0x5
    80002276:	1be50513          	addi	a0,a0,446 # 80007430 <etext+0x430>
    8000227a:	697020ef          	jal	80005110 <printf>
  return 0;
    8000227e:	4481                	li	s1,0
    80002280:	b79d                	j	800021e6 <balloc+0x84>

0000000080002282 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002282:	7179                	addi	sp,sp,-48
    80002284:	f406                	sd	ra,40(sp)
    80002286:	f022                	sd	s0,32(sp)
    80002288:	ec26                	sd	s1,24(sp)
    8000228a:	e84a                	sd	s2,16(sp)
    8000228c:	e44e                	sd	s3,8(sp)
    8000228e:	1800                	addi	s0,sp,48
    80002290:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002292:	47ad                	li	a5,11
    80002294:	02b7e663          	bltu	a5,a1,800022c0 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002298:	02059793          	slli	a5,a1,0x20
    8000229c:	01e7d593          	srli	a1,a5,0x1e
    800022a0:	00b504b3          	add	s1,a0,a1
    800022a4:	0504a903          	lw	s2,80(s1)
    800022a8:	06091a63          	bnez	s2,8000231c <bmap+0x9a>
      addr = balloc(ip->dev);
    800022ac:	4108                	lw	a0,0(a0)
    800022ae:	eb5ff0ef          	jal	80002162 <balloc>
    800022b2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022b6:	06090363          	beqz	s2,8000231c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800022ba:	0524a823          	sw	s2,80(s1)
    800022be:	a8b9                	j	8000231c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800022c0:	ff45849b          	addiw	s1,a1,-12
    800022c4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800022c8:	0ff00793          	li	a5,255
    800022cc:	06e7ee63          	bltu	a5,a4,80002348 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022d0:	08052903          	lw	s2,128(a0)
    800022d4:	00091d63          	bnez	s2,800022ee <bmap+0x6c>
      addr = balloc(ip->dev);
    800022d8:	4108                	lw	a0,0(a0)
    800022da:	e89ff0ef          	jal	80002162 <balloc>
    800022de:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800022e2:	02090d63          	beqz	s2,8000231c <bmap+0x9a>
    800022e6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800022e8:	0929a023          	sw	s2,128(s3)
    800022ec:	a011                	j	800022f0 <bmap+0x6e>
    800022ee:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800022f0:	85ca                	mv	a1,s2
    800022f2:	0009a503          	lw	a0,0(s3)
    800022f6:	c09ff0ef          	jal	80001efe <bread>
    800022fa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800022fc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002300:	02049713          	slli	a4,s1,0x20
    80002304:	01e75593          	srli	a1,a4,0x1e
    80002308:	00b784b3          	add	s1,a5,a1
    8000230c:	0004a903          	lw	s2,0(s1)
    80002310:	00090e63          	beqz	s2,8000232c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002314:	8552                	mv	a0,s4
    80002316:	cf1ff0ef          	jal	80002006 <brelse>
    return addr;
    8000231a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000231c:	854a                	mv	a0,s2
    8000231e:	70a2                	ld	ra,40(sp)
    80002320:	7402                	ld	s0,32(sp)
    80002322:	64e2                	ld	s1,24(sp)
    80002324:	6942                	ld	s2,16(sp)
    80002326:	69a2                	ld	s3,8(sp)
    80002328:	6145                	addi	sp,sp,48
    8000232a:	8082                	ret
      addr = balloc(ip->dev);
    8000232c:	0009a503          	lw	a0,0(s3)
    80002330:	e33ff0ef          	jal	80002162 <balloc>
    80002334:	0005091b          	sext.w	s2,a0
      if(addr){
    80002338:	fc090ee3          	beqz	s2,80002314 <bmap+0x92>
        a[bn] = addr;
    8000233c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002340:	8552                	mv	a0,s4
    80002342:	50f000ef          	jal	80003050 <log_write>
    80002346:	b7f9                	j	80002314 <bmap+0x92>
    80002348:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000234a:	00005517          	auipc	a0,0x5
    8000234e:	0fe50513          	addi	a0,a0,254 # 80007448 <etext+0x448>
    80002352:	090030ef          	jal	800053e2 <panic>

0000000080002356 <iget>:
{
    80002356:	7179                	addi	sp,sp,-48
    80002358:	f406                	sd	ra,40(sp)
    8000235a:	f022                	sd	s0,32(sp)
    8000235c:	ec26                	sd	s1,24(sp)
    8000235e:	e84a                	sd	s2,16(sp)
    80002360:	e44e                	sd	s3,8(sp)
    80002362:	e052                	sd	s4,0(sp)
    80002364:	1800                	addi	s0,sp,48
    80002366:	89aa                	mv	s3,a0
    80002368:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000236a:	00016517          	auipc	a0,0x16
    8000236e:	3fe50513          	addi	a0,a0,1022 # 80018768 <itable>
    80002372:	39e030ef          	jal	80005710 <acquire>
  empty = 0;
    80002376:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002378:	00016497          	auipc	s1,0x16
    8000237c:	40848493          	addi	s1,s1,1032 # 80018780 <itable+0x18>
    80002380:	00018697          	auipc	a3,0x18
    80002384:	e9068693          	addi	a3,a3,-368 # 8001a210 <log>
    80002388:	a039                	j	80002396 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000238a:	02090963          	beqz	s2,800023bc <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000238e:	08848493          	addi	s1,s1,136
    80002392:	02d48863          	beq	s1,a3,800023c2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002396:	449c                	lw	a5,8(s1)
    80002398:	fef059e3          	blez	a5,8000238a <iget+0x34>
    8000239c:	4098                	lw	a4,0(s1)
    8000239e:	ff3716e3          	bne	a4,s3,8000238a <iget+0x34>
    800023a2:	40d8                	lw	a4,4(s1)
    800023a4:	ff4713e3          	bne	a4,s4,8000238a <iget+0x34>
      ip->ref++;
    800023a8:	2785                	addiw	a5,a5,1
    800023aa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800023ac:	00016517          	auipc	a0,0x16
    800023b0:	3bc50513          	addi	a0,a0,956 # 80018768 <itable>
    800023b4:	3f4030ef          	jal	800057a8 <release>
      return ip;
    800023b8:	8926                	mv	s2,s1
    800023ba:	a02d                	j	800023e4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023bc:	fbe9                	bnez	a5,8000238e <iget+0x38>
      empty = ip;
    800023be:	8926                	mv	s2,s1
    800023c0:	b7f9                	j	8000238e <iget+0x38>
  if(empty == 0)
    800023c2:	02090a63          	beqz	s2,800023f6 <iget+0xa0>
  ip->dev = dev;
    800023c6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800023ca:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800023ce:	4785                	li	a5,1
    800023d0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023d4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023d8:	00016517          	auipc	a0,0x16
    800023dc:	39050513          	addi	a0,a0,912 # 80018768 <itable>
    800023e0:	3c8030ef          	jal	800057a8 <release>
}
    800023e4:	854a                	mv	a0,s2
    800023e6:	70a2                	ld	ra,40(sp)
    800023e8:	7402                	ld	s0,32(sp)
    800023ea:	64e2                	ld	s1,24(sp)
    800023ec:	6942                	ld	s2,16(sp)
    800023ee:	69a2                	ld	s3,8(sp)
    800023f0:	6a02                	ld	s4,0(sp)
    800023f2:	6145                	addi	sp,sp,48
    800023f4:	8082                	ret
    panic("iget: no inodes");
    800023f6:	00005517          	auipc	a0,0x5
    800023fa:	06a50513          	addi	a0,a0,106 # 80007460 <etext+0x460>
    800023fe:	7e5020ef          	jal	800053e2 <panic>

0000000080002402 <fsinit>:
fsinit(int dev) {
    80002402:	7179                	addi	sp,sp,-48
    80002404:	f406                	sd	ra,40(sp)
    80002406:	f022                	sd	s0,32(sp)
    80002408:	ec26                	sd	s1,24(sp)
    8000240a:	e84a                	sd	s2,16(sp)
    8000240c:	e44e                	sd	s3,8(sp)
    8000240e:	1800                	addi	s0,sp,48
    80002410:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002412:	4585                	li	a1,1
    80002414:	aebff0ef          	jal	80001efe <bread>
    80002418:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000241a:	00016997          	auipc	s3,0x16
    8000241e:	32e98993          	addi	s3,s3,814 # 80018748 <sb>
    80002422:	02000613          	li	a2,32
    80002426:	05850593          	addi	a1,a0,88
    8000242a:	854e                	mv	a0,s3
    8000242c:	d65fd0ef          	jal	80000190 <memmove>
  brelse(bp);
    80002430:	8526                	mv	a0,s1
    80002432:	bd5ff0ef          	jal	80002006 <brelse>
  if(sb.magic != FSMAGIC)
    80002436:	0009a703          	lw	a4,0(s3)
    8000243a:	102037b7          	lui	a5,0x10203
    8000243e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002442:	02f71063          	bne	a4,a5,80002462 <fsinit+0x60>
  initlog(dev, &sb);
    80002446:	00016597          	auipc	a1,0x16
    8000244a:	30258593          	addi	a1,a1,770 # 80018748 <sb>
    8000244e:	854a                	mv	a0,s2
    80002450:	1f9000ef          	jal	80002e48 <initlog>
}
    80002454:	70a2                	ld	ra,40(sp)
    80002456:	7402                	ld	s0,32(sp)
    80002458:	64e2                	ld	s1,24(sp)
    8000245a:	6942                	ld	s2,16(sp)
    8000245c:	69a2                	ld	s3,8(sp)
    8000245e:	6145                	addi	sp,sp,48
    80002460:	8082                	ret
    panic("invalid file system");
    80002462:	00005517          	auipc	a0,0x5
    80002466:	00e50513          	addi	a0,a0,14 # 80007470 <etext+0x470>
    8000246a:	779020ef          	jal	800053e2 <panic>

000000008000246e <iinit>:
{
    8000246e:	7179                	addi	sp,sp,-48
    80002470:	f406                	sd	ra,40(sp)
    80002472:	f022                	sd	s0,32(sp)
    80002474:	ec26                	sd	s1,24(sp)
    80002476:	e84a                	sd	s2,16(sp)
    80002478:	e44e                	sd	s3,8(sp)
    8000247a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000247c:	00005597          	auipc	a1,0x5
    80002480:	00c58593          	addi	a1,a1,12 # 80007488 <etext+0x488>
    80002484:	00016517          	auipc	a0,0x16
    80002488:	2e450513          	addi	a0,a0,740 # 80018768 <itable>
    8000248c:	204030ef          	jal	80005690 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002490:	00016497          	auipc	s1,0x16
    80002494:	30048493          	addi	s1,s1,768 # 80018790 <itable+0x28>
    80002498:	00018997          	auipc	s3,0x18
    8000249c:	d8898993          	addi	s3,s3,-632 # 8001a220 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024a0:	00005917          	auipc	s2,0x5
    800024a4:	ff090913          	addi	s2,s2,-16 # 80007490 <etext+0x490>
    800024a8:	85ca                	mv	a1,s2
    800024aa:	8526                	mv	a0,s1
    800024ac:	475000ef          	jal	80003120 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024b0:	08848493          	addi	s1,s1,136
    800024b4:	ff349ae3          	bne	s1,s3,800024a8 <iinit+0x3a>
}
    800024b8:	70a2                	ld	ra,40(sp)
    800024ba:	7402                	ld	s0,32(sp)
    800024bc:	64e2                	ld	s1,24(sp)
    800024be:	6942                	ld	s2,16(sp)
    800024c0:	69a2                	ld	s3,8(sp)
    800024c2:	6145                	addi	sp,sp,48
    800024c4:	8082                	ret

00000000800024c6 <ialloc>:
{
    800024c6:	7139                	addi	sp,sp,-64
    800024c8:	fc06                	sd	ra,56(sp)
    800024ca:	f822                	sd	s0,48(sp)
    800024cc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800024ce:	00016717          	auipc	a4,0x16
    800024d2:	28672703          	lw	a4,646(a4) # 80018754 <sb+0xc>
    800024d6:	4785                	li	a5,1
    800024d8:	06e7f063          	bgeu	a5,a4,80002538 <ialloc+0x72>
    800024dc:	f426                	sd	s1,40(sp)
    800024de:	f04a                	sd	s2,32(sp)
    800024e0:	ec4e                	sd	s3,24(sp)
    800024e2:	e852                	sd	s4,16(sp)
    800024e4:	e456                	sd	s5,8(sp)
    800024e6:	e05a                	sd	s6,0(sp)
    800024e8:	8aaa                	mv	s5,a0
    800024ea:	8b2e                	mv	s6,a1
    800024ec:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800024ee:	00016a17          	auipc	s4,0x16
    800024f2:	25aa0a13          	addi	s4,s4,602 # 80018748 <sb>
    800024f6:	00495593          	srli	a1,s2,0x4
    800024fa:	018a2783          	lw	a5,24(s4)
    800024fe:	9dbd                	addw	a1,a1,a5
    80002500:	8556                	mv	a0,s5
    80002502:	9fdff0ef          	jal	80001efe <bread>
    80002506:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002508:	05850993          	addi	s3,a0,88
    8000250c:	00f97793          	andi	a5,s2,15
    80002510:	079a                	slli	a5,a5,0x6
    80002512:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002514:	00099783          	lh	a5,0(s3)
    80002518:	cb9d                	beqz	a5,8000254e <ialloc+0x88>
    brelse(bp);
    8000251a:	aedff0ef          	jal	80002006 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000251e:	0905                	addi	s2,s2,1
    80002520:	00ca2703          	lw	a4,12(s4)
    80002524:	0009079b          	sext.w	a5,s2
    80002528:	fce7e7e3          	bltu	a5,a4,800024f6 <ialloc+0x30>
    8000252c:	74a2                	ld	s1,40(sp)
    8000252e:	7902                	ld	s2,32(sp)
    80002530:	69e2                	ld	s3,24(sp)
    80002532:	6a42                	ld	s4,16(sp)
    80002534:	6aa2                	ld	s5,8(sp)
    80002536:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002538:	00005517          	auipc	a0,0x5
    8000253c:	f6050513          	addi	a0,a0,-160 # 80007498 <etext+0x498>
    80002540:	3d1020ef          	jal	80005110 <printf>
  return 0;
    80002544:	4501                	li	a0,0
}
    80002546:	70e2                	ld	ra,56(sp)
    80002548:	7442                	ld	s0,48(sp)
    8000254a:	6121                	addi	sp,sp,64
    8000254c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000254e:	04000613          	li	a2,64
    80002552:	4581                	li	a1,0
    80002554:	854e                	mv	a0,s3
    80002556:	bdffd0ef          	jal	80000134 <memset>
      dip->type = type;
    8000255a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000255e:	8526                	mv	a0,s1
    80002560:	2f1000ef          	jal	80003050 <log_write>
      brelse(bp);
    80002564:	8526                	mv	a0,s1
    80002566:	aa1ff0ef          	jal	80002006 <brelse>
      return iget(dev, inum);
    8000256a:	0009059b          	sext.w	a1,s2
    8000256e:	8556                	mv	a0,s5
    80002570:	de7ff0ef          	jal	80002356 <iget>
    80002574:	74a2                	ld	s1,40(sp)
    80002576:	7902                	ld	s2,32(sp)
    80002578:	69e2                	ld	s3,24(sp)
    8000257a:	6a42                	ld	s4,16(sp)
    8000257c:	6aa2                	ld	s5,8(sp)
    8000257e:	6b02                	ld	s6,0(sp)
    80002580:	b7d9                	j	80002546 <ialloc+0x80>

0000000080002582 <iupdate>:
{
    80002582:	1101                	addi	sp,sp,-32
    80002584:	ec06                	sd	ra,24(sp)
    80002586:	e822                	sd	s0,16(sp)
    80002588:	e426                	sd	s1,8(sp)
    8000258a:	e04a                	sd	s2,0(sp)
    8000258c:	1000                	addi	s0,sp,32
    8000258e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002590:	415c                	lw	a5,4(a0)
    80002592:	0047d79b          	srliw	a5,a5,0x4
    80002596:	00016597          	auipc	a1,0x16
    8000259a:	1ca5a583          	lw	a1,458(a1) # 80018760 <sb+0x18>
    8000259e:	9dbd                	addw	a1,a1,a5
    800025a0:	4108                	lw	a0,0(a0)
    800025a2:	95dff0ef          	jal	80001efe <bread>
    800025a6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025a8:	05850793          	addi	a5,a0,88
    800025ac:	40d8                	lw	a4,4(s1)
    800025ae:	8b3d                	andi	a4,a4,15
    800025b0:	071a                	slli	a4,a4,0x6
    800025b2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025b4:	04449703          	lh	a4,68(s1)
    800025b8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025bc:	04649703          	lh	a4,70(s1)
    800025c0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800025c4:	04849703          	lh	a4,72(s1)
    800025c8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800025cc:	04a49703          	lh	a4,74(s1)
    800025d0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025d4:	44f8                	lw	a4,76(s1)
    800025d6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025d8:	03400613          	li	a2,52
    800025dc:	05048593          	addi	a1,s1,80
    800025e0:	00c78513          	addi	a0,a5,12
    800025e4:	badfd0ef          	jal	80000190 <memmove>
  log_write(bp);
    800025e8:	854a                	mv	a0,s2
    800025ea:	267000ef          	jal	80003050 <log_write>
  brelse(bp);
    800025ee:	854a                	mv	a0,s2
    800025f0:	a17ff0ef          	jal	80002006 <brelse>
}
    800025f4:	60e2                	ld	ra,24(sp)
    800025f6:	6442                	ld	s0,16(sp)
    800025f8:	64a2                	ld	s1,8(sp)
    800025fa:	6902                	ld	s2,0(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret

0000000080002600 <idup>:
{
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	addi	s0,sp,32
    8000260a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000260c:	00016517          	auipc	a0,0x16
    80002610:	15c50513          	addi	a0,a0,348 # 80018768 <itable>
    80002614:	0fc030ef          	jal	80005710 <acquire>
  ip->ref++;
    80002618:	449c                	lw	a5,8(s1)
    8000261a:	2785                	addiw	a5,a5,1
    8000261c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000261e:	00016517          	auipc	a0,0x16
    80002622:	14a50513          	addi	a0,a0,330 # 80018768 <itable>
    80002626:	182030ef          	jal	800057a8 <release>
}
    8000262a:	8526                	mv	a0,s1
    8000262c:	60e2                	ld	ra,24(sp)
    8000262e:	6442                	ld	s0,16(sp)
    80002630:	64a2                	ld	s1,8(sp)
    80002632:	6105                	addi	sp,sp,32
    80002634:	8082                	ret

0000000080002636 <ilock>:
{
    80002636:	1101                	addi	sp,sp,-32
    80002638:	ec06                	sd	ra,24(sp)
    8000263a:	e822                	sd	s0,16(sp)
    8000263c:	e426                	sd	s1,8(sp)
    8000263e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002640:	cd19                	beqz	a0,8000265e <ilock+0x28>
    80002642:	84aa                	mv	s1,a0
    80002644:	451c                	lw	a5,8(a0)
    80002646:	00f05c63          	blez	a5,8000265e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000264a:	0541                	addi	a0,a0,16
    8000264c:	30b000ef          	jal	80003156 <acquiresleep>
  if(ip->valid == 0){
    80002650:	40bc                	lw	a5,64(s1)
    80002652:	cf89                	beqz	a5,8000266c <ilock+0x36>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret
    8000265e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002660:	00005517          	auipc	a0,0x5
    80002664:	e5050513          	addi	a0,a0,-432 # 800074b0 <etext+0x4b0>
    80002668:	57b020ef          	jal	800053e2 <panic>
    8000266c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000266e:	40dc                	lw	a5,4(s1)
    80002670:	0047d79b          	srliw	a5,a5,0x4
    80002674:	00016597          	auipc	a1,0x16
    80002678:	0ec5a583          	lw	a1,236(a1) # 80018760 <sb+0x18>
    8000267c:	9dbd                	addw	a1,a1,a5
    8000267e:	4088                	lw	a0,0(s1)
    80002680:	87fff0ef          	jal	80001efe <bread>
    80002684:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002686:	05850593          	addi	a1,a0,88
    8000268a:	40dc                	lw	a5,4(s1)
    8000268c:	8bbd                	andi	a5,a5,15
    8000268e:	079a                	slli	a5,a5,0x6
    80002690:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002692:	00059783          	lh	a5,0(a1)
    80002696:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000269a:	00259783          	lh	a5,2(a1)
    8000269e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026a2:	00459783          	lh	a5,4(a1)
    800026a6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026aa:	00659783          	lh	a5,6(a1)
    800026ae:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026b2:	459c                	lw	a5,8(a1)
    800026b4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026b6:	03400613          	li	a2,52
    800026ba:	05b1                	addi	a1,a1,12
    800026bc:	05048513          	addi	a0,s1,80
    800026c0:	ad1fd0ef          	jal	80000190 <memmove>
    brelse(bp);
    800026c4:	854a                	mv	a0,s2
    800026c6:	941ff0ef          	jal	80002006 <brelse>
    ip->valid = 1;
    800026ca:	4785                	li	a5,1
    800026cc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800026ce:	04449783          	lh	a5,68(s1)
    800026d2:	c399                	beqz	a5,800026d8 <ilock+0xa2>
    800026d4:	6902                	ld	s2,0(sp)
    800026d6:	bfbd                	j	80002654 <ilock+0x1e>
      panic("ilock: no type");
    800026d8:	00005517          	auipc	a0,0x5
    800026dc:	de050513          	addi	a0,a0,-544 # 800074b8 <etext+0x4b8>
    800026e0:	503020ef          	jal	800053e2 <panic>

00000000800026e4 <iunlock>:
{
    800026e4:	1101                	addi	sp,sp,-32
    800026e6:	ec06                	sd	ra,24(sp)
    800026e8:	e822                	sd	s0,16(sp)
    800026ea:	e426                	sd	s1,8(sp)
    800026ec:	e04a                	sd	s2,0(sp)
    800026ee:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800026f0:	c505                	beqz	a0,80002718 <iunlock+0x34>
    800026f2:	84aa                	mv	s1,a0
    800026f4:	01050913          	addi	s2,a0,16
    800026f8:	854a                	mv	a0,s2
    800026fa:	2db000ef          	jal	800031d4 <holdingsleep>
    800026fe:	cd09                	beqz	a0,80002718 <iunlock+0x34>
    80002700:	449c                	lw	a5,8(s1)
    80002702:	00f05b63          	blez	a5,80002718 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002706:	854a                	mv	a0,s2
    80002708:	295000ef          	jal	8000319c <releasesleep>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6902                	ld	s2,0(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    panic("iunlock");
    80002718:	00005517          	auipc	a0,0x5
    8000271c:	db050513          	addi	a0,a0,-592 # 800074c8 <etext+0x4c8>
    80002720:	4c3020ef          	jal	800053e2 <panic>

0000000080002724 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002724:	7179                	addi	sp,sp,-48
    80002726:	f406                	sd	ra,40(sp)
    80002728:	f022                	sd	s0,32(sp)
    8000272a:	ec26                	sd	s1,24(sp)
    8000272c:	e84a                	sd	s2,16(sp)
    8000272e:	e44e                	sd	s3,8(sp)
    80002730:	1800                	addi	s0,sp,48
    80002732:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002734:	05050493          	addi	s1,a0,80
    80002738:	08050913          	addi	s2,a0,128
    8000273c:	a021                	j	80002744 <itrunc+0x20>
    8000273e:	0491                	addi	s1,s1,4
    80002740:	01248b63          	beq	s1,s2,80002756 <itrunc+0x32>
    if(ip->addrs[i]){
    80002744:	408c                	lw	a1,0(s1)
    80002746:	dde5                	beqz	a1,8000273e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002748:	0009a503          	lw	a0,0(s3)
    8000274c:	9abff0ef          	jal	800020f6 <bfree>
      ip->addrs[i] = 0;
    80002750:	0004a023          	sw	zero,0(s1)
    80002754:	b7ed                	j	8000273e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002756:	0809a583          	lw	a1,128(s3)
    8000275a:	ed89                	bnez	a1,80002774 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000275c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002760:	854e                	mv	a0,s3
    80002762:	e21ff0ef          	jal	80002582 <iupdate>
}
    80002766:	70a2                	ld	ra,40(sp)
    80002768:	7402                	ld	s0,32(sp)
    8000276a:	64e2                	ld	s1,24(sp)
    8000276c:	6942                	ld	s2,16(sp)
    8000276e:	69a2                	ld	s3,8(sp)
    80002770:	6145                	addi	sp,sp,48
    80002772:	8082                	ret
    80002774:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002776:	0009a503          	lw	a0,0(s3)
    8000277a:	f84ff0ef          	jal	80001efe <bread>
    8000277e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002780:	05850493          	addi	s1,a0,88
    80002784:	45850913          	addi	s2,a0,1112
    80002788:	a021                	j	80002790 <itrunc+0x6c>
    8000278a:	0491                	addi	s1,s1,4
    8000278c:	01248963          	beq	s1,s2,8000279e <itrunc+0x7a>
      if(a[j])
    80002790:	408c                	lw	a1,0(s1)
    80002792:	dde5                	beqz	a1,8000278a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002794:	0009a503          	lw	a0,0(s3)
    80002798:	95fff0ef          	jal	800020f6 <bfree>
    8000279c:	b7fd                	j	8000278a <itrunc+0x66>
    brelse(bp);
    8000279e:	8552                	mv	a0,s4
    800027a0:	867ff0ef          	jal	80002006 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027a4:	0809a583          	lw	a1,128(s3)
    800027a8:	0009a503          	lw	a0,0(s3)
    800027ac:	94bff0ef          	jal	800020f6 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027b0:	0809a023          	sw	zero,128(s3)
    800027b4:	6a02                	ld	s4,0(sp)
    800027b6:	b75d                	j	8000275c <itrunc+0x38>

00000000800027b8 <iput>:
{
    800027b8:	1101                	addi	sp,sp,-32
    800027ba:	ec06                	sd	ra,24(sp)
    800027bc:	e822                	sd	s0,16(sp)
    800027be:	e426                	sd	s1,8(sp)
    800027c0:	1000                	addi	s0,sp,32
    800027c2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027c4:	00016517          	auipc	a0,0x16
    800027c8:	fa450513          	addi	a0,a0,-92 # 80018768 <itable>
    800027cc:	745020ef          	jal	80005710 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027d0:	4498                	lw	a4,8(s1)
    800027d2:	4785                	li	a5,1
    800027d4:	02f70063          	beq	a4,a5,800027f4 <iput+0x3c>
  ip->ref--;
    800027d8:	449c                	lw	a5,8(s1)
    800027da:	37fd                	addiw	a5,a5,-1
    800027dc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027de:	00016517          	auipc	a0,0x16
    800027e2:	f8a50513          	addi	a0,a0,-118 # 80018768 <itable>
    800027e6:	7c3020ef          	jal	800057a8 <release>
}
    800027ea:	60e2                	ld	ra,24(sp)
    800027ec:	6442                	ld	s0,16(sp)
    800027ee:	64a2                	ld	s1,8(sp)
    800027f0:	6105                	addi	sp,sp,32
    800027f2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027f4:	40bc                	lw	a5,64(s1)
    800027f6:	d3ed                	beqz	a5,800027d8 <iput+0x20>
    800027f8:	04a49783          	lh	a5,74(s1)
    800027fc:	fff1                	bnez	a5,800027d8 <iput+0x20>
    800027fe:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002800:	01048913          	addi	s2,s1,16
    80002804:	854a                	mv	a0,s2
    80002806:	151000ef          	jal	80003156 <acquiresleep>
    release(&itable.lock);
    8000280a:	00016517          	auipc	a0,0x16
    8000280e:	f5e50513          	addi	a0,a0,-162 # 80018768 <itable>
    80002812:	797020ef          	jal	800057a8 <release>
    itrunc(ip);
    80002816:	8526                	mv	a0,s1
    80002818:	f0dff0ef          	jal	80002724 <itrunc>
    ip->type = 0;
    8000281c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002820:	8526                	mv	a0,s1
    80002822:	d61ff0ef          	jal	80002582 <iupdate>
    ip->valid = 0;
    80002826:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000282a:	854a                	mv	a0,s2
    8000282c:	171000ef          	jal	8000319c <releasesleep>
    acquire(&itable.lock);
    80002830:	00016517          	auipc	a0,0x16
    80002834:	f3850513          	addi	a0,a0,-200 # 80018768 <itable>
    80002838:	6d9020ef          	jal	80005710 <acquire>
    8000283c:	6902                	ld	s2,0(sp)
    8000283e:	bf69                	j	800027d8 <iput+0x20>

0000000080002840 <iunlockput>:
{
    80002840:	1101                	addi	sp,sp,-32
    80002842:	ec06                	sd	ra,24(sp)
    80002844:	e822                	sd	s0,16(sp)
    80002846:	e426                	sd	s1,8(sp)
    80002848:	1000                	addi	s0,sp,32
    8000284a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000284c:	e99ff0ef          	jal	800026e4 <iunlock>
  iput(ip);
    80002850:	8526                	mv	a0,s1
    80002852:	f67ff0ef          	jal	800027b8 <iput>
}
    80002856:	60e2                	ld	ra,24(sp)
    80002858:	6442                	ld	s0,16(sp)
    8000285a:	64a2                	ld	s1,8(sp)
    8000285c:	6105                	addi	sp,sp,32
    8000285e:	8082                	ret

0000000080002860 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002860:	1141                	addi	sp,sp,-16
    80002862:	e422                	sd	s0,8(sp)
    80002864:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002866:	411c                	lw	a5,0(a0)
    80002868:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000286a:	415c                	lw	a5,4(a0)
    8000286c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000286e:	04451783          	lh	a5,68(a0)
    80002872:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002876:	04a51783          	lh	a5,74(a0)
    8000287a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000287e:	04c56783          	lwu	a5,76(a0)
    80002882:	e99c                	sd	a5,16(a1)
}
    80002884:	6422                	ld	s0,8(sp)
    80002886:	0141                	addi	sp,sp,16
    80002888:	8082                	ret

000000008000288a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000288a:	457c                	lw	a5,76(a0)
    8000288c:	0ed7eb63          	bltu	a5,a3,80002982 <readi+0xf8>
{
    80002890:	7159                	addi	sp,sp,-112
    80002892:	f486                	sd	ra,104(sp)
    80002894:	f0a2                	sd	s0,96(sp)
    80002896:	eca6                	sd	s1,88(sp)
    80002898:	e0d2                	sd	s4,64(sp)
    8000289a:	fc56                	sd	s5,56(sp)
    8000289c:	f85a                	sd	s6,48(sp)
    8000289e:	f45e                	sd	s7,40(sp)
    800028a0:	1880                	addi	s0,sp,112
    800028a2:	8b2a                	mv	s6,a0
    800028a4:	8bae                	mv	s7,a1
    800028a6:	8a32                	mv	s4,a2
    800028a8:	84b6                	mv	s1,a3
    800028aa:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800028ac:	9f35                	addw	a4,a4,a3
    return 0;
    800028ae:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800028b0:	0cd76063          	bltu	a4,a3,80002970 <readi+0xe6>
    800028b4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800028b6:	00e7f463          	bgeu	a5,a4,800028be <readi+0x34>
    n = ip->size - off;
    800028ba:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028be:	080a8f63          	beqz	s5,8000295c <readi+0xd2>
    800028c2:	e8ca                	sd	s2,80(sp)
    800028c4:	f062                	sd	s8,32(sp)
    800028c6:	ec66                	sd	s9,24(sp)
    800028c8:	e86a                	sd	s10,16(sp)
    800028ca:	e46e                	sd	s11,8(sp)
    800028cc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800028ce:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800028d2:	5c7d                	li	s8,-1
    800028d4:	a80d                	j	80002906 <readi+0x7c>
    800028d6:	020d1d93          	slli	s11,s10,0x20
    800028da:	020ddd93          	srli	s11,s11,0x20
    800028de:	05890613          	addi	a2,s2,88
    800028e2:	86ee                	mv	a3,s11
    800028e4:	963a                	add	a2,a2,a4
    800028e6:	85d2                	mv	a1,s4
    800028e8:	855e                	mv	a0,s7
    800028ea:	d97fe0ef          	jal	80001680 <either_copyout>
    800028ee:	05850763          	beq	a0,s8,8000293c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800028f2:	854a                	mv	a0,s2
    800028f4:	f12ff0ef          	jal	80002006 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028f8:	013d09bb          	addw	s3,s10,s3
    800028fc:	009d04bb          	addw	s1,s10,s1
    80002900:	9a6e                	add	s4,s4,s11
    80002902:	0559f763          	bgeu	s3,s5,80002950 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002906:	00a4d59b          	srliw	a1,s1,0xa
    8000290a:	855a                	mv	a0,s6
    8000290c:	977ff0ef          	jal	80002282 <bmap>
    80002910:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002914:	c5b1                	beqz	a1,80002960 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002916:	000b2503          	lw	a0,0(s6)
    8000291a:	de4ff0ef          	jal	80001efe <bread>
    8000291e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002920:	3ff4f713          	andi	a4,s1,1023
    80002924:	40ec87bb          	subw	a5,s9,a4
    80002928:	413a86bb          	subw	a3,s5,s3
    8000292c:	8d3e                	mv	s10,a5
    8000292e:	2781                	sext.w	a5,a5
    80002930:	0006861b          	sext.w	a2,a3
    80002934:	faf671e3          	bgeu	a2,a5,800028d6 <readi+0x4c>
    80002938:	8d36                	mv	s10,a3
    8000293a:	bf71                	j	800028d6 <readi+0x4c>
      brelse(bp);
    8000293c:	854a                	mv	a0,s2
    8000293e:	ec8ff0ef          	jal	80002006 <brelse>
      tot = -1;
    80002942:	59fd                	li	s3,-1
      break;
    80002944:	6946                	ld	s2,80(sp)
    80002946:	7c02                	ld	s8,32(sp)
    80002948:	6ce2                	ld	s9,24(sp)
    8000294a:	6d42                	ld	s10,16(sp)
    8000294c:	6da2                	ld	s11,8(sp)
    8000294e:	a831                	j	8000296a <readi+0xe0>
    80002950:	6946                	ld	s2,80(sp)
    80002952:	7c02                	ld	s8,32(sp)
    80002954:	6ce2                	ld	s9,24(sp)
    80002956:	6d42                	ld	s10,16(sp)
    80002958:	6da2                	ld	s11,8(sp)
    8000295a:	a801                	j	8000296a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000295c:	89d6                	mv	s3,s5
    8000295e:	a031                	j	8000296a <readi+0xe0>
    80002960:	6946                	ld	s2,80(sp)
    80002962:	7c02                	ld	s8,32(sp)
    80002964:	6ce2                	ld	s9,24(sp)
    80002966:	6d42                	ld	s10,16(sp)
    80002968:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000296a:	0009851b          	sext.w	a0,s3
    8000296e:	69a6                	ld	s3,72(sp)
}
    80002970:	70a6                	ld	ra,104(sp)
    80002972:	7406                	ld	s0,96(sp)
    80002974:	64e6                	ld	s1,88(sp)
    80002976:	6a06                	ld	s4,64(sp)
    80002978:	7ae2                	ld	s5,56(sp)
    8000297a:	7b42                	ld	s6,48(sp)
    8000297c:	7ba2                	ld	s7,40(sp)
    8000297e:	6165                	addi	sp,sp,112
    80002980:	8082                	ret
    return 0;
    80002982:	4501                	li	a0,0
}
    80002984:	8082                	ret

0000000080002986 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002986:	457c                	lw	a5,76(a0)
    80002988:	10d7e063          	bltu	a5,a3,80002a88 <writei+0x102>
{
    8000298c:	7159                	addi	sp,sp,-112
    8000298e:	f486                	sd	ra,104(sp)
    80002990:	f0a2                	sd	s0,96(sp)
    80002992:	e8ca                	sd	s2,80(sp)
    80002994:	e0d2                	sd	s4,64(sp)
    80002996:	fc56                	sd	s5,56(sp)
    80002998:	f85a                	sd	s6,48(sp)
    8000299a:	f45e                	sd	s7,40(sp)
    8000299c:	1880                	addi	s0,sp,112
    8000299e:	8aaa                	mv	s5,a0
    800029a0:	8bae                	mv	s7,a1
    800029a2:	8a32                	mv	s4,a2
    800029a4:	8936                	mv	s2,a3
    800029a6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800029a8:	00e687bb          	addw	a5,a3,a4
    800029ac:	0ed7e063          	bltu	a5,a3,80002a8c <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800029b0:	00043737          	lui	a4,0x43
    800029b4:	0cf76e63          	bltu	a4,a5,80002a90 <writei+0x10a>
    800029b8:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029ba:	0a0b0f63          	beqz	s6,80002a78 <writei+0xf2>
    800029be:	eca6                	sd	s1,88(sp)
    800029c0:	f062                	sd	s8,32(sp)
    800029c2:	ec66                	sd	s9,24(sp)
    800029c4:	e86a                	sd	s10,16(sp)
    800029c6:	e46e                	sd	s11,8(sp)
    800029c8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029ca:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800029ce:	5c7d                	li	s8,-1
    800029d0:	a825                	j	80002a08 <writei+0x82>
    800029d2:	020d1d93          	slli	s11,s10,0x20
    800029d6:	020ddd93          	srli	s11,s11,0x20
    800029da:	05848513          	addi	a0,s1,88
    800029de:	86ee                	mv	a3,s11
    800029e0:	8652                	mv	a2,s4
    800029e2:	85de                	mv	a1,s7
    800029e4:	953a                	add	a0,a0,a4
    800029e6:	ce5fe0ef          	jal	800016ca <either_copyin>
    800029ea:	05850a63          	beq	a0,s8,80002a3e <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029ee:	8526                	mv	a0,s1
    800029f0:	660000ef          	jal	80003050 <log_write>
    brelse(bp);
    800029f4:	8526                	mv	a0,s1
    800029f6:	e10ff0ef          	jal	80002006 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029fa:	013d09bb          	addw	s3,s10,s3
    800029fe:	012d093b          	addw	s2,s10,s2
    80002a02:	9a6e                	add	s4,s4,s11
    80002a04:	0569f063          	bgeu	s3,s6,80002a44 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a08:	00a9559b          	srliw	a1,s2,0xa
    80002a0c:	8556                	mv	a0,s5
    80002a0e:	875ff0ef          	jal	80002282 <bmap>
    80002a12:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a16:	c59d                	beqz	a1,80002a44 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002a18:	000aa503          	lw	a0,0(s5)
    80002a1c:	ce2ff0ef          	jal	80001efe <bread>
    80002a20:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a22:	3ff97713          	andi	a4,s2,1023
    80002a26:	40ec87bb          	subw	a5,s9,a4
    80002a2a:	413b06bb          	subw	a3,s6,s3
    80002a2e:	8d3e                	mv	s10,a5
    80002a30:	2781                	sext.w	a5,a5
    80002a32:	0006861b          	sext.w	a2,a3
    80002a36:	f8f67ee3          	bgeu	a2,a5,800029d2 <writei+0x4c>
    80002a3a:	8d36                	mv	s10,a3
    80002a3c:	bf59                	j	800029d2 <writei+0x4c>
      brelse(bp);
    80002a3e:	8526                	mv	a0,s1
    80002a40:	dc6ff0ef          	jal	80002006 <brelse>
  }

  if(off > ip->size)
    80002a44:	04caa783          	lw	a5,76(s5)
    80002a48:	0327fa63          	bgeu	a5,s2,80002a7c <writei+0xf6>
    ip->size = off;
    80002a4c:	052aa623          	sw	s2,76(s5)
    80002a50:	64e6                	ld	s1,88(sp)
    80002a52:	7c02                	ld	s8,32(sp)
    80002a54:	6ce2                	ld	s9,24(sp)
    80002a56:	6d42                	ld	s10,16(sp)
    80002a58:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a5a:	8556                	mv	a0,s5
    80002a5c:	b27ff0ef          	jal	80002582 <iupdate>

  return tot;
    80002a60:	0009851b          	sext.w	a0,s3
    80002a64:	69a6                	ld	s3,72(sp)
}
    80002a66:	70a6                	ld	ra,104(sp)
    80002a68:	7406                	ld	s0,96(sp)
    80002a6a:	6946                	ld	s2,80(sp)
    80002a6c:	6a06                	ld	s4,64(sp)
    80002a6e:	7ae2                	ld	s5,56(sp)
    80002a70:	7b42                	ld	s6,48(sp)
    80002a72:	7ba2                	ld	s7,40(sp)
    80002a74:	6165                	addi	sp,sp,112
    80002a76:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a78:	89da                	mv	s3,s6
    80002a7a:	b7c5                	j	80002a5a <writei+0xd4>
    80002a7c:	64e6                	ld	s1,88(sp)
    80002a7e:	7c02                	ld	s8,32(sp)
    80002a80:	6ce2                	ld	s9,24(sp)
    80002a82:	6d42                	ld	s10,16(sp)
    80002a84:	6da2                	ld	s11,8(sp)
    80002a86:	bfd1                	j	80002a5a <writei+0xd4>
    return -1;
    80002a88:	557d                	li	a0,-1
}
    80002a8a:	8082                	ret
    return -1;
    80002a8c:	557d                	li	a0,-1
    80002a8e:	bfe1                	j	80002a66 <writei+0xe0>
    return -1;
    80002a90:	557d                	li	a0,-1
    80002a92:	bfd1                	j	80002a66 <writei+0xe0>

0000000080002a94 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002a94:	1141                	addi	sp,sp,-16
    80002a96:	e406                	sd	ra,8(sp)
    80002a98:	e022                	sd	s0,0(sp)
    80002a9a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002a9c:	4639                	li	a2,14
    80002a9e:	f62fd0ef          	jal	80000200 <strncmp>
}
    80002aa2:	60a2                	ld	ra,8(sp)
    80002aa4:	6402                	ld	s0,0(sp)
    80002aa6:	0141                	addi	sp,sp,16
    80002aa8:	8082                	ret

0000000080002aaa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002aaa:	7139                	addi	sp,sp,-64
    80002aac:	fc06                	sd	ra,56(sp)
    80002aae:	f822                	sd	s0,48(sp)
    80002ab0:	f426                	sd	s1,40(sp)
    80002ab2:	f04a                	sd	s2,32(sp)
    80002ab4:	ec4e                	sd	s3,24(sp)
    80002ab6:	e852                	sd	s4,16(sp)
    80002ab8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002aba:	04451703          	lh	a4,68(a0)
    80002abe:	4785                	li	a5,1
    80002ac0:	00f71a63          	bne	a4,a5,80002ad4 <dirlookup+0x2a>
    80002ac4:	892a                	mv	s2,a0
    80002ac6:	89ae                	mv	s3,a1
    80002ac8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002aca:	457c                	lw	a5,76(a0)
    80002acc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ace:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ad0:	e39d                	bnez	a5,80002af6 <dirlookup+0x4c>
    80002ad2:	a095                	j	80002b36 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ad4:	00005517          	auipc	a0,0x5
    80002ad8:	9fc50513          	addi	a0,a0,-1540 # 800074d0 <etext+0x4d0>
    80002adc:	107020ef          	jal	800053e2 <panic>
      panic("dirlookup read");
    80002ae0:	00005517          	auipc	a0,0x5
    80002ae4:	a0850513          	addi	a0,a0,-1528 # 800074e8 <etext+0x4e8>
    80002ae8:	0fb020ef          	jal	800053e2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002aec:	24c1                	addiw	s1,s1,16
    80002aee:	04c92783          	lw	a5,76(s2)
    80002af2:	04f4f163          	bgeu	s1,a5,80002b34 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002af6:	4741                	li	a4,16
    80002af8:	86a6                	mv	a3,s1
    80002afa:	fc040613          	addi	a2,s0,-64
    80002afe:	4581                	li	a1,0
    80002b00:	854a                	mv	a0,s2
    80002b02:	d89ff0ef          	jal	8000288a <readi>
    80002b06:	47c1                	li	a5,16
    80002b08:	fcf51ce3          	bne	a0,a5,80002ae0 <dirlookup+0x36>
    if(de.inum == 0)
    80002b0c:	fc045783          	lhu	a5,-64(s0)
    80002b10:	dff1                	beqz	a5,80002aec <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002b12:	fc240593          	addi	a1,s0,-62
    80002b16:	854e                	mv	a0,s3
    80002b18:	f7dff0ef          	jal	80002a94 <namecmp>
    80002b1c:	f961                	bnez	a0,80002aec <dirlookup+0x42>
      if(poff)
    80002b1e:	000a0463          	beqz	s4,80002b26 <dirlookup+0x7c>
        *poff = off;
    80002b22:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002b26:	fc045583          	lhu	a1,-64(s0)
    80002b2a:	00092503          	lw	a0,0(s2)
    80002b2e:	829ff0ef          	jal	80002356 <iget>
    80002b32:	a011                	j	80002b36 <dirlookup+0x8c>
  return 0;
    80002b34:	4501                	li	a0,0
}
    80002b36:	70e2                	ld	ra,56(sp)
    80002b38:	7442                	ld	s0,48(sp)
    80002b3a:	74a2                	ld	s1,40(sp)
    80002b3c:	7902                	ld	s2,32(sp)
    80002b3e:	69e2                	ld	s3,24(sp)
    80002b40:	6a42                	ld	s4,16(sp)
    80002b42:	6121                	addi	sp,sp,64
    80002b44:	8082                	ret

0000000080002b46 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b46:	711d                	addi	sp,sp,-96
    80002b48:	ec86                	sd	ra,88(sp)
    80002b4a:	e8a2                	sd	s0,80(sp)
    80002b4c:	e4a6                	sd	s1,72(sp)
    80002b4e:	e0ca                	sd	s2,64(sp)
    80002b50:	fc4e                	sd	s3,56(sp)
    80002b52:	f852                	sd	s4,48(sp)
    80002b54:	f456                	sd	s5,40(sp)
    80002b56:	f05a                	sd	s6,32(sp)
    80002b58:	ec5e                	sd	s7,24(sp)
    80002b5a:	e862                	sd	s8,16(sp)
    80002b5c:	e466                	sd	s9,8(sp)
    80002b5e:	1080                	addi	s0,sp,96
    80002b60:	84aa                	mv	s1,a0
    80002b62:	8b2e                	mv	s6,a1
    80002b64:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b66:	00054703          	lbu	a4,0(a0)
    80002b6a:	02f00793          	li	a5,47
    80002b6e:	00f70e63          	beq	a4,a5,80002b8a <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b72:	9e4fe0ef          	jal	80000d56 <myproc>
    80002b76:	15053503          	ld	a0,336(a0)
    80002b7a:	a87ff0ef          	jal	80002600 <idup>
    80002b7e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b80:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b84:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b86:	4b85                	li	s7,1
    80002b88:	a871                	j	80002c24 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002b8a:	4585                	li	a1,1
    80002b8c:	4505                	li	a0,1
    80002b8e:	fc8ff0ef          	jal	80002356 <iget>
    80002b92:	8a2a                	mv	s4,a0
    80002b94:	b7f5                	j	80002b80 <namex+0x3a>
      iunlockput(ip);
    80002b96:	8552                	mv	a0,s4
    80002b98:	ca9ff0ef          	jal	80002840 <iunlockput>
      return 0;
    80002b9c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002b9e:	8552                	mv	a0,s4
    80002ba0:	60e6                	ld	ra,88(sp)
    80002ba2:	6446                	ld	s0,80(sp)
    80002ba4:	64a6                	ld	s1,72(sp)
    80002ba6:	6906                	ld	s2,64(sp)
    80002ba8:	79e2                	ld	s3,56(sp)
    80002baa:	7a42                	ld	s4,48(sp)
    80002bac:	7aa2                	ld	s5,40(sp)
    80002bae:	7b02                	ld	s6,32(sp)
    80002bb0:	6be2                	ld	s7,24(sp)
    80002bb2:	6c42                	ld	s8,16(sp)
    80002bb4:	6ca2                	ld	s9,8(sp)
    80002bb6:	6125                	addi	sp,sp,96
    80002bb8:	8082                	ret
      iunlock(ip);
    80002bba:	8552                	mv	a0,s4
    80002bbc:	b29ff0ef          	jal	800026e4 <iunlock>
      return ip;
    80002bc0:	bff9                	j	80002b9e <namex+0x58>
      iunlockput(ip);
    80002bc2:	8552                	mv	a0,s4
    80002bc4:	c7dff0ef          	jal	80002840 <iunlockput>
      return 0;
    80002bc8:	8a4e                	mv	s4,s3
    80002bca:	bfd1                	j	80002b9e <namex+0x58>
  len = path - s;
    80002bcc:	40998633          	sub	a2,s3,s1
    80002bd0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002bd4:	099c5063          	bge	s8,s9,80002c54 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002bd8:	4639                	li	a2,14
    80002bda:	85a6                	mv	a1,s1
    80002bdc:	8556                	mv	a0,s5
    80002bde:	db2fd0ef          	jal	80000190 <memmove>
    80002be2:	84ce                	mv	s1,s3
  while(*path == '/')
    80002be4:	0004c783          	lbu	a5,0(s1)
    80002be8:	01279763          	bne	a5,s2,80002bf6 <namex+0xb0>
    path++;
    80002bec:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002bee:	0004c783          	lbu	a5,0(s1)
    80002bf2:	ff278de3          	beq	a5,s2,80002bec <namex+0xa6>
    ilock(ip);
    80002bf6:	8552                	mv	a0,s4
    80002bf8:	a3fff0ef          	jal	80002636 <ilock>
    if(ip->type != T_DIR){
    80002bfc:	044a1783          	lh	a5,68(s4)
    80002c00:	f9779be3          	bne	a5,s7,80002b96 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002c04:	000b0563          	beqz	s6,80002c0e <namex+0xc8>
    80002c08:	0004c783          	lbu	a5,0(s1)
    80002c0c:	d7dd                	beqz	a5,80002bba <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002c0e:	4601                	li	a2,0
    80002c10:	85d6                	mv	a1,s5
    80002c12:	8552                	mv	a0,s4
    80002c14:	e97ff0ef          	jal	80002aaa <dirlookup>
    80002c18:	89aa                	mv	s3,a0
    80002c1a:	d545                	beqz	a0,80002bc2 <namex+0x7c>
    iunlockput(ip);
    80002c1c:	8552                	mv	a0,s4
    80002c1e:	c23ff0ef          	jal	80002840 <iunlockput>
    ip = next;
    80002c22:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002c24:	0004c783          	lbu	a5,0(s1)
    80002c28:	01279763          	bne	a5,s2,80002c36 <namex+0xf0>
    path++;
    80002c2c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c2e:	0004c783          	lbu	a5,0(s1)
    80002c32:	ff278de3          	beq	a5,s2,80002c2c <namex+0xe6>
  if(*path == 0)
    80002c36:	cb8d                	beqz	a5,80002c68 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002c38:	0004c783          	lbu	a5,0(s1)
    80002c3c:	89a6                	mv	s3,s1
  len = path - s;
    80002c3e:	4c81                	li	s9,0
    80002c40:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002c42:	01278963          	beq	a5,s2,80002c54 <namex+0x10e>
    80002c46:	d3d9                	beqz	a5,80002bcc <namex+0x86>
    path++;
    80002c48:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c4a:	0009c783          	lbu	a5,0(s3)
    80002c4e:	ff279ce3          	bne	a5,s2,80002c46 <namex+0x100>
    80002c52:	bfad                	j	80002bcc <namex+0x86>
    memmove(name, s, len);
    80002c54:	2601                	sext.w	a2,a2
    80002c56:	85a6                	mv	a1,s1
    80002c58:	8556                	mv	a0,s5
    80002c5a:	d36fd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80002c5e:	9cd6                	add	s9,s9,s5
    80002c60:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002c64:	84ce                	mv	s1,s3
    80002c66:	bfbd                	j	80002be4 <namex+0x9e>
  if(nameiparent){
    80002c68:	f20b0be3          	beqz	s6,80002b9e <namex+0x58>
    iput(ip);
    80002c6c:	8552                	mv	a0,s4
    80002c6e:	b4bff0ef          	jal	800027b8 <iput>
    return 0;
    80002c72:	4a01                	li	s4,0
    80002c74:	b72d                	j	80002b9e <namex+0x58>

0000000080002c76 <dirlink>:
{
    80002c76:	7139                	addi	sp,sp,-64
    80002c78:	fc06                	sd	ra,56(sp)
    80002c7a:	f822                	sd	s0,48(sp)
    80002c7c:	f04a                	sd	s2,32(sp)
    80002c7e:	ec4e                	sd	s3,24(sp)
    80002c80:	e852                	sd	s4,16(sp)
    80002c82:	0080                	addi	s0,sp,64
    80002c84:	892a                	mv	s2,a0
    80002c86:	8a2e                	mv	s4,a1
    80002c88:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c8a:	4601                	li	a2,0
    80002c8c:	e1fff0ef          	jal	80002aaa <dirlookup>
    80002c90:	e535                	bnez	a0,80002cfc <dirlink+0x86>
    80002c92:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c94:	04c92483          	lw	s1,76(s2)
    80002c98:	c48d                	beqz	s1,80002cc2 <dirlink+0x4c>
    80002c9a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c9c:	4741                	li	a4,16
    80002c9e:	86a6                	mv	a3,s1
    80002ca0:	fc040613          	addi	a2,s0,-64
    80002ca4:	4581                	li	a1,0
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	be3ff0ef          	jal	8000288a <readi>
    80002cac:	47c1                	li	a5,16
    80002cae:	04f51b63          	bne	a0,a5,80002d04 <dirlink+0x8e>
    if(de.inum == 0)
    80002cb2:	fc045783          	lhu	a5,-64(s0)
    80002cb6:	c791                	beqz	a5,80002cc2 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cb8:	24c1                	addiw	s1,s1,16
    80002cba:	04c92783          	lw	a5,76(s2)
    80002cbe:	fcf4efe3          	bltu	s1,a5,80002c9c <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002cc2:	4639                	li	a2,14
    80002cc4:	85d2                	mv	a1,s4
    80002cc6:	fc240513          	addi	a0,s0,-62
    80002cca:	d6cfd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80002cce:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cd2:	4741                	li	a4,16
    80002cd4:	86a6                	mv	a3,s1
    80002cd6:	fc040613          	addi	a2,s0,-64
    80002cda:	4581                	li	a1,0
    80002cdc:	854a                	mv	a0,s2
    80002cde:	ca9ff0ef          	jal	80002986 <writei>
    80002ce2:	1541                	addi	a0,a0,-16
    80002ce4:	00a03533          	snez	a0,a0
    80002ce8:	40a00533          	neg	a0,a0
    80002cec:	74a2                	ld	s1,40(sp)
}
    80002cee:	70e2                	ld	ra,56(sp)
    80002cf0:	7442                	ld	s0,48(sp)
    80002cf2:	7902                	ld	s2,32(sp)
    80002cf4:	69e2                	ld	s3,24(sp)
    80002cf6:	6a42                	ld	s4,16(sp)
    80002cf8:	6121                	addi	sp,sp,64
    80002cfa:	8082                	ret
    iput(ip);
    80002cfc:	abdff0ef          	jal	800027b8 <iput>
    return -1;
    80002d00:	557d                	li	a0,-1
    80002d02:	b7f5                	j	80002cee <dirlink+0x78>
      panic("dirlink read");
    80002d04:	00004517          	auipc	a0,0x4
    80002d08:	7f450513          	addi	a0,a0,2036 # 800074f8 <etext+0x4f8>
    80002d0c:	6d6020ef          	jal	800053e2 <panic>

0000000080002d10 <namei>:

struct inode*
namei(char *path)
{
    80002d10:	1101                	addi	sp,sp,-32
    80002d12:	ec06                	sd	ra,24(sp)
    80002d14:	e822                	sd	s0,16(sp)
    80002d16:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002d18:	fe040613          	addi	a2,s0,-32
    80002d1c:	4581                	li	a1,0
    80002d1e:	e29ff0ef          	jal	80002b46 <namex>
}
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	6105                	addi	sp,sp,32
    80002d28:	8082                	ret

0000000080002d2a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d2a:	1141                	addi	sp,sp,-16
    80002d2c:	e406                	sd	ra,8(sp)
    80002d2e:	e022                	sd	s0,0(sp)
    80002d30:	0800                	addi	s0,sp,16
    80002d32:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d34:	4585                	li	a1,1
    80002d36:	e11ff0ef          	jal	80002b46 <namex>
}
    80002d3a:	60a2                	ld	ra,8(sp)
    80002d3c:	6402                	ld	s0,0(sp)
    80002d3e:	0141                	addi	sp,sp,16
    80002d40:	8082                	ret

0000000080002d42 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	e426                	sd	s1,8(sp)
    80002d4a:	e04a                	sd	s2,0(sp)
    80002d4c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d4e:	00017917          	auipc	s2,0x17
    80002d52:	4c290913          	addi	s2,s2,1218 # 8001a210 <log>
    80002d56:	01892583          	lw	a1,24(s2)
    80002d5a:	02892503          	lw	a0,40(s2)
    80002d5e:	9a0ff0ef          	jal	80001efe <bread>
    80002d62:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d64:	02c92603          	lw	a2,44(s2)
    80002d68:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d6a:	00c05f63          	blez	a2,80002d88 <write_head+0x46>
    80002d6e:	00017717          	auipc	a4,0x17
    80002d72:	4d270713          	addi	a4,a4,1234 # 8001a240 <log+0x30>
    80002d76:	87aa                	mv	a5,a0
    80002d78:	060a                	slli	a2,a2,0x2
    80002d7a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002d7c:	4314                	lw	a3,0(a4)
    80002d7e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002d80:	0711                	addi	a4,a4,4
    80002d82:	0791                	addi	a5,a5,4
    80002d84:	fec79ce3          	bne	a5,a2,80002d7c <write_head+0x3a>
  }
  bwrite(buf);
    80002d88:	8526                	mv	a0,s1
    80002d8a:	a4aff0ef          	jal	80001fd4 <bwrite>
  brelse(buf);
    80002d8e:	8526                	mv	a0,s1
    80002d90:	a76ff0ef          	jal	80002006 <brelse>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002da0:	00017797          	auipc	a5,0x17
    80002da4:	49c7a783          	lw	a5,1180(a5) # 8001a23c <log+0x2c>
    80002da8:	08f05f63          	blez	a5,80002e46 <install_trans+0xa6>
{
    80002dac:	7139                	addi	sp,sp,-64
    80002dae:	fc06                	sd	ra,56(sp)
    80002db0:	f822                	sd	s0,48(sp)
    80002db2:	f426                	sd	s1,40(sp)
    80002db4:	f04a                	sd	s2,32(sp)
    80002db6:	ec4e                	sd	s3,24(sp)
    80002db8:	e852                	sd	s4,16(sp)
    80002dba:	e456                	sd	s5,8(sp)
    80002dbc:	e05a                	sd	s6,0(sp)
    80002dbe:	0080                	addi	s0,sp,64
    80002dc0:	8b2a                	mv	s6,a0
    80002dc2:	00017a97          	auipc	s5,0x17
    80002dc6:	47ea8a93          	addi	s5,s5,1150 # 8001a240 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dca:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dcc:	00017997          	auipc	s3,0x17
    80002dd0:	44498993          	addi	s3,s3,1092 # 8001a210 <log>
    80002dd4:	a829                	j	80002dee <install_trans+0x4e>
    brelse(lbuf);
    80002dd6:	854a                	mv	a0,s2
    80002dd8:	a2eff0ef          	jal	80002006 <brelse>
    brelse(dbuf);
    80002ddc:	8526                	mv	a0,s1
    80002dde:	a28ff0ef          	jal	80002006 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002de2:	2a05                	addiw	s4,s4,1
    80002de4:	0a91                	addi	s5,s5,4
    80002de6:	02c9a783          	lw	a5,44(s3)
    80002dea:	04fa5463          	bge	s4,a5,80002e32 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dee:	0189a583          	lw	a1,24(s3)
    80002df2:	014585bb          	addw	a1,a1,s4
    80002df6:	2585                	addiw	a1,a1,1
    80002df8:	0289a503          	lw	a0,40(s3)
    80002dfc:	902ff0ef          	jal	80001efe <bread>
    80002e00:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002e02:	000aa583          	lw	a1,0(s5)
    80002e06:	0289a503          	lw	a0,40(s3)
    80002e0a:	8f4ff0ef          	jal	80001efe <bread>
    80002e0e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e10:	40000613          	li	a2,1024
    80002e14:	05890593          	addi	a1,s2,88
    80002e18:	05850513          	addi	a0,a0,88
    80002e1c:	b74fd0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e20:	8526                	mv	a0,s1
    80002e22:	9b2ff0ef          	jal	80001fd4 <bwrite>
    if(recovering == 0)
    80002e26:	fa0b18e3          	bnez	s6,80002dd6 <install_trans+0x36>
      bunpin(dbuf);
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	a96ff0ef          	jal	800020c2 <bunpin>
    80002e30:	b75d                	j	80002dd6 <install_trans+0x36>
}
    80002e32:	70e2                	ld	ra,56(sp)
    80002e34:	7442                	ld	s0,48(sp)
    80002e36:	74a2                	ld	s1,40(sp)
    80002e38:	7902                	ld	s2,32(sp)
    80002e3a:	69e2                	ld	s3,24(sp)
    80002e3c:	6a42                	ld	s4,16(sp)
    80002e3e:	6aa2                	ld	s5,8(sp)
    80002e40:	6b02                	ld	s6,0(sp)
    80002e42:	6121                	addi	sp,sp,64
    80002e44:	8082                	ret
    80002e46:	8082                	ret

0000000080002e48 <initlog>:
{
    80002e48:	7179                	addi	sp,sp,-48
    80002e4a:	f406                	sd	ra,40(sp)
    80002e4c:	f022                	sd	s0,32(sp)
    80002e4e:	ec26                	sd	s1,24(sp)
    80002e50:	e84a                	sd	s2,16(sp)
    80002e52:	e44e                	sd	s3,8(sp)
    80002e54:	1800                	addi	s0,sp,48
    80002e56:	892a                	mv	s2,a0
    80002e58:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e5a:	00017497          	auipc	s1,0x17
    80002e5e:	3b648493          	addi	s1,s1,950 # 8001a210 <log>
    80002e62:	00004597          	auipc	a1,0x4
    80002e66:	6a658593          	addi	a1,a1,1702 # 80007508 <etext+0x508>
    80002e6a:	8526                	mv	a0,s1
    80002e6c:	025020ef          	jal	80005690 <initlock>
  log.start = sb->logstart;
    80002e70:	0149a583          	lw	a1,20(s3)
    80002e74:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e76:	0109a783          	lw	a5,16(s3)
    80002e7a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e7c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e80:	854a                	mv	a0,s2
    80002e82:	87cff0ef          	jal	80001efe <bread>
  log.lh.n = lh->n;
    80002e86:	4d30                	lw	a2,88(a0)
    80002e88:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e8a:	00c05f63          	blez	a2,80002ea8 <initlog+0x60>
    80002e8e:	87aa                	mv	a5,a0
    80002e90:	00017717          	auipc	a4,0x17
    80002e94:	3b070713          	addi	a4,a4,944 # 8001a240 <log+0x30>
    80002e98:	060a                	slli	a2,a2,0x2
    80002e9a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002e9c:	4ff4                	lw	a3,92(a5)
    80002e9e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002ea0:	0791                	addi	a5,a5,4
    80002ea2:	0711                	addi	a4,a4,4
    80002ea4:	fec79ce3          	bne	a5,a2,80002e9c <initlog+0x54>
  brelse(buf);
    80002ea8:	95eff0ef          	jal	80002006 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002eac:	4505                	li	a0,1
    80002eae:	ef3ff0ef          	jal	80002da0 <install_trans>
  log.lh.n = 0;
    80002eb2:	00017797          	auipc	a5,0x17
    80002eb6:	3807a523          	sw	zero,906(a5) # 8001a23c <log+0x2c>
  write_head(); // clear the log
    80002eba:	e89ff0ef          	jal	80002d42 <write_head>
}
    80002ebe:	70a2                	ld	ra,40(sp)
    80002ec0:	7402                	ld	s0,32(sp)
    80002ec2:	64e2                	ld	s1,24(sp)
    80002ec4:	6942                	ld	s2,16(sp)
    80002ec6:	69a2                	ld	s3,8(sp)
    80002ec8:	6145                	addi	sp,sp,48
    80002eca:	8082                	ret

0000000080002ecc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ecc:	1101                	addi	sp,sp,-32
    80002ece:	ec06                	sd	ra,24(sp)
    80002ed0:	e822                	sd	s0,16(sp)
    80002ed2:	e426                	sd	s1,8(sp)
    80002ed4:	e04a                	sd	s2,0(sp)
    80002ed6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ed8:	00017517          	auipc	a0,0x17
    80002edc:	33850513          	addi	a0,a0,824 # 8001a210 <log>
    80002ee0:	031020ef          	jal	80005710 <acquire>
  while(1){
    if(log.committing){
    80002ee4:	00017497          	auipc	s1,0x17
    80002ee8:	32c48493          	addi	s1,s1,812 # 8001a210 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002eec:	4979                	li	s2,30
    80002eee:	a029                	j	80002ef8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002ef0:	85a6                	mv	a1,s1
    80002ef2:	8526                	mv	a0,s1
    80002ef4:	c30fe0ef          	jal	80001324 <sleep>
    if(log.committing){
    80002ef8:	50dc                	lw	a5,36(s1)
    80002efa:	fbfd                	bnez	a5,80002ef0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002efc:	5098                	lw	a4,32(s1)
    80002efe:	2705                	addiw	a4,a4,1
    80002f00:	0027179b          	slliw	a5,a4,0x2
    80002f04:	9fb9                	addw	a5,a5,a4
    80002f06:	0017979b          	slliw	a5,a5,0x1
    80002f0a:	54d4                	lw	a3,44(s1)
    80002f0c:	9fb5                	addw	a5,a5,a3
    80002f0e:	00f95763          	bge	s2,a5,80002f1c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002f12:	85a6                	mv	a1,s1
    80002f14:	8526                	mv	a0,s1
    80002f16:	c0efe0ef          	jal	80001324 <sleep>
    80002f1a:	bff9                	j	80002ef8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002f1c:	00017517          	auipc	a0,0x17
    80002f20:	2f450513          	addi	a0,a0,756 # 8001a210 <log>
    80002f24:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002f26:	083020ef          	jal	800057a8 <release>
      break;
    }
  }
}
    80002f2a:	60e2                	ld	ra,24(sp)
    80002f2c:	6442                	ld	s0,16(sp)
    80002f2e:	64a2                	ld	s1,8(sp)
    80002f30:	6902                	ld	s2,0(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f36:	7139                	addi	sp,sp,-64
    80002f38:	fc06                	sd	ra,56(sp)
    80002f3a:	f822                	sd	s0,48(sp)
    80002f3c:	f426                	sd	s1,40(sp)
    80002f3e:	f04a                	sd	s2,32(sp)
    80002f40:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f42:	00017497          	auipc	s1,0x17
    80002f46:	2ce48493          	addi	s1,s1,718 # 8001a210 <log>
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	7c4020ef          	jal	80005710 <acquire>
  log.outstanding -= 1;
    80002f50:	509c                	lw	a5,32(s1)
    80002f52:	37fd                	addiw	a5,a5,-1
    80002f54:	0007891b          	sext.w	s2,a5
    80002f58:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f5a:	50dc                	lw	a5,36(s1)
    80002f5c:	ef9d                	bnez	a5,80002f9a <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f5e:	04091763          	bnez	s2,80002fac <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f62:	00017497          	auipc	s1,0x17
    80002f66:	2ae48493          	addi	s1,s1,686 # 8001a210 <log>
    80002f6a:	4785                	li	a5,1
    80002f6c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f6e:	8526                	mv	a0,s1
    80002f70:	039020ef          	jal	800057a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f74:	54dc                	lw	a5,44(s1)
    80002f76:	04f04b63          	bgtz	a5,80002fcc <end_op+0x96>
    acquire(&log.lock);
    80002f7a:	00017497          	auipc	s1,0x17
    80002f7e:	29648493          	addi	s1,s1,662 # 8001a210 <log>
    80002f82:	8526                	mv	a0,s1
    80002f84:	78c020ef          	jal	80005710 <acquire>
    log.committing = 0;
    80002f88:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f8c:	8526                	mv	a0,s1
    80002f8e:	be2fe0ef          	jal	80001370 <wakeup>
    release(&log.lock);
    80002f92:	8526                	mv	a0,s1
    80002f94:	015020ef          	jal	800057a8 <release>
}
    80002f98:	a025                	j	80002fc0 <end_op+0x8a>
    80002f9a:	ec4e                	sd	s3,24(sp)
    80002f9c:	e852                	sd	s4,16(sp)
    80002f9e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80002fa0:	00004517          	auipc	a0,0x4
    80002fa4:	57050513          	addi	a0,a0,1392 # 80007510 <etext+0x510>
    80002fa8:	43a020ef          	jal	800053e2 <panic>
    wakeup(&log);
    80002fac:	00017497          	auipc	s1,0x17
    80002fb0:	26448493          	addi	s1,s1,612 # 8001a210 <log>
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	bbafe0ef          	jal	80001370 <wakeup>
  release(&log.lock);
    80002fba:	8526                	mv	a0,s1
    80002fbc:	7ec020ef          	jal	800057a8 <release>
}
    80002fc0:	70e2                	ld	ra,56(sp)
    80002fc2:	7442                	ld	s0,48(sp)
    80002fc4:	74a2                	ld	s1,40(sp)
    80002fc6:	7902                	ld	s2,32(sp)
    80002fc8:	6121                	addi	sp,sp,64
    80002fca:	8082                	ret
    80002fcc:	ec4e                	sd	s3,24(sp)
    80002fce:	e852                	sd	s4,16(sp)
    80002fd0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd2:	00017a97          	auipc	s5,0x17
    80002fd6:	26ea8a93          	addi	s5,s5,622 # 8001a240 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002fda:	00017a17          	auipc	s4,0x17
    80002fde:	236a0a13          	addi	s4,s4,566 # 8001a210 <log>
    80002fe2:	018a2583          	lw	a1,24(s4)
    80002fe6:	012585bb          	addw	a1,a1,s2
    80002fea:	2585                	addiw	a1,a1,1
    80002fec:	028a2503          	lw	a0,40(s4)
    80002ff0:	f0ffe0ef          	jal	80001efe <bread>
    80002ff4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80002ff6:	000aa583          	lw	a1,0(s5)
    80002ffa:	028a2503          	lw	a0,40(s4)
    80002ffe:	f01fe0ef          	jal	80001efe <bread>
    80003002:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003004:	40000613          	li	a2,1024
    80003008:	05850593          	addi	a1,a0,88
    8000300c:	05848513          	addi	a0,s1,88
    80003010:	980fd0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    80003014:	8526                	mv	a0,s1
    80003016:	fbffe0ef          	jal	80001fd4 <bwrite>
    brelse(from);
    8000301a:	854e                	mv	a0,s3
    8000301c:	febfe0ef          	jal	80002006 <brelse>
    brelse(to);
    80003020:	8526                	mv	a0,s1
    80003022:	fe5fe0ef          	jal	80002006 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003026:	2905                	addiw	s2,s2,1
    80003028:	0a91                	addi	s5,s5,4
    8000302a:	02ca2783          	lw	a5,44(s4)
    8000302e:	faf94ae3          	blt	s2,a5,80002fe2 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003032:	d11ff0ef          	jal	80002d42 <write_head>
    install_trans(0); // Now install writes to home locations
    80003036:	4501                	li	a0,0
    80003038:	d69ff0ef          	jal	80002da0 <install_trans>
    log.lh.n = 0;
    8000303c:	00017797          	auipc	a5,0x17
    80003040:	2007a023          	sw	zero,512(a5) # 8001a23c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003044:	cffff0ef          	jal	80002d42 <write_head>
    80003048:	69e2                	ld	s3,24(sp)
    8000304a:	6a42                	ld	s4,16(sp)
    8000304c:	6aa2                	ld	s5,8(sp)
    8000304e:	b735                	j	80002f7a <end_op+0x44>

0000000080003050 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003050:	1101                	addi	sp,sp,-32
    80003052:	ec06                	sd	ra,24(sp)
    80003054:	e822                	sd	s0,16(sp)
    80003056:	e426                	sd	s1,8(sp)
    80003058:	e04a                	sd	s2,0(sp)
    8000305a:	1000                	addi	s0,sp,32
    8000305c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000305e:	00017917          	auipc	s2,0x17
    80003062:	1b290913          	addi	s2,s2,434 # 8001a210 <log>
    80003066:	854a                	mv	a0,s2
    80003068:	6a8020ef          	jal	80005710 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000306c:	02c92603          	lw	a2,44(s2)
    80003070:	47f5                	li	a5,29
    80003072:	06c7c363          	blt	a5,a2,800030d8 <log_write+0x88>
    80003076:	00017797          	auipc	a5,0x17
    8000307a:	1b67a783          	lw	a5,438(a5) # 8001a22c <log+0x1c>
    8000307e:	37fd                	addiw	a5,a5,-1
    80003080:	04f65c63          	bge	a2,a5,800030d8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003084:	00017797          	auipc	a5,0x17
    80003088:	1ac7a783          	lw	a5,428(a5) # 8001a230 <log+0x20>
    8000308c:	04f05c63          	blez	a5,800030e4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003090:	4781                	li	a5,0
    80003092:	04c05f63          	blez	a2,800030f0 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003096:	44cc                	lw	a1,12(s1)
    80003098:	00017717          	auipc	a4,0x17
    8000309c:	1a870713          	addi	a4,a4,424 # 8001a240 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800030a0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030a2:	4314                	lw	a3,0(a4)
    800030a4:	04b68663          	beq	a3,a1,800030f0 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800030a8:	2785                	addiw	a5,a5,1
    800030aa:	0711                	addi	a4,a4,4
    800030ac:	fef61be3          	bne	a2,a5,800030a2 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800030b0:	0621                	addi	a2,a2,8
    800030b2:	060a                	slli	a2,a2,0x2
    800030b4:	00017797          	auipc	a5,0x17
    800030b8:	15c78793          	addi	a5,a5,348 # 8001a210 <log>
    800030bc:	97b2                	add	a5,a5,a2
    800030be:	44d8                	lw	a4,12(s1)
    800030c0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030c2:	8526                	mv	a0,s1
    800030c4:	fcbfe0ef          	jal	8000208e <bpin>
    log.lh.n++;
    800030c8:	00017717          	auipc	a4,0x17
    800030cc:	14870713          	addi	a4,a4,328 # 8001a210 <log>
    800030d0:	575c                	lw	a5,44(a4)
    800030d2:	2785                	addiw	a5,a5,1
    800030d4:	d75c                	sw	a5,44(a4)
    800030d6:	a80d                	j	80003108 <log_write+0xb8>
    panic("too big a transaction");
    800030d8:	00004517          	auipc	a0,0x4
    800030dc:	44850513          	addi	a0,a0,1096 # 80007520 <etext+0x520>
    800030e0:	302020ef          	jal	800053e2 <panic>
    panic("log_write outside of trans");
    800030e4:	00004517          	auipc	a0,0x4
    800030e8:	45450513          	addi	a0,a0,1108 # 80007538 <etext+0x538>
    800030ec:	2f6020ef          	jal	800053e2 <panic>
  log.lh.block[i] = b->blockno;
    800030f0:	00878693          	addi	a3,a5,8
    800030f4:	068a                	slli	a3,a3,0x2
    800030f6:	00017717          	auipc	a4,0x17
    800030fa:	11a70713          	addi	a4,a4,282 # 8001a210 <log>
    800030fe:	9736                	add	a4,a4,a3
    80003100:	44d4                	lw	a3,12(s1)
    80003102:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003104:	faf60fe3          	beq	a2,a5,800030c2 <log_write+0x72>
  }
  release(&log.lock);
    80003108:	00017517          	auipc	a0,0x17
    8000310c:	10850513          	addi	a0,a0,264 # 8001a210 <log>
    80003110:	698020ef          	jal	800057a8 <release>
}
    80003114:	60e2                	ld	ra,24(sp)
    80003116:	6442                	ld	s0,16(sp)
    80003118:	64a2                	ld	s1,8(sp)
    8000311a:	6902                	ld	s2,0(sp)
    8000311c:	6105                	addi	sp,sp,32
    8000311e:	8082                	ret

0000000080003120 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003120:	1101                	addi	sp,sp,-32
    80003122:	ec06                	sd	ra,24(sp)
    80003124:	e822                	sd	s0,16(sp)
    80003126:	e426                	sd	s1,8(sp)
    80003128:	e04a                	sd	s2,0(sp)
    8000312a:	1000                	addi	s0,sp,32
    8000312c:	84aa                	mv	s1,a0
    8000312e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003130:	00004597          	auipc	a1,0x4
    80003134:	42858593          	addi	a1,a1,1064 # 80007558 <etext+0x558>
    80003138:	0521                	addi	a0,a0,8
    8000313a:	556020ef          	jal	80005690 <initlock>
  lk->name = name;
    8000313e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003142:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003146:	0204a423          	sw	zero,40(s1)
}
    8000314a:	60e2                	ld	ra,24(sp)
    8000314c:	6442                	ld	s0,16(sp)
    8000314e:	64a2                	ld	s1,8(sp)
    80003150:	6902                	ld	s2,0(sp)
    80003152:	6105                	addi	sp,sp,32
    80003154:	8082                	ret

0000000080003156 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003156:	1101                	addi	sp,sp,-32
    80003158:	ec06                	sd	ra,24(sp)
    8000315a:	e822                	sd	s0,16(sp)
    8000315c:	e426                	sd	s1,8(sp)
    8000315e:	e04a                	sd	s2,0(sp)
    80003160:	1000                	addi	s0,sp,32
    80003162:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003164:	00850913          	addi	s2,a0,8
    80003168:	854a                	mv	a0,s2
    8000316a:	5a6020ef          	jal	80005710 <acquire>
  while (lk->locked) {
    8000316e:	409c                	lw	a5,0(s1)
    80003170:	c799                	beqz	a5,8000317e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003172:	85ca                	mv	a1,s2
    80003174:	8526                	mv	a0,s1
    80003176:	9aefe0ef          	jal	80001324 <sleep>
  while (lk->locked) {
    8000317a:	409c                	lw	a5,0(s1)
    8000317c:	fbfd                	bnez	a5,80003172 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000317e:	4785                	li	a5,1
    80003180:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003182:	bd5fd0ef          	jal	80000d56 <myproc>
    80003186:	591c                	lw	a5,48(a0)
    80003188:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000318a:	854a                	mv	a0,s2
    8000318c:	61c020ef          	jal	800057a8 <release>
}
    80003190:	60e2                	ld	ra,24(sp)
    80003192:	6442                	ld	s0,16(sp)
    80003194:	64a2                	ld	s1,8(sp)
    80003196:	6902                	ld	s2,0(sp)
    80003198:	6105                	addi	sp,sp,32
    8000319a:	8082                	ret

000000008000319c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000319c:	1101                	addi	sp,sp,-32
    8000319e:	ec06                	sd	ra,24(sp)
    800031a0:	e822                	sd	s0,16(sp)
    800031a2:	e426                	sd	s1,8(sp)
    800031a4:	e04a                	sd	s2,0(sp)
    800031a6:	1000                	addi	s0,sp,32
    800031a8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800031aa:	00850913          	addi	s2,a0,8
    800031ae:	854a                	mv	a0,s2
    800031b0:	560020ef          	jal	80005710 <acquire>
  lk->locked = 0;
    800031b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031b8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031bc:	8526                	mv	a0,s1
    800031be:	9b2fe0ef          	jal	80001370 <wakeup>
  release(&lk->lk);
    800031c2:	854a                	mv	a0,s2
    800031c4:	5e4020ef          	jal	800057a8 <release>
}
    800031c8:	60e2                	ld	ra,24(sp)
    800031ca:	6442                	ld	s0,16(sp)
    800031cc:	64a2                	ld	s1,8(sp)
    800031ce:	6902                	ld	s2,0(sp)
    800031d0:	6105                	addi	sp,sp,32
    800031d2:	8082                	ret

00000000800031d4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031d4:	7179                	addi	sp,sp,-48
    800031d6:	f406                	sd	ra,40(sp)
    800031d8:	f022                	sd	s0,32(sp)
    800031da:	ec26                	sd	s1,24(sp)
    800031dc:	e84a                	sd	s2,16(sp)
    800031de:	1800                	addi	s0,sp,48
    800031e0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031e2:	00850913          	addi	s2,a0,8
    800031e6:	854a                	mv	a0,s2
    800031e8:	528020ef          	jal	80005710 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800031ec:	409c                	lw	a5,0(s1)
    800031ee:	ef81                	bnez	a5,80003206 <holdingsleep+0x32>
    800031f0:	4481                	li	s1,0
  release(&lk->lk);
    800031f2:	854a                	mv	a0,s2
    800031f4:	5b4020ef          	jal	800057a8 <release>
  return r;
}
    800031f8:	8526                	mv	a0,s1
    800031fa:	70a2                	ld	ra,40(sp)
    800031fc:	7402                	ld	s0,32(sp)
    800031fe:	64e2                	ld	s1,24(sp)
    80003200:	6942                	ld	s2,16(sp)
    80003202:	6145                	addi	sp,sp,48
    80003204:	8082                	ret
    80003206:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003208:	0284a983          	lw	s3,40(s1)
    8000320c:	b4bfd0ef          	jal	80000d56 <myproc>
    80003210:	5904                	lw	s1,48(a0)
    80003212:	413484b3          	sub	s1,s1,s3
    80003216:	0014b493          	seqz	s1,s1
    8000321a:	69a2                	ld	s3,8(sp)
    8000321c:	bfd9                	j	800031f2 <holdingsleep+0x1e>

000000008000321e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000321e:	1141                	addi	sp,sp,-16
    80003220:	e406                	sd	ra,8(sp)
    80003222:	e022                	sd	s0,0(sp)
    80003224:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003226:	00004597          	auipc	a1,0x4
    8000322a:	34258593          	addi	a1,a1,834 # 80007568 <etext+0x568>
    8000322e:	00017517          	auipc	a0,0x17
    80003232:	12a50513          	addi	a0,a0,298 # 8001a358 <ftable>
    80003236:	45a020ef          	jal	80005690 <initlock>
}
    8000323a:	60a2                	ld	ra,8(sp)
    8000323c:	6402                	ld	s0,0(sp)
    8000323e:	0141                	addi	sp,sp,16
    80003240:	8082                	ret

0000000080003242 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003242:	1101                	addi	sp,sp,-32
    80003244:	ec06                	sd	ra,24(sp)
    80003246:	e822                	sd	s0,16(sp)
    80003248:	e426                	sd	s1,8(sp)
    8000324a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000324c:	00017517          	auipc	a0,0x17
    80003250:	10c50513          	addi	a0,a0,268 # 8001a358 <ftable>
    80003254:	4bc020ef          	jal	80005710 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003258:	00017497          	auipc	s1,0x17
    8000325c:	11848493          	addi	s1,s1,280 # 8001a370 <ftable+0x18>
    80003260:	00018717          	auipc	a4,0x18
    80003264:	0b070713          	addi	a4,a4,176 # 8001b310 <disk>
    if(f->ref == 0){
    80003268:	40dc                	lw	a5,4(s1)
    8000326a:	cf89                	beqz	a5,80003284 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000326c:	02848493          	addi	s1,s1,40
    80003270:	fee49ce3          	bne	s1,a4,80003268 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003274:	00017517          	auipc	a0,0x17
    80003278:	0e450513          	addi	a0,a0,228 # 8001a358 <ftable>
    8000327c:	52c020ef          	jal	800057a8 <release>
  return 0;
    80003280:	4481                	li	s1,0
    80003282:	a809                	j	80003294 <filealloc+0x52>
      f->ref = 1;
    80003284:	4785                	li	a5,1
    80003286:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003288:	00017517          	auipc	a0,0x17
    8000328c:	0d050513          	addi	a0,a0,208 # 8001a358 <ftable>
    80003290:	518020ef          	jal	800057a8 <release>
}
    80003294:	8526                	mv	a0,s1
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	64a2                	ld	s1,8(sp)
    8000329c:	6105                	addi	sp,sp,32
    8000329e:	8082                	ret

00000000800032a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800032a0:	1101                	addi	sp,sp,-32
    800032a2:	ec06                	sd	ra,24(sp)
    800032a4:	e822                	sd	s0,16(sp)
    800032a6:	e426                	sd	s1,8(sp)
    800032a8:	1000                	addi	s0,sp,32
    800032aa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800032ac:	00017517          	auipc	a0,0x17
    800032b0:	0ac50513          	addi	a0,a0,172 # 8001a358 <ftable>
    800032b4:	45c020ef          	jal	80005710 <acquire>
  if(f->ref < 1)
    800032b8:	40dc                	lw	a5,4(s1)
    800032ba:	02f05063          	blez	a5,800032da <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032be:	2785                	addiw	a5,a5,1
    800032c0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032c2:	00017517          	auipc	a0,0x17
    800032c6:	09650513          	addi	a0,a0,150 # 8001a358 <ftable>
    800032ca:	4de020ef          	jal	800057a8 <release>
  return f;
}
    800032ce:	8526                	mv	a0,s1
    800032d0:	60e2                	ld	ra,24(sp)
    800032d2:	6442                	ld	s0,16(sp)
    800032d4:	64a2                	ld	s1,8(sp)
    800032d6:	6105                	addi	sp,sp,32
    800032d8:	8082                	ret
    panic("filedup");
    800032da:	00004517          	auipc	a0,0x4
    800032de:	29650513          	addi	a0,a0,662 # 80007570 <etext+0x570>
    800032e2:	100020ef          	jal	800053e2 <panic>

00000000800032e6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032e6:	7139                	addi	sp,sp,-64
    800032e8:	fc06                	sd	ra,56(sp)
    800032ea:	f822                	sd	s0,48(sp)
    800032ec:	f426                	sd	s1,40(sp)
    800032ee:	0080                	addi	s0,sp,64
    800032f0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800032f2:	00017517          	auipc	a0,0x17
    800032f6:	06650513          	addi	a0,a0,102 # 8001a358 <ftable>
    800032fa:	416020ef          	jal	80005710 <acquire>
  if(f->ref < 1)
    800032fe:	40dc                	lw	a5,4(s1)
    80003300:	04f05a63          	blez	a5,80003354 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003304:	37fd                	addiw	a5,a5,-1
    80003306:	0007871b          	sext.w	a4,a5
    8000330a:	c0dc                	sw	a5,4(s1)
    8000330c:	04e04e63          	bgtz	a4,80003368 <fileclose+0x82>
    80003310:	f04a                	sd	s2,32(sp)
    80003312:	ec4e                	sd	s3,24(sp)
    80003314:	e852                	sd	s4,16(sp)
    80003316:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003318:	0004a903          	lw	s2,0(s1)
    8000331c:	0094ca83          	lbu	s5,9(s1)
    80003320:	0104ba03          	ld	s4,16(s1)
    80003324:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003328:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000332c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003330:	00017517          	auipc	a0,0x17
    80003334:	02850513          	addi	a0,a0,40 # 8001a358 <ftable>
    80003338:	470020ef          	jal	800057a8 <release>

  if(ff.type == FD_PIPE){
    8000333c:	4785                	li	a5,1
    8000333e:	04f90063          	beq	s2,a5,8000337e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003342:	3979                	addiw	s2,s2,-2
    80003344:	4785                	li	a5,1
    80003346:	0527f563          	bgeu	a5,s2,80003390 <fileclose+0xaa>
    8000334a:	7902                	ld	s2,32(sp)
    8000334c:	69e2                	ld	s3,24(sp)
    8000334e:	6a42                	ld	s4,16(sp)
    80003350:	6aa2                	ld	s5,8(sp)
    80003352:	a00d                	j	80003374 <fileclose+0x8e>
    80003354:	f04a                	sd	s2,32(sp)
    80003356:	ec4e                	sd	s3,24(sp)
    80003358:	e852                	sd	s4,16(sp)
    8000335a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000335c:	00004517          	auipc	a0,0x4
    80003360:	21c50513          	addi	a0,a0,540 # 80007578 <etext+0x578>
    80003364:	07e020ef          	jal	800053e2 <panic>
    release(&ftable.lock);
    80003368:	00017517          	auipc	a0,0x17
    8000336c:	ff050513          	addi	a0,a0,-16 # 8001a358 <ftable>
    80003370:	438020ef          	jal	800057a8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003374:	70e2                	ld	ra,56(sp)
    80003376:	7442                	ld	s0,48(sp)
    80003378:	74a2                	ld	s1,40(sp)
    8000337a:	6121                	addi	sp,sp,64
    8000337c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000337e:	85d6                	mv	a1,s5
    80003380:	8552                	mv	a0,s4
    80003382:	336000ef          	jal	800036b8 <pipeclose>
    80003386:	7902                	ld	s2,32(sp)
    80003388:	69e2                	ld	s3,24(sp)
    8000338a:	6a42                	ld	s4,16(sp)
    8000338c:	6aa2                	ld	s5,8(sp)
    8000338e:	b7dd                	j	80003374 <fileclose+0x8e>
    begin_op();
    80003390:	b3dff0ef          	jal	80002ecc <begin_op>
    iput(ff.ip);
    80003394:	854e                	mv	a0,s3
    80003396:	c22ff0ef          	jal	800027b8 <iput>
    end_op();
    8000339a:	b9dff0ef          	jal	80002f36 <end_op>
    8000339e:	7902                	ld	s2,32(sp)
    800033a0:	69e2                	ld	s3,24(sp)
    800033a2:	6a42                	ld	s4,16(sp)
    800033a4:	6aa2                	ld	s5,8(sp)
    800033a6:	b7f9                	j	80003374 <fileclose+0x8e>

00000000800033a8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800033a8:	715d                	addi	sp,sp,-80
    800033aa:	e486                	sd	ra,72(sp)
    800033ac:	e0a2                	sd	s0,64(sp)
    800033ae:	fc26                	sd	s1,56(sp)
    800033b0:	f44e                	sd	s3,40(sp)
    800033b2:	0880                	addi	s0,sp,80
    800033b4:	84aa                	mv	s1,a0
    800033b6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800033b8:	99ffd0ef          	jal	80000d56 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800033bc:	409c                	lw	a5,0(s1)
    800033be:	37f9                	addiw	a5,a5,-2
    800033c0:	4705                	li	a4,1
    800033c2:	04f76063          	bltu	a4,a5,80003402 <filestat+0x5a>
    800033c6:	f84a                	sd	s2,48(sp)
    800033c8:	892a                	mv	s2,a0
    ilock(f->ip);
    800033ca:	6c88                	ld	a0,24(s1)
    800033cc:	a6aff0ef          	jal	80002636 <ilock>
    stati(f->ip, &st);
    800033d0:	fb840593          	addi	a1,s0,-72
    800033d4:	6c88                	ld	a0,24(s1)
    800033d6:	c8aff0ef          	jal	80002860 <stati>
    iunlock(f->ip);
    800033da:	6c88                	ld	a0,24(s1)
    800033dc:	b08ff0ef          	jal	800026e4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033e0:	46e1                	li	a3,24
    800033e2:	fb840613          	addi	a2,s0,-72
    800033e6:	85ce                	mv	a1,s3
    800033e8:	05093503          	ld	a0,80(s2)
    800033ec:	ddafd0ef          	jal	800009c6 <copyout>
    800033f0:	41f5551b          	sraiw	a0,a0,0x1f
    800033f4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800033f6:	60a6                	ld	ra,72(sp)
    800033f8:	6406                	ld	s0,64(sp)
    800033fa:	74e2                	ld	s1,56(sp)
    800033fc:	79a2                	ld	s3,40(sp)
    800033fe:	6161                	addi	sp,sp,80
    80003400:	8082                	ret
  return -1;
    80003402:	557d                	li	a0,-1
    80003404:	bfcd                	j	800033f6 <filestat+0x4e>

0000000080003406 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003406:	7179                	addi	sp,sp,-48
    80003408:	f406                	sd	ra,40(sp)
    8000340a:	f022                	sd	s0,32(sp)
    8000340c:	e84a                	sd	s2,16(sp)
    8000340e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003410:	00854783          	lbu	a5,8(a0)
    80003414:	cfd1                	beqz	a5,800034b0 <fileread+0xaa>
    80003416:	ec26                	sd	s1,24(sp)
    80003418:	e44e                	sd	s3,8(sp)
    8000341a:	84aa                	mv	s1,a0
    8000341c:	89ae                	mv	s3,a1
    8000341e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003420:	411c                	lw	a5,0(a0)
    80003422:	4705                	li	a4,1
    80003424:	04e78363          	beq	a5,a4,8000346a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003428:	470d                	li	a4,3
    8000342a:	04e78763          	beq	a5,a4,80003478 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000342e:	4709                	li	a4,2
    80003430:	06e79a63          	bne	a5,a4,800034a4 <fileread+0x9e>
    ilock(f->ip);
    80003434:	6d08                	ld	a0,24(a0)
    80003436:	a00ff0ef          	jal	80002636 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000343a:	874a                	mv	a4,s2
    8000343c:	5094                	lw	a3,32(s1)
    8000343e:	864e                	mv	a2,s3
    80003440:	4585                	li	a1,1
    80003442:	6c88                	ld	a0,24(s1)
    80003444:	c46ff0ef          	jal	8000288a <readi>
    80003448:	892a                	mv	s2,a0
    8000344a:	00a05563          	blez	a0,80003454 <fileread+0x4e>
      f->off += r;
    8000344e:	509c                	lw	a5,32(s1)
    80003450:	9fa9                	addw	a5,a5,a0
    80003452:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003454:	6c88                	ld	a0,24(s1)
    80003456:	a8eff0ef          	jal	800026e4 <iunlock>
    8000345a:	64e2                	ld	s1,24(sp)
    8000345c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000345e:	854a                	mv	a0,s2
    80003460:	70a2                	ld	ra,40(sp)
    80003462:	7402                	ld	s0,32(sp)
    80003464:	6942                	ld	s2,16(sp)
    80003466:	6145                	addi	sp,sp,48
    80003468:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000346a:	6908                	ld	a0,16(a0)
    8000346c:	388000ef          	jal	800037f4 <piperead>
    80003470:	892a                	mv	s2,a0
    80003472:	64e2                	ld	s1,24(sp)
    80003474:	69a2                	ld	s3,8(sp)
    80003476:	b7e5                	j	8000345e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003478:	02451783          	lh	a5,36(a0)
    8000347c:	03079693          	slli	a3,a5,0x30
    80003480:	92c1                	srli	a3,a3,0x30
    80003482:	4725                	li	a4,9
    80003484:	02d76863          	bltu	a4,a3,800034b4 <fileread+0xae>
    80003488:	0792                	slli	a5,a5,0x4
    8000348a:	00017717          	auipc	a4,0x17
    8000348e:	e2e70713          	addi	a4,a4,-466 # 8001a2b8 <devsw>
    80003492:	97ba                	add	a5,a5,a4
    80003494:	639c                	ld	a5,0(a5)
    80003496:	c39d                	beqz	a5,800034bc <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003498:	4505                	li	a0,1
    8000349a:	9782                	jalr	a5
    8000349c:	892a                	mv	s2,a0
    8000349e:	64e2                	ld	s1,24(sp)
    800034a0:	69a2                	ld	s3,8(sp)
    800034a2:	bf75                	j	8000345e <fileread+0x58>
    panic("fileread");
    800034a4:	00004517          	auipc	a0,0x4
    800034a8:	0e450513          	addi	a0,a0,228 # 80007588 <etext+0x588>
    800034ac:	737010ef          	jal	800053e2 <panic>
    return -1;
    800034b0:	597d                	li	s2,-1
    800034b2:	b775                	j	8000345e <fileread+0x58>
      return -1;
    800034b4:	597d                	li	s2,-1
    800034b6:	64e2                	ld	s1,24(sp)
    800034b8:	69a2                	ld	s3,8(sp)
    800034ba:	b755                	j	8000345e <fileread+0x58>
    800034bc:	597d                	li	s2,-1
    800034be:	64e2                	ld	s1,24(sp)
    800034c0:	69a2                	ld	s3,8(sp)
    800034c2:	bf71                	j	8000345e <fileread+0x58>

00000000800034c4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800034c4:	00954783          	lbu	a5,9(a0)
    800034c8:	10078b63          	beqz	a5,800035de <filewrite+0x11a>
{
    800034cc:	715d                	addi	sp,sp,-80
    800034ce:	e486                	sd	ra,72(sp)
    800034d0:	e0a2                	sd	s0,64(sp)
    800034d2:	f84a                	sd	s2,48(sp)
    800034d4:	f052                	sd	s4,32(sp)
    800034d6:	e85a                	sd	s6,16(sp)
    800034d8:	0880                	addi	s0,sp,80
    800034da:	892a                	mv	s2,a0
    800034dc:	8b2e                	mv	s6,a1
    800034de:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800034e0:	411c                	lw	a5,0(a0)
    800034e2:	4705                	li	a4,1
    800034e4:	02e78763          	beq	a5,a4,80003512 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034e8:	470d                	li	a4,3
    800034ea:	02e78863          	beq	a5,a4,8000351a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800034ee:	4709                	li	a4,2
    800034f0:	0ce79c63          	bne	a5,a4,800035c8 <filewrite+0x104>
    800034f4:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800034f6:	0ac05863          	blez	a2,800035a6 <filewrite+0xe2>
    800034fa:	fc26                	sd	s1,56(sp)
    800034fc:	ec56                	sd	s5,24(sp)
    800034fe:	e45e                	sd	s7,8(sp)
    80003500:	e062                	sd	s8,0(sp)
    int i = 0;
    80003502:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003504:	6b85                	lui	s7,0x1
    80003506:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000350a:	6c05                	lui	s8,0x1
    8000350c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003510:	a8b5                	j	8000358c <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003512:	6908                	ld	a0,16(a0)
    80003514:	1fc000ef          	jal	80003710 <pipewrite>
    80003518:	a04d                	j	800035ba <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000351a:	02451783          	lh	a5,36(a0)
    8000351e:	03079693          	slli	a3,a5,0x30
    80003522:	92c1                	srli	a3,a3,0x30
    80003524:	4725                	li	a4,9
    80003526:	0ad76e63          	bltu	a4,a3,800035e2 <filewrite+0x11e>
    8000352a:	0792                	slli	a5,a5,0x4
    8000352c:	00017717          	auipc	a4,0x17
    80003530:	d8c70713          	addi	a4,a4,-628 # 8001a2b8 <devsw>
    80003534:	97ba                	add	a5,a5,a4
    80003536:	679c                	ld	a5,8(a5)
    80003538:	c7dd                	beqz	a5,800035e6 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000353a:	4505                	li	a0,1
    8000353c:	9782                	jalr	a5
    8000353e:	a8b5                	j	800035ba <filewrite+0xf6>
      if(n1 > max)
    80003540:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003544:	989ff0ef          	jal	80002ecc <begin_op>
      ilock(f->ip);
    80003548:	01893503          	ld	a0,24(s2)
    8000354c:	8eaff0ef          	jal	80002636 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003550:	8756                	mv	a4,s5
    80003552:	02092683          	lw	a3,32(s2)
    80003556:	01698633          	add	a2,s3,s6
    8000355a:	4585                	li	a1,1
    8000355c:	01893503          	ld	a0,24(s2)
    80003560:	c26ff0ef          	jal	80002986 <writei>
    80003564:	84aa                	mv	s1,a0
    80003566:	00a05763          	blez	a0,80003574 <filewrite+0xb0>
        f->off += r;
    8000356a:	02092783          	lw	a5,32(s2)
    8000356e:	9fa9                	addw	a5,a5,a0
    80003570:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003574:	01893503          	ld	a0,24(s2)
    80003578:	96cff0ef          	jal	800026e4 <iunlock>
      end_op();
    8000357c:	9bbff0ef          	jal	80002f36 <end_op>

      if(r != n1){
    80003580:	029a9563          	bne	s5,s1,800035aa <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003584:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003588:	0149da63          	bge	s3,s4,8000359c <filewrite+0xd8>
      int n1 = n - i;
    8000358c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003590:	0004879b          	sext.w	a5,s1
    80003594:	fafbd6e3          	bge	s7,a5,80003540 <filewrite+0x7c>
    80003598:	84e2                	mv	s1,s8
    8000359a:	b75d                	j	80003540 <filewrite+0x7c>
    8000359c:	74e2                	ld	s1,56(sp)
    8000359e:	6ae2                	ld	s5,24(sp)
    800035a0:	6ba2                	ld	s7,8(sp)
    800035a2:	6c02                	ld	s8,0(sp)
    800035a4:	a039                	j	800035b2 <filewrite+0xee>
    int i = 0;
    800035a6:	4981                	li	s3,0
    800035a8:	a029                	j	800035b2 <filewrite+0xee>
    800035aa:	74e2                	ld	s1,56(sp)
    800035ac:	6ae2                	ld	s5,24(sp)
    800035ae:	6ba2                	ld	s7,8(sp)
    800035b0:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800035b2:	033a1c63          	bne	s4,s3,800035ea <filewrite+0x126>
    800035b6:	8552                	mv	a0,s4
    800035b8:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800035ba:	60a6                	ld	ra,72(sp)
    800035bc:	6406                	ld	s0,64(sp)
    800035be:	7942                	ld	s2,48(sp)
    800035c0:	7a02                	ld	s4,32(sp)
    800035c2:	6b42                	ld	s6,16(sp)
    800035c4:	6161                	addi	sp,sp,80
    800035c6:	8082                	ret
    800035c8:	fc26                	sd	s1,56(sp)
    800035ca:	f44e                	sd	s3,40(sp)
    800035cc:	ec56                	sd	s5,24(sp)
    800035ce:	e45e                	sd	s7,8(sp)
    800035d0:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800035d2:	00004517          	auipc	a0,0x4
    800035d6:	fc650513          	addi	a0,a0,-58 # 80007598 <etext+0x598>
    800035da:	609010ef          	jal	800053e2 <panic>
    return -1;
    800035de:	557d                	li	a0,-1
}
    800035e0:	8082                	ret
      return -1;
    800035e2:	557d                	li	a0,-1
    800035e4:	bfd9                	j	800035ba <filewrite+0xf6>
    800035e6:	557d                	li	a0,-1
    800035e8:	bfc9                	j	800035ba <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800035ea:	557d                	li	a0,-1
    800035ec:	79a2                	ld	s3,40(sp)
    800035ee:	b7f1                	j	800035ba <filewrite+0xf6>

00000000800035f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800035f0:	7179                	addi	sp,sp,-48
    800035f2:	f406                	sd	ra,40(sp)
    800035f4:	f022                	sd	s0,32(sp)
    800035f6:	ec26                	sd	s1,24(sp)
    800035f8:	e052                	sd	s4,0(sp)
    800035fa:	1800                	addi	s0,sp,48
    800035fc:	84aa                	mv	s1,a0
    800035fe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003600:	0005b023          	sd	zero,0(a1)
    80003604:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003608:	c3bff0ef          	jal	80003242 <filealloc>
    8000360c:	e088                	sd	a0,0(s1)
    8000360e:	c549                	beqz	a0,80003698 <pipealloc+0xa8>
    80003610:	c33ff0ef          	jal	80003242 <filealloc>
    80003614:	00aa3023          	sd	a0,0(s4)
    80003618:	cd25                	beqz	a0,80003690 <pipealloc+0xa0>
    8000361a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000361c:	adbfc0ef          	jal	800000f6 <kalloc>
    80003620:	892a                	mv	s2,a0
    80003622:	c12d                	beqz	a0,80003684 <pipealloc+0x94>
    80003624:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003626:	4985                	li	s3,1
    80003628:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000362c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003630:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003634:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003638:	00004597          	auipc	a1,0x4
    8000363c:	f7058593          	addi	a1,a1,-144 # 800075a8 <etext+0x5a8>
    80003640:	050020ef          	jal	80005690 <initlock>
  (*f0)->type = FD_PIPE;
    80003644:	609c                	ld	a5,0(s1)
    80003646:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000364a:	609c                	ld	a5,0(s1)
    8000364c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003650:	609c                	ld	a5,0(s1)
    80003652:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003656:	609c                	ld	a5,0(s1)
    80003658:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000365c:	000a3783          	ld	a5,0(s4)
    80003660:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003664:	000a3783          	ld	a5,0(s4)
    80003668:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000366c:	000a3783          	ld	a5,0(s4)
    80003670:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003674:	000a3783          	ld	a5,0(s4)
    80003678:	0127b823          	sd	s2,16(a5)
  return 0;
    8000367c:	4501                	li	a0,0
    8000367e:	6942                	ld	s2,16(sp)
    80003680:	69a2                	ld	s3,8(sp)
    80003682:	a01d                	j	800036a8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003684:	6088                	ld	a0,0(s1)
    80003686:	c119                	beqz	a0,8000368c <pipealloc+0x9c>
    80003688:	6942                	ld	s2,16(sp)
    8000368a:	a029                	j	80003694 <pipealloc+0xa4>
    8000368c:	6942                	ld	s2,16(sp)
    8000368e:	a029                	j	80003698 <pipealloc+0xa8>
    80003690:	6088                	ld	a0,0(s1)
    80003692:	c10d                	beqz	a0,800036b4 <pipealloc+0xc4>
    fileclose(*f0);
    80003694:	c53ff0ef          	jal	800032e6 <fileclose>
  if(*f1)
    80003698:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000369c:	557d                	li	a0,-1
  if(*f1)
    8000369e:	c789                	beqz	a5,800036a8 <pipealloc+0xb8>
    fileclose(*f1);
    800036a0:	853e                	mv	a0,a5
    800036a2:	c45ff0ef          	jal	800032e6 <fileclose>
  return -1;
    800036a6:	557d                	li	a0,-1
}
    800036a8:	70a2                	ld	ra,40(sp)
    800036aa:	7402                	ld	s0,32(sp)
    800036ac:	64e2                	ld	s1,24(sp)
    800036ae:	6a02                	ld	s4,0(sp)
    800036b0:	6145                	addi	sp,sp,48
    800036b2:	8082                	ret
  return -1;
    800036b4:	557d                	li	a0,-1
    800036b6:	bfcd                	j	800036a8 <pipealloc+0xb8>

00000000800036b8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800036b8:	1101                	addi	sp,sp,-32
    800036ba:	ec06                	sd	ra,24(sp)
    800036bc:	e822                	sd	s0,16(sp)
    800036be:	e426                	sd	s1,8(sp)
    800036c0:	e04a                	sd	s2,0(sp)
    800036c2:	1000                	addi	s0,sp,32
    800036c4:	84aa                	mv	s1,a0
    800036c6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800036c8:	048020ef          	jal	80005710 <acquire>
  if(writable){
    800036cc:	02090763          	beqz	s2,800036fa <pipeclose+0x42>
    pi->writeopen = 0;
    800036d0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800036d4:	21848513          	addi	a0,s1,536
    800036d8:	c99fd0ef          	jal	80001370 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036dc:	2204b783          	ld	a5,544(s1)
    800036e0:	e785                	bnez	a5,80003708 <pipeclose+0x50>
    release(&pi->lock);
    800036e2:	8526                	mv	a0,s1
    800036e4:	0c4020ef          	jal	800057a8 <release>
    kfree((char*)pi);
    800036e8:	8526                	mv	a0,s1
    800036ea:	933fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800036ee:	60e2                	ld	ra,24(sp)
    800036f0:	6442                	ld	s0,16(sp)
    800036f2:	64a2                	ld	s1,8(sp)
    800036f4:	6902                	ld	s2,0(sp)
    800036f6:	6105                	addi	sp,sp,32
    800036f8:	8082                	ret
    pi->readopen = 0;
    800036fa:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800036fe:	21c48513          	addi	a0,s1,540
    80003702:	c6ffd0ef          	jal	80001370 <wakeup>
    80003706:	bfd9                	j	800036dc <pipeclose+0x24>
    release(&pi->lock);
    80003708:	8526                	mv	a0,s1
    8000370a:	09e020ef          	jal	800057a8 <release>
}
    8000370e:	b7c5                	j	800036ee <pipeclose+0x36>

0000000080003710 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003710:	711d                	addi	sp,sp,-96
    80003712:	ec86                	sd	ra,88(sp)
    80003714:	e8a2                	sd	s0,80(sp)
    80003716:	e4a6                	sd	s1,72(sp)
    80003718:	e0ca                	sd	s2,64(sp)
    8000371a:	fc4e                	sd	s3,56(sp)
    8000371c:	f852                	sd	s4,48(sp)
    8000371e:	f456                	sd	s5,40(sp)
    80003720:	1080                	addi	s0,sp,96
    80003722:	84aa                	mv	s1,a0
    80003724:	8aae                	mv	s5,a1
    80003726:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003728:	e2efd0ef          	jal	80000d56 <myproc>
    8000372c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000372e:	8526                	mv	a0,s1
    80003730:	7e1010ef          	jal	80005710 <acquire>
  while(i < n){
    80003734:	0b405a63          	blez	s4,800037e8 <pipewrite+0xd8>
    80003738:	f05a                	sd	s6,32(sp)
    8000373a:	ec5e                	sd	s7,24(sp)
    8000373c:	e862                	sd	s8,16(sp)
  int i = 0;
    8000373e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003740:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003742:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003746:	21c48b93          	addi	s7,s1,540
    8000374a:	a81d                	j	80003780 <pipewrite+0x70>
      release(&pi->lock);
    8000374c:	8526                	mv	a0,s1
    8000374e:	05a020ef          	jal	800057a8 <release>
      return -1;
    80003752:	597d                	li	s2,-1
    80003754:	7b02                	ld	s6,32(sp)
    80003756:	6be2                	ld	s7,24(sp)
    80003758:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000375a:	854a                	mv	a0,s2
    8000375c:	60e6                	ld	ra,88(sp)
    8000375e:	6446                	ld	s0,80(sp)
    80003760:	64a6                	ld	s1,72(sp)
    80003762:	6906                	ld	s2,64(sp)
    80003764:	79e2                	ld	s3,56(sp)
    80003766:	7a42                	ld	s4,48(sp)
    80003768:	7aa2                	ld	s5,40(sp)
    8000376a:	6125                	addi	sp,sp,96
    8000376c:	8082                	ret
      wakeup(&pi->nread);
    8000376e:	8562                	mv	a0,s8
    80003770:	c01fd0ef          	jal	80001370 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003774:	85a6                	mv	a1,s1
    80003776:	855e                	mv	a0,s7
    80003778:	badfd0ef          	jal	80001324 <sleep>
  while(i < n){
    8000377c:	05495b63          	bge	s2,s4,800037d2 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003780:	2204a783          	lw	a5,544(s1)
    80003784:	d7e1                	beqz	a5,8000374c <pipewrite+0x3c>
    80003786:	854e                	mv	a0,s3
    80003788:	dd5fd0ef          	jal	8000155c <killed>
    8000378c:	f161                	bnez	a0,8000374c <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000378e:	2184a783          	lw	a5,536(s1)
    80003792:	21c4a703          	lw	a4,540(s1)
    80003796:	2007879b          	addiw	a5,a5,512
    8000379a:	fcf70ae3          	beq	a4,a5,8000376e <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000379e:	4685                	li	a3,1
    800037a0:	01590633          	add	a2,s2,s5
    800037a4:	faf40593          	addi	a1,s0,-81
    800037a8:	0509b503          	ld	a0,80(s3)
    800037ac:	af2fd0ef          	jal	80000a9e <copyin>
    800037b0:	03650e63          	beq	a0,s6,800037ec <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800037b4:	21c4a783          	lw	a5,540(s1)
    800037b8:	0017871b          	addiw	a4,a5,1
    800037bc:	20e4ae23          	sw	a4,540(s1)
    800037c0:	1ff7f793          	andi	a5,a5,511
    800037c4:	97a6                	add	a5,a5,s1
    800037c6:	faf44703          	lbu	a4,-81(s0)
    800037ca:	00e78c23          	sb	a4,24(a5)
      i++;
    800037ce:	2905                	addiw	s2,s2,1
    800037d0:	b775                	j	8000377c <pipewrite+0x6c>
    800037d2:	7b02                	ld	s6,32(sp)
    800037d4:	6be2                	ld	s7,24(sp)
    800037d6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800037d8:	21848513          	addi	a0,s1,536
    800037dc:	b95fd0ef          	jal	80001370 <wakeup>
  release(&pi->lock);
    800037e0:	8526                	mv	a0,s1
    800037e2:	7c7010ef          	jal	800057a8 <release>
  return i;
    800037e6:	bf95                	j	8000375a <pipewrite+0x4a>
  int i = 0;
    800037e8:	4901                	li	s2,0
    800037ea:	b7fd                	j	800037d8 <pipewrite+0xc8>
    800037ec:	7b02                	ld	s6,32(sp)
    800037ee:	6be2                	ld	s7,24(sp)
    800037f0:	6c42                	ld	s8,16(sp)
    800037f2:	b7dd                	j	800037d8 <pipewrite+0xc8>

00000000800037f4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800037f4:	715d                	addi	sp,sp,-80
    800037f6:	e486                	sd	ra,72(sp)
    800037f8:	e0a2                	sd	s0,64(sp)
    800037fa:	fc26                	sd	s1,56(sp)
    800037fc:	f84a                	sd	s2,48(sp)
    800037fe:	f44e                	sd	s3,40(sp)
    80003800:	f052                	sd	s4,32(sp)
    80003802:	ec56                	sd	s5,24(sp)
    80003804:	0880                	addi	s0,sp,80
    80003806:	84aa                	mv	s1,a0
    80003808:	892e                	mv	s2,a1
    8000380a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000380c:	d4afd0ef          	jal	80000d56 <myproc>
    80003810:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003812:	8526                	mv	a0,s1
    80003814:	6fd010ef          	jal	80005710 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003818:	2184a703          	lw	a4,536(s1)
    8000381c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003820:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003824:	02f71563          	bne	a4,a5,8000384e <piperead+0x5a>
    80003828:	2244a783          	lw	a5,548(s1)
    8000382c:	cb85                	beqz	a5,8000385c <piperead+0x68>
    if(killed(pr)){
    8000382e:	8552                	mv	a0,s4
    80003830:	d2dfd0ef          	jal	8000155c <killed>
    80003834:	ed19                	bnez	a0,80003852 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003836:	85a6                	mv	a1,s1
    80003838:	854e                	mv	a0,s3
    8000383a:	aebfd0ef          	jal	80001324 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000383e:	2184a703          	lw	a4,536(s1)
    80003842:	21c4a783          	lw	a5,540(s1)
    80003846:	fef701e3          	beq	a4,a5,80003828 <piperead+0x34>
    8000384a:	e85a                	sd	s6,16(sp)
    8000384c:	a809                	j	8000385e <piperead+0x6a>
    8000384e:	e85a                	sd	s6,16(sp)
    80003850:	a039                	j	8000385e <piperead+0x6a>
      release(&pi->lock);
    80003852:	8526                	mv	a0,s1
    80003854:	755010ef          	jal	800057a8 <release>
      return -1;
    80003858:	59fd                	li	s3,-1
    8000385a:	a8b1                	j	800038b6 <piperead+0xc2>
    8000385c:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000385e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003860:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003862:	05505263          	blez	s5,800038a6 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003866:	2184a783          	lw	a5,536(s1)
    8000386a:	21c4a703          	lw	a4,540(s1)
    8000386e:	02f70c63          	beq	a4,a5,800038a6 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003872:	0017871b          	addiw	a4,a5,1
    80003876:	20e4ac23          	sw	a4,536(s1)
    8000387a:	1ff7f793          	andi	a5,a5,511
    8000387e:	97a6                	add	a5,a5,s1
    80003880:	0187c783          	lbu	a5,24(a5)
    80003884:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003888:	4685                	li	a3,1
    8000388a:	fbf40613          	addi	a2,s0,-65
    8000388e:	85ca                	mv	a1,s2
    80003890:	050a3503          	ld	a0,80(s4)
    80003894:	932fd0ef          	jal	800009c6 <copyout>
    80003898:	01650763          	beq	a0,s6,800038a6 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000389c:	2985                	addiw	s3,s3,1
    8000389e:	0905                	addi	s2,s2,1
    800038a0:	fd3a93e3          	bne	s5,s3,80003866 <piperead+0x72>
    800038a4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800038a6:	21c48513          	addi	a0,s1,540
    800038aa:	ac7fd0ef          	jal	80001370 <wakeup>
  release(&pi->lock);
    800038ae:	8526                	mv	a0,s1
    800038b0:	6f9010ef          	jal	800057a8 <release>
    800038b4:	6b42                	ld	s6,16(sp)
  return i;
}
    800038b6:	854e                	mv	a0,s3
    800038b8:	60a6                	ld	ra,72(sp)
    800038ba:	6406                	ld	s0,64(sp)
    800038bc:	74e2                	ld	s1,56(sp)
    800038be:	7942                	ld	s2,48(sp)
    800038c0:	79a2                	ld	s3,40(sp)
    800038c2:	7a02                	ld	s4,32(sp)
    800038c4:	6ae2                	ld	s5,24(sp)
    800038c6:	6161                	addi	sp,sp,80
    800038c8:	8082                	ret

00000000800038ca <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800038ca:	1141                	addi	sp,sp,-16
    800038cc:	e422                	sd	s0,8(sp)
    800038ce:	0800                	addi	s0,sp,16
    800038d0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800038d2:	8905                	andi	a0,a0,1
    800038d4:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800038d6:	8b89                	andi	a5,a5,2
    800038d8:	c399                	beqz	a5,800038de <flags2perm+0x14>
      perm |= PTE_W;
    800038da:	00456513          	ori	a0,a0,4
    return perm;
}
    800038de:	6422                	ld	s0,8(sp)
    800038e0:	0141                	addi	sp,sp,16
    800038e2:	8082                	ret

00000000800038e4 <exec>:

int
exec(char *path, char **argv)
{
    800038e4:	df010113          	addi	sp,sp,-528
    800038e8:	20113423          	sd	ra,520(sp)
    800038ec:	20813023          	sd	s0,512(sp)
    800038f0:	ffa6                	sd	s1,504(sp)
    800038f2:	fbca                	sd	s2,496(sp)
    800038f4:	0c00                	addi	s0,sp,528
    800038f6:	892a                	mv	s2,a0
    800038f8:	dea43c23          	sd	a0,-520(s0)
    800038fc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003900:	c56fd0ef          	jal	80000d56 <myproc>
    80003904:	84aa                	mv	s1,a0

  begin_op();
    80003906:	dc6ff0ef          	jal	80002ecc <begin_op>

  if((ip = namei(path)) == 0){
    8000390a:	854a                	mv	a0,s2
    8000390c:	c04ff0ef          	jal	80002d10 <namei>
    80003910:	c931                	beqz	a0,80003964 <exec+0x80>
    80003912:	f3d2                	sd	s4,480(sp)
    80003914:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003916:	d21fe0ef          	jal	80002636 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000391a:	04000713          	li	a4,64
    8000391e:	4681                	li	a3,0
    80003920:	e5040613          	addi	a2,s0,-432
    80003924:	4581                	li	a1,0
    80003926:	8552                	mv	a0,s4
    80003928:	f63fe0ef          	jal	8000288a <readi>
    8000392c:	04000793          	li	a5,64
    80003930:	00f51a63          	bne	a0,a5,80003944 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003934:	e5042703          	lw	a4,-432(s0)
    80003938:	464c47b7          	lui	a5,0x464c4
    8000393c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003940:	02f70663          	beq	a4,a5,8000396c <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003944:	8552                	mv	a0,s4
    80003946:	efbfe0ef          	jal	80002840 <iunlockput>
    end_op();
    8000394a:	decff0ef          	jal	80002f36 <end_op>
  }
  return -1;
    8000394e:	557d                	li	a0,-1
    80003950:	7a1e                	ld	s4,480(sp)
}
    80003952:	20813083          	ld	ra,520(sp)
    80003956:	20013403          	ld	s0,512(sp)
    8000395a:	74fe                	ld	s1,504(sp)
    8000395c:	795e                	ld	s2,496(sp)
    8000395e:	21010113          	addi	sp,sp,528
    80003962:	8082                	ret
    end_op();
    80003964:	dd2ff0ef          	jal	80002f36 <end_op>
    return -1;
    80003968:	557d                	li	a0,-1
    8000396a:	b7e5                	j	80003952 <exec+0x6e>
    8000396c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000396e:	8526                	mv	a0,s1
    80003970:	c8efd0ef          	jal	80000dfe <proc_pagetable>
    80003974:	8b2a                	mv	s6,a0
    80003976:	2c050b63          	beqz	a0,80003c4c <exec+0x368>
    8000397a:	f7ce                	sd	s3,488(sp)
    8000397c:	efd6                	sd	s5,472(sp)
    8000397e:	e7de                	sd	s7,456(sp)
    80003980:	e3e2                	sd	s8,448(sp)
    80003982:	ff66                	sd	s9,440(sp)
    80003984:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003986:	e7042d03          	lw	s10,-400(s0)
    8000398a:	e8845783          	lhu	a5,-376(s0)
    8000398e:	12078963          	beqz	a5,80003ac0 <exec+0x1dc>
    80003992:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003994:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003996:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003998:	6c85                	lui	s9,0x1
    8000399a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000399e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800039a2:	6a85                	lui	s5,0x1
    800039a4:	a085                	j	80003a04 <exec+0x120>
      panic("loadseg: address should exist");
    800039a6:	00004517          	auipc	a0,0x4
    800039aa:	c0a50513          	addi	a0,a0,-1014 # 800075b0 <etext+0x5b0>
    800039ae:	235010ef          	jal	800053e2 <panic>
    if(sz - i < PGSIZE)
    800039b2:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800039b4:	8726                	mv	a4,s1
    800039b6:	012c06bb          	addw	a3,s8,s2
    800039ba:	4581                	li	a1,0
    800039bc:	8552                	mv	a0,s4
    800039be:	ecdfe0ef          	jal	8000288a <readi>
    800039c2:	2501                	sext.w	a0,a0
    800039c4:	24a49a63          	bne	s1,a0,80003c18 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    800039c8:	012a893b          	addw	s2,s5,s2
    800039cc:	03397363          	bgeu	s2,s3,800039f2 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    800039d0:	02091593          	slli	a1,s2,0x20
    800039d4:	9181                	srli	a1,a1,0x20
    800039d6:	95de                	add	a1,a1,s7
    800039d8:	855a                	mv	a0,s6
    800039da:	a69fc0ef          	jal	80000442 <walkaddr>
    800039de:	862a                	mv	a2,a0
    if(pa == 0)
    800039e0:	d179                	beqz	a0,800039a6 <exec+0xc2>
    if(sz - i < PGSIZE)
    800039e2:	412984bb          	subw	s1,s3,s2
    800039e6:	0004879b          	sext.w	a5,s1
    800039ea:	fcfcf4e3          	bgeu	s9,a5,800039b2 <exec+0xce>
    800039ee:	84d6                	mv	s1,s5
    800039f0:	b7c9                	j	800039b2 <exec+0xce>
    sz = sz1;
    800039f2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800039f6:	2d85                	addiw	s11,s11,1
    800039f8:	038d0d1b          	addiw	s10,s10,56
    800039fc:	e8845783          	lhu	a5,-376(s0)
    80003a00:	08fdd063          	bge	s11,a5,80003a80 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003a04:	2d01                	sext.w	s10,s10
    80003a06:	03800713          	li	a4,56
    80003a0a:	86ea                	mv	a3,s10
    80003a0c:	e1840613          	addi	a2,s0,-488
    80003a10:	4581                	li	a1,0
    80003a12:	8552                	mv	a0,s4
    80003a14:	e77fe0ef          	jal	8000288a <readi>
    80003a18:	03800793          	li	a5,56
    80003a1c:	1cf51663          	bne	a0,a5,80003be8 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003a20:	e1842783          	lw	a5,-488(s0)
    80003a24:	4705                	li	a4,1
    80003a26:	fce798e3          	bne	a5,a4,800039f6 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003a2a:	e4043483          	ld	s1,-448(s0)
    80003a2e:	e3843783          	ld	a5,-456(s0)
    80003a32:	1af4ef63          	bltu	s1,a5,80003bf0 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003a36:	e2843783          	ld	a5,-472(s0)
    80003a3a:	94be                	add	s1,s1,a5
    80003a3c:	1af4ee63          	bltu	s1,a5,80003bf8 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003a40:	df043703          	ld	a4,-528(s0)
    80003a44:	8ff9                	and	a5,a5,a4
    80003a46:	1a079d63          	bnez	a5,80003c00 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003a4a:	e1c42503          	lw	a0,-484(s0)
    80003a4e:	e7dff0ef          	jal	800038ca <flags2perm>
    80003a52:	86aa                	mv	a3,a0
    80003a54:	8626                	mv	a2,s1
    80003a56:	85ca                	mv	a1,s2
    80003a58:	855a                	mv	a0,s6
    80003a5a:	d61fc0ef          	jal	800007ba <uvmalloc>
    80003a5e:	e0a43423          	sd	a0,-504(s0)
    80003a62:	1a050363          	beqz	a0,80003c08 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003a66:	e2843b83          	ld	s7,-472(s0)
    80003a6a:	e2042c03          	lw	s8,-480(s0)
    80003a6e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003a72:	00098463          	beqz	s3,80003a7a <exec+0x196>
    80003a76:	4901                	li	s2,0
    80003a78:	bfa1                	j	800039d0 <exec+0xec>
    sz = sz1;
    80003a7a:	e0843903          	ld	s2,-504(s0)
    80003a7e:	bfa5                	j	800039f6 <exec+0x112>
    80003a80:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003a82:	8552                	mv	a0,s4
    80003a84:	dbdfe0ef          	jal	80002840 <iunlockput>
  end_op();
    80003a88:	caeff0ef          	jal	80002f36 <end_op>
  p = myproc();
    80003a8c:	acafd0ef          	jal	80000d56 <myproc>
    80003a90:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003a92:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003a96:	6985                	lui	s3,0x1
    80003a98:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003a9a:	99ca                	add	s3,s3,s2
    80003a9c:	77fd                	lui	a5,0xfffff
    80003a9e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003aa2:	4691                	li	a3,4
    80003aa4:	6609                	lui	a2,0x2
    80003aa6:	964e                	add	a2,a2,s3
    80003aa8:	85ce                	mv	a1,s3
    80003aaa:	855a                	mv	a0,s6
    80003aac:	d0ffc0ef          	jal	800007ba <uvmalloc>
    80003ab0:	892a                	mv	s2,a0
    80003ab2:	e0a43423          	sd	a0,-504(s0)
    80003ab6:	e519                	bnez	a0,80003ac4 <exec+0x1e0>
  if(pagetable)
    80003ab8:	e1343423          	sd	s3,-504(s0)
    80003abc:	4a01                	li	s4,0
    80003abe:	aab1                	j	80003c1a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ac0:	4901                	li	s2,0
    80003ac2:	b7c1                	j	80003a82 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003ac4:	75f9                	lui	a1,0xffffe
    80003ac6:	95aa                	add	a1,a1,a0
    80003ac8:	855a                	mv	a0,s6
    80003aca:	ed3fc0ef          	jal	8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003ace:	7bfd                	lui	s7,0xfffff
    80003ad0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003ad2:	e0043783          	ld	a5,-512(s0)
    80003ad6:	6388                	ld	a0,0(a5)
    80003ad8:	cd39                	beqz	a0,80003b36 <exec+0x252>
    80003ada:	e9040993          	addi	s3,s0,-368
    80003ade:	f9040c13          	addi	s8,s0,-112
    80003ae2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003ae4:	fc0fc0ef          	jal	800002a4 <strlen>
    80003ae8:	0015079b          	addiw	a5,a0,1
    80003aec:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003af0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003af4:	11796e63          	bltu	s2,s7,80003c10 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003af8:	e0043d03          	ld	s10,-512(s0)
    80003afc:	000d3a03          	ld	s4,0(s10)
    80003b00:	8552                	mv	a0,s4
    80003b02:	fa2fc0ef          	jal	800002a4 <strlen>
    80003b06:	0015069b          	addiw	a3,a0,1
    80003b0a:	8652                	mv	a2,s4
    80003b0c:	85ca                	mv	a1,s2
    80003b0e:	855a                	mv	a0,s6
    80003b10:	eb7fc0ef          	jal	800009c6 <copyout>
    80003b14:	10054063          	bltz	a0,80003c14 <exec+0x330>
    ustack[argc] = sp;
    80003b18:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003b1c:	0485                	addi	s1,s1,1
    80003b1e:	008d0793          	addi	a5,s10,8
    80003b22:	e0f43023          	sd	a5,-512(s0)
    80003b26:	008d3503          	ld	a0,8(s10)
    80003b2a:	c909                	beqz	a0,80003b3c <exec+0x258>
    if(argc >= MAXARG)
    80003b2c:	09a1                	addi	s3,s3,8
    80003b2e:	fb899be3          	bne	s3,s8,80003ae4 <exec+0x200>
  ip = 0;
    80003b32:	4a01                	li	s4,0
    80003b34:	a0dd                	j	80003c1a <exec+0x336>
  sp = sz;
    80003b36:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003b3a:	4481                	li	s1,0
  ustack[argc] = 0;
    80003b3c:	00349793          	slli	a5,s1,0x3
    80003b40:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdba40>
    80003b44:	97a2                	add	a5,a5,s0
    80003b46:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003b4a:	00148693          	addi	a3,s1,1
    80003b4e:	068e                	slli	a3,a3,0x3
    80003b50:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003b54:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003b58:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003b5c:	f5796ee3          	bltu	s2,s7,80003ab8 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003b60:	e9040613          	addi	a2,s0,-368
    80003b64:	85ca                	mv	a1,s2
    80003b66:	855a                	mv	a0,s6
    80003b68:	e5ffc0ef          	jal	800009c6 <copyout>
    80003b6c:	0e054263          	bltz	a0,80003c50 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003b70:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003b74:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003b78:	df843783          	ld	a5,-520(s0)
    80003b7c:	0007c703          	lbu	a4,0(a5)
    80003b80:	cf11                	beqz	a4,80003b9c <exec+0x2b8>
    80003b82:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003b84:	02f00693          	li	a3,47
    80003b88:	a039                	j	80003b96 <exec+0x2b2>
      last = s+1;
    80003b8a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003b8e:	0785                	addi	a5,a5,1
    80003b90:	fff7c703          	lbu	a4,-1(a5)
    80003b94:	c701                	beqz	a4,80003b9c <exec+0x2b8>
    if(*s == '/')
    80003b96:	fed71ce3          	bne	a4,a3,80003b8e <exec+0x2aa>
    80003b9a:	bfc5                	j	80003b8a <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003b9c:	4641                	li	a2,16
    80003b9e:	df843583          	ld	a1,-520(s0)
    80003ba2:	158a8513          	addi	a0,s5,344
    80003ba6:	eccfc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003baa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003bae:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003bb2:	e0843783          	ld	a5,-504(s0)
    80003bb6:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003bba:	058ab783          	ld	a5,88(s5)
    80003bbe:	e6843703          	ld	a4,-408(s0)
    80003bc2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003bc4:	058ab783          	ld	a5,88(s5)
    80003bc8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003bcc:	85e6                	mv	a1,s9
    80003bce:	ab4fd0ef          	jal	80000e82 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003bd2:	0004851b          	sext.w	a0,s1
    80003bd6:	79be                	ld	s3,488(sp)
    80003bd8:	7a1e                	ld	s4,480(sp)
    80003bda:	6afe                	ld	s5,472(sp)
    80003bdc:	6b5e                	ld	s6,464(sp)
    80003bde:	6bbe                	ld	s7,456(sp)
    80003be0:	6c1e                	ld	s8,448(sp)
    80003be2:	7cfa                	ld	s9,440(sp)
    80003be4:	7d5a                	ld	s10,432(sp)
    80003be6:	b3b5                	j	80003952 <exec+0x6e>
    80003be8:	e1243423          	sd	s2,-504(s0)
    80003bec:	7dba                	ld	s11,424(sp)
    80003bee:	a035                	j	80003c1a <exec+0x336>
    80003bf0:	e1243423          	sd	s2,-504(s0)
    80003bf4:	7dba                	ld	s11,424(sp)
    80003bf6:	a015                	j	80003c1a <exec+0x336>
    80003bf8:	e1243423          	sd	s2,-504(s0)
    80003bfc:	7dba                	ld	s11,424(sp)
    80003bfe:	a831                	j	80003c1a <exec+0x336>
    80003c00:	e1243423          	sd	s2,-504(s0)
    80003c04:	7dba                	ld	s11,424(sp)
    80003c06:	a811                	j	80003c1a <exec+0x336>
    80003c08:	e1243423          	sd	s2,-504(s0)
    80003c0c:	7dba                	ld	s11,424(sp)
    80003c0e:	a031                	j	80003c1a <exec+0x336>
  ip = 0;
    80003c10:	4a01                	li	s4,0
    80003c12:	a021                	j	80003c1a <exec+0x336>
    80003c14:	4a01                	li	s4,0
  if(pagetable)
    80003c16:	a011                	j	80003c1a <exec+0x336>
    80003c18:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003c1a:	e0843583          	ld	a1,-504(s0)
    80003c1e:	855a                	mv	a0,s6
    80003c20:	a62fd0ef          	jal	80000e82 <proc_freepagetable>
  return -1;
    80003c24:	557d                	li	a0,-1
  if(ip){
    80003c26:	000a1b63          	bnez	s4,80003c3c <exec+0x358>
    80003c2a:	79be                	ld	s3,488(sp)
    80003c2c:	7a1e                	ld	s4,480(sp)
    80003c2e:	6afe                	ld	s5,472(sp)
    80003c30:	6b5e                	ld	s6,464(sp)
    80003c32:	6bbe                	ld	s7,456(sp)
    80003c34:	6c1e                	ld	s8,448(sp)
    80003c36:	7cfa                	ld	s9,440(sp)
    80003c38:	7d5a                	ld	s10,432(sp)
    80003c3a:	bb21                	j	80003952 <exec+0x6e>
    80003c3c:	79be                	ld	s3,488(sp)
    80003c3e:	6afe                	ld	s5,472(sp)
    80003c40:	6b5e                	ld	s6,464(sp)
    80003c42:	6bbe                	ld	s7,456(sp)
    80003c44:	6c1e                	ld	s8,448(sp)
    80003c46:	7cfa                	ld	s9,440(sp)
    80003c48:	7d5a                	ld	s10,432(sp)
    80003c4a:	b9ed                	j	80003944 <exec+0x60>
    80003c4c:	6b5e                	ld	s6,464(sp)
    80003c4e:	b9dd                	j	80003944 <exec+0x60>
  sz = sz1;
    80003c50:	e0843983          	ld	s3,-504(s0)
    80003c54:	b595                	j	80003ab8 <exec+0x1d4>

0000000080003c56 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003c56:	7179                	addi	sp,sp,-48
    80003c58:	f406                	sd	ra,40(sp)
    80003c5a:	f022                	sd	s0,32(sp)
    80003c5c:	ec26                	sd	s1,24(sp)
    80003c5e:	e84a                	sd	s2,16(sp)
    80003c60:	1800                	addi	s0,sp,48
    80003c62:	892e                	mv	s2,a1
    80003c64:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003c66:	fdc40593          	addi	a1,s0,-36
    80003c6a:	fa1fd0ef          	jal	80001c0a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c6e:	fdc42703          	lw	a4,-36(s0)
    80003c72:	47bd                	li	a5,15
    80003c74:	02e7e963          	bltu	a5,a4,80003ca6 <argfd+0x50>
    80003c78:	8defd0ef          	jal	80000d56 <myproc>
    80003c7c:	fdc42703          	lw	a4,-36(s0)
    80003c80:	01a70793          	addi	a5,a4,26
    80003c84:	078e                	slli	a5,a5,0x3
    80003c86:	953e                	add	a0,a0,a5
    80003c88:	611c                	ld	a5,0(a0)
    80003c8a:	c385                	beqz	a5,80003caa <argfd+0x54>
    return -1;
  if(pfd)
    80003c8c:	00090463          	beqz	s2,80003c94 <argfd+0x3e>
    *pfd = fd;
    80003c90:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003c94:	4501                	li	a0,0
  if(pf)
    80003c96:	c091                	beqz	s1,80003c9a <argfd+0x44>
    *pf = f;
    80003c98:	e09c                	sd	a5,0(s1)
}
    80003c9a:	70a2                	ld	ra,40(sp)
    80003c9c:	7402                	ld	s0,32(sp)
    80003c9e:	64e2                	ld	s1,24(sp)
    80003ca0:	6942                	ld	s2,16(sp)
    80003ca2:	6145                	addi	sp,sp,48
    80003ca4:	8082                	ret
    return -1;
    80003ca6:	557d                	li	a0,-1
    80003ca8:	bfcd                	j	80003c9a <argfd+0x44>
    80003caa:	557d                	li	a0,-1
    80003cac:	b7fd                	j	80003c9a <argfd+0x44>

0000000080003cae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003cae:	1101                	addi	sp,sp,-32
    80003cb0:	ec06                	sd	ra,24(sp)
    80003cb2:	e822                	sd	s0,16(sp)
    80003cb4:	e426                	sd	s1,8(sp)
    80003cb6:	1000                	addi	s0,sp,32
    80003cb8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003cba:	89cfd0ef          	jal	80000d56 <myproc>
    80003cbe:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003cc0:	0d050793          	addi	a5,a0,208
    80003cc4:	4501                	li	a0,0
    80003cc6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003cc8:	6398                	ld	a4,0(a5)
    80003cca:	cb19                	beqz	a4,80003ce0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ccc:	2505                	addiw	a0,a0,1
    80003cce:	07a1                	addi	a5,a5,8
    80003cd0:	fed51ce3          	bne	a0,a3,80003cc8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003cd4:	557d                	li	a0,-1
}
    80003cd6:	60e2                	ld	ra,24(sp)
    80003cd8:	6442                	ld	s0,16(sp)
    80003cda:	64a2                	ld	s1,8(sp)
    80003cdc:	6105                	addi	sp,sp,32
    80003cde:	8082                	ret
      p->ofile[fd] = f;
    80003ce0:	01a50793          	addi	a5,a0,26
    80003ce4:	078e                	slli	a5,a5,0x3
    80003ce6:	963e                	add	a2,a2,a5
    80003ce8:	e204                	sd	s1,0(a2)
      return fd;
    80003cea:	b7f5                	j	80003cd6 <fdalloc+0x28>

0000000080003cec <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003cec:	715d                	addi	sp,sp,-80
    80003cee:	e486                	sd	ra,72(sp)
    80003cf0:	e0a2                	sd	s0,64(sp)
    80003cf2:	fc26                	sd	s1,56(sp)
    80003cf4:	f84a                	sd	s2,48(sp)
    80003cf6:	f44e                	sd	s3,40(sp)
    80003cf8:	ec56                	sd	s5,24(sp)
    80003cfa:	e85a                	sd	s6,16(sp)
    80003cfc:	0880                	addi	s0,sp,80
    80003cfe:	8b2e                	mv	s6,a1
    80003d00:	89b2                	mv	s3,a2
    80003d02:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003d04:	fb040593          	addi	a1,s0,-80
    80003d08:	822ff0ef          	jal	80002d2a <nameiparent>
    80003d0c:	84aa                	mv	s1,a0
    80003d0e:	10050a63          	beqz	a0,80003e22 <create+0x136>
    return 0;

  ilock(dp);
    80003d12:	925fe0ef          	jal	80002636 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d16:	4601                	li	a2,0
    80003d18:	fb040593          	addi	a1,s0,-80
    80003d1c:	8526                	mv	a0,s1
    80003d1e:	d8dfe0ef          	jal	80002aaa <dirlookup>
    80003d22:	8aaa                	mv	s5,a0
    80003d24:	c129                	beqz	a0,80003d66 <create+0x7a>
    iunlockput(dp);
    80003d26:	8526                	mv	a0,s1
    80003d28:	b19fe0ef          	jal	80002840 <iunlockput>
    ilock(ip);
    80003d2c:	8556                	mv	a0,s5
    80003d2e:	909fe0ef          	jal	80002636 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003d32:	4789                	li	a5,2
    80003d34:	02fb1463          	bne	s6,a5,80003d5c <create+0x70>
    80003d38:	044ad783          	lhu	a5,68(s5)
    80003d3c:	37f9                	addiw	a5,a5,-2
    80003d3e:	17c2                	slli	a5,a5,0x30
    80003d40:	93c1                	srli	a5,a5,0x30
    80003d42:	4705                	li	a4,1
    80003d44:	00f76c63          	bltu	a4,a5,80003d5c <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003d48:	8556                	mv	a0,s5
    80003d4a:	60a6                	ld	ra,72(sp)
    80003d4c:	6406                	ld	s0,64(sp)
    80003d4e:	74e2                	ld	s1,56(sp)
    80003d50:	7942                	ld	s2,48(sp)
    80003d52:	79a2                	ld	s3,40(sp)
    80003d54:	6ae2                	ld	s5,24(sp)
    80003d56:	6b42                	ld	s6,16(sp)
    80003d58:	6161                	addi	sp,sp,80
    80003d5a:	8082                	ret
    iunlockput(ip);
    80003d5c:	8556                	mv	a0,s5
    80003d5e:	ae3fe0ef          	jal	80002840 <iunlockput>
    return 0;
    80003d62:	4a81                	li	s5,0
    80003d64:	b7d5                	j	80003d48 <create+0x5c>
    80003d66:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d68:	85da                	mv	a1,s6
    80003d6a:	4088                	lw	a0,0(s1)
    80003d6c:	f5afe0ef          	jal	800024c6 <ialloc>
    80003d70:	8a2a                	mv	s4,a0
    80003d72:	cd15                	beqz	a0,80003dae <create+0xc2>
  ilock(ip);
    80003d74:	8c3fe0ef          	jal	80002636 <ilock>
  ip->major = major;
    80003d78:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d7c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d80:	4905                	li	s2,1
    80003d82:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d86:	8552                	mv	a0,s4
    80003d88:	ffafe0ef          	jal	80002582 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003d8c:	032b0763          	beq	s6,s2,80003dba <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003d90:	004a2603          	lw	a2,4(s4)
    80003d94:	fb040593          	addi	a1,s0,-80
    80003d98:	8526                	mv	a0,s1
    80003d9a:	eddfe0ef          	jal	80002c76 <dirlink>
    80003d9e:	06054563          	bltz	a0,80003e08 <create+0x11c>
  iunlockput(dp);
    80003da2:	8526                	mv	a0,s1
    80003da4:	a9dfe0ef          	jal	80002840 <iunlockput>
  return ip;
    80003da8:	8ad2                	mv	s5,s4
    80003daa:	7a02                	ld	s4,32(sp)
    80003dac:	bf71                	j	80003d48 <create+0x5c>
    iunlockput(dp);
    80003dae:	8526                	mv	a0,s1
    80003db0:	a91fe0ef          	jal	80002840 <iunlockput>
    return 0;
    80003db4:	8ad2                	mv	s5,s4
    80003db6:	7a02                	ld	s4,32(sp)
    80003db8:	bf41                	j	80003d48 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003dba:	004a2603          	lw	a2,4(s4)
    80003dbe:	00004597          	auipc	a1,0x4
    80003dc2:	81258593          	addi	a1,a1,-2030 # 800075d0 <etext+0x5d0>
    80003dc6:	8552                	mv	a0,s4
    80003dc8:	eaffe0ef          	jal	80002c76 <dirlink>
    80003dcc:	02054e63          	bltz	a0,80003e08 <create+0x11c>
    80003dd0:	40d0                	lw	a2,4(s1)
    80003dd2:	00004597          	auipc	a1,0x4
    80003dd6:	80658593          	addi	a1,a1,-2042 # 800075d8 <etext+0x5d8>
    80003dda:	8552                	mv	a0,s4
    80003ddc:	e9bfe0ef          	jal	80002c76 <dirlink>
    80003de0:	02054463          	bltz	a0,80003e08 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003de4:	004a2603          	lw	a2,4(s4)
    80003de8:	fb040593          	addi	a1,s0,-80
    80003dec:	8526                	mv	a0,s1
    80003dee:	e89fe0ef          	jal	80002c76 <dirlink>
    80003df2:	00054b63          	bltz	a0,80003e08 <create+0x11c>
    dp->nlink++;  // for ".."
    80003df6:	04a4d783          	lhu	a5,74(s1)
    80003dfa:	2785                	addiw	a5,a5,1
    80003dfc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003e00:	8526                	mv	a0,s1
    80003e02:	f80fe0ef          	jal	80002582 <iupdate>
    80003e06:	bf71                	j	80003da2 <create+0xb6>
  ip->nlink = 0;
    80003e08:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	f74fe0ef          	jal	80002582 <iupdate>
  iunlockput(ip);
    80003e12:	8552                	mv	a0,s4
    80003e14:	a2dfe0ef          	jal	80002840 <iunlockput>
  iunlockput(dp);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	a27fe0ef          	jal	80002840 <iunlockput>
  return 0;
    80003e1e:	7a02                	ld	s4,32(sp)
    80003e20:	b725                	j	80003d48 <create+0x5c>
    return 0;
    80003e22:	8aaa                	mv	s5,a0
    80003e24:	b715                	j	80003d48 <create+0x5c>

0000000080003e26 <sys_dup>:
{
    80003e26:	7179                	addi	sp,sp,-48
    80003e28:	f406                	sd	ra,40(sp)
    80003e2a:	f022                	sd	s0,32(sp)
    80003e2c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003e2e:	fd840613          	addi	a2,s0,-40
    80003e32:	4581                	li	a1,0
    80003e34:	4501                	li	a0,0
    80003e36:	e21ff0ef          	jal	80003c56 <argfd>
    return -1;
    80003e3a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003e3c:	02054363          	bltz	a0,80003e62 <sys_dup+0x3c>
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003e44:	fd843903          	ld	s2,-40(s0)
    80003e48:	854a                	mv	a0,s2
    80003e4a:	e65ff0ef          	jal	80003cae <fdalloc>
    80003e4e:	84aa                	mv	s1,a0
    return -1;
    80003e50:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003e52:	00054d63          	bltz	a0,80003e6c <sys_dup+0x46>
  filedup(f);
    80003e56:	854a                	mv	a0,s2
    80003e58:	c48ff0ef          	jal	800032a0 <filedup>
  return fd;
    80003e5c:	87a6                	mv	a5,s1
    80003e5e:	64e2                	ld	s1,24(sp)
    80003e60:	6942                	ld	s2,16(sp)
}
    80003e62:	853e                	mv	a0,a5
    80003e64:	70a2                	ld	ra,40(sp)
    80003e66:	7402                	ld	s0,32(sp)
    80003e68:	6145                	addi	sp,sp,48
    80003e6a:	8082                	ret
    80003e6c:	64e2                	ld	s1,24(sp)
    80003e6e:	6942                	ld	s2,16(sp)
    80003e70:	bfcd                	j	80003e62 <sys_dup+0x3c>

0000000080003e72 <sys_read>:
{
    80003e72:	7179                	addi	sp,sp,-48
    80003e74:	f406                	sd	ra,40(sp)
    80003e76:	f022                	sd	s0,32(sp)
    80003e78:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e7a:	fd840593          	addi	a1,s0,-40
    80003e7e:	4505                	li	a0,1
    80003e80:	da7fd0ef          	jal	80001c26 <argaddr>
  argint(2, &n);
    80003e84:	fe440593          	addi	a1,s0,-28
    80003e88:	4509                	li	a0,2
    80003e8a:	d81fd0ef          	jal	80001c0a <argint>
  if(argfd(0, 0, &f) < 0)
    80003e8e:	fe840613          	addi	a2,s0,-24
    80003e92:	4581                	li	a1,0
    80003e94:	4501                	li	a0,0
    80003e96:	dc1ff0ef          	jal	80003c56 <argfd>
    80003e9a:	87aa                	mv	a5,a0
    return -1;
    80003e9c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003e9e:	0007ca63          	bltz	a5,80003eb2 <sys_read+0x40>
  return fileread(f, p, n);
    80003ea2:	fe442603          	lw	a2,-28(s0)
    80003ea6:	fd843583          	ld	a1,-40(s0)
    80003eaa:	fe843503          	ld	a0,-24(s0)
    80003eae:	d58ff0ef          	jal	80003406 <fileread>
}
    80003eb2:	70a2                	ld	ra,40(sp)
    80003eb4:	7402                	ld	s0,32(sp)
    80003eb6:	6145                	addi	sp,sp,48
    80003eb8:	8082                	ret

0000000080003eba <sys_write>:
{
    80003eba:	7179                	addi	sp,sp,-48
    80003ebc:	f406                	sd	ra,40(sp)
    80003ebe:	f022                	sd	s0,32(sp)
    80003ec0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003ec2:	fd840593          	addi	a1,s0,-40
    80003ec6:	4505                	li	a0,1
    80003ec8:	d5ffd0ef          	jal	80001c26 <argaddr>
  argint(2, &n);
    80003ecc:	fe440593          	addi	a1,s0,-28
    80003ed0:	4509                	li	a0,2
    80003ed2:	d39fd0ef          	jal	80001c0a <argint>
  if(argfd(0, 0, &f) < 0)
    80003ed6:	fe840613          	addi	a2,s0,-24
    80003eda:	4581                	li	a1,0
    80003edc:	4501                	li	a0,0
    80003ede:	d79ff0ef          	jal	80003c56 <argfd>
    80003ee2:	87aa                	mv	a5,a0
    return -1;
    80003ee4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ee6:	0007ca63          	bltz	a5,80003efa <sys_write+0x40>
  return filewrite(f, p, n);
    80003eea:	fe442603          	lw	a2,-28(s0)
    80003eee:	fd843583          	ld	a1,-40(s0)
    80003ef2:	fe843503          	ld	a0,-24(s0)
    80003ef6:	dceff0ef          	jal	800034c4 <filewrite>
}
    80003efa:	70a2                	ld	ra,40(sp)
    80003efc:	7402                	ld	s0,32(sp)
    80003efe:	6145                	addi	sp,sp,48
    80003f00:	8082                	ret

0000000080003f02 <sys_close>:
{
    80003f02:	1101                	addi	sp,sp,-32
    80003f04:	ec06                	sd	ra,24(sp)
    80003f06:	e822                	sd	s0,16(sp)
    80003f08:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003f0a:	fe040613          	addi	a2,s0,-32
    80003f0e:	fec40593          	addi	a1,s0,-20
    80003f12:	4501                	li	a0,0
    80003f14:	d43ff0ef          	jal	80003c56 <argfd>
    return -1;
    80003f18:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003f1a:	02054063          	bltz	a0,80003f3a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003f1e:	e39fc0ef          	jal	80000d56 <myproc>
    80003f22:	fec42783          	lw	a5,-20(s0)
    80003f26:	07e9                	addi	a5,a5,26
    80003f28:	078e                	slli	a5,a5,0x3
    80003f2a:	953e                	add	a0,a0,a5
    80003f2c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003f30:	fe043503          	ld	a0,-32(s0)
    80003f34:	bb2ff0ef          	jal	800032e6 <fileclose>
  return 0;
    80003f38:	4781                	li	a5,0
}
    80003f3a:	853e                	mv	a0,a5
    80003f3c:	60e2                	ld	ra,24(sp)
    80003f3e:	6442                	ld	s0,16(sp)
    80003f40:	6105                	addi	sp,sp,32
    80003f42:	8082                	ret

0000000080003f44 <sys_fstat>:
{
    80003f44:	1101                	addi	sp,sp,-32
    80003f46:	ec06                	sd	ra,24(sp)
    80003f48:	e822                	sd	s0,16(sp)
    80003f4a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003f4c:	fe040593          	addi	a1,s0,-32
    80003f50:	4505                	li	a0,1
    80003f52:	cd5fd0ef          	jal	80001c26 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003f56:	fe840613          	addi	a2,s0,-24
    80003f5a:	4581                	li	a1,0
    80003f5c:	4501                	li	a0,0
    80003f5e:	cf9ff0ef          	jal	80003c56 <argfd>
    80003f62:	87aa                	mv	a5,a0
    return -1;
    80003f64:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f66:	0007c863          	bltz	a5,80003f76 <sys_fstat+0x32>
  return filestat(f, st);
    80003f6a:	fe043583          	ld	a1,-32(s0)
    80003f6e:	fe843503          	ld	a0,-24(s0)
    80003f72:	c36ff0ef          	jal	800033a8 <filestat>
}
    80003f76:	60e2                	ld	ra,24(sp)
    80003f78:	6442                	ld	s0,16(sp)
    80003f7a:	6105                	addi	sp,sp,32
    80003f7c:	8082                	ret

0000000080003f7e <sys_link>:
{
    80003f7e:	7169                	addi	sp,sp,-304
    80003f80:	f606                	sd	ra,296(sp)
    80003f82:	f222                	sd	s0,288(sp)
    80003f84:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f86:	08000613          	li	a2,128
    80003f8a:	ed040593          	addi	a1,s0,-304
    80003f8e:	4501                	li	a0,0
    80003f90:	cb3fd0ef          	jal	80001c42 <argstr>
    return -1;
    80003f94:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f96:	0c054e63          	bltz	a0,80004072 <sys_link+0xf4>
    80003f9a:	08000613          	li	a2,128
    80003f9e:	f5040593          	addi	a1,s0,-176
    80003fa2:	4505                	li	a0,1
    80003fa4:	c9ffd0ef          	jal	80001c42 <argstr>
    return -1;
    80003fa8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003faa:	0c054463          	bltz	a0,80004072 <sys_link+0xf4>
    80003fae:	ee26                	sd	s1,280(sp)
  begin_op();
    80003fb0:	f1dfe0ef          	jal	80002ecc <begin_op>
  if((ip = namei(old)) == 0){
    80003fb4:	ed040513          	addi	a0,s0,-304
    80003fb8:	d59fe0ef          	jal	80002d10 <namei>
    80003fbc:	84aa                	mv	s1,a0
    80003fbe:	c53d                	beqz	a0,8000402c <sys_link+0xae>
  ilock(ip);
    80003fc0:	e76fe0ef          	jal	80002636 <ilock>
  if(ip->type == T_DIR){
    80003fc4:	04449703          	lh	a4,68(s1)
    80003fc8:	4785                	li	a5,1
    80003fca:	06f70663          	beq	a4,a5,80004036 <sys_link+0xb8>
    80003fce:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80003fd0:	04a4d783          	lhu	a5,74(s1)
    80003fd4:	2785                	addiw	a5,a5,1
    80003fd6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	da6fe0ef          	jal	80002582 <iupdate>
  iunlock(ip);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	f02fe0ef          	jal	800026e4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003fe6:	fd040593          	addi	a1,s0,-48
    80003fea:	f5040513          	addi	a0,s0,-176
    80003fee:	d3dfe0ef          	jal	80002d2a <nameiparent>
    80003ff2:	892a                	mv	s2,a0
    80003ff4:	cd21                	beqz	a0,8000404c <sys_link+0xce>
  ilock(dp);
    80003ff6:	e40fe0ef          	jal	80002636 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80003ffa:	00092703          	lw	a4,0(s2)
    80003ffe:	409c                	lw	a5,0(s1)
    80004000:	04f71363          	bne	a4,a5,80004046 <sys_link+0xc8>
    80004004:	40d0                	lw	a2,4(s1)
    80004006:	fd040593          	addi	a1,s0,-48
    8000400a:	854a                	mv	a0,s2
    8000400c:	c6bfe0ef          	jal	80002c76 <dirlink>
    80004010:	02054b63          	bltz	a0,80004046 <sys_link+0xc8>
  iunlockput(dp);
    80004014:	854a                	mv	a0,s2
    80004016:	82bfe0ef          	jal	80002840 <iunlockput>
  iput(ip);
    8000401a:	8526                	mv	a0,s1
    8000401c:	f9cfe0ef          	jal	800027b8 <iput>
  end_op();
    80004020:	f17fe0ef          	jal	80002f36 <end_op>
  return 0;
    80004024:	4781                	li	a5,0
    80004026:	64f2                	ld	s1,280(sp)
    80004028:	6952                	ld	s2,272(sp)
    8000402a:	a0a1                	j	80004072 <sys_link+0xf4>
    end_op();
    8000402c:	f0bfe0ef          	jal	80002f36 <end_op>
    return -1;
    80004030:	57fd                	li	a5,-1
    80004032:	64f2                	ld	s1,280(sp)
    80004034:	a83d                	j	80004072 <sys_link+0xf4>
    iunlockput(ip);
    80004036:	8526                	mv	a0,s1
    80004038:	809fe0ef          	jal	80002840 <iunlockput>
    end_op();
    8000403c:	efbfe0ef          	jal	80002f36 <end_op>
    return -1;
    80004040:	57fd                	li	a5,-1
    80004042:	64f2                	ld	s1,280(sp)
    80004044:	a03d                	j	80004072 <sys_link+0xf4>
    iunlockput(dp);
    80004046:	854a                	mv	a0,s2
    80004048:	ff8fe0ef          	jal	80002840 <iunlockput>
  ilock(ip);
    8000404c:	8526                	mv	a0,s1
    8000404e:	de8fe0ef          	jal	80002636 <ilock>
  ip->nlink--;
    80004052:	04a4d783          	lhu	a5,74(s1)
    80004056:	37fd                	addiw	a5,a5,-1
    80004058:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000405c:	8526                	mv	a0,s1
    8000405e:	d24fe0ef          	jal	80002582 <iupdate>
  iunlockput(ip);
    80004062:	8526                	mv	a0,s1
    80004064:	fdcfe0ef          	jal	80002840 <iunlockput>
  end_op();
    80004068:	ecffe0ef          	jal	80002f36 <end_op>
  return -1;
    8000406c:	57fd                	li	a5,-1
    8000406e:	64f2                	ld	s1,280(sp)
    80004070:	6952                	ld	s2,272(sp)
}
    80004072:	853e                	mv	a0,a5
    80004074:	70b2                	ld	ra,296(sp)
    80004076:	7412                	ld	s0,288(sp)
    80004078:	6155                	addi	sp,sp,304
    8000407a:	8082                	ret

000000008000407c <sys_unlink>:
{
    8000407c:	7151                	addi	sp,sp,-240
    8000407e:	f586                	sd	ra,232(sp)
    80004080:	f1a2                	sd	s0,224(sp)
    80004082:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004084:	08000613          	li	a2,128
    80004088:	f3040593          	addi	a1,s0,-208
    8000408c:	4501                	li	a0,0
    8000408e:	bb5fd0ef          	jal	80001c42 <argstr>
    80004092:	16054063          	bltz	a0,800041f2 <sys_unlink+0x176>
    80004096:	eda6                	sd	s1,216(sp)
  begin_op();
    80004098:	e35fe0ef          	jal	80002ecc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000409c:	fb040593          	addi	a1,s0,-80
    800040a0:	f3040513          	addi	a0,s0,-208
    800040a4:	c87fe0ef          	jal	80002d2a <nameiparent>
    800040a8:	84aa                	mv	s1,a0
    800040aa:	c945                	beqz	a0,8000415a <sys_unlink+0xde>
  ilock(dp);
    800040ac:	d8afe0ef          	jal	80002636 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800040b0:	00003597          	auipc	a1,0x3
    800040b4:	52058593          	addi	a1,a1,1312 # 800075d0 <etext+0x5d0>
    800040b8:	fb040513          	addi	a0,s0,-80
    800040bc:	9d9fe0ef          	jal	80002a94 <namecmp>
    800040c0:	10050e63          	beqz	a0,800041dc <sys_unlink+0x160>
    800040c4:	00003597          	auipc	a1,0x3
    800040c8:	51458593          	addi	a1,a1,1300 # 800075d8 <etext+0x5d8>
    800040cc:	fb040513          	addi	a0,s0,-80
    800040d0:	9c5fe0ef          	jal	80002a94 <namecmp>
    800040d4:	10050463          	beqz	a0,800041dc <sys_unlink+0x160>
    800040d8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800040da:	f2c40613          	addi	a2,s0,-212
    800040de:	fb040593          	addi	a1,s0,-80
    800040e2:	8526                	mv	a0,s1
    800040e4:	9c7fe0ef          	jal	80002aaa <dirlookup>
    800040e8:	892a                	mv	s2,a0
    800040ea:	0e050863          	beqz	a0,800041da <sys_unlink+0x15e>
  ilock(ip);
    800040ee:	d48fe0ef          	jal	80002636 <ilock>
  if(ip->nlink < 1)
    800040f2:	04a91783          	lh	a5,74(s2)
    800040f6:	06f05763          	blez	a5,80004164 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800040fa:	04491703          	lh	a4,68(s2)
    800040fe:	4785                	li	a5,1
    80004100:	06f70963          	beq	a4,a5,80004172 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004104:	4641                	li	a2,16
    80004106:	4581                	li	a1,0
    80004108:	fc040513          	addi	a0,s0,-64
    8000410c:	828fc0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004110:	4741                	li	a4,16
    80004112:	f2c42683          	lw	a3,-212(s0)
    80004116:	fc040613          	addi	a2,s0,-64
    8000411a:	4581                	li	a1,0
    8000411c:	8526                	mv	a0,s1
    8000411e:	869fe0ef          	jal	80002986 <writei>
    80004122:	47c1                	li	a5,16
    80004124:	08f51b63          	bne	a0,a5,800041ba <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004128:	04491703          	lh	a4,68(s2)
    8000412c:	4785                	li	a5,1
    8000412e:	08f70d63          	beq	a4,a5,800041c8 <sys_unlink+0x14c>
  iunlockput(dp);
    80004132:	8526                	mv	a0,s1
    80004134:	f0cfe0ef          	jal	80002840 <iunlockput>
  ip->nlink--;
    80004138:	04a95783          	lhu	a5,74(s2)
    8000413c:	37fd                	addiw	a5,a5,-1
    8000413e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004142:	854a                	mv	a0,s2
    80004144:	c3efe0ef          	jal	80002582 <iupdate>
  iunlockput(ip);
    80004148:	854a                	mv	a0,s2
    8000414a:	ef6fe0ef          	jal	80002840 <iunlockput>
  end_op();
    8000414e:	de9fe0ef          	jal	80002f36 <end_op>
  return 0;
    80004152:	4501                	li	a0,0
    80004154:	64ee                	ld	s1,216(sp)
    80004156:	694e                	ld	s2,208(sp)
    80004158:	a849                	j	800041ea <sys_unlink+0x16e>
    end_op();
    8000415a:	dddfe0ef          	jal	80002f36 <end_op>
    return -1;
    8000415e:	557d                	li	a0,-1
    80004160:	64ee                	ld	s1,216(sp)
    80004162:	a061                	j	800041ea <sys_unlink+0x16e>
    80004164:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004166:	00003517          	auipc	a0,0x3
    8000416a:	47a50513          	addi	a0,a0,1146 # 800075e0 <etext+0x5e0>
    8000416e:	274010ef          	jal	800053e2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004172:	04c92703          	lw	a4,76(s2)
    80004176:	02000793          	li	a5,32
    8000417a:	f8e7f5e3          	bgeu	a5,a4,80004104 <sys_unlink+0x88>
    8000417e:	e5ce                	sd	s3,200(sp)
    80004180:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004184:	4741                	li	a4,16
    80004186:	86ce                	mv	a3,s3
    80004188:	f1840613          	addi	a2,s0,-232
    8000418c:	4581                	li	a1,0
    8000418e:	854a                	mv	a0,s2
    80004190:	efafe0ef          	jal	8000288a <readi>
    80004194:	47c1                	li	a5,16
    80004196:	00f51c63          	bne	a0,a5,800041ae <sys_unlink+0x132>
    if(de.inum != 0)
    8000419a:	f1845783          	lhu	a5,-232(s0)
    8000419e:	efa1                	bnez	a5,800041f6 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800041a0:	29c1                	addiw	s3,s3,16
    800041a2:	04c92783          	lw	a5,76(s2)
    800041a6:	fcf9efe3          	bltu	s3,a5,80004184 <sys_unlink+0x108>
    800041aa:	69ae                	ld	s3,200(sp)
    800041ac:	bfa1                	j	80004104 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800041ae:	00003517          	auipc	a0,0x3
    800041b2:	44a50513          	addi	a0,a0,1098 # 800075f8 <etext+0x5f8>
    800041b6:	22c010ef          	jal	800053e2 <panic>
    800041ba:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800041bc:	00003517          	auipc	a0,0x3
    800041c0:	45450513          	addi	a0,a0,1108 # 80007610 <etext+0x610>
    800041c4:	21e010ef          	jal	800053e2 <panic>
    dp->nlink--;
    800041c8:	04a4d783          	lhu	a5,74(s1)
    800041cc:	37fd                	addiw	a5,a5,-1
    800041ce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800041d2:	8526                	mv	a0,s1
    800041d4:	baefe0ef          	jal	80002582 <iupdate>
    800041d8:	bfa9                	j	80004132 <sys_unlink+0xb6>
    800041da:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800041dc:	8526                	mv	a0,s1
    800041de:	e62fe0ef          	jal	80002840 <iunlockput>
  end_op();
    800041e2:	d55fe0ef          	jal	80002f36 <end_op>
  return -1;
    800041e6:	557d                	li	a0,-1
    800041e8:	64ee                	ld	s1,216(sp)
}
    800041ea:	70ae                	ld	ra,232(sp)
    800041ec:	740e                	ld	s0,224(sp)
    800041ee:	616d                	addi	sp,sp,240
    800041f0:	8082                	ret
    return -1;
    800041f2:	557d                	li	a0,-1
    800041f4:	bfdd                	j	800041ea <sys_unlink+0x16e>
    iunlockput(ip);
    800041f6:	854a                	mv	a0,s2
    800041f8:	e48fe0ef          	jal	80002840 <iunlockput>
    goto bad;
    800041fc:	694e                	ld	s2,208(sp)
    800041fe:	69ae                	ld	s3,200(sp)
    80004200:	bff1                	j	800041dc <sys_unlink+0x160>

0000000080004202 <sys_open>:

uint64
sys_open(void)
{
    80004202:	7131                	addi	sp,sp,-192
    80004204:	fd06                	sd	ra,184(sp)
    80004206:	f922                	sd	s0,176(sp)
    80004208:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000420a:	f4c40593          	addi	a1,s0,-180
    8000420e:	4505                	li	a0,1
    80004210:	9fbfd0ef          	jal	80001c0a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004214:	08000613          	li	a2,128
    80004218:	f5040593          	addi	a1,s0,-176
    8000421c:	4501                	li	a0,0
    8000421e:	a25fd0ef          	jal	80001c42 <argstr>
    80004222:	87aa                	mv	a5,a0
    return -1;
    80004224:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004226:	0a07c263          	bltz	a5,800042ca <sys_open+0xc8>
    8000422a:	f526                	sd	s1,168(sp)

  begin_op();
    8000422c:	ca1fe0ef          	jal	80002ecc <begin_op>

  if(omode & O_CREATE){
    80004230:	f4c42783          	lw	a5,-180(s0)
    80004234:	2007f793          	andi	a5,a5,512
    80004238:	c3d5                	beqz	a5,800042dc <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000423a:	4681                	li	a3,0
    8000423c:	4601                	li	a2,0
    8000423e:	4589                	li	a1,2
    80004240:	f5040513          	addi	a0,s0,-176
    80004244:	aa9ff0ef          	jal	80003cec <create>
    80004248:	84aa                	mv	s1,a0
    if(ip == 0){
    8000424a:	c541                	beqz	a0,800042d2 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000424c:	04449703          	lh	a4,68(s1)
    80004250:	478d                	li	a5,3
    80004252:	00f71763          	bne	a4,a5,80004260 <sys_open+0x5e>
    80004256:	0464d703          	lhu	a4,70(s1)
    8000425a:	47a5                	li	a5,9
    8000425c:	0ae7ed63          	bltu	a5,a4,80004316 <sys_open+0x114>
    80004260:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004262:	fe1fe0ef          	jal	80003242 <filealloc>
    80004266:	892a                	mv	s2,a0
    80004268:	c179                	beqz	a0,8000432e <sys_open+0x12c>
    8000426a:	ed4e                	sd	s3,152(sp)
    8000426c:	a43ff0ef          	jal	80003cae <fdalloc>
    80004270:	89aa                	mv	s3,a0
    80004272:	0a054a63          	bltz	a0,80004326 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004276:	04449703          	lh	a4,68(s1)
    8000427a:	478d                	li	a5,3
    8000427c:	0cf70263          	beq	a4,a5,80004340 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004280:	4789                	li	a5,2
    80004282:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004286:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000428a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000428e:	f4c42783          	lw	a5,-180(s0)
    80004292:	0017c713          	xori	a4,a5,1
    80004296:	8b05                	andi	a4,a4,1
    80004298:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000429c:	0037f713          	andi	a4,a5,3
    800042a0:	00e03733          	snez	a4,a4
    800042a4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800042a8:	4007f793          	andi	a5,a5,1024
    800042ac:	c791                	beqz	a5,800042b8 <sys_open+0xb6>
    800042ae:	04449703          	lh	a4,68(s1)
    800042b2:	4789                	li	a5,2
    800042b4:	08f70d63          	beq	a4,a5,8000434e <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800042b8:	8526                	mv	a0,s1
    800042ba:	c2afe0ef          	jal	800026e4 <iunlock>
  end_op();
    800042be:	c79fe0ef          	jal	80002f36 <end_op>

  return fd;
    800042c2:	854e                	mv	a0,s3
    800042c4:	74aa                	ld	s1,168(sp)
    800042c6:	790a                	ld	s2,160(sp)
    800042c8:	69ea                	ld	s3,152(sp)
}
    800042ca:	70ea                	ld	ra,184(sp)
    800042cc:	744a                	ld	s0,176(sp)
    800042ce:	6129                	addi	sp,sp,192
    800042d0:	8082                	ret
      end_op();
    800042d2:	c65fe0ef          	jal	80002f36 <end_op>
      return -1;
    800042d6:	557d                	li	a0,-1
    800042d8:	74aa                	ld	s1,168(sp)
    800042da:	bfc5                	j	800042ca <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800042dc:	f5040513          	addi	a0,s0,-176
    800042e0:	a31fe0ef          	jal	80002d10 <namei>
    800042e4:	84aa                	mv	s1,a0
    800042e6:	c11d                	beqz	a0,8000430c <sys_open+0x10a>
    ilock(ip);
    800042e8:	b4efe0ef          	jal	80002636 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800042ec:	04449703          	lh	a4,68(s1)
    800042f0:	4785                	li	a5,1
    800042f2:	f4f71de3          	bne	a4,a5,8000424c <sys_open+0x4a>
    800042f6:	f4c42783          	lw	a5,-180(s0)
    800042fa:	d3bd                	beqz	a5,80004260 <sys_open+0x5e>
      iunlockput(ip);
    800042fc:	8526                	mv	a0,s1
    800042fe:	d42fe0ef          	jal	80002840 <iunlockput>
      end_op();
    80004302:	c35fe0ef          	jal	80002f36 <end_op>
      return -1;
    80004306:	557d                	li	a0,-1
    80004308:	74aa                	ld	s1,168(sp)
    8000430a:	b7c1                	j	800042ca <sys_open+0xc8>
      end_op();
    8000430c:	c2bfe0ef          	jal	80002f36 <end_op>
      return -1;
    80004310:	557d                	li	a0,-1
    80004312:	74aa                	ld	s1,168(sp)
    80004314:	bf5d                	j	800042ca <sys_open+0xc8>
    iunlockput(ip);
    80004316:	8526                	mv	a0,s1
    80004318:	d28fe0ef          	jal	80002840 <iunlockput>
    end_op();
    8000431c:	c1bfe0ef          	jal	80002f36 <end_op>
    return -1;
    80004320:	557d                	li	a0,-1
    80004322:	74aa                	ld	s1,168(sp)
    80004324:	b75d                	j	800042ca <sys_open+0xc8>
      fileclose(f);
    80004326:	854a                	mv	a0,s2
    80004328:	fbffe0ef          	jal	800032e6 <fileclose>
    8000432c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000432e:	8526                	mv	a0,s1
    80004330:	d10fe0ef          	jal	80002840 <iunlockput>
    end_op();
    80004334:	c03fe0ef          	jal	80002f36 <end_op>
    return -1;
    80004338:	557d                	li	a0,-1
    8000433a:	74aa                	ld	s1,168(sp)
    8000433c:	790a                	ld	s2,160(sp)
    8000433e:	b771                	j	800042ca <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004340:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004344:	04649783          	lh	a5,70(s1)
    80004348:	02f91223          	sh	a5,36(s2)
    8000434c:	bf3d                	j	8000428a <sys_open+0x88>
    itrunc(ip);
    8000434e:	8526                	mv	a0,s1
    80004350:	bd4fe0ef          	jal	80002724 <itrunc>
    80004354:	b795                	j	800042b8 <sys_open+0xb6>

0000000080004356 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004356:	7175                	addi	sp,sp,-144
    80004358:	e506                	sd	ra,136(sp)
    8000435a:	e122                	sd	s0,128(sp)
    8000435c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000435e:	b6ffe0ef          	jal	80002ecc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004362:	08000613          	li	a2,128
    80004366:	f7040593          	addi	a1,s0,-144
    8000436a:	4501                	li	a0,0
    8000436c:	8d7fd0ef          	jal	80001c42 <argstr>
    80004370:	02054363          	bltz	a0,80004396 <sys_mkdir+0x40>
    80004374:	4681                	li	a3,0
    80004376:	4601                	li	a2,0
    80004378:	4585                	li	a1,1
    8000437a:	f7040513          	addi	a0,s0,-144
    8000437e:	96fff0ef          	jal	80003cec <create>
    80004382:	c911                	beqz	a0,80004396 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004384:	cbcfe0ef          	jal	80002840 <iunlockput>
  end_op();
    80004388:	baffe0ef          	jal	80002f36 <end_op>
  return 0;
    8000438c:	4501                	li	a0,0
}
    8000438e:	60aa                	ld	ra,136(sp)
    80004390:	640a                	ld	s0,128(sp)
    80004392:	6149                	addi	sp,sp,144
    80004394:	8082                	ret
    end_op();
    80004396:	ba1fe0ef          	jal	80002f36 <end_op>
    return -1;
    8000439a:	557d                	li	a0,-1
    8000439c:	bfcd                	j	8000438e <sys_mkdir+0x38>

000000008000439e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000439e:	7135                	addi	sp,sp,-160
    800043a0:	ed06                	sd	ra,152(sp)
    800043a2:	e922                	sd	s0,144(sp)
    800043a4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043a6:	b27fe0ef          	jal	80002ecc <begin_op>
  argint(1, &major);
    800043aa:	f6c40593          	addi	a1,s0,-148
    800043ae:	4505                	li	a0,1
    800043b0:	85bfd0ef          	jal	80001c0a <argint>
  argint(2, &minor);
    800043b4:	f6840593          	addi	a1,s0,-152
    800043b8:	4509                	li	a0,2
    800043ba:	851fd0ef          	jal	80001c0a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043be:	08000613          	li	a2,128
    800043c2:	f7040593          	addi	a1,s0,-144
    800043c6:	4501                	li	a0,0
    800043c8:	87bfd0ef          	jal	80001c42 <argstr>
    800043cc:	02054563          	bltz	a0,800043f6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043d0:	f6841683          	lh	a3,-152(s0)
    800043d4:	f6c41603          	lh	a2,-148(s0)
    800043d8:	458d                	li	a1,3
    800043da:	f7040513          	addi	a0,s0,-144
    800043de:	90fff0ef          	jal	80003cec <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043e2:	c911                	beqz	a0,800043f6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043e4:	c5cfe0ef          	jal	80002840 <iunlockput>
  end_op();
    800043e8:	b4ffe0ef          	jal	80002f36 <end_op>
  return 0;
    800043ec:	4501                	li	a0,0
}
    800043ee:	60ea                	ld	ra,152(sp)
    800043f0:	644a                	ld	s0,144(sp)
    800043f2:	610d                	addi	sp,sp,160
    800043f4:	8082                	ret
    end_op();
    800043f6:	b41fe0ef          	jal	80002f36 <end_op>
    return -1;
    800043fa:	557d                	li	a0,-1
    800043fc:	bfcd                	j	800043ee <sys_mknod+0x50>

00000000800043fe <sys_chdir>:

uint64
sys_chdir(void)
{
    800043fe:	7135                	addi	sp,sp,-160
    80004400:	ed06                	sd	ra,152(sp)
    80004402:	e922                	sd	s0,144(sp)
    80004404:	e14a                	sd	s2,128(sp)
    80004406:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004408:	94ffc0ef          	jal	80000d56 <myproc>
    8000440c:	892a                	mv	s2,a0
  
  begin_op();
    8000440e:	abffe0ef          	jal	80002ecc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004412:	08000613          	li	a2,128
    80004416:	f6040593          	addi	a1,s0,-160
    8000441a:	4501                	li	a0,0
    8000441c:	827fd0ef          	jal	80001c42 <argstr>
    80004420:	04054363          	bltz	a0,80004466 <sys_chdir+0x68>
    80004424:	e526                	sd	s1,136(sp)
    80004426:	f6040513          	addi	a0,s0,-160
    8000442a:	8e7fe0ef          	jal	80002d10 <namei>
    8000442e:	84aa                	mv	s1,a0
    80004430:	c915                	beqz	a0,80004464 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004432:	a04fe0ef          	jal	80002636 <ilock>
  if(ip->type != T_DIR){
    80004436:	04449703          	lh	a4,68(s1)
    8000443a:	4785                	li	a5,1
    8000443c:	02f71963          	bne	a4,a5,8000446e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004440:	8526                	mv	a0,s1
    80004442:	aa2fe0ef          	jal	800026e4 <iunlock>
  iput(p->cwd);
    80004446:	15093503          	ld	a0,336(s2)
    8000444a:	b6efe0ef          	jal	800027b8 <iput>
  end_op();
    8000444e:	ae9fe0ef          	jal	80002f36 <end_op>
  p->cwd = ip;
    80004452:	14993823          	sd	s1,336(s2)
  return 0;
    80004456:	4501                	li	a0,0
    80004458:	64aa                	ld	s1,136(sp)
}
    8000445a:	60ea                	ld	ra,152(sp)
    8000445c:	644a                	ld	s0,144(sp)
    8000445e:	690a                	ld	s2,128(sp)
    80004460:	610d                	addi	sp,sp,160
    80004462:	8082                	ret
    80004464:	64aa                	ld	s1,136(sp)
    end_op();
    80004466:	ad1fe0ef          	jal	80002f36 <end_op>
    return -1;
    8000446a:	557d                	li	a0,-1
    8000446c:	b7fd                	j	8000445a <sys_chdir+0x5c>
    iunlockput(ip);
    8000446e:	8526                	mv	a0,s1
    80004470:	bd0fe0ef          	jal	80002840 <iunlockput>
    end_op();
    80004474:	ac3fe0ef          	jal	80002f36 <end_op>
    return -1;
    80004478:	557d                	li	a0,-1
    8000447a:	64aa                	ld	s1,136(sp)
    8000447c:	bff9                	j	8000445a <sys_chdir+0x5c>

000000008000447e <sys_exec>:

uint64
sys_exec(void)
{
    8000447e:	7121                	addi	sp,sp,-448
    80004480:	ff06                	sd	ra,440(sp)
    80004482:	fb22                	sd	s0,432(sp)
    80004484:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004486:	e4840593          	addi	a1,s0,-440
    8000448a:	4505                	li	a0,1
    8000448c:	f9afd0ef          	jal	80001c26 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004490:	08000613          	li	a2,128
    80004494:	f5040593          	addi	a1,s0,-176
    80004498:	4501                	li	a0,0
    8000449a:	fa8fd0ef          	jal	80001c42 <argstr>
    8000449e:	87aa                	mv	a5,a0
    return -1;
    800044a0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044a2:	0c07c463          	bltz	a5,8000456a <sys_exec+0xec>
    800044a6:	f726                	sd	s1,424(sp)
    800044a8:	f34a                	sd	s2,416(sp)
    800044aa:	ef4e                	sd	s3,408(sp)
    800044ac:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800044ae:	10000613          	li	a2,256
    800044b2:	4581                	li	a1,0
    800044b4:	e5040513          	addi	a0,s0,-432
    800044b8:	c7dfb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044bc:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800044c0:	89a6                	mv	s3,s1
    800044c2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800044c4:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044c8:	00391513          	slli	a0,s2,0x3
    800044cc:	e4040593          	addi	a1,s0,-448
    800044d0:	e4843783          	ld	a5,-440(s0)
    800044d4:	953e                	add	a0,a0,a5
    800044d6:	eaafd0ef          	jal	80001b80 <fetchaddr>
    800044da:	02054663          	bltz	a0,80004506 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800044de:	e4043783          	ld	a5,-448(s0)
    800044e2:	c3a9                	beqz	a5,80004524 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800044e4:	c13fb0ef          	jal	800000f6 <kalloc>
    800044e8:	85aa                	mv	a1,a0
    800044ea:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800044ee:	cd01                	beqz	a0,80004506 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800044f0:	6605                	lui	a2,0x1
    800044f2:	e4043503          	ld	a0,-448(s0)
    800044f6:	ed4fd0ef          	jal	80001bca <fetchstr>
    800044fa:	00054663          	bltz	a0,80004506 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800044fe:	0905                	addi	s2,s2,1
    80004500:	09a1                	addi	s3,s3,8
    80004502:	fd4913e3          	bne	s2,s4,800044c8 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004506:	f5040913          	addi	s2,s0,-176
    8000450a:	6088                	ld	a0,0(s1)
    8000450c:	c931                	beqz	a0,80004560 <sys_exec+0xe2>
    kfree(argv[i]);
    8000450e:	b0ffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004512:	04a1                	addi	s1,s1,8
    80004514:	ff249be3          	bne	s1,s2,8000450a <sys_exec+0x8c>
  return -1;
    80004518:	557d                	li	a0,-1
    8000451a:	74ba                	ld	s1,424(sp)
    8000451c:	791a                	ld	s2,416(sp)
    8000451e:	69fa                	ld	s3,408(sp)
    80004520:	6a5a                	ld	s4,400(sp)
    80004522:	a0a1                	j	8000456a <sys_exec+0xec>
      argv[i] = 0;
    80004524:	0009079b          	sext.w	a5,s2
    80004528:	078e                	slli	a5,a5,0x3
    8000452a:	fd078793          	addi	a5,a5,-48
    8000452e:	97a2                	add	a5,a5,s0
    80004530:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004534:	e5040593          	addi	a1,s0,-432
    80004538:	f5040513          	addi	a0,s0,-176
    8000453c:	ba8ff0ef          	jal	800038e4 <exec>
    80004540:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004542:	f5040993          	addi	s3,s0,-176
    80004546:	6088                	ld	a0,0(s1)
    80004548:	c511                	beqz	a0,80004554 <sys_exec+0xd6>
    kfree(argv[i]);
    8000454a:	ad3fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000454e:	04a1                	addi	s1,s1,8
    80004550:	ff349be3          	bne	s1,s3,80004546 <sys_exec+0xc8>
  return ret;
    80004554:	854a                	mv	a0,s2
    80004556:	74ba                	ld	s1,424(sp)
    80004558:	791a                	ld	s2,416(sp)
    8000455a:	69fa                	ld	s3,408(sp)
    8000455c:	6a5a                	ld	s4,400(sp)
    8000455e:	a031                	j	8000456a <sys_exec+0xec>
  return -1;
    80004560:	557d                	li	a0,-1
    80004562:	74ba                	ld	s1,424(sp)
    80004564:	791a                	ld	s2,416(sp)
    80004566:	69fa                	ld	s3,408(sp)
    80004568:	6a5a                	ld	s4,400(sp)
}
    8000456a:	70fa                	ld	ra,440(sp)
    8000456c:	745a                	ld	s0,432(sp)
    8000456e:	6139                	addi	sp,sp,448
    80004570:	8082                	ret

0000000080004572 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004572:	7139                	addi	sp,sp,-64
    80004574:	fc06                	sd	ra,56(sp)
    80004576:	f822                	sd	s0,48(sp)
    80004578:	f426                	sd	s1,40(sp)
    8000457a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000457c:	fdafc0ef          	jal	80000d56 <myproc>
    80004580:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004582:	fd840593          	addi	a1,s0,-40
    80004586:	4501                	li	a0,0
    80004588:	e9efd0ef          	jal	80001c26 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000458c:	fc840593          	addi	a1,s0,-56
    80004590:	fd040513          	addi	a0,s0,-48
    80004594:	85cff0ef          	jal	800035f0 <pipealloc>
    return -1;
    80004598:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000459a:	0a054463          	bltz	a0,80004642 <sys_pipe+0xd0>
  fd0 = -1;
    8000459e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800045a2:	fd043503          	ld	a0,-48(s0)
    800045a6:	f08ff0ef          	jal	80003cae <fdalloc>
    800045aa:	fca42223          	sw	a0,-60(s0)
    800045ae:	08054163          	bltz	a0,80004630 <sys_pipe+0xbe>
    800045b2:	fc843503          	ld	a0,-56(s0)
    800045b6:	ef8ff0ef          	jal	80003cae <fdalloc>
    800045ba:	fca42023          	sw	a0,-64(s0)
    800045be:	06054063          	bltz	a0,8000461e <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045c2:	4691                	li	a3,4
    800045c4:	fc440613          	addi	a2,s0,-60
    800045c8:	fd843583          	ld	a1,-40(s0)
    800045cc:	68a8                	ld	a0,80(s1)
    800045ce:	bf8fc0ef          	jal	800009c6 <copyout>
    800045d2:	00054e63          	bltz	a0,800045ee <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800045d6:	4691                	li	a3,4
    800045d8:	fc040613          	addi	a2,s0,-64
    800045dc:	fd843583          	ld	a1,-40(s0)
    800045e0:	0591                	addi	a1,a1,4
    800045e2:	68a8                	ld	a0,80(s1)
    800045e4:	be2fc0ef          	jal	800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800045e8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045ea:	04055c63          	bgez	a0,80004642 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800045ee:	fc442783          	lw	a5,-60(s0)
    800045f2:	07e9                	addi	a5,a5,26
    800045f4:	078e                	slli	a5,a5,0x3
    800045f6:	97a6                	add	a5,a5,s1
    800045f8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800045fc:	fc042783          	lw	a5,-64(s0)
    80004600:	07e9                	addi	a5,a5,26
    80004602:	078e                	slli	a5,a5,0x3
    80004604:	94be                	add	s1,s1,a5
    80004606:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000460a:	fd043503          	ld	a0,-48(s0)
    8000460e:	cd9fe0ef          	jal	800032e6 <fileclose>
    fileclose(wf);
    80004612:	fc843503          	ld	a0,-56(s0)
    80004616:	cd1fe0ef          	jal	800032e6 <fileclose>
    return -1;
    8000461a:	57fd                	li	a5,-1
    8000461c:	a01d                	j	80004642 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000461e:	fc442783          	lw	a5,-60(s0)
    80004622:	0007c763          	bltz	a5,80004630 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004626:	07e9                	addi	a5,a5,26
    80004628:	078e                	slli	a5,a5,0x3
    8000462a:	97a6                	add	a5,a5,s1
    8000462c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004630:	fd043503          	ld	a0,-48(s0)
    80004634:	cb3fe0ef          	jal	800032e6 <fileclose>
    fileclose(wf);
    80004638:	fc843503          	ld	a0,-56(s0)
    8000463c:	cabfe0ef          	jal	800032e6 <fileclose>
    return -1;
    80004640:	57fd                	li	a5,-1
}
    80004642:	853e                	mv	a0,a5
    80004644:	70e2                	ld	ra,56(sp)
    80004646:	7442                	ld	s0,48(sp)
    80004648:	74a2                	ld	s1,40(sp)
    8000464a:	6121                	addi	sp,sp,64
    8000464c:	8082                	ret
	...

0000000080004650 <kernelvec>:
    80004650:	7111                	addi	sp,sp,-256
    80004652:	e006                	sd	ra,0(sp)
    80004654:	e40a                	sd	sp,8(sp)
    80004656:	e80e                	sd	gp,16(sp)
    80004658:	ec12                	sd	tp,24(sp)
    8000465a:	f016                	sd	t0,32(sp)
    8000465c:	f41a                	sd	t1,40(sp)
    8000465e:	f81e                	sd	t2,48(sp)
    80004660:	e4aa                	sd	a0,72(sp)
    80004662:	e8ae                	sd	a1,80(sp)
    80004664:	ecb2                	sd	a2,88(sp)
    80004666:	f0b6                	sd	a3,96(sp)
    80004668:	f4ba                	sd	a4,104(sp)
    8000466a:	f8be                	sd	a5,112(sp)
    8000466c:	fcc2                	sd	a6,120(sp)
    8000466e:	e146                	sd	a7,128(sp)
    80004670:	edf2                	sd	t3,216(sp)
    80004672:	f1f6                	sd	t4,224(sp)
    80004674:	f5fa                	sd	t5,232(sp)
    80004676:	f9fe                	sd	t6,240(sp)
    80004678:	c18fd0ef          	jal	80001a90 <kerneltrap>
    8000467c:	6082                	ld	ra,0(sp)
    8000467e:	6122                	ld	sp,8(sp)
    80004680:	61c2                	ld	gp,16(sp)
    80004682:	7282                	ld	t0,32(sp)
    80004684:	7322                	ld	t1,40(sp)
    80004686:	73c2                	ld	t2,48(sp)
    80004688:	6526                	ld	a0,72(sp)
    8000468a:	65c6                	ld	a1,80(sp)
    8000468c:	6666                	ld	a2,88(sp)
    8000468e:	7686                	ld	a3,96(sp)
    80004690:	7726                	ld	a4,104(sp)
    80004692:	77c6                	ld	a5,112(sp)
    80004694:	7866                	ld	a6,120(sp)
    80004696:	688a                	ld	a7,128(sp)
    80004698:	6e6e                	ld	t3,216(sp)
    8000469a:	7e8e                	ld	t4,224(sp)
    8000469c:	7f2e                	ld	t5,232(sp)
    8000469e:	7fce                	ld	t6,240(sp)
    800046a0:	6111                	addi	sp,sp,256
    800046a2:	10200073          	sret
	...

00000000800046ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800046ae:	1141                	addi	sp,sp,-16
    800046b0:	e422                	sd	s0,8(sp)
    800046b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800046b4:	0c0007b7          	lui	a5,0xc000
    800046b8:	4705                	li	a4,1
    800046ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800046bc:	0c0007b7          	lui	a5,0xc000
    800046c0:	c3d8                	sw	a4,4(a5)
}
    800046c2:	6422                	ld	s0,8(sp)
    800046c4:	0141                	addi	sp,sp,16
    800046c6:	8082                	ret

00000000800046c8 <plicinithart>:

void
plicinithart(void)
{
    800046c8:	1141                	addi	sp,sp,-16
    800046ca:	e406                	sd	ra,8(sp)
    800046cc:	e022                	sd	s0,0(sp)
    800046ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800046d0:	e5afc0ef          	jal	80000d2a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800046d4:	0085171b          	slliw	a4,a0,0x8
    800046d8:	0c0027b7          	lui	a5,0xc002
    800046dc:	97ba                	add	a5,a5,a4
    800046de:	40200713          	li	a4,1026
    800046e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800046e6:	00d5151b          	slliw	a0,a0,0xd
    800046ea:	0c2017b7          	lui	a5,0xc201
    800046ee:	97aa                	add	a5,a5,a0
    800046f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800046f4:	60a2                	ld	ra,8(sp)
    800046f6:	6402                	ld	s0,0(sp)
    800046f8:	0141                	addi	sp,sp,16
    800046fa:	8082                	ret

00000000800046fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800046fc:	1141                	addi	sp,sp,-16
    800046fe:	e406                	sd	ra,8(sp)
    80004700:	e022                	sd	s0,0(sp)
    80004702:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004704:	e26fc0ef          	jal	80000d2a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004708:	00d5151b          	slliw	a0,a0,0xd
    8000470c:	0c2017b7          	lui	a5,0xc201
    80004710:	97aa                	add	a5,a5,a0
  return irq;
}
    80004712:	43c8                	lw	a0,4(a5)
    80004714:	60a2                	ld	ra,8(sp)
    80004716:	6402                	ld	s0,0(sp)
    80004718:	0141                	addi	sp,sp,16
    8000471a:	8082                	ret

000000008000471c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000471c:	1101                	addi	sp,sp,-32
    8000471e:	ec06                	sd	ra,24(sp)
    80004720:	e822                	sd	s0,16(sp)
    80004722:	e426                	sd	s1,8(sp)
    80004724:	1000                	addi	s0,sp,32
    80004726:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004728:	e02fc0ef          	jal	80000d2a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000472c:	00d5151b          	slliw	a0,a0,0xd
    80004730:	0c2017b7          	lui	a5,0xc201
    80004734:	97aa                	add	a5,a5,a0
    80004736:	c3c4                	sw	s1,4(a5)
}
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	64a2                	ld	s1,8(sp)
    8000473e:	6105                	addi	sp,sp,32
    80004740:	8082                	ret

0000000080004742 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004742:	1141                	addi	sp,sp,-16
    80004744:	e406                	sd	ra,8(sp)
    80004746:	e022                	sd	s0,0(sp)
    80004748:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000474a:	479d                	li	a5,7
    8000474c:	04a7ca63          	blt	a5,a0,800047a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004750:	00017797          	auipc	a5,0x17
    80004754:	bc078793          	addi	a5,a5,-1088 # 8001b310 <disk>
    80004758:	97aa                	add	a5,a5,a0
    8000475a:	0187c783          	lbu	a5,24(a5)
    8000475e:	e7b9                	bnez	a5,800047ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004760:	00451693          	slli	a3,a0,0x4
    80004764:	00017797          	auipc	a5,0x17
    80004768:	bac78793          	addi	a5,a5,-1108 # 8001b310 <disk>
    8000476c:	6398                	ld	a4,0(a5)
    8000476e:	9736                	add	a4,a4,a3
    80004770:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004774:	6398                	ld	a4,0(a5)
    80004776:	9736                	add	a4,a4,a3
    80004778:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000477c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004780:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004784:	97aa                	add	a5,a5,a0
    80004786:	4705                	li	a4,1
    80004788:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000478c:	00017517          	auipc	a0,0x17
    80004790:	b9c50513          	addi	a0,a0,-1124 # 8001b328 <disk+0x18>
    80004794:	bddfc0ef          	jal	80001370 <wakeup>
}
    80004798:	60a2                	ld	ra,8(sp)
    8000479a:	6402                	ld	s0,0(sp)
    8000479c:	0141                	addi	sp,sp,16
    8000479e:	8082                	ret
    panic("free_desc 1");
    800047a0:	00003517          	auipc	a0,0x3
    800047a4:	e8050513          	addi	a0,a0,-384 # 80007620 <etext+0x620>
    800047a8:	43b000ef          	jal	800053e2 <panic>
    panic("free_desc 2");
    800047ac:	00003517          	auipc	a0,0x3
    800047b0:	e8450513          	addi	a0,a0,-380 # 80007630 <etext+0x630>
    800047b4:	42f000ef          	jal	800053e2 <panic>

00000000800047b8 <virtio_disk_init>:
{
    800047b8:	1101                	addi	sp,sp,-32
    800047ba:	ec06                	sd	ra,24(sp)
    800047bc:	e822                	sd	s0,16(sp)
    800047be:	e426                	sd	s1,8(sp)
    800047c0:	e04a                	sd	s2,0(sp)
    800047c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800047c4:	00003597          	auipc	a1,0x3
    800047c8:	e7c58593          	addi	a1,a1,-388 # 80007640 <etext+0x640>
    800047cc:	00017517          	auipc	a0,0x17
    800047d0:	c6c50513          	addi	a0,a0,-916 # 8001b438 <disk+0x128>
    800047d4:	6bd000ef          	jal	80005690 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800047d8:	100017b7          	lui	a5,0x10001
    800047dc:	4398                	lw	a4,0(a5)
    800047de:	2701                	sext.w	a4,a4
    800047e0:	747277b7          	lui	a5,0x74727
    800047e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800047e8:	18f71063          	bne	a4,a5,80004968 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800047ec:	100017b7          	lui	a5,0x10001
    800047f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800047f2:	439c                	lw	a5,0(a5)
    800047f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800047f6:	4709                	li	a4,2
    800047f8:	16e79863          	bne	a5,a4,80004968 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800047fc:	100017b7          	lui	a5,0x10001
    80004800:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004802:	439c                	lw	a5,0(a5)
    80004804:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004806:	16e79163          	bne	a5,a4,80004968 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000480a:	100017b7          	lui	a5,0x10001
    8000480e:	47d8                	lw	a4,12(a5)
    80004810:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004812:	554d47b7          	lui	a5,0x554d4
    80004816:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000481a:	14f71763          	bne	a4,a5,80004968 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000481e:	100017b7          	lui	a5,0x10001
    80004822:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004826:	4705                	li	a4,1
    80004828:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000482a:	470d                	li	a4,3
    8000482c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000482e:	10001737          	lui	a4,0x10001
    80004832:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004834:	c7ffe737          	lui	a4,0xc7ffe
    80004838:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb20f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000483c:	8ef9                	and	a3,a3,a4
    8000483e:	10001737          	lui	a4,0x10001
    80004842:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004844:	472d                	li	a4,11
    80004846:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004848:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000484c:	439c                	lw	a5,0(a5)
    8000484e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004852:	8ba1                	andi	a5,a5,8
    80004854:	12078063          	beqz	a5,80004974 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004858:	100017b7          	lui	a5,0x10001
    8000485c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004860:	100017b7          	lui	a5,0x10001
    80004864:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004868:	439c                	lw	a5,0(a5)
    8000486a:	2781                	sext.w	a5,a5
    8000486c:	10079a63          	bnez	a5,80004980 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004870:	100017b7          	lui	a5,0x10001
    80004874:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004878:	439c                	lw	a5,0(a5)
    8000487a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000487c:	10078863          	beqz	a5,8000498c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004880:	471d                	li	a4,7
    80004882:	10f77b63          	bgeu	a4,a5,80004998 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004886:	871fb0ef          	jal	800000f6 <kalloc>
    8000488a:	00017497          	auipc	s1,0x17
    8000488e:	a8648493          	addi	s1,s1,-1402 # 8001b310 <disk>
    80004892:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004894:	863fb0ef          	jal	800000f6 <kalloc>
    80004898:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000489a:	85dfb0ef          	jal	800000f6 <kalloc>
    8000489e:	87aa                	mv	a5,a0
    800048a0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800048a2:	6088                	ld	a0,0(s1)
    800048a4:	10050063          	beqz	a0,800049a4 <virtio_disk_init+0x1ec>
    800048a8:	00017717          	auipc	a4,0x17
    800048ac:	a7073703          	ld	a4,-1424(a4) # 8001b318 <disk+0x8>
    800048b0:	0e070a63          	beqz	a4,800049a4 <virtio_disk_init+0x1ec>
    800048b4:	0e078863          	beqz	a5,800049a4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800048b8:	6605                	lui	a2,0x1
    800048ba:	4581                	li	a1,0
    800048bc:	879fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    800048c0:	00017497          	auipc	s1,0x17
    800048c4:	a5048493          	addi	s1,s1,-1456 # 8001b310 <disk>
    800048c8:	6605                	lui	a2,0x1
    800048ca:	4581                	li	a1,0
    800048cc:	6488                	ld	a0,8(s1)
    800048ce:	867fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    800048d2:	6605                	lui	a2,0x1
    800048d4:	4581                	li	a1,0
    800048d6:	6888                	ld	a0,16(s1)
    800048d8:	85dfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800048dc:	100017b7          	lui	a5,0x10001
    800048e0:	4721                	li	a4,8
    800048e2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800048e4:	4098                	lw	a4,0(s1)
    800048e6:	100017b7          	lui	a5,0x10001
    800048ea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800048ee:	40d8                	lw	a4,4(s1)
    800048f0:	100017b7          	lui	a5,0x10001
    800048f4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800048f8:	649c                	ld	a5,8(s1)
    800048fa:	0007869b          	sext.w	a3,a5
    800048fe:	10001737          	lui	a4,0x10001
    80004902:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004906:	9781                	srai	a5,a5,0x20
    80004908:	10001737          	lui	a4,0x10001
    8000490c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004910:	689c                	ld	a5,16(s1)
    80004912:	0007869b          	sext.w	a3,a5
    80004916:	10001737          	lui	a4,0x10001
    8000491a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000491e:	9781                	srai	a5,a5,0x20
    80004920:	10001737          	lui	a4,0x10001
    80004924:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004928:	10001737          	lui	a4,0x10001
    8000492c:	4785                	li	a5,1
    8000492e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004930:	00f48c23          	sb	a5,24(s1)
    80004934:	00f48ca3          	sb	a5,25(s1)
    80004938:	00f48d23          	sb	a5,26(s1)
    8000493c:	00f48da3          	sb	a5,27(s1)
    80004940:	00f48e23          	sb	a5,28(s1)
    80004944:	00f48ea3          	sb	a5,29(s1)
    80004948:	00f48f23          	sb	a5,30(s1)
    8000494c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004950:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004954:	100017b7          	lui	a5,0x10001
    80004958:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000495c:	60e2                	ld	ra,24(sp)
    8000495e:	6442                	ld	s0,16(sp)
    80004960:	64a2                	ld	s1,8(sp)
    80004962:	6902                	ld	s2,0(sp)
    80004964:	6105                	addi	sp,sp,32
    80004966:	8082                	ret
    panic("could not find virtio disk");
    80004968:	00003517          	auipc	a0,0x3
    8000496c:	ce850513          	addi	a0,a0,-792 # 80007650 <etext+0x650>
    80004970:	273000ef          	jal	800053e2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004974:	00003517          	auipc	a0,0x3
    80004978:	cfc50513          	addi	a0,a0,-772 # 80007670 <etext+0x670>
    8000497c:	267000ef          	jal	800053e2 <panic>
    panic("virtio disk should not be ready");
    80004980:	00003517          	auipc	a0,0x3
    80004984:	d1050513          	addi	a0,a0,-752 # 80007690 <etext+0x690>
    80004988:	25b000ef          	jal	800053e2 <panic>
    panic("virtio disk has no queue 0");
    8000498c:	00003517          	auipc	a0,0x3
    80004990:	d2450513          	addi	a0,a0,-732 # 800076b0 <etext+0x6b0>
    80004994:	24f000ef          	jal	800053e2 <panic>
    panic("virtio disk max queue too short");
    80004998:	00003517          	auipc	a0,0x3
    8000499c:	d3850513          	addi	a0,a0,-712 # 800076d0 <etext+0x6d0>
    800049a0:	243000ef          	jal	800053e2 <panic>
    panic("virtio disk kalloc");
    800049a4:	00003517          	auipc	a0,0x3
    800049a8:	d4c50513          	addi	a0,a0,-692 # 800076f0 <etext+0x6f0>
    800049ac:	237000ef          	jal	800053e2 <panic>

00000000800049b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800049b0:	7159                	addi	sp,sp,-112
    800049b2:	f486                	sd	ra,104(sp)
    800049b4:	f0a2                	sd	s0,96(sp)
    800049b6:	eca6                	sd	s1,88(sp)
    800049b8:	e8ca                	sd	s2,80(sp)
    800049ba:	e4ce                	sd	s3,72(sp)
    800049bc:	e0d2                	sd	s4,64(sp)
    800049be:	fc56                	sd	s5,56(sp)
    800049c0:	f85a                	sd	s6,48(sp)
    800049c2:	f45e                	sd	s7,40(sp)
    800049c4:	f062                	sd	s8,32(sp)
    800049c6:	ec66                	sd	s9,24(sp)
    800049c8:	1880                	addi	s0,sp,112
    800049ca:	8a2a                	mv	s4,a0
    800049cc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800049ce:	00c52c83          	lw	s9,12(a0)
    800049d2:	001c9c9b          	slliw	s9,s9,0x1
    800049d6:	1c82                	slli	s9,s9,0x20
    800049d8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800049dc:	00017517          	auipc	a0,0x17
    800049e0:	a5c50513          	addi	a0,a0,-1444 # 8001b438 <disk+0x128>
    800049e4:	52d000ef          	jal	80005710 <acquire>
  for(int i = 0; i < 3; i++){
    800049e8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800049ea:	44a1                	li	s1,8
      disk.free[i] = 0;
    800049ec:	00017b17          	auipc	s6,0x17
    800049f0:	924b0b13          	addi	s6,s6,-1756 # 8001b310 <disk>
  for(int i = 0; i < 3; i++){
    800049f4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800049f6:	00017c17          	auipc	s8,0x17
    800049fa:	a42c0c13          	addi	s8,s8,-1470 # 8001b438 <disk+0x128>
    800049fe:	a8b9                	j	80004a5c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004a00:	00fb0733          	add	a4,s6,a5
    80004a04:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004a08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a0a:	0207c563          	bltz	a5,80004a34 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004a0e:	2905                	addiw	s2,s2,1
    80004a10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a12:	05590963          	beq	s2,s5,80004a64 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004a16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a18:	00017717          	auipc	a4,0x17
    80004a1c:	8f870713          	addi	a4,a4,-1800 # 8001b310 <disk>
    80004a20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004a22:	01874683          	lbu	a3,24(a4)
    80004a26:	fee9                	bnez	a3,80004a00 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004a28:	2785                	addiw	a5,a5,1
    80004a2a:	0705                	addi	a4,a4,1
    80004a2c:	fe979be3          	bne	a5,s1,80004a22 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004a30:	57fd                	li	a5,-1
    80004a32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004a34:	01205d63          	blez	s2,80004a4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004a38:	f9042503          	lw	a0,-112(s0)
    80004a3c:	d07ff0ef          	jal	80004742 <free_desc>
      for(int j = 0; j < i; j++)
    80004a40:	4785                	li	a5,1
    80004a42:	0127d663          	bge	a5,s2,80004a4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004a46:	f9442503          	lw	a0,-108(s0)
    80004a4a:	cf9ff0ef          	jal	80004742 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a4e:	85e2                	mv	a1,s8
    80004a50:	00017517          	auipc	a0,0x17
    80004a54:	8d850513          	addi	a0,a0,-1832 # 8001b328 <disk+0x18>
    80004a58:	8cdfc0ef          	jal	80001324 <sleep>
  for(int i = 0; i < 3; i++){
    80004a5c:	f9040613          	addi	a2,s0,-112
    80004a60:	894e                	mv	s2,s3
    80004a62:	bf55                	j	80004a16 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a64:	f9042503          	lw	a0,-112(s0)
    80004a68:	00451693          	slli	a3,a0,0x4

  if(write)
    80004a6c:	00017797          	auipc	a5,0x17
    80004a70:	8a478793          	addi	a5,a5,-1884 # 8001b310 <disk>
    80004a74:	00a50713          	addi	a4,a0,10
    80004a78:	0712                	slli	a4,a4,0x4
    80004a7a:	973e                	add	a4,a4,a5
    80004a7c:	01703633          	snez	a2,s7
    80004a80:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004a82:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004a86:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a8a:	6398                	ld	a4,0(a5)
    80004a8c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a8e:	0a868613          	addi	a2,a3,168
    80004a92:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004a94:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004a96:	6390                	ld	a2,0(a5)
    80004a98:	00d605b3          	add	a1,a2,a3
    80004a9c:	4741                	li	a4,16
    80004a9e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004aa0:	4805                	li	a6,1
    80004aa2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004aa6:	f9442703          	lw	a4,-108(s0)
    80004aaa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004aae:	0712                	slli	a4,a4,0x4
    80004ab0:	963a                	add	a2,a2,a4
    80004ab2:	058a0593          	addi	a1,s4,88
    80004ab6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ab8:	0007b883          	ld	a7,0(a5)
    80004abc:	9746                	add	a4,a4,a7
    80004abe:	40000613          	li	a2,1024
    80004ac2:	c710                	sw	a2,8(a4)
  if(write)
    80004ac4:	001bb613          	seqz	a2,s7
    80004ac8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004acc:	00166613          	ori	a2,a2,1
    80004ad0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ad4:	f9842583          	lw	a1,-104(s0)
    80004ad8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004adc:	00250613          	addi	a2,a0,2
    80004ae0:	0612                	slli	a2,a2,0x4
    80004ae2:	963e                	add	a2,a2,a5
    80004ae4:	577d                	li	a4,-1
    80004ae6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004aea:	0592                	slli	a1,a1,0x4
    80004aec:	98ae                	add	a7,a7,a1
    80004aee:	03068713          	addi	a4,a3,48
    80004af2:	973e                	add	a4,a4,a5
    80004af4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004af8:	6398                	ld	a4,0(a5)
    80004afa:	972e                	add	a4,a4,a1
    80004afc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004b00:	4689                	li	a3,2
    80004b02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004b0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b12:	6794                	ld	a3,8(a5)
    80004b14:	0026d703          	lhu	a4,2(a3)
    80004b18:	8b1d                	andi	a4,a4,7
    80004b1a:	0706                	slli	a4,a4,0x1
    80004b1c:	96ba                	add	a3,a3,a4
    80004b1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b26:	6798                	ld	a4,8(a5)
    80004b28:	00275783          	lhu	a5,2(a4)
    80004b2c:	2785                	addiw	a5,a5,1
    80004b2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b36:	100017b7          	lui	a5,0x10001
    80004b3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004b42:	00017917          	auipc	s2,0x17
    80004b46:	8f690913          	addi	s2,s2,-1802 # 8001b438 <disk+0x128>
  while(b->disk == 1) {
    80004b4a:	4485                	li	s1,1
    80004b4c:	01079a63          	bne	a5,a6,80004b60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004b50:	85ca                	mv	a1,s2
    80004b52:	8552                	mv	a0,s4
    80004b54:	fd0fc0ef          	jal	80001324 <sleep>
  while(b->disk == 1) {
    80004b58:	004a2783          	lw	a5,4(s4)
    80004b5c:	fe978ae3          	beq	a5,s1,80004b50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004b60:	f9042903          	lw	s2,-112(s0)
    80004b64:	00290713          	addi	a4,s2,2
    80004b68:	0712                	slli	a4,a4,0x4
    80004b6a:	00016797          	auipc	a5,0x16
    80004b6e:	7a678793          	addi	a5,a5,1958 # 8001b310 <disk>
    80004b72:	97ba                	add	a5,a5,a4
    80004b74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004b78:	00016997          	auipc	s3,0x16
    80004b7c:	79898993          	addi	s3,s3,1944 # 8001b310 <disk>
    80004b80:	00491713          	slli	a4,s2,0x4
    80004b84:	0009b783          	ld	a5,0(s3)
    80004b88:	97ba                	add	a5,a5,a4
    80004b8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004b8e:	854a                	mv	a0,s2
    80004b90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004b94:	bafff0ef          	jal	80004742 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004b98:	8885                	andi	s1,s1,1
    80004b9a:	f0fd                	bnez	s1,80004b80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004b9c:	00017517          	auipc	a0,0x17
    80004ba0:	89c50513          	addi	a0,a0,-1892 # 8001b438 <disk+0x128>
    80004ba4:	405000ef          	jal	800057a8 <release>
}
    80004ba8:	70a6                	ld	ra,104(sp)
    80004baa:	7406                	ld	s0,96(sp)
    80004bac:	64e6                	ld	s1,88(sp)
    80004bae:	6946                	ld	s2,80(sp)
    80004bb0:	69a6                	ld	s3,72(sp)
    80004bb2:	6a06                	ld	s4,64(sp)
    80004bb4:	7ae2                	ld	s5,56(sp)
    80004bb6:	7b42                	ld	s6,48(sp)
    80004bb8:	7ba2                	ld	s7,40(sp)
    80004bba:	7c02                	ld	s8,32(sp)
    80004bbc:	6ce2                	ld	s9,24(sp)
    80004bbe:	6165                	addi	sp,sp,112
    80004bc0:	8082                	ret

0000000080004bc2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004bc2:	1101                	addi	sp,sp,-32
    80004bc4:	ec06                	sd	ra,24(sp)
    80004bc6:	e822                	sd	s0,16(sp)
    80004bc8:	e426                	sd	s1,8(sp)
    80004bca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004bcc:	00016497          	auipc	s1,0x16
    80004bd0:	74448493          	addi	s1,s1,1860 # 8001b310 <disk>
    80004bd4:	00017517          	auipc	a0,0x17
    80004bd8:	86450513          	addi	a0,a0,-1948 # 8001b438 <disk+0x128>
    80004bdc:	335000ef          	jal	80005710 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004be0:	100017b7          	lui	a5,0x10001
    80004be4:	53b8                	lw	a4,96(a5)
    80004be6:	8b0d                	andi	a4,a4,3
    80004be8:	100017b7          	lui	a5,0x10001
    80004bec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004bee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004bf2:	689c                	ld	a5,16(s1)
    80004bf4:	0204d703          	lhu	a4,32(s1)
    80004bf8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004bfc:	04f70663          	beq	a4,a5,80004c48 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004c00:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c04:	6898                	ld	a4,16(s1)
    80004c06:	0204d783          	lhu	a5,32(s1)
    80004c0a:	8b9d                	andi	a5,a5,7
    80004c0c:	078e                	slli	a5,a5,0x3
    80004c0e:	97ba                	add	a5,a5,a4
    80004c10:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c12:	00278713          	addi	a4,a5,2
    80004c16:	0712                	slli	a4,a4,0x4
    80004c18:	9726                	add	a4,a4,s1
    80004c1a:	01074703          	lbu	a4,16(a4)
    80004c1e:	e321                	bnez	a4,80004c5e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c20:	0789                	addi	a5,a5,2
    80004c22:	0792                	slli	a5,a5,0x4
    80004c24:	97a6                	add	a5,a5,s1
    80004c26:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c28:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c2c:	f44fc0ef          	jal	80001370 <wakeup>

    disk.used_idx += 1;
    80004c30:	0204d783          	lhu	a5,32(s1)
    80004c34:	2785                	addiw	a5,a5,1
    80004c36:	17c2                	slli	a5,a5,0x30
    80004c38:	93c1                	srli	a5,a5,0x30
    80004c3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c3e:	6898                	ld	a4,16(s1)
    80004c40:	00275703          	lhu	a4,2(a4)
    80004c44:	faf71ee3          	bne	a4,a5,80004c00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004c48:	00016517          	auipc	a0,0x16
    80004c4c:	7f050513          	addi	a0,a0,2032 # 8001b438 <disk+0x128>
    80004c50:	359000ef          	jal	800057a8 <release>
}
    80004c54:	60e2                	ld	ra,24(sp)
    80004c56:	6442                	ld	s0,16(sp)
    80004c58:	64a2                	ld	s1,8(sp)
    80004c5a:	6105                	addi	sp,sp,32
    80004c5c:	8082                	ret
      panic("virtio_disk_intr status");
    80004c5e:	00003517          	auipc	a0,0x3
    80004c62:	aaa50513          	addi	a0,a0,-1366 # 80007708 <etext+0x708>
    80004c66:	77c000ef          	jal	800053e2 <panic>

0000000080004c6a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004c6a:	1141                	addi	sp,sp,-16
    80004c6c:	e422                	sd	s0,8(sp)
    80004c6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004c70:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004c74:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004c78:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004c7c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004c80:	577d                	li	a4,-1
    80004c82:	177e                	slli	a4,a4,0x3f
    80004c84:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004c86:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004c8a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004c8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004c92:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004c96:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004c9a:	000f4737          	lui	a4,0xf4
    80004c9e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004ca2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ca4:	14d79073          	csrw	stimecmp,a5
}
    80004ca8:	6422                	ld	s0,8(sp)
    80004caa:	0141                	addi	sp,sp,16
    80004cac:	8082                	ret

0000000080004cae <start>:
{
    80004cae:	1141                	addi	sp,sp,-16
    80004cb0:	e406                	sd	ra,8(sp)
    80004cb2:	e022                	sd	s0,0(sp)
    80004cb4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004cb6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004cba:	7779                	lui	a4,0xffffe
    80004cbc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb2af>
    80004cc0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004cc2:	6705                	lui	a4,0x1
    80004cc4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004cc8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004cca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004cce:	ffffb797          	auipc	a5,0xffffb
    80004cd2:	60078793          	addi	a5,a5,1536 # 800002ce <main>
    80004cd6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004cda:	4781                	li	a5,0
    80004cdc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ce0:	67c1                	lui	a5,0x10
    80004ce2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ce4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ce8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004cec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004cf0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004cf4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004cf8:	57fd                	li	a5,-1
    80004cfa:	83a9                	srli	a5,a5,0xa
    80004cfc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d00:	47bd                	li	a5,15
    80004d02:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d06:	f65ff0ef          	jal	80004c6a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d0a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d0e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d10:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d12:	30200073          	mret
}
    80004d16:	60a2                	ld	ra,8(sp)
    80004d18:	6402                	ld	s0,0(sp)
    80004d1a:	0141                	addi	sp,sp,16
    80004d1c:	8082                	ret

0000000080004d1e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d1e:	715d                	addi	sp,sp,-80
    80004d20:	e486                	sd	ra,72(sp)
    80004d22:	e0a2                	sd	s0,64(sp)
    80004d24:	f84a                	sd	s2,48(sp)
    80004d26:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004d28:	04c05263          	blez	a2,80004d6c <consolewrite+0x4e>
    80004d2c:	fc26                	sd	s1,56(sp)
    80004d2e:	f44e                	sd	s3,40(sp)
    80004d30:	f052                	sd	s4,32(sp)
    80004d32:	ec56                	sd	s5,24(sp)
    80004d34:	8a2a                	mv	s4,a0
    80004d36:	84ae                	mv	s1,a1
    80004d38:	89b2                	mv	s3,a2
    80004d3a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d3c:	5afd                	li	s5,-1
    80004d3e:	4685                	li	a3,1
    80004d40:	8626                	mv	a2,s1
    80004d42:	85d2                	mv	a1,s4
    80004d44:	fbf40513          	addi	a0,s0,-65
    80004d48:	983fc0ef          	jal	800016ca <either_copyin>
    80004d4c:	03550263          	beq	a0,s5,80004d70 <consolewrite+0x52>
      break;
    uartputc(c);
    80004d50:	fbf44503          	lbu	a0,-65(s0)
    80004d54:	035000ef          	jal	80005588 <uartputc>
  for(i = 0; i < n; i++){
    80004d58:	2905                	addiw	s2,s2,1
    80004d5a:	0485                	addi	s1,s1,1
    80004d5c:	ff2991e3          	bne	s3,s2,80004d3e <consolewrite+0x20>
    80004d60:	894e                	mv	s2,s3
    80004d62:	74e2                	ld	s1,56(sp)
    80004d64:	79a2                	ld	s3,40(sp)
    80004d66:	7a02                	ld	s4,32(sp)
    80004d68:	6ae2                	ld	s5,24(sp)
    80004d6a:	a039                	j	80004d78 <consolewrite+0x5a>
    80004d6c:	4901                	li	s2,0
    80004d6e:	a029                	j	80004d78 <consolewrite+0x5a>
    80004d70:	74e2                	ld	s1,56(sp)
    80004d72:	79a2                	ld	s3,40(sp)
    80004d74:	7a02                	ld	s4,32(sp)
    80004d76:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004d78:	854a                	mv	a0,s2
    80004d7a:	60a6                	ld	ra,72(sp)
    80004d7c:	6406                	ld	s0,64(sp)
    80004d7e:	7942                	ld	s2,48(sp)
    80004d80:	6161                	addi	sp,sp,80
    80004d82:	8082                	ret

0000000080004d84 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004d84:	711d                	addi	sp,sp,-96
    80004d86:	ec86                	sd	ra,88(sp)
    80004d88:	e8a2                	sd	s0,80(sp)
    80004d8a:	e4a6                	sd	s1,72(sp)
    80004d8c:	e0ca                	sd	s2,64(sp)
    80004d8e:	fc4e                	sd	s3,56(sp)
    80004d90:	f852                	sd	s4,48(sp)
    80004d92:	f456                	sd	s5,40(sp)
    80004d94:	f05a                	sd	s6,32(sp)
    80004d96:	1080                	addi	s0,sp,96
    80004d98:	8aaa                	mv	s5,a0
    80004d9a:	8a2e                	mv	s4,a1
    80004d9c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004d9e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004da2:	0001e517          	auipc	a0,0x1e
    80004da6:	6ae50513          	addi	a0,a0,1710 # 80023450 <cons>
    80004daa:	167000ef          	jal	80005710 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004dae:	0001e497          	auipc	s1,0x1e
    80004db2:	6a248493          	addi	s1,s1,1698 # 80023450 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004db6:	0001e917          	auipc	s2,0x1e
    80004dba:	73290913          	addi	s2,s2,1842 # 800234e8 <cons+0x98>
  while(n > 0){
    80004dbe:	0b305d63          	blez	s3,80004e78 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004dc2:	0984a783          	lw	a5,152(s1)
    80004dc6:	09c4a703          	lw	a4,156(s1)
    80004dca:	0af71263          	bne	a4,a5,80004e6e <consoleread+0xea>
      if(killed(myproc())){
    80004dce:	f89fb0ef          	jal	80000d56 <myproc>
    80004dd2:	f8afc0ef          	jal	8000155c <killed>
    80004dd6:	e12d                	bnez	a0,80004e38 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004dd8:	85a6                	mv	a1,s1
    80004dda:	854a                	mv	a0,s2
    80004ddc:	d48fc0ef          	jal	80001324 <sleep>
    while(cons.r == cons.w){
    80004de0:	0984a783          	lw	a5,152(s1)
    80004de4:	09c4a703          	lw	a4,156(s1)
    80004de8:	fef703e3          	beq	a4,a5,80004dce <consoleread+0x4a>
    80004dec:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004dee:	0001e717          	auipc	a4,0x1e
    80004df2:	66270713          	addi	a4,a4,1634 # 80023450 <cons>
    80004df6:	0017869b          	addiw	a3,a5,1
    80004dfa:	08d72c23          	sw	a3,152(a4)
    80004dfe:	07f7f693          	andi	a3,a5,127
    80004e02:	9736                	add	a4,a4,a3
    80004e04:	01874703          	lbu	a4,24(a4)
    80004e08:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004e0c:	4691                	li	a3,4
    80004e0e:	04db8663          	beq	s7,a3,80004e5a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004e12:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e16:	4685                	li	a3,1
    80004e18:	faf40613          	addi	a2,s0,-81
    80004e1c:	85d2                	mv	a1,s4
    80004e1e:	8556                	mv	a0,s5
    80004e20:	861fc0ef          	jal	80001680 <either_copyout>
    80004e24:	57fd                	li	a5,-1
    80004e26:	04f50863          	beq	a0,a5,80004e76 <consoleread+0xf2>
      break;

    dst++;
    80004e2a:	0a05                	addi	s4,s4,1
    --n;
    80004e2c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004e2e:	47a9                	li	a5,10
    80004e30:	04fb8d63          	beq	s7,a5,80004e8a <consoleread+0x106>
    80004e34:	6be2                	ld	s7,24(sp)
    80004e36:	b761                	j	80004dbe <consoleread+0x3a>
        release(&cons.lock);
    80004e38:	0001e517          	auipc	a0,0x1e
    80004e3c:	61850513          	addi	a0,a0,1560 # 80023450 <cons>
    80004e40:	169000ef          	jal	800057a8 <release>
        return -1;
    80004e44:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004e46:	60e6                	ld	ra,88(sp)
    80004e48:	6446                	ld	s0,80(sp)
    80004e4a:	64a6                	ld	s1,72(sp)
    80004e4c:	6906                	ld	s2,64(sp)
    80004e4e:	79e2                	ld	s3,56(sp)
    80004e50:	7a42                	ld	s4,48(sp)
    80004e52:	7aa2                	ld	s5,40(sp)
    80004e54:	7b02                	ld	s6,32(sp)
    80004e56:	6125                	addi	sp,sp,96
    80004e58:	8082                	ret
      if(n < target){
    80004e5a:	0009871b          	sext.w	a4,s3
    80004e5e:	01677a63          	bgeu	a4,s6,80004e72 <consoleread+0xee>
        cons.r--;
    80004e62:	0001e717          	auipc	a4,0x1e
    80004e66:	68f72323          	sw	a5,1670(a4) # 800234e8 <cons+0x98>
    80004e6a:	6be2                	ld	s7,24(sp)
    80004e6c:	a031                	j	80004e78 <consoleread+0xf4>
    80004e6e:	ec5e                	sd	s7,24(sp)
    80004e70:	bfbd                	j	80004dee <consoleread+0x6a>
    80004e72:	6be2                	ld	s7,24(sp)
    80004e74:	a011                	j	80004e78 <consoleread+0xf4>
    80004e76:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004e78:	0001e517          	auipc	a0,0x1e
    80004e7c:	5d850513          	addi	a0,a0,1496 # 80023450 <cons>
    80004e80:	129000ef          	jal	800057a8 <release>
  return target - n;
    80004e84:	413b053b          	subw	a0,s6,s3
    80004e88:	bf7d                	j	80004e46 <consoleread+0xc2>
    80004e8a:	6be2                	ld	s7,24(sp)
    80004e8c:	b7f5                	j	80004e78 <consoleread+0xf4>

0000000080004e8e <consputc>:
{
    80004e8e:	1141                	addi	sp,sp,-16
    80004e90:	e406                	sd	ra,8(sp)
    80004e92:	e022                	sd	s0,0(sp)
    80004e94:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004e96:	10000793          	li	a5,256
    80004e9a:	00f50863          	beq	a0,a5,80004eaa <consputc+0x1c>
    uartputc_sync(c);
    80004e9e:	604000ef          	jal	800054a2 <uartputc_sync>
}
    80004ea2:	60a2                	ld	ra,8(sp)
    80004ea4:	6402                	ld	s0,0(sp)
    80004ea6:	0141                	addi	sp,sp,16
    80004ea8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004eaa:	4521                	li	a0,8
    80004eac:	5f6000ef          	jal	800054a2 <uartputc_sync>
    80004eb0:	02000513          	li	a0,32
    80004eb4:	5ee000ef          	jal	800054a2 <uartputc_sync>
    80004eb8:	4521                	li	a0,8
    80004eba:	5e8000ef          	jal	800054a2 <uartputc_sync>
    80004ebe:	b7d5                	j	80004ea2 <consputc+0x14>

0000000080004ec0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ec0:	1101                	addi	sp,sp,-32
    80004ec2:	ec06                	sd	ra,24(sp)
    80004ec4:	e822                	sd	s0,16(sp)
    80004ec6:	e426                	sd	s1,8(sp)
    80004ec8:	1000                	addi	s0,sp,32
    80004eca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004ecc:	0001e517          	auipc	a0,0x1e
    80004ed0:	58450513          	addi	a0,a0,1412 # 80023450 <cons>
    80004ed4:	03d000ef          	jal	80005710 <acquire>

  switch(c){
    80004ed8:	47d5                	li	a5,21
    80004eda:	08f48f63          	beq	s1,a5,80004f78 <consoleintr+0xb8>
    80004ede:	0297c563          	blt	a5,s1,80004f08 <consoleintr+0x48>
    80004ee2:	47a1                	li	a5,8
    80004ee4:	0ef48463          	beq	s1,a5,80004fcc <consoleintr+0x10c>
    80004ee8:	47c1                	li	a5,16
    80004eea:	10f49563          	bne	s1,a5,80004ff4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004eee:	827fc0ef          	jal	80001714 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004ef2:	0001e517          	auipc	a0,0x1e
    80004ef6:	55e50513          	addi	a0,a0,1374 # 80023450 <cons>
    80004efa:	0af000ef          	jal	800057a8 <release>
}
    80004efe:	60e2                	ld	ra,24(sp)
    80004f00:	6442                	ld	s0,16(sp)
    80004f02:	64a2                	ld	s1,8(sp)
    80004f04:	6105                	addi	sp,sp,32
    80004f06:	8082                	ret
  switch(c){
    80004f08:	07f00793          	li	a5,127
    80004f0c:	0cf48063          	beq	s1,a5,80004fcc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f10:	0001e717          	auipc	a4,0x1e
    80004f14:	54070713          	addi	a4,a4,1344 # 80023450 <cons>
    80004f18:	0a072783          	lw	a5,160(a4)
    80004f1c:	09872703          	lw	a4,152(a4)
    80004f20:	9f99                	subw	a5,a5,a4
    80004f22:	07f00713          	li	a4,127
    80004f26:	fcf766e3          	bltu	a4,a5,80004ef2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004f2a:	47b5                	li	a5,13
    80004f2c:	0cf48763          	beq	s1,a5,80004ffa <consoleintr+0x13a>
      consputc(c);
    80004f30:	8526                	mv	a0,s1
    80004f32:	f5dff0ef          	jal	80004e8e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f36:	0001e797          	auipc	a5,0x1e
    80004f3a:	51a78793          	addi	a5,a5,1306 # 80023450 <cons>
    80004f3e:	0a07a683          	lw	a3,160(a5)
    80004f42:	0016871b          	addiw	a4,a3,1
    80004f46:	0007061b          	sext.w	a2,a4
    80004f4a:	0ae7a023          	sw	a4,160(a5)
    80004f4e:	07f6f693          	andi	a3,a3,127
    80004f52:	97b6                	add	a5,a5,a3
    80004f54:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004f58:	47a9                	li	a5,10
    80004f5a:	0cf48563          	beq	s1,a5,80005024 <consoleintr+0x164>
    80004f5e:	4791                	li	a5,4
    80004f60:	0cf48263          	beq	s1,a5,80005024 <consoleintr+0x164>
    80004f64:	0001e797          	auipc	a5,0x1e
    80004f68:	5847a783          	lw	a5,1412(a5) # 800234e8 <cons+0x98>
    80004f6c:	9f1d                	subw	a4,a4,a5
    80004f6e:	08000793          	li	a5,128
    80004f72:	f8f710e3          	bne	a4,a5,80004ef2 <consoleintr+0x32>
    80004f76:	a07d                	j	80005024 <consoleintr+0x164>
    80004f78:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80004f7a:	0001e717          	auipc	a4,0x1e
    80004f7e:	4d670713          	addi	a4,a4,1238 # 80023450 <cons>
    80004f82:	0a072783          	lw	a5,160(a4)
    80004f86:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004f8a:	0001e497          	auipc	s1,0x1e
    80004f8e:	4c648493          	addi	s1,s1,1222 # 80023450 <cons>
    while(cons.e != cons.w &&
    80004f92:	4929                	li	s2,10
    80004f94:	02f70863          	beq	a4,a5,80004fc4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004f98:	37fd                	addiw	a5,a5,-1
    80004f9a:	07f7f713          	andi	a4,a5,127
    80004f9e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fa0:	01874703          	lbu	a4,24(a4)
    80004fa4:	03270263          	beq	a4,s2,80004fc8 <consoleintr+0x108>
      cons.e--;
    80004fa8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004fac:	10000513          	li	a0,256
    80004fb0:	edfff0ef          	jal	80004e8e <consputc>
    while(cons.e != cons.w &&
    80004fb4:	0a04a783          	lw	a5,160(s1)
    80004fb8:	09c4a703          	lw	a4,156(s1)
    80004fbc:	fcf71ee3          	bne	a4,a5,80004f98 <consoleintr+0xd8>
    80004fc0:	6902                	ld	s2,0(sp)
    80004fc2:	bf05                	j	80004ef2 <consoleintr+0x32>
    80004fc4:	6902                	ld	s2,0(sp)
    80004fc6:	b735                	j	80004ef2 <consoleintr+0x32>
    80004fc8:	6902                	ld	s2,0(sp)
    80004fca:	b725                	j	80004ef2 <consoleintr+0x32>
    if(cons.e != cons.w){
    80004fcc:	0001e717          	auipc	a4,0x1e
    80004fd0:	48470713          	addi	a4,a4,1156 # 80023450 <cons>
    80004fd4:	0a072783          	lw	a5,160(a4)
    80004fd8:	09c72703          	lw	a4,156(a4)
    80004fdc:	f0f70be3          	beq	a4,a5,80004ef2 <consoleintr+0x32>
      cons.e--;
    80004fe0:	37fd                	addiw	a5,a5,-1
    80004fe2:	0001e717          	auipc	a4,0x1e
    80004fe6:	50f72723          	sw	a5,1294(a4) # 800234f0 <cons+0xa0>
      consputc(BACKSPACE);
    80004fea:	10000513          	li	a0,256
    80004fee:	ea1ff0ef          	jal	80004e8e <consputc>
    80004ff2:	b701                	j	80004ef2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004ff4:	ee048fe3          	beqz	s1,80004ef2 <consoleintr+0x32>
    80004ff8:	bf21                	j	80004f10 <consoleintr+0x50>
      consputc(c);
    80004ffa:	4529                	li	a0,10
    80004ffc:	e93ff0ef          	jal	80004e8e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005000:	0001e797          	auipc	a5,0x1e
    80005004:	45078793          	addi	a5,a5,1104 # 80023450 <cons>
    80005008:	0a07a703          	lw	a4,160(a5)
    8000500c:	0017069b          	addiw	a3,a4,1
    80005010:	0006861b          	sext.w	a2,a3
    80005014:	0ad7a023          	sw	a3,160(a5)
    80005018:	07f77713          	andi	a4,a4,127
    8000501c:	97ba                	add	a5,a5,a4
    8000501e:	4729                	li	a4,10
    80005020:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005024:	0001e797          	auipc	a5,0x1e
    80005028:	4cc7a423          	sw	a2,1224(a5) # 800234ec <cons+0x9c>
        wakeup(&cons.r);
    8000502c:	0001e517          	auipc	a0,0x1e
    80005030:	4bc50513          	addi	a0,a0,1212 # 800234e8 <cons+0x98>
    80005034:	b3cfc0ef          	jal	80001370 <wakeup>
    80005038:	bd6d                	j	80004ef2 <consoleintr+0x32>

000000008000503a <consoleinit>:

void
consoleinit(void)
{
    8000503a:	1141                	addi	sp,sp,-16
    8000503c:	e406                	sd	ra,8(sp)
    8000503e:	e022                	sd	s0,0(sp)
    80005040:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005042:	00002597          	auipc	a1,0x2
    80005046:	6de58593          	addi	a1,a1,1758 # 80007720 <etext+0x720>
    8000504a:	0001e517          	auipc	a0,0x1e
    8000504e:	40650513          	addi	a0,a0,1030 # 80023450 <cons>
    80005052:	63e000ef          	jal	80005690 <initlock>

  uartinit();
    80005056:	3f4000ef          	jal	8000544a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000505a:	00015797          	auipc	a5,0x15
    8000505e:	25e78793          	addi	a5,a5,606 # 8001a2b8 <devsw>
    80005062:	00000717          	auipc	a4,0x0
    80005066:	d2270713          	addi	a4,a4,-734 # 80004d84 <consoleread>
    8000506a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000506c:	00000717          	auipc	a4,0x0
    80005070:	cb270713          	addi	a4,a4,-846 # 80004d1e <consolewrite>
    80005074:	ef98                	sd	a4,24(a5)
}
    80005076:	60a2                	ld	ra,8(sp)
    80005078:	6402                	ld	s0,0(sp)
    8000507a:	0141                	addi	sp,sp,16
    8000507c:	8082                	ret

000000008000507e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000507e:	7179                	addi	sp,sp,-48
    80005080:	f406                	sd	ra,40(sp)
    80005082:	f022                	sd	s0,32(sp)
    80005084:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005086:	c219                	beqz	a2,8000508c <printint+0xe>
    80005088:	08054063          	bltz	a0,80005108 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000508c:	4881                	li	a7,0
    8000508e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005092:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005094:	00002617          	auipc	a2,0x2
    80005098:	7e460613          	addi	a2,a2,2020 # 80007878 <digits>
    8000509c:	883e                	mv	a6,a5
    8000509e:	2785                	addiw	a5,a5,1
    800050a0:	02b57733          	remu	a4,a0,a1
    800050a4:	9732                	add	a4,a4,a2
    800050a6:	00074703          	lbu	a4,0(a4)
    800050aa:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050ae:	872a                	mv	a4,a0
    800050b0:	02b55533          	divu	a0,a0,a1
    800050b4:	0685                	addi	a3,a3,1
    800050b6:	feb773e3          	bgeu	a4,a1,8000509c <printint+0x1e>

  if(sign)
    800050ba:	00088a63          	beqz	a7,800050ce <printint+0x50>
    buf[i++] = '-';
    800050be:	1781                	addi	a5,a5,-32
    800050c0:	97a2                	add	a5,a5,s0
    800050c2:	02d00713          	li	a4,45
    800050c6:	fee78823          	sb	a4,-16(a5)
    800050ca:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800050ce:	02f05963          	blez	a5,80005100 <printint+0x82>
    800050d2:	ec26                	sd	s1,24(sp)
    800050d4:	e84a                	sd	s2,16(sp)
    800050d6:	fd040713          	addi	a4,s0,-48
    800050da:	00f704b3          	add	s1,a4,a5
    800050de:	fff70913          	addi	s2,a4,-1
    800050e2:	993e                	add	s2,s2,a5
    800050e4:	37fd                	addiw	a5,a5,-1
    800050e6:	1782                	slli	a5,a5,0x20
    800050e8:	9381                	srli	a5,a5,0x20
    800050ea:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800050ee:	fff4c503          	lbu	a0,-1(s1)
    800050f2:	d9dff0ef          	jal	80004e8e <consputc>
  while(--i >= 0)
    800050f6:	14fd                	addi	s1,s1,-1
    800050f8:	ff249be3          	bne	s1,s2,800050ee <printint+0x70>
    800050fc:	64e2                	ld	s1,24(sp)
    800050fe:	6942                	ld	s2,16(sp)
}
    80005100:	70a2                	ld	ra,40(sp)
    80005102:	7402                	ld	s0,32(sp)
    80005104:	6145                	addi	sp,sp,48
    80005106:	8082                	ret
    x = -xx;
    80005108:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000510c:	4885                	li	a7,1
    x = -xx;
    8000510e:	b741                	j	8000508e <printint+0x10>

0000000080005110 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005110:	7155                	addi	sp,sp,-208
    80005112:	e506                	sd	ra,136(sp)
    80005114:	e122                	sd	s0,128(sp)
    80005116:	f0d2                	sd	s4,96(sp)
    80005118:	0900                	addi	s0,sp,144
    8000511a:	8a2a                	mv	s4,a0
    8000511c:	e40c                	sd	a1,8(s0)
    8000511e:	e810                	sd	a2,16(s0)
    80005120:	ec14                	sd	a3,24(s0)
    80005122:	f018                	sd	a4,32(s0)
    80005124:	f41c                	sd	a5,40(s0)
    80005126:	03043823          	sd	a6,48(s0)
    8000512a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000512e:	0001e797          	auipc	a5,0x1e
    80005132:	3e27a783          	lw	a5,994(a5) # 80023510 <pr+0x18>
    80005136:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000513a:	e3a1                	bnez	a5,8000517a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000513c:	00840793          	addi	a5,s0,8
    80005140:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005144:	00054503          	lbu	a0,0(a0)
    80005148:	26050763          	beqz	a0,800053b6 <printf+0x2a6>
    8000514c:	fca6                	sd	s1,120(sp)
    8000514e:	f8ca                	sd	s2,112(sp)
    80005150:	f4ce                	sd	s3,104(sp)
    80005152:	ecd6                	sd	s5,88(sp)
    80005154:	e8da                	sd	s6,80(sp)
    80005156:	e0e2                	sd	s8,64(sp)
    80005158:	fc66                	sd	s9,56(sp)
    8000515a:	f86a                	sd	s10,48(sp)
    8000515c:	f46e                	sd	s11,40(sp)
    8000515e:	4981                	li	s3,0
    if(cx != '%'){
    80005160:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005164:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005168:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000516c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005170:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005174:	07000d93          	li	s11,112
    80005178:	a815                	j	800051ac <printf+0x9c>
    acquire(&pr.lock);
    8000517a:	0001e517          	auipc	a0,0x1e
    8000517e:	37e50513          	addi	a0,a0,894 # 800234f8 <pr>
    80005182:	58e000ef          	jal	80005710 <acquire>
  va_start(ap, fmt);
    80005186:	00840793          	addi	a5,s0,8
    8000518a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000518e:	000a4503          	lbu	a0,0(s4)
    80005192:	fd4d                	bnez	a0,8000514c <printf+0x3c>
    80005194:	a481                	j	800053d4 <printf+0x2c4>
      consputc(cx);
    80005196:	cf9ff0ef          	jal	80004e8e <consputc>
      continue;
    8000519a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000519c:	0014899b          	addiw	s3,s1,1
    800051a0:	013a07b3          	add	a5,s4,s3
    800051a4:	0007c503          	lbu	a0,0(a5)
    800051a8:	1e050b63          	beqz	a0,8000539e <printf+0x28e>
    if(cx != '%'){
    800051ac:	ff5515e3          	bne	a0,s5,80005196 <printf+0x86>
    i++;
    800051b0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800051b4:	009a07b3          	add	a5,s4,s1
    800051b8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800051bc:	1e090163          	beqz	s2,8000539e <printf+0x28e>
    800051c0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800051c4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800051c6:	c789                	beqz	a5,800051d0 <printf+0xc0>
    800051c8:	009a0733          	add	a4,s4,s1
    800051cc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800051d0:	03690763          	beq	s2,s6,800051fe <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800051d4:	05890163          	beq	s2,s8,80005216 <printf+0x106>
    } else if(c0 == 'u'){
    800051d8:	0d990b63          	beq	s2,s9,800052ae <printf+0x19e>
    } else if(c0 == 'x'){
    800051dc:	13a90163          	beq	s2,s10,800052fe <printf+0x1ee>
    } else if(c0 == 'p'){
    800051e0:	13b90b63          	beq	s2,s11,80005316 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800051e4:	07300793          	li	a5,115
    800051e8:	16f90a63          	beq	s2,a5,8000535c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800051ec:	1b590463          	beq	s2,s5,80005394 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800051f0:	8556                	mv	a0,s5
    800051f2:	c9dff0ef          	jal	80004e8e <consputc>
      consputc(c0);
    800051f6:	854a                	mv	a0,s2
    800051f8:	c97ff0ef          	jal	80004e8e <consputc>
    800051fc:	b745                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800051fe:	f8843783          	ld	a5,-120(s0)
    80005202:	00878713          	addi	a4,a5,8
    80005206:	f8e43423          	sd	a4,-120(s0)
    8000520a:	4605                	li	a2,1
    8000520c:	45a9                	li	a1,10
    8000520e:	4388                	lw	a0,0(a5)
    80005210:	e6fff0ef          	jal	8000507e <printint>
    80005214:	b761                	j	8000519c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005216:	03678663          	beq	a5,s6,80005242 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000521a:	05878263          	beq	a5,s8,8000525e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000521e:	0b978463          	beq	a5,s9,800052c6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005222:	fda797e3          	bne	a5,s10,800051f0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005226:	f8843783          	ld	a5,-120(s0)
    8000522a:	00878713          	addi	a4,a5,8
    8000522e:	f8e43423          	sd	a4,-120(s0)
    80005232:	4601                	li	a2,0
    80005234:	45c1                	li	a1,16
    80005236:	6388                	ld	a0,0(a5)
    80005238:	e47ff0ef          	jal	8000507e <printint>
      i += 1;
    8000523c:	0029849b          	addiw	s1,s3,2
    80005240:	bfb1                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005242:	f8843783          	ld	a5,-120(s0)
    80005246:	00878713          	addi	a4,a5,8
    8000524a:	f8e43423          	sd	a4,-120(s0)
    8000524e:	4605                	li	a2,1
    80005250:	45a9                	li	a1,10
    80005252:	6388                	ld	a0,0(a5)
    80005254:	e2bff0ef          	jal	8000507e <printint>
      i += 1;
    80005258:	0029849b          	addiw	s1,s3,2
    8000525c:	b781                	j	8000519c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000525e:	06400793          	li	a5,100
    80005262:	02f68863          	beq	a3,a5,80005292 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005266:	07500793          	li	a5,117
    8000526a:	06f68c63          	beq	a3,a5,800052e2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000526e:	07800793          	li	a5,120
    80005272:	f6f69fe3          	bne	a3,a5,800051f0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005276:	f8843783          	ld	a5,-120(s0)
    8000527a:	00878713          	addi	a4,a5,8
    8000527e:	f8e43423          	sd	a4,-120(s0)
    80005282:	4601                	li	a2,0
    80005284:	45c1                	li	a1,16
    80005286:	6388                	ld	a0,0(a5)
    80005288:	df7ff0ef          	jal	8000507e <printint>
      i += 2;
    8000528c:	0039849b          	addiw	s1,s3,3
    80005290:	b731                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005292:	f8843783          	ld	a5,-120(s0)
    80005296:	00878713          	addi	a4,a5,8
    8000529a:	f8e43423          	sd	a4,-120(s0)
    8000529e:	4605                	li	a2,1
    800052a0:	45a9                	li	a1,10
    800052a2:	6388                	ld	a0,0(a5)
    800052a4:	ddbff0ef          	jal	8000507e <printint>
      i += 2;
    800052a8:	0039849b          	addiw	s1,s3,3
    800052ac:	bdc5                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800052ae:	f8843783          	ld	a5,-120(s0)
    800052b2:	00878713          	addi	a4,a5,8
    800052b6:	f8e43423          	sd	a4,-120(s0)
    800052ba:	4601                	li	a2,0
    800052bc:	45a9                	li	a1,10
    800052be:	4388                	lw	a0,0(a5)
    800052c0:	dbfff0ef          	jal	8000507e <printint>
    800052c4:	bde1                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052c6:	f8843783          	ld	a5,-120(s0)
    800052ca:	00878713          	addi	a4,a5,8
    800052ce:	f8e43423          	sd	a4,-120(s0)
    800052d2:	4601                	li	a2,0
    800052d4:	45a9                	li	a1,10
    800052d6:	6388                	ld	a0,0(a5)
    800052d8:	da7ff0ef          	jal	8000507e <printint>
      i += 1;
    800052dc:	0029849b          	addiw	s1,s3,2
    800052e0:	bd75                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800052e2:	f8843783          	ld	a5,-120(s0)
    800052e6:	00878713          	addi	a4,a5,8
    800052ea:	f8e43423          	sd	a4,-120(s0)
    800052ee:	4601                	li	a2,0
    800052f0:	45a9                	li	a1,10
    800052f2:	6388                	ld	a0,0(a5)
    800052f4:	d8bff0ef          	jal	8000507e <printint>
      i += 2;
    800052f8:	0039849b          	addiw	s1,s3,3
    800052fc:	b545                	j	8000519c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800052fe:	f8843783          	ld	a5,-120(s0)
    80005302:	00878713          	addi	a4,a5,8
    80005306:	f8e43423          	sd	a4,-120(s0)
    8000530a:	4601                	li	a2,0
    8000530c:	45c1                	li	a1,16
    8000530e:	4388                	lw	a0,0(a5)
    80005310:	d6fff0ef          	jal	8000507e <printint>
    80005314:	b561                	j	8000519c <printf+0x8c>
    80005316:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005318:	f8843783          	ld	a5,-120(s0)
    8000531c:	00878713          	addi	a4,a5,8
    80005320:	f8e43423          	sd	a4,-120(s0)
    80005324:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005328:	03000513          	li	a0,48
    8000532c:	b63ff0ef          	jal	80004e8e <consputc>
  consputc('x');
    80005330:	07800513          	li	a0,120
    80005334:	b5bff0ef          	jal	80004e8e <consputc>
    80005338:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000533a:	00002b97          	auipc	s7,0x2
    8000533e:	53eb8b93          	addi	s7,s7,1342 # 80007878 <digits>
    80005342:	03c9d793          	srli	a5,s3,0x3c
    80005346:	97de                	add	a5,a5,s7
    80005348:	0007c503          	lbu	a0,0(a5)
    8000534c:	b43ff0ef          	jal	80004e8e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005350:	0992                	slli	s3,s3,0x4
    80005352:	397d                	addiw	s2,s2,-1
    80005354:	fe0917e3          	bnez	s2,80005342 <printf+0x232>
    80005358:	6ba6                	ld	s7,72(sp)
    8000535a:	b589                	j	8000519c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000535c:	f8843783          	ld	a5,-120(s0)
    80005360:	00878713          	addi	a4,a5,8
    80005364:	f8e43423          	sd	a4,-120(s0)
    80005368:	0007b903          	ld	s2,0(a5)
    8000536c:	00090d63          	beqz	s2,80005386 <printf+0x276>
      for(; *s; s++)
    80005370:	00094503          	lbu	a0,0(s2)
    80005374:	e20504e3          	beqz	a0,8000519c <printf+0x8c>
        consputc(*s);
    80005378:	b17ff0ef          	jal	80004e8e <consputc>
      for(; *s; s++)
    8000537c:	0905                	addi	s2,s2,1
    8000537e:	00094503          	lbu	a0,0(s2)
    80005382:	f97d                	bnez	a0,80005378 <printf+0x268>
    80005384:	bd21                	j	8000519c <printf+0x8c>
        s = "(null)";
    80005386:	00002917          	auipc	s2,0x2
    8000538a:	3a290913          	addi	s2,s2,930 # 80007728 <etext+0x728>
      for(; *s; s++)
    8000538e:	02800513          	li	a0,40
    80005392:	b7dd                	j	80005378 <printf+0x268>
      consputc('%');
    80005394:	02500513          	li	a0,37
    80005398:	af7ff0ef          	jal	80004e8e <consputc>
    8000539c:	b501                	j	8000519c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000539e:	f7843783          	ld	a5,-136(s0)
    800053a2:	e385                	bnez	a5,800053c2 <printf+0x2b2>
    800053a4:	74e6                	ld	s1,120(sp)
    800053a6:	7946                	ld	s2,112(sp)
    800053a8:	79a6                	ld	s3,104(sp)
    800053aa:	6ae6                	ld	s5,88(sp)
    800053ac:	6b46                	ld	s6,80(sp)
    800053ae:	6c06                	ld	s8,64(sp)
    800053b0:	7ce2                	ld	s9,56(sp)
    800053b2:	7d42                	ld	s10,48(sp)
    800053b4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800053b6:	4501                	li	a0,0
    800053b8:	60aa                	ld	ra,136(sp)
    800053ba:	640a                	ld	s0,128(sp)
    800053bc:	7a06                	ld	s4,96(sp)
    800053be:	6169                	addi	sp,sp,208
    800053c0:	8082                	ret
    800053c2:	74e6                	ld	s1,120(sp)
    800053c4:	7946                	ld	s2,112(sp)
    800053c6:	79a6                	ld	s3,104(sp)
    800053c8:	6ae6                	ld	s5,88(sp)
    800053ca:	6b46                	ld	s6,80(sp)
    800053cc:	6c06                	ld	s8,64(sp)
    800053ce:	7ce2                	ld	s9,56(sp)
    800053d0:	7d42                	ld	s10,48(sp)
    800053d2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800053d4:	0001e517          	auipc	a0,0x1e
    800053d8:	12450513          	addi	a0,a0,292 # 800234f8 <pr>
    800053dc:	3cc000ef          	jal	800057a8 <release>
    800053e0:	bfd9                	j	800053b6 <printf+0x2a6>

00000000800053e2 <panic>:

void
panic(char *s)
{
    800053e2:	1101                	addi	sp,sp,-32
    800053e4:	ec06                	sd	ra,24(sp)
    800053e6:	e822                	sd	s0,16(sp)
    800053e8:	e426                	sd	s1,8(sp)
    800053ea:	1000                	addi	s0,sp,32
    800053ec:	84aa                	mv	s1,a0
  pr.locking = 0;
    800053ee:	0001e797          	auipc	a5,0x1e
    800053f2:	1207a123          	sw	zero,290(a5) # 80023510 <pr+0x18>
  printf("panic: ");
    800053f6:	00002517          	auipc	a0,0x2
    800053fa:	33a50513          	addi	a0,a0,826 # 80007730 <etext+0x730>
    800053fe:	d13ff0ef          	jal	80005110 <printf>
  printf("%s\n", s);
    80005402:	85a6                	mv	a1,s1
    80005404:	00002517          	auipc	a0,0x2
    80005408:	33450513          	addi	a0,a0,820 # 80007738 <etext+0x738>
    8000540c:	d05ff0ef          	jal	80005110 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005410:	4785                	li	a5,1
    80005412:	00005717          	auipc	a4,0x5
    80005416:	def72d23          	sw	a5,-518(a4) # 8000a20c <panicked>
  for(;;)
    8000541a:	a001                	j	8000541a <panic+0x38>

000000008000541c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000541c:	1101                	addi	sp,sp,-32
    8000541e:	ec06                	sd	ra,24(sp)
    80005420:	e822                	sd	s0,16(sp)
    80005422:	e426                	sd	s1,8(sp)
    80005424:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005426:	0001e497          	auipc	s1,0x1e
    8000542a:	0d248493          	addi	s1,s1,210 # 800234f8 <pr>
    8000542e:	00002597          	auipc	a1,0x2
    80005432:	31258593          	addi	a1,a1,786 # 80007740 <etext+0x740>
    80005436:	8526                	mv	a0,s1
    80005438:	258000ef          	jal	80005690 <initlock>
  pr.locking = 1;
    8000543c:	4785                	li	a5,1
    8000543e:	cc9c                	sw	a5,24(s1)
}
    80005440:	60e2                	ld	ra,24(sp)
    80005442:	6442                	ld	s0,16(sp)
    80005444:	64a2                	ld	s1,8(sp)
    80005446:	6105                	addi	sp,sp,32
    80005448:	8082                	ret

000000008000544a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000544a:	1141                	addi	sp,sp,-16
    8000544c:	e406                	sd	ra,8(sp)
    8000544e:	e022                	sd	s0,0(sp)
    80005450:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005452:	100007b7          	lui	a5,0x10000
    80005456:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000545a:	10000737          	lui	a4,0x10000
    8000545e:	f8000693          	li	a3,-128
    80005462:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005466:	468d                	li	a3,3
    80005468:	10000637          	lui	a2,0x10000
    8000546c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005470:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005474:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005478:	10000737          	lui	a4,0x10000
    8000547c:	461d                	li	a2,7
    8000547e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005482:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005486:	00002597          	auipc	a1,0x2
    8000548a:	2c258593          	addi	a1,a1,706 # 80007748 <etext+0x748>
    8000548e:	0001e517          	auipc	a0,0x1e
    80005492:	08a50513          	addi	a0,a0,138 # 80023518 <uart_tx_lock>
    80005496:	1fa000ef          	jal	80005690 <initlock>
}
    8000549a:	60a2                	ld	ra,8(sp)
    8000549c:	6402                	ld	s0,0(sp)
    8000549e:	0141                	addi	sp,sp,16
    800054a0:	8082                	ret

00000000800054a2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800054a2:	1101                	addi	sp,sp,-32
    800054a4:	ec06                	sd	ra,24(sp)
    800054a6:	e822                	sd	s0,16(sp)
    800054a8:	e426                	sd	s1,8(sp)
    800054aa:	1000                	addi	s0,sp,32
    800054ac:	84aa                	mv	s1,a0
  push_off();
    800054ae:	222000ef          	jal	800056d0 <push_off>

  if(panicked){
    800054b2:	00005797          	auipc	a5,0x5
    800054b6:	d5a7a783          	lw	a5,-678(a5) # 8000a20c <panicked>
    800054ba:	e795                	bnez	a5,800054e6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054bc:	10000737          	lui	a4,0x10000
    800054c0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800054c2:	00074783          	lbu	a5,0(a4)
    800054c6:	0207f793          	andi	a5,a5,32
    800054ca:	dfe5                	beqz	a5,800054c2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054cc:	0ff4f513          	zext.b	a0,s1
    800054d0:	100007b7          	lui	a5,0x10000
    800054d4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054d8:	27c000ef          	jal	80005754 <pop_off>
}
    800054dc:	60e2                	ld	ra,24(sp)
    800054de:	6442                	ld	s0,16(sp)
    800054e0:	64a2                	ld	s1,8(sp)
    800054e2:	6105                	addi	sp,sp,32
    800054e4:	8082                	ret
    for(;;)
    800054e6:	a001                	j	800054e6 <uartputc_sync+0x44>

00000000800054e8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054e8:	00005797          	auipc	a5,0x5
    800054ec:	d287b783          	ld	a5,-728(a5) # 8000a210 <uart_tx_r>
    800054f0:	00005717          	auipc	a4,0x5
    800054f4:	d2873703          	ld	a4,-728(a4) # 8000a218 <uart_tx_w>
    800054f8:	08f70263          	beq	a4,a5,8000557c <uartstart+0x94>
{
    800054fc:	7139                	addi	sp,sp,-64
    800054fe:	fc06                	sd	ra,56(sp)
    80005500:	f822                	sd	s0,48(sp)
    80005502:	f426                	sd	s1,40(sp)
    80005504:	f04a                	sd	s2,32(sp)
    80005506:	ec4e                	sd	s3,24(sp)
    80005508:	e852                	sd	s4,16(sp)
    8000550a:	e456                	sd	s5,8(sp)
    8000550c:	e05a                	sd	s6,0(sp)
    8000550e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005510:	10000937          	lui	s2,0x10000
    80005514:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005516:	0001ea97          	auipc	s5,0x1e
    8000551a:	002a8a93          	addi	s5,s5,2 # 80023518 <uart_tx_lock>
    uart_tx_r += 1;
    8000551e:	00005497          	auipc	s1,0x5
    80005522:	cf248493          	addi	s1,s1,-782 # 8000a210 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005526:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000552a:	00005997          	auipc	s3,0x5
    8000552e:	cee98993          	addi	s3,s3,-786 # 8000a218 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005532:	00094703          	lbu	a4,0(s2)
    80005536:	02077713          	andi	a4,a4,32
    8000553a:	c71d                	beqz	a4,80005568 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000553c:	01f7f713          	andi	a4,a5,31
    80005540:	9756                	add	a4,a4,s5
    80005542:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005546:	0785                	addi	a5,a5,1
    80005548:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000554a:	8526                	mv	a0,s1
    8000554c:	e25fb0ef          	jal	80001370 <wakeup>
    WriteReg(THR, c);
    80005550:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005554:	609c                	ld	a5,0(s1)
    80005556:	0009b703          	ld	a4,0(s3)
    8000555a:	fcf71ce3          	bne	a4,a5,80005532 <uartstart+0x4a>
      ReadReg(ISR);
    8000555e:	100007b7          	lui	a5,0x10000
    80005562:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005564:	0007c783          	lbu	a5,0(a5)
  }
}
    80005568:	70e2                	ld	ra,56(sp)
    8000556a:	7442                	ld	s0,48(sp)
    8000556c:	74a2                	ld	s1,40(sp)
    8000556e:	7902                	ld	s2,32(sp)
    80005570:	69e2                	ld	s3,24(sp)
    80005572:	6a42                	ld	s4,16(sp)
    80005574:	6aa2                	ld	s5,8(sp)
    80005576:	6b02                	ld	s6,0(sp)
    80005578:	6121                	addi	sp,sp,64
    8000557a:	8082                	ret
      ReadReg(ISR);
    8000557c:	100007b7          	lui	a5,0x10000
    80005580:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005582:	0007c783          	lbu	a5,0(a5)
      return;
    80005586:	8082                	ret

0000000080005588 <uartputc>:
{
    80005588:	7179                	addi	sp,sp,-48
    8000558a:	f406                	sd	ra,40(sp)
    8000558c:	f022                	sd	s0,32(sp)
    8000558e:	ec26                	sd	s1,24(sp)
    80005590:	e84a                	sd	s2,16(sp)
    80005592:	e44e                	sd	s3,8(sp)
    80005594:	e052                	sd	s4,0(sp)
    80005596:	1800                	addi	s0,sp,48
    80005598:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000559a:	0001e517          	auipc	a0,0x1e
    8000559e:	f7e50513          	addi	a0,a0,-130 # 80023518 <uart_tx_lock>
    800055a2:	16e000ef          	jal	80005710 <acquire>
  if(panicked){
    800055a6:	00005797          	auipc	a5,0x5
    800055aa:	c667a783          	lw	a5,-922(a5) # 8000a20c <panicked>
    800055ae:	efbd                	bnez	a5,8000562c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055b0:	00005717          	auipc	a4,0x5
    800055b4:	c6873703          	ld	a4,-920(a4) # 8000a218 <uart_tx_w>
    800055b8:	00005797          	auipc	a5,0x5
    800055bc:	c587b783          	ld	a5,-936(a5) # 8000a210 <uart_tx_r>
    800055c0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800055c4:	0001e997          	auipc	s3,0x1e
    800055c8:	f5498993          	addi	s3,s3,-172 # 80023518 <uart_tx_lock>
    800055cc:	00005497          	auipc	s1,0x5
    800055d0:	c4448493          	addi	s1,s1,-956 # 8000a210 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055d4:	00005917          	auipc	s2,0x5
    800055d8:	c4490913          	addi	s2,s2,-956 # 8000a218 <uart_tx_w>
    800055dc:	00e79d63          	bne	a5,a4,800055f6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055e0:	85ce                	mv	a1,s3
    800055e2:	8526                	mv	a0,s1
    800055e4:	d41fb0ef          	jal	80001324 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055e8:	00093703          	ld	a4,0(s2)
    800055ec:	609c                	ld	a5,0(s1)
    800055ee:	02078793          	addi	a5,a5,32
    800055f2:	fee787e3          	beq	a5,a4,800055e0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800055f6:	0001e497          	auipc	s1,0x1e
    800055fa:	f2248493          	addi	s1,s1,-222 # 80023518 <uart_tx_lock>
    800055fe:	01f77793          	andi	a5,a4,31
    80005602:	97a6                	add	a5,a5,s1
    80005604:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005608:	0705                	addi	a4,a4,1
    8000560a:	00005797          	auipc	a5,0x5
    8000560e:	c0e7b723          	sd	a4,-1010(a5) # 8000a218 <uart_tx_w>
  uartstart();
    80005612:	ed7ff0ef          	jal	800054e8 <uartstart>
  release(&uart_tx_lock);
    80005616:	8526                	mv	a0,s1
    80005618:	190000ef          	jal	800057a8 <release>
}
    8000561c:	70a2                	ld	ra,40(sp)
    8000561e:	7402                	ld	s0,32(sp)
    80005620:	64e2                	ld	s1,24(sp)
    80005622:	6942                	ld	s2,16(sp)
    80005624:	69a2                	ld	s3,8(sp)
    80005626:	6a02                	ld	s4,0(sp)
    80005628:	6145                	addi	sp,sp,48
    8000562a:	8082                	ret
    for(;;)
    8000562c:	a001                	j	8000562c <uartputc+0xa4>

000000008000562e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000562e:	1141                	addi	sp,sp,-16
    80005630:	e422                	sd	s0,8(sp)
    80005632:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005634:	100007b7          	lui	a5,0x10000
    80005638:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000563a:	0007c783          	lbu	a5,0(a5)
    8000563e:	8b85                	andi	a5,a5,1
    80005640:	cb81                	beqz	a5,80005650 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005642:	100007b7          	lui	a5,0x10000
    80005646:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000564a:	6422                	ld	s0,8(sp)
    8000564c:	0141                	addi	sp,sp,16
    8000564e:	8082                	ret
    return -1;
    80005650:	557d                	li	a0,-1
    80005652:	bfe5                	j	8000564a <uartgetc+0x1c>

0000000080005654 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005654:	1101                	addi	sp,sp,-32
    80005656:	ec06                	sd	ra,24(sp)
    80005658:	e822                	sd	s0,16(sp)
    8000565a:	e426                	sd	s1,8(sp)
    8000565c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000565e:	54fd                	li	s1,-1
    80005660:	a019                	j	80005666 <uartintr+0x12>
      break;
    consoleintr(c);
    80005662:	85fff0ef          	jal	80004ec0 <consoleintr>
    int c = uartgetc();
    80005666:	fc9ff0ef          	jal	8000562e <uartgetc>
    if(c == -1)
    8000566a:	fe951ce3          	bne	a0,s1,80005662 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000566e:	0001e497          	auipc	s1,0x1e
    80005672:	eaa48493          	addi	s1,s1,-342 # 80023518 <uart_tx_lock>
    80005676:	8526                	mv	a0,s1
    80005678:	098000ef          	jal	80005710 <acquire>
  uartstart();
    8000567c:	e6dff0ef          	jal	800054e8 <uartstart>
  release(&uart_tx_lock);
    80005680:	8526                	mv	a0,s1
    80005682:	126000ef          	jal	800057a8 <release>
}
    80005686:	60e2                	ld	ra,24(sp)
    80005688:	6442                	ld	s0,16(sp)
    8000568a:	64a2                	ld	s1,8(sp)
    8000568c:	6105                	addi	sp,sp,32
    8000568e:	8082                	ret

0000000080005690 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005690:	1141                	addi	sp,sp,-16
    80005692:	e422                	sd	s0,8(sp)
    80005694:	0800                	addi	s0,sp,16
  lk->name = name;
    80005696:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005698:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000569c:	00053823          	sd	zero,16(a0)
}
    800056a0:	6422                	ld	s0,8(sp)
    800056a2:	0141                	addi	sp,sp,16
    800056a4:	8082                	ret

00000000800056a6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056a6:	411c                	lw	a5,0(a0)
    800056a8:	e399                	bnez	a5,800056ae <holding+0x8>
    800056aa:	4501                	li	a0,0
  return r;
}
    800056ac:	8082                	ret
{
    800056ae:	1101                	addi	sp,sp,-32
    800056b0:	ec06                	sd	ra,24(sp)
    800056b2:	e822                	sd	s0,16(sp)
    800056b4:	e426                	sd	s1,8(sp)
    800056b6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056b8:	6904                	ld	s1,16(a0)
    800056ba:	e80fb0ef          	jal	80000d3a <mycpu>
    800056be:	40a48533          	sub	a0,s1,a0
    800056c2:	00153513          	seqz	a0,a0
}
    800056c6:	60e2                	ld	ra,24(sp)
    800056c8:	6442                	ld	s0,16(sp)
    800056ca:	64a2                	ld	s1,8(sp)
    800056cc:	6105                	addi	sp,sp,32
    800056ce:	8082                	ret

00000000800056d0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056d0:	1101                	addi	sp,sp,-32
    800056d2:	ec06                	sd	ra,24(sp)
    800056d4:	e822                	sd	s0,16(sp)
    800056d6:	e426                	sd	s1,8(sp)
    800056d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056da:	100024f3          	csrr	s1,sstatus
    800056de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056e2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056e4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056e8:	e52fb0ef          	jal	80000d3a <mycpu>
    800056ec:	5d3c                	lw	a5,120(a0)
    800056ee:	cb99                	beqz	a5,80005704 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800056f0:	e4afb0ef          	jal	80000d3a <mycpu>
    800056f4:	5d3c                	lw	a5,120(a0)
    800056f6:	2785                	addiw	a5,a5,1
    800056f8:	dd3c                	sw	a5,120(a0)
}
    800056fa:	60e2                	ld	ra,24(sp)
    800056fc:	6442                	ld	s0,16(sp)
    800056fe:	64a2                	ld	s1,8(sp)
    80005700:	6105                	addi	sp,sp,32
    80005702:	8082                	ret
    mycpu()->intena = old;
    80005704:	e36fb0ef          	jal	80000d3a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005708:	8085                	srli	s1,s1,0x1
    8000570a:	8885                	andi	s1,s1,1
    8000570c:	dd64                	sw	s1,124(a0)
    8000570e:	b7cd                	j	800056f0 <push_off+0x20>

0000000080005710 <acquire>:
{
    80005710:	1101                	addi	sp,sp,-32
    80005712:	ec06                	sd	ra,24(sp)
    80005714:	e822                	sd	s0,16(sp)
    80005716:	e426                	sd	s1,8(sp)
    80005718:	1000                	addi	s0,sp,32
    8000571a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000571c:	fb5ff0ef          	jal	800056d0 <push_off>
  if(holding(lk))
    80005720:	8526                	mv	a0,s1
    80005722:	f85ff0ef          	jal	800056a6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005726:	4705                	li	a4,1
  if(holding(lk))
    80005728:	e105                	bnez	a0,80005748 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000572a:	87ba                	mv	a5,a4
    8000572c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005730:	2781                	sext.w	a5,a5
    80005732:	ffe5                	bnez	a5,8000572a <acquire+0x1a>
  __sync_synchronize();
    80005734:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005738:	e02fb0ef          	jal	80000d3a <mycpu>
    8000573c:	e888                	sd	a0,16(s1)
}
    8000573e:	60e2                	ld	ra,24(sp)
    80005740:	6442                	ld	s0,16(sp)
    80005742:	64a2                	ld	s1,8(sp)
    80005744:	6105                	addi	sp,sp,32
    80005746:	8082                	ret
    panic("acquire");
    80005748:	00002517          	auipc	a0,0x2
    8000574c:	00850513          	addi	a0,a0,8 # 80007750 <etext+0x750>
    80005750:	c93ff0ef          	jal	800053e2 <panic>

0000000080005754 <pop_off>:

void
pop_off(void)
{
    80005754:	1141                	addi	sp,sp,-16
    80005756:	e406                	sd	ra,8(sp)
    80005758:	e022                	sd	s0,0(sp)
    8000575a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000575c:	ddefb0ef          	jal	80000d3a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005760:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005764:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005766:	e78d                	bnez	a5,80005790 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005768:	5d3c                	lw	a5,120(a0)
    8000576a:	02f05963          	blez	a5,8000579c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000576e:	37fd                	addiw	a5,a5,-1
    80005770:	0007871b          	sext.w	a4,a5
    80005774:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005776:	eb09                	bnez	a4,80005788 <pop_off+0x34>
    80005778:	5d7c                	lw	a5,124(a0)
    8000577a:	c799                	beqz	a5,80005788 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000577c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005780:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005784:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005788:	60a2                	ld	ra,8(sp)
    8000578a:	6402                	ld	s0,0(sp)
    8000578c:	0141                	addi	sp,sp,16
    8000578e:	8082                	ret
    panic("pop_off - interruptible");
    80005790:	00002517          	auipc	a0,0x2
    80005794:	fc850513          	addi	a0,a0,-56 # 80007758 <etext+0x758>
    80005798:	c4bff0ef          	jal	800053e2 <panic>
    panic("pop_off");
    8000579c:	00002517          	auipc	a0,0x2
    800057a0:	fd450513          	addi	a0,a0,-44 # 80007770 <etext+0x770>
    800057a4:	c3fff0ef          	jal	800053e2 <panic>

00000000800057a8 <release>:
{
    800057a8:	1101                	addi	sp,sp,-32
    800057aa:	ec06                	sd	ra,24(sp)
    800057ac:	e822                	sd	s0,16(sp)
    800057ae:	e426                	sd	s1,8(sp)
    800057b0:	1000                	addi	s0,sp,32
    800057b2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057b4:	ef3ff0ef          	jal	800056a6 <holding>
    800057b8:	c105                	beqz	a0,800057d8 <release+0x30>
  lk->cpu = 0;
    800057ba:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057be:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800057c2:	0310000f          	fence	rw,w
    800057c6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800057ca:	f8bff0ef          	jal	80005754 <pop_off>
}
    800057ce:	60e2                	ld	ra,24(sp)
    800057d0:	6442                	ld	s0,16(sp)
    800057d2:	64a2                	ld	s1,8(sp)
    800057d4:	6105                	addi	sp,sp,32
    800057d6:	8082                	ret
    panic("release");
    800057d8:	00002517          	auipc	a0,0x2
    800057dc:	fa050513          	addi	a0,a0,-96 # 80007778 <etext+0x778>
    800057e0:	c03ff0ef          	jal	800053e2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
