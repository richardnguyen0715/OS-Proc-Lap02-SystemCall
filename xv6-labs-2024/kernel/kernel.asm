
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	3f013103          	ld	sp,1008(sp) # 8000a3f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5b9040ef          	jal	80004dce <start>

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
    80000030:	00024797          	auipc	a5,0x24
    80000034:	94078793          	addi	a5,a5,-1728 # 80023970 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	3fc90913          	addi	s2,s2,1020 # 8000a440 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	7e2050ef          	jal	80005830 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	06b050ef          	jal	800058c8 <release>
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
    80000076:	48c050ef          	jal	80005502 <panic>

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
    800000ce:	f3e58593          	addi	a1,a1,-194 # 80007008 <etext+0x8>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	36e50513          	addi	a0,a0,878 # 8000a440 <kmem>
    800000da:	6d6050ef          	jal	800057b0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00024517          	auipc	a0,0x24
    800000e6:	88e50513          	addi	a0,a0,-1906 # 80023970 <end>
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
    80000104:	34048493          	addi	s1,s1,832 # 8000a440 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	726050ef          	jal	80005830 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	34f73223          	sd	a5,836(a4) # 8000a458 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	32450513          	addi	a0,a0,804 # 8000a440 <kmem>
    80000124:	7a4050ef          	jal	800058c8 <release>
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

0000000080000134 <nfree>:




uint64
nfree(void){
    80000134:	1101                	addi	sp,sp,-32
    80000136:	ec06                	sd	ra,24(sp)
    80000138:	e822                	sd	s0,16(sp)
    8000013a:	e426                	sd	s1,8(sp)
    8000013c:	1000                	addi	s0,sp,32
  struct run* r;
  int byteCount = 0;
  acquire(&kmem.lock);
    8000013e:	0000a497          	auipc	s1,0xa
    80000142:	30248493          	addi	s1,s1,770 # 8000a440 <kmem>
    80000146:	8526                	mv	a0,s1
    80000148:	6e8050ef          	jal	80005830 <acquire>
  r = kmem.freelist;
    8000014c:	6c9c                	ld	a5,24(s1)
  while(r){
    8000014e:	c395                	beqz	a5,80000172 <nfree+0x3e>
  int byteCount = 0;
    80000150:	4481                	li	s1,0
    r = r->next;
    80000152:	639c                	ld	a5,0(a5)
    byteCount++;
    80000154:	2485                	addiw	s1,s1,1
  while(r){
    80000156:	fff5                	bnez	a5,80000152 <nfree+0x1e>
  }
  release(&kmem.lock);
    80000158:	0000a517          	auipc	a0,0xa
    8000015c:	2e850513          	addi	a0,a0,744 # 8000a440 <kmem>
    80000160:	768050ef          	jal	800058c8 <release>
  return byteCount * PGSIZE;
    80000164:	00c4951b          	slliw	a0,s1,0xc
    80000168:	60e2                	ld	ra,24(sp)
    8000016a:	6442                	ld	s0,16(sp)
    8000016c:	64a2                	ld	s1,8(sp)
    8000016e:	6105                	addi	sp,sp,32
    80000170:	8082                	ret
  int byteCount = 0;
    80000172:	4481                	li	s1,0
    80000174:	b7d5                	j	80000158 <nfree+0x24>

0000000080000176 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000176:	1141                	addi	sp,sp,-16
    80000178:	e422                	sd	s0,8(sp)
    8000017a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017c:	ca19                	beqz	a2,80000192 <memset+0x1c>
    8000017e:	87aa                	mv	a5,a0
    80000180:	1602                	slli	a2,a2,0x20
    80000182:	9201                	srli	a2,a2,0x20
    80000184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000018c:	0785                	addi	a5,a5,1
    8000018e:	fee79de3          	bne	a5,a4,80000188 <memset+0x12>
  }
  return dst;
}
    80000192:	6422                	ld	s0,8(sp)
    80000194:	0141                	addi	sp,sp,16
    80000196:	8082                	ret

0000000080000198 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000198:	1141                	addi	sp,sp,-16
    8000019a:	e422                	sd	s0,8(sp)
    8000019c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000019e:	ca05                	beqz	a2,800001ce <memcmp+0x36>
    800001a0:	fff6069b          	addiw	a3,a2,-1
    800001a4:	1682                	slli	a3,a3,0x20
    800001a6:	9281                	srli	a3,a3,0x20
    800001a8:	0685                	addi	a3,a3,1
    800001aa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001ac:	00054783          	lbu	a5,0(a0)
    800001b0:	0005c703          	lbu	a4,0(a1)
    800001b4:	00e79863          	bne	a5,a4,800001c4 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001b8:	0505                	addi	a0,a0,1
    800001ba:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001bc:	fed518e3          	bne	a0,a3,800001ac <memcmp+0x14>
  }

  return 0;
    800001c0:	4501                	li	a0,0
    800001c2:	a019                	j	800001c8 <memcmp+0x30>
      return *s1 - *s2;
    800001c4:	40e7853b          	subw	a0,a5,a4
}
    800001c8:	6422                	ld	s0,8(sp)
    800001ca:	0141                	addi	sp,sp,16
    800001cc:	8082                	ret
  return 0;
    800001ce:	4501                	li	a0,0
    800001d0:	bfe5                	j	800001c8 <memcmp+0x30>

00000000800001d2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d2:	1141                	addi	sp,sp,-16
    800001d4:	e422                	sd	s0,8(sp)
    800001d6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001d8:	c205                	beqz	a2,800001f8 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001da:	02a5e263          	bltu	a1,a0,800001fe <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001de:	1602                	slli	a2,a2,0x20
    800001e0:	9201                	srli	a2,a2,0x20
    800001e2:	00c587b3          	add	a5,a1,a2
{
    800001e6:	872a                	mv	a4,a0
      *d++ = *s++;
    800001e8:	0585                	addi	a1,a1,1
    800001ea:	0705                	addi	a4,a4,1
    800001ec:	fff5c683          	lbu	a3,-1(a1)
    800001f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f4:	feb79ae3          	bne	a5,a1,800001e8 <memmove+0x16>

  return dst;
}
    800001f8:	6422                	ld	s0,8(sp)
    800001fa:	0141                	addi	sp,sp,16
    800001fc:	8082                	ret
  if(s < d && s + n > d){
    800001fe:	02061693          	slli	a3,a2,0x20
    80000202:	9281                	srli	a3,a3,0x20
    80000204:	00d58733          	add	a4,a1,a3
    80000208:	fce57be3          	bgeu	a0,a4,800001de <memmove+0xc>
    d += n;
    8000020c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000020e:	fff6079b          	addiw	a5,a2,-1
    80000212:	1782                	slli	a5,a5,0x20
    80000214:	9381                	srli	a5,a5,0x20
    80000216:	fff7c793          	not	a5,a5
    8000021a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000021c:	177d                	addi	a4,a4,-1
    8000021e:	16fd                	addi	a3,a3,-1
    80000220:	00074603          	lbu	a2,0(a4)
    80000224:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000228:	fef71ae3          	bne	a4,a5,8000021c <memmove+0x4a>
    8000022c:	b7f1                	j	800001f8 <memmove+0x26>

000000008000022e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000022e:	1141                	addi	sp,sp,-16
    80000230:	e406                	sd	ra,8(sp)
    80000232:	e022                	sd	s0,0(sp)
    80000234:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000236:	f9dff0ef          	jal	800001d2 <memmove>
}
    8000023a:	60a2                	ld	ra,8(sp)
    8000023c:	6402                	ld	s0,0(sp)
    8000023e:	0141                	addi	sp,sp,16
    80000240:	8082                	ret

0000000080000242 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000242:	1141                	addi	sp,sp,-16
    80000244:	e422                	sd	s0,8(sp)
    80000246:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000248:	ce11                	beqz	a2,80000264 <strncmp+0x22>
    8000024a:	00054783          	lbu	a5,0(a0)
    8000024e:	cf89                	beqz	a5,80000268 <strncmp+0x26>
    80000250:	0005c703          	lbu	a4,0(a1)
    80000254:	00f71a63          	bne	a4,a5,80000268 <strncmp+0x26>
    n--, p++, q++;
    80000258:	367d                	addiw	a2,a2,-1
    8000025a:	0505                	addi	a0,a0,1
    8000025c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000025e:	f675                	bnez	a2,8000024a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000260:	4501                	li	a0,0
    80000262:	a801                	j	80000272 <strncmp+0x30>
    80000264:	4501                	li	a0,0
    80000266:	a031                	j	80000272 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000268:	00054503          	lbu	a0,0(a0)
    8000026c:	0005c783          	lbu	a5,0(a1)
    80000270:	9d1d                	subw	a0,a0,a5
}
    80000272:	6422                	ld	s0,8(sp)
    80000274:	0141                	addi	sp,sp,16
    80000276:	8082                	ret

0000000080000278 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e422                	sd	s0,8(sp)
    8000027c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000027e:	87aa                	mv	a5,a0
    80000280:	86b2                	mv	a3,a2
    80000282:	367d                	addiw	a2,a2,-1
    80000284:	02d05563          	blez	a3,800002ae <strncpy+0x36>
    80000288:	0785                	addi	a5,a5,1
    8000028a:	0005c703          	lbu	a4,0(a1)
    8000028e:	fee78fa3          	sb	a4,-1(a5)
    80000292:	0585                	addi	a1,a1,1
    80000294:	f775                	bnez	a4,80000280 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000296:	873e                	mv	a4,a5
    80000298:	9fb5                	addw	a5,a5,a3
    8000029a:	37fd                	addiw	a5,a5,-1
    8000029c:	00c05963          	blez	a2,800002ae <strncpy+0x36>
    *s++ = 0;
    800002a0:	0705                	addi	a4,a4,1
    800002a2:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002a6:	40e786bb          	subw	a3,a5,a4
    800002aa:	fed04be3          	bgtz	a3,800002a0 <strncpy+0x28>
  return os;
}
    800002ae:	6422                	ld	s0,8(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret

00000000800002b4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002b4:	1141                	addi	sp,sp,-16
    800002b6:	e422                	sd	s0,8(sp)
    800002b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2c>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x28>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x16>
    ;
  *s = 0;
    800002dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e0:	6422                	ld	s0,8(sp)
    800002e2:	0141                	addi	sp,sp,16
    800002e4:	8082                	ret

00000000800002e6 <strlen>:

int
strlen(const char *s)
{
    800002e6:	1141                	addi	sp,sp,-16
    800002e8:	e422                	sd	s0,8(sp)
    800002ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002ec:	00054783          	lbu	a5,0(a0)
    800002f0:	cf91                	beqz	a5,8000030c <strlen+0x26>
    800002f2:	0505                	addi	a0,a0,1
    800002f4:	87aa                	mv	a5,a0
    800002f6:	86be                	mv	a3,a5
    800002f8:	0785                	addi	a5,a5,1
    800002fa:	fff7c703          	lbu	a4,-1(a5)
    800002fe:	ff65                	bnez	a4,800002f6 <strlen+0x10>
    80000300:	40a6853b          	subw	a0,a3,a0
    80000304:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	addi	sp,sp,16
    8000030a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000030c:	4501                	li	a0,0
    8000030e:	bfe5                	j	80000306 <strlen+0x20>

0000000080000310 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000310:	1141                	addi	sp,sp,-16
    80000312:	e406                	sd	ra,8(sp)
    80000314:	e022                	sd	s0,0(sp)
    80000316:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000318:	255000ef          	jal	80000d6c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000031c:	0000a717          	auipc	a4,0xa
    80000320:	0f470713          	addi	a4,a4,244 # 8000a410 <started>
  if(cpuid() == 0){
    80000324:	c51d                	beqz	a0,80000352 <main+0x42>
    while(started == 0)
    80000326:	431c                	lw	a5,0(a4)
    80000328:	2781                	sext.w	a5,a5
    8000032a:	dff5                	beqz	a5,80000326 <main+0x16>
      ;
    __sync_synchronize();
    8000032c:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000330:	23d000ef          	jal	80000d6c <cpuid>
    80000334:	85aa                	mv	a1,a0
    80000336:	00007517          	auipc	a0,0x7
    8000033a:	cf250513          	addi	a0,a0,-782 # 80007028 <etext+0x28>
    8000033e:	6f3040ef          	jal	80005230 <printf>
    kvminithart();    // turn on paging
    80000342:	080000ef          	jal	800003c2 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000346:	57e010ef          	jal	800018c4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034a:	49e040ef          	jal	800047e8 <plicinithart>
  }

  scheduler();        
    8000034e:	68b000ef          	jal	800011d8 <scheduler>
    consoleinit();
    80000352:	609040ef          	jal	8000515a <consoleinit>
    printfinit();
    80000356:	1e6050ef          	jal	8000553c <printfinit>
    printf("\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cde50513          	addi	a0,a0,-802 # 80007038 <etext+0x38>
    80000362:	6cf040ef          	jal	80005230 <printf>
    printf("xv6 kernel is booting\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	caa50513          	addi	a0,a0,-854 # 80007010 <etext+0x10>
    8000036e:	6c3040ef          	jal	80005230 <printf>
    printf("\n");
    80000372:	00007517          	auipc	a0,0x7
    80000376:	cc650513          	addi	a0,a0,-826 # 80007038 <etext+0x38>
    8000037a:	6b7040ef          	jal	80005230 <printf>
    kinit();         // physical page allocator
    8000037e:	d45ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000382:	2ca000ef          	jal	8000064c <kvminit>
    kvminithart();   // turn on paging
    80000386:	03c000ef          	jal	800003c2 <kvminithart>
    procinit();      // process table
    8000038a:	12d000ef          	jal	80000cb6 <procinit>
    trapinit();      // trap vectors
    8000038e:	512010ef          	jal	800018a0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000392:	532010ef          	jal	800018c4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000396:	438040ef          	jal	800047ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039a:	44e040ef          	jal	800047e8 <plicinithart>
    binit();         // buffer cache
    8000039e:	3f9010ef          	jal	80001f96 <binit>
    iinit();         // inode table
    800003a2:	1ea020ef          	jal	8000258c <iinit>
    fileinit();      // file table
    800003a6:	797020ef          	jal	8000333c <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003aa:	52e040ef          	jal	800048d8 <virtio_disk_init>
    userinit();      // first user process
    800003ae:	457000ef          	jal	80001004 <userinit>
    __sync_synchronize();
    800003b2:	0330000f          	fence	rw,rw
    started = 1;
    800003b6:	4785                	li	a5,1
    800003b8:	0000a717          	auipc	a4,0xa
    800003bc:	04f72c23          	sw	a5,88(a4) # 8000a410 <started>
    800003c0:	b779                	j	8000034e <main+0x3e>

00000000800003c2 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003c2:	1141                	addi	sp,sp,-16
    800003c4:	e422                	sd	s0,8(sp)
    800003c6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003c8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003cc:	0000a797          	auipc	a5,0xa
    800003d0:	04c7b783          	ld	a5,76(a5) # 8000a418 <kernel_pagetable>
    800003d4:	83b1                	srli	a5,a5,0xc
    800003d6:	577d                	li	a4,-1
    800003d8:	177e                	slli	a4,a4,0x3f
    800003da:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003dc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003e0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003e4:	6422                	ld	s0,8(sp)
    800003e6:	0141                	addi	sp,sp,16
    800003e8:	8082                	ret

00000000800003ea <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003ea:	7139                	addi	sp,sp,-64
    800003ec:	fc06                	sd	ra,56(sp)
    800003ee:	f822                	sd	s0,48(sp)
    800003f0:	f426                	sd	s1,40(sp)
    800003f2:	f04a                	sd	s2,32(sp)
    800003f4:	ec4e                	sd	s3,24(sp)
    800003f6:	e852                	sd	s4,16(sp)
    800003f8:	e456                	sd	s5,8(sp)
    800003fa:	e05a                	sd	s6,0(sp)
    800003fc:	0080                	addi	s0,sp,64
    800003fe:	84aa                	mv	s1,a0
    80000400:	89ae                	mv	s3,a1
    80000402:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000404:	57fd                	li	a5,-1
    80000406:	83e9                	srli	a5,a5,0x1a
    80000408:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000040a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000040c:	02b7fc63          	bgeu	a5,a1,80000444 <walk+0x5a>
    panic("walk");
    80000410:	00007517          	auipc	a0,0x7
    80000414:	c3050513          	addi	a0,a0,-976 # 80007040 <etext+0x40>
    80000418:	0ea050ef          	jal	80005502 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000041c:	060a8263          	beqz	s5,80000480 <walk+0x96>
    80000420:	cd7ff0ef          	jal	800000f6 <kalloc>
    80000424:	84aa                	mv	s1,a0
    80000426:	c139                	beqz	a0,8000046c <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000428:	6605                	lui	a2,0x1
    8000042a:	4581                	li	a1,0
    8000042c:	d4bff0ef          	jal	80000176 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000430:	00c4d793          	srli	a5,s1,0xc
    80000434:	07aa                	slli	a5,a5,0xa
    80000436:	0017e793          	ori	a5,a5,1
    8000043a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000043e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb687>
    80000440:	036a0063          	beq	s4,s6,80000460 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000444:	0149d933          	srl	s2,s3,s4
    80000448:	1ff97913          	andi	s2,s2,511
    8000044c:	090e                	slli	s2,s2,0x3
    8000044e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000450:	00093483          	ld	s1,0(s2)
    80000454:	0014f793          	andi	a5,s1,1
    80000458:	d3f1                	beqz	a5,8000041c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000045a:	80a9                	srli	s1,s1,0xa
    8000045c:	04b2                	slli	s1,s1,0xc
    8000045e:	b7c5                	j	8000043e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000460:	00c9d513          	srli	a0,s3,0xc
    80000464:	1ff57513          	andi	a0,a0,511
    80000468:	050e                	slli	a0,a0,0x3
    8000046a:	9526                	add	a0,a0,s1
}
    8000046c:	70e2                	ld	ra,56(sp)
    8000046e:	7442                	ld	s0,48(sp)
    80000470:	74a2                	ld	s1,40(sp)
    80000472:	7902                	ld	s2,32(sp)
    80000474:	69e2                	ld	s3,24(sp)
    80000476:	6a42                	ld	s4,16(sp)
    80000478:	6aa2                	ld	s5,8(sp)
    8000047a:	6b02                	ld	s6,0(sp)
    8000047c:	6121                	addi	sp,sp,64
    8000047e:	8082                	ret
        return 0;
    80000480:	4501                	li	a0,0
    80000482:	b7ed                	j	8000046c <walk+0x82>

0000000080000484 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000484:	57fd                	li	a5,-1
    80000486:	83e9                	srli	a5,a5,0x1a
    80000488:	00b7f463          	bgeu	a5,a1,80000490 <walkaddr+0xc>
    return 0;
    8000048c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000048e:	8082                	ret
{
    80000490:	1141                	addi	sp,sp,-16
    80000492:	e406                	sd	ra,8(sp)
    80000494:	e022                	sd	s0,0(sp)
    80000496:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000498:	4601                	li	a2,0
    8000049a:	f51ff0ef          	jal	800003ea <walk>
  if(pte == 0)
    8000049e:	c105                	beqz	a0,800004be <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004a0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004a2:	0117f693          	andi	a3,a5,17
    800004a6:	4745                	li	a4,17
    return 0;
    800004a8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004aa:	00e68663          	beq	a3,a4,800004b6 <walkaddr+0x32>
}
    800004ae:	60a2                	ld	ra,8(sp)
    800004b0:	6402                	ld	s0,0(sp)
    800004b2:	0141                	addi	sp,sp,16
    800004b4:	8082                	ret
  pa = PTE2PA(*pte);
    800004b6:	83a9                	srli	a5,a5,0xa
    800004b8:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004bc:	bfcd                	j	800004ae <walkaddr+0x2a>
    return 0;
    800004be:	4501                	li	a0,0
    800004c0:	b7fd                	j	800004ae <walkaddr+0x2a>

00000000800004c2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c2:	715d                	addi	sp,sp,-80
    800004c4:	e486                	sd	ra,72(sp)
    800004c6:	e0a2                	sd	s0,64(sp)
    800004c8:	fc26                	sd	s1,56(sp)
    800004ca:	f84a                	sd	s2,48(sp)
    800004cc:	f44e                	sd	s3,40(sp)
    800004ce:	f052                	sd	s4,32(sp)
    800004d0:	ec56                	sd	s5,24(sp)
    800004d2:	e85a                	sd	s6,16(sp)
    800004d4:	e45e                	sd	s7,8(sp)
    800004d6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d8:	03459793          	slli	a5,a1,0x34
    800004dc:	e7a9                	bnez	a5,80000526 <mappages+0x64>
    800004de:	8aaa                	mv	s5,a0
    800004e0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e2:	03461793          	slli	a5,a2,0x34
    800004e6:	e7b1                	bnez	a5,80000532 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e8:	ca39                	beqz	a2,8000053e <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ea:	77fd                	lui	a5,0xfffff
    800004ec:	963e                	add	a2,a2,a5
    800004ee:	00b609b3          	add	s3,a2,a1
  a = va;
    800004f2:	892e                	mv	s2,a1
    800004f4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f8:	6b85                	lui	s7,0x1
    800004fa:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fe:	4605                	li	a2,1
    80000500:	85ca                	mv	a1,s2
    80000502:	8556                	mv	a0,s5
    80000504:	ee7ff0ef          	jal	800003ea <walk>
    80000508:	c539                	beqz	a0,80000556 <mappages+0x94>
    if(*pte & PTE_V)
    8000050a:	611c                	ld	a5,0(a0)
    8000050c:	8b85                	andi	a5,a5,1
    8000050e:	ef95                	bnez	a5,8000054a <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000510:	80b1                	srli	s1,s1,0xc
    80000512:	04aa                	slli	s1,s1,0xa
    80000514:	0164e4b3          	or	s1,s1,s6
    80000518:	0014e493          	ori	s1,s1,1
    8000051c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051e:	05390863          	beq	s2,s3,8000056e <mappages+0xac>
    a += PGSIZE;
    80000522:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000524:	bfd9                	j	800004fa <mappages+0x38>
    panic("mappages: va not aligned");
    80000526:	00007517          	auipc	a0,0x7
    8000052a:	b2250513          	addi	a0,a0,-1246 # 80007048 <etext+0x48>
    8000052e:	7d5040ef          	jal	80005502 <panic>
    panic("mappages: size not aligned");
    80000532:	00007517          	auipc	a0,0x7
    80000536:	b3650513          	addi	a0,a0,-1226 # 80007068 <etext+0x68>
    8000053a:	7c9040ef          	jal	80005502 <panic>
    panic("mappages: size");
    8000053e:	00007517          	auipc	a0,0x7
    80000542:	b4a50513          	addi	a0,a0,-1206 # 80007088 <etext+0x88>
    80000546:	7bd040ef          	jal	80005502 <panic>
      panic("mappages: remap");
    8000054a:	00007517          	auipc	a0,0x7
    8000054e:	b4e50513          	addi	a0,a0,-1202 # 80007098 <etext+0x98>
    80000552:	7b1040ef          	jal	80005502 <panic>
      return -1;
    80000556:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000558:	60a6                	ld	ra,72(sp)
    8000055a:	6406                	ld	s0,64(sp)
    8000055c:	74e2                	ld	s1,56(sp)
    8000055e:	7942                	ld	s2,48(sp)
    80000560:	79a2                	ld	s3,40(sp)
    80000562:	7a02                	ld	s4,32(sp)
    80000564:	6ae2                	ld	s5,24(sp)
    80000566:	6b42                	ld	s6,16(sp)
    80000568:	6ba2                	ld	s7,8(sp)
    8000056a:	6161                	addi	sp,sp,80
    8000056c:	8082                	ret
  return 0;
    8000056e:	4501                	li	a0,0
    80000570:	b7e5                	j	80000558 <mappages+0x96>

0000000080000572 <kvmmap>:
{
    80000572:	1141                	addi	sp,sp,-16
    80000574:	e406                	sd	ra,8(sp)
    80000576:	e022                	sd	s0,0(sp)
    80000578:	0800                	addi	s0,sp,16
    8000057a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057c:	86b2                	mv	a3,a2
    8000057e:	863e                	mv	a2,a5
    80000580:	f43ff0ef          	jal	800004c2 <mappages>
    80000584:	e509                	bnez	a0,8000058e <kvmmap+0x1c>
}
    80000586:	60a2                	ld	ra,8(sp)
    80000588:	6402                	ld	s0,0(sp)
    8000058a:	0141                	addi	sp,sp,16
    8000058c:	8082                	ret
    panic("kvmmap");
    8000058e:	00007517          	auipc	a0,0x7
    80000592:	b1a50513          	addi	a0,a0,-1254 # 800070a8 <etext+0xa8>
    80000596:	76d040ef          	jal	80005502 <panic>

000000008000059a <kvmmake>:
{
    8000059a:	1101                	addi	sp,sp,-32
    8000059c:	ec06                	sd	ra,24(sp)
    8000059e:	e822                	sd	s0,16(sp)
    800005a0:	e426                	sd	s1,8(sp)
    800005a2:	e04a                	sd	s2,0(sp)
    800005a4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a6:	b51ff0ef          	jal	800000f6 <kalloc>
    800005aa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005ac:	6605                	lui	a2,0x1
    800005ae:	4581                	li	a1,0
    800005b0:	bc7ff0ef          	jal	80000176 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b4:	4719                	li	a4,6
    800005b6:	6685                	lui	a3,0x1
    800005b8:	10000637          	lui	a2,0x10000
    800005bc:	100005b7          	lui	a1,0x10000
    800005c0:	8526                	mv	a0,s1
    800005c2:	fb1ff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c6:	4719                	li	a4,6
    800005c8:	6685                	lui	a3,0x1
    800005ca:	10001637          	lui	a2,0x10001
    800005ce:	100015b7          	lui	a1,0x10001
    800005d2:	8526                	mv	a0,s1
    800005d4:	f9fff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d8:	4719                	li	a4,6
    800005da:	040006b7          	lui	a3,0x4000
    800005de:	0c000637          	lui	a2,0xc000
    800005e2:	0c0005b7          	lui	a1,0xc000
    800005e6:	8526                	mv	a0,s1
    800005e8:	f8bff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ec:	00007917          	auipc	s2,0x7
    800005f0:	a1490913          	addi	s2,s2,-1516 # 80007000 <etext>
    800005f4:	4729                	li	a4,10
    800005f6:	80007697          	auipc	a3,0x80007
    800005fa:	a0a68693          	addi	a3,a3,-1526 # 7000 <_entry-0x7fff9000>
    800005fe:	4605                	li	a2,1
    80000600:	067e                	slli	a2,a2,0x1f
    80000602:	85b2                	mv	a1,a2
    80000604:	8526                	mv	a0,s1
    80000606:	f6dff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000060a:	46c5                	li	a3,17
    8000060c:	06ee                	slli	a3,a3,0x1b
    8000060e:	4719                	li	a4,6
    80000610:	412686b3          	sub	a3,a3,s2
    80000614:	864a                	mv	a2,s2
    80000616:	85ca                	mv	a1,s2
    80000618:	8526                	mv	a0,s1
    8000061a:	f59ff0ef          	jal	80000572 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000061e:	4729                	li	a4,10
    80000620:	6685                	lui	a3,0x1
    80000622:	00006617          	auipc	a2,0x6
    80000626:	9de60613          	addi	a2,a2,-1570 # 80006000 <_trampoline>
    8000062a:	040005b7          	lui	a1,0x4000
    8000062e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000630:	05b2                	slli	a1,a1,0xc
    80000632:	8526                	mv	a0,s1
    80000634:	f3fff0ef          	jal	80000572 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000638:	8526                	mv	a0,s1
    8000063a:	5e4000ef          	jal	80000c1e <proc_mapstacks>
}
    8000063e:	8526                	mv	a0,s1
    80000640:	60e2                	ld	ra,24(sp)
    80000642:	6442                	ld	s0,16(sp)
    80000644:	64a2                	ld	s1,8(sp)
    80000646:	6902                	ld	s2,0(sp)
    80000648:	6105                	addi	sp,sp,32
    8000064a:	8082                	ret

000000008000064c <kvminit>:
{
    8000064c:	1141                	addi	sp,sp,-16
    8000064e:	e406                	sd	ra,8(sp)
    80000650:	e022                	sd	s0,0(sp)
    80000652:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000654:	f47ff0ef          	jal	8000059a <kvmmake>
    80000658:	0000a797          	auipc	a5,0xa
    8000065c:	dca7b023          	sd	a0,-576(a5) # 8000a418 <kernel_pagetable>
}
    80000660:	60a2                	ld	ra,8(sp)
    80000662:	6402                	ld	s0,0(sp)
    80000664:	0141                	addi	sp,sp,16
    80000666:	8082                	ret

0000000080000668 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000668:	715d                	addi	sp,sp,-80
    8000066a:	e486                	sd	ra,72(sp)
    8000066c:	e0a2                	sd	s0,64(sp)
    8000066e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000670:	03459793          	slli	a5,a1,0x34
    80000674:	e39d                	bnez	a5,8000069a <uvmunmap+0x32>
    80000676:	f84a                	sd	s2,48(sp)
    80000678:	f44e                	sd	s3,40(sp)
    8000067a:	f052                	sd	s4,32(sp)
    8000067c:	ec56                	sd	s5,24(sp)
    8000067e:	e85a                	sd	s6,16(sp)
    80000680:	e45e                	sd	s7,8(sp)
    80000682:	8a2a                	mv	s4,a0
    80000684:	892e                	mv	s2,a1
    80000686:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000688:	0632                	slli	a2,a2,0xc
    8000068a:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000068e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000690:	6b05                	lui	s6,0x1
    80000692:	0935f763          	bgeu	a1,s3,80000720 <uvmunmap+0xb8>
    80000696:	fc26                	sd	s1,56(sp)
    80000698:	a8a1                	j	800006f0 <uvmunmap+0x88>
    8000069a:	fc26                	sd	s1,56(sp)
    8000069c:	f84a                	sd	s2,48(sp)
    8000069e:	f44e                	sd	s3,40(sp)
    800006a0:	f052                	sd	s4,32(sp)
    800006a2:	ec56                	sd	s5,24(sp)
    800006a4:	e85a                	sd	s6,16(sp)
    800006a6:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a8:	00007517          	auipc	a0,0x7
    800006ac:	a0850513          	addi	a0,a0,-1528 # 800070b0 <etext+0xb0>
    800006b0:	653040ef          	jal	80005502 <panic>
      panic("uvmunmap: walk");
    800006b4:	00007517          	auipc	a0,0x7
    800006b8:	a1450513          	addi	a0,a0,-1516 # 800070c8 <etext+0xc8>
    800006bc:	647040ef          	jal	80005502 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006c0:	85ca                	mv	a1,s2
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	a1650513          	addi	a0,a0,-1514 # 800070d8 <etext+0xd8>
    800006ca:	367040ef          	jal	80005230 <printf>
      panic("uvmunmap: not mapped");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a1a50513          	addi	a0,a0,-1510 # 800070e8 <etext+0xe8>
    800006d6:	62d040ef          	jal	80005502 <panic>
      panic("uvmunmap: not a leaf");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a2650513          	addi	a0,a0,-1498 # 80007100 <etext+0x100>
    800006e2:	621040ef          	jal	80005502 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006e6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006ea:	995a                	add	s2,s2,s6
    800006ec:	03397963          	bgeu	s2,s3,8000071e <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006f0:	4601                	li	a2,0
    800006f2:	85ca                	mv	a1,s2
    800006f4:	8552                	mv	a0,s4
    800006f6:	cf5ff0ef          	jal	800003ea <walk>
    800006fa:	84aa                	mv	s1,a0
    800006fc:	dd45                	beqz	a0,800006b4 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006fe:	6110                	ld	a2,0(a0)
    80000700:	00167793          	andi	a5,a2,1
    80000704:	dfd5                	beqz	a5,800006c0 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000706:	3ff67793          	andi	a5,a2,1023
    8000070a:	fd7788e3          	beq	a5,s7,800006da <uvmunmap+0x72>
    if(do_free){
    8000070e:	fc0a8ce3          	beqz	s5,800006e6 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    80000712:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    80000714:	00c61513          	slli	a0,a2,0xc
    80000718:	905ff0ef          	jal	8000001c <kfree>
    8000071c:	b7e9                	j	800006e6 <uvmunmap+0x7e>
    8000071e:	74e2                	ld	s1,56(sp)
    80000720:	7942                	ld	s2,48(sp)
    80000722:	79a2                	ld	s3,40(sp)
    80000724:	7a02                	ld	s4,32(sp)
    80000726:	6ae2                	ld	s5,24(sp)
    80000728:	6b42                	ld	s6,16(sp)
    8000072a:	6ba2                	ld	s7,8(sp)
  }
}
    8000072c:	60a6                	ld	ra,72(sp)
    8000072e:	6406                	ld	s0,64(sp)
    80000730:	6161                	addi	sp,sp,80
    80000732:	8082                	ret

0000000080000734 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000734:	1101                	addi	sp,sp,-32
    80000736:	ec06                	sd	ra,24(sp)
    80000738:	e822                	sd	s0,16(sp)
    8000073a:	e426                	sd	s1,8(sp)
    8000073c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000073e:	9b9ff0ef          	jal	800000f6 <kalloc>
    80000742:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000744:	c509                	beqz	a0,8000074e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000746:	6605                	lui	a2,0x1
    80000748:	4581                	li	a1,0
    8000074a:	a2dff0ef          	jal	80000176 <memset>
  return pagetable;
}
    8000074e:	8526                	mv	a0,s1
    80000750:	60e2                	ld	ra,24(sp)
    80000752:	6442                	ld	s0,16(sp)
    80000754:	64a2                	ld	s1,8(sp)
    80000756:	6105                	addi	sp,sp,32
    80000758:	8082                	ret

000000008000075a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000075a:	7179                	addi	sp,sp,-48
    8000075c:	f406                	sd	ra,40(sp)
    8000075e:	f022                	sd	s0,32(sp)
    80000760:	ec26                	sd	s1,24(sp)
    80000762:	e84a                	sd	s2,16(sp)
    80000764:	e44e                	sd	s3,8(sp)
    80000766:	e052                	sd	s4,0(sp)
    80000768:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000076a:	6785                	lui	a5,0x1
    8000076c:	04f67063          	bgeu	a2,a5,800007ac <uvmfirst+0x52>
    80000770:	8a2a                	mv	s4,a0
    80000772:	89ae                	mv	s3,a1
    80000774:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000776:	981ff0ef          	jal	800000f6 <kalloc>
    8000077a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000077c:	6605                	lui	a2,0x1
    8000077e:	4581                	li	a1,0
    80000780:	9f7ff0ef          	jal	80000176 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000784:	4779                	li	a4,30
    80000786:	86ca                	mv	a3,s2
    80000788:	6605                	lui	a2,0x1
    8000078a:	4581                	li	a1,0
    8000078c:	8552                	mv	a0,s4
    8000078e:	d35ff0ef          	jal	800004c2 <mappages>
  memmove(mem, src, sz);
    80000792:	8626                	mv	a2,s1
    80000794:	85ce                	mv	a1,s3
    80000796:	854a                	mv	a0,s2
    80000798:	a3bff0ef          	jal	800001d2 <memmove>
}
    8000079c:	70a2                	ld	ra,40(sp)
    8000079e:	7402                	ld	s0,32(sp)
    800007a0:	64e2                	ld	s1,24(sp)
    800007a2:	6942                	ld	s2,16(sp)
    800007a4:	69a2                	ld	s3,8(sp)
    800007a6:	6a02                	ld	s4,0(sp)
    800007a8:	6145                	addi	sp,sp,48
    800007aa:	8082                	ret
    panic("uvmfirst: more than a page");
    800007ac:	00007517          	auipc	a0,0x7
    800007b0:	96c50513          	addi	a0,a0,-1684 # 80007118 <etext+0x118>
    800007b4:	54f040ef          	jal	80005502 <panic>

00000000800007b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007b8:	1101                	addi	sp,sp,-32
    800007ba:	ec06                	sd	ra,24(sp)
    800007bc:	e822                	sd	s0,16(sp)
    800007be:	e426                	sd	s1,8(sp)
    800007c0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007c4:	00b67d63          	bgeu	a2,a1,800007de <uvmdealloc+0x26>
    800007c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007ca:	6785                	lui	a5,0x1
    800007cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ce:	00f60733          	add	a4,a2,a5
    800007d2:	76fd                	lui	a3,0xfffff
    800007d4:	8f75                	and	a4,a4,a3
    800007d6:	97ae                	add	a5,a5,a1
    800007d8:	8ff5                	and	a5,a5,a3
    800007da:	00f76863          	bltu	a4,a5,800007ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007de:	8526                	mv	a0,s1
    800007e0:	60e2                	ld	ra,24(sp)
    800007e2:	6442                	ld	s0,16(sp)
    800007e4:	64a2                	ld	s1,8(sp)
    800007e6:	6105                	addi	sp,sp,32
    800007e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007ea:	8f99                	sub	a5,a5,a4
    800007ec:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ee:	4685                	li	a3,1
    800007f0:	0007861b          	sext.w	a2,a5
    800007f4:	85ba                	mv	a1,a4
    800007f6:	e73ff0ef          	jal	80000668 <uvmunmap>
    800007fa:	b7d5                	j	800007de <uvmdealloc+0x26>

00000000800007fc <uvmalloc>:
  if(newsz < oldsz)
    800007fc:	08b66b63          	bltu	a2,a1,80000892 <uvmalloc+0x96>
{
    80000800:	7139                	addi	sp,sp,-64
    80000802:	fc06                	sd	ra,56(sp)
    80000804:	f822                	sd	s0,48(sp)
    80000806:	ec4e                	sd	s3,24(sp)
    80000808:	e852                	sd	s4,16(sp)
    8000080a:	e456                	sd	s5,8(sp)
    8000080c:	0080                	addi	s0,sp,64
    8000080e:	8aaa                	mv	s5,a0
    80000810:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000812:	6785                	lui	a5,0x1
    80000814:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000816:	95be                	add	a1,a1,a5
    80000818:	77fd                	lui	a5,0xfffff
    8000081a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    8000081e:	06c9fc63          	bgeu	s3,a2,80000896 <uvmalloc+0x9a>
    80000822:	f426                	sd	s1,40(sp)
    80000824:	f04a                	sd	s2,32(sp)
    80000826:	e05a                	sd	s6,0(sp)
    80000828:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000082a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000082e:	8c9ff0ef          	jal	800000f6 <kalloc>
    80000832:	84aa                	mv	s1,a0
    if(mem == 0){
    80000834:	c115                	beqz	a0,80000858 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000836:	875a                	mv	a4,s6
    80000838:	86aa                	mv	a3,a0
    8000083a:	6605                	lui	a2,0x1
    8000083c:	85ca                	mv	a1,s2
    8000083e:	8556                	mv	a0,s5
    80000840:	c83ff0ef          	jal	800004c2 <mappages>
    80000844:	e915                	bnez	a0,80000878 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000846:	6785                	lui	a5,0x1
    80000848:	993e                	add	s2,s2,a5
    8000084a:	ff4962e3          	bltu	s2,s4,8000082e <uvmalloc+0x32>
  return newsz;
    8000084e:	8552                	mv	a0,s4
    80000850:	74a2                	ld	s1,40(sp)
    80000852:	7902                	ld	s2,32(sp)
    80000854:	6b02                	ld	s6,0(sp)
    80000856:	a811                	j	8000086a <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000858:	864e                	mv	a2,s3
    8000085a:	85ca                	mv	a1,s2
    8000085c:	8556                	mv	a0,s5
    8000085e:	f5bff0ef          	jal	800007b8 <uvmdealloc>
      return 0;
    80000862:	4501                	li	a0,0
    80000864:	74a2                	ld	s1,40(sp)
    80000866:	7902                	ld	s2,32(sp)
    80000868:	6b02                	ld	s6,0(sp)
}
    8000086a:	70e2                	ld	ra,56(sp)
    8000086c:	7442                	ld	s0,48(sp)
    8000086e:	69e2                	ld	s3,24(sp)
    80000870:	6a42                	ld	s4,16(sp)
    80000872:	6aa2                	ld	s5,8(sp)
    80000874:	6121                	addi	sp,sp,64
    80000876:	8082                	ret
      kfree(mem);
    80000878:	8526                	mv	a0,s1
    8000087a:	fa2ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000087e:	864e                	mv	a2,s3
    80000880:	85ca                	mv	a1,s2
    80000882:	8556                	mv	a0,s5
    80000884:	f35ff0ef          	jal	800007b8 <uvmdealloc>
      return 0;
    80000888:	4501                	li	a0,0
    8000088a:	74a2                	ld	s1,40(sp)
    8000088c:	7902                	ld	s2,32(sp)
    8000088e:	6b02                	ld	s6,0(sp)
    80000890:	bfe9                	j	8000086a <uvmalloc+0x6e>
    return oldsz;
    80000892:	852e                	mv	a0,a1
}
    80000894:	8082                	ret
  return newsz;
    80000896:	8532                	mv	a0,a2
    80000898:	bfc9                	j	8000086a <uvmalloc+0x6e>

000000008000089a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000089a:	7179                	addi	sp,sp,-48
    8000089c:	f406                	sd	ra,40(sp)
    8000089e:	f022                	sd	s0,32(sp)
    800008a0:	ec26                	sd	s1,24(sp)
    800008a2:	e84a                	sd	s2,16(sp)
    800008a4:	e44e                	sd	s3,8(sp)
    800008a6:	e052                	sd	s4,0(sp)
    800008a8:	1800                	addi	s0,sp,48
    800008aa:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008ac:	84aa                	mv	s1,a0
    800008ae:	6905                	lui	s2,0x1
    800008b0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008b2:	4985                	li	s3,1
    800008b4:	a819                	j	800008ca <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008b6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008b8:	00c79513          	slli	a0,a5,0xc
    800008bc:	fdfff0ef          	jal	8000089a <freewalk>
      pagetable[i] = 0;
    800008c0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008c4:	04a1                	addi	s1,s1,8
    800008c6:	01248f63          	beq	s1,s2,800008e4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008ca:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008cc:	00f7f713          	andi	a4,a5,15
    800008d0:	ff3703e3          	beq	a4,s3,800008b6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008d4:	8b85                	andi	a5,a5,1
    800008d6:	d7fd                	beqz	a5,800008c4 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008d8:	00007517          	auipc	a0,0x7
    800008dc:	86050513          	addi	a0,a0,-1952 # 80007138 <etext+0x138>
    800008e0:	423040ef          	jal	80005502 <panic>
    }
  }
  kfree((void*)pagetable);
    800008e4:	8552                	mv	a0,s4
    800008e6:	f36ff0ef          	jal	8000001c <kfree>
}
    800008ea:	70a2                	ld	ra,40(sp)
    800008ec:	7402                	ld	s0,32(sp)
    800008ee:	64e2                	ld	s1,24(sp)
    800008f0:	6942                	ld	s2,16(sp)
    800008f2:	69a2                	ld	s3,8(sp)
    800008f4:	6a02                	ld	s4,0(sp)
    800008f6:	6145                	addi	sp,sp,48
    800008f8:	8082                	ret

00000000800008fa <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008fa:	1101                	addi	sp,sp,-32
    800008fc:	ec06                	sd	ra,24(sp)
    800008fe:	e822                	sd	s0,16(sp)
    80000900:	e426                	sd	s1,8(sp)
    80000902:	1000                	addi	s0,sp,32
    80000904:	84aa                	mv	s1,a0
  if(sz > 0)
    80000906:	e989                	bnez	a1,80000918 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000908:	8526                	mv	a0,s1
    8000090a:	f91ff0ef          	jal	8000089a <freewalk>
}
    8000090e:	60e2                	ld	ra,24(sp)
    80000910:	6442                	ld	s0,16(sp)
    80000912:	64a2                	ld	s1,8(sp)
    80000914:	6105                	addi	sp,sp,32
    80000916:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000918:	6785                	lui	a5,0x1
    8000091a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091c:	95be                	add	a1,a1,a5
    8000091e:	4685                	li	a3,1
    80000920:	00c5d613          	srli	a2,a1,0xc
    80000924:	4581                	li	a1,0
    80000926:	d43ff0ef          	jal	80000668 <uvmunmap>
    8000092a:	bff9                	j	80000908 <uvmfree+0xe>

000000008000092c <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    8000092c:	c65d                	beqz	a2,800009da <uvmcopy+0xae>
{
    8000092e:	715d                	addi	sp,sp,-80
    80000930:	e486                	sd	ra,72(sp)
    80000932:	e0a2                	sd	s0,64(sp)
    80000934:	fc26                	sd	s1,56(sp)
    80000936:	f84a                	sd	s2,48(sp)
    80000938:	f44e                	sd	s3,40(sp)
    8000093a:	f052                	sd	s4,32(sp)
    8000093c:	ec56                	sd	s5,24(sp)
    8000093e:	e85a                	sd	s6,16(sp)
    80000940:	e45e                	sd	s7,8(sp)
    80000942:	0880                	addi	s0,sp,80
    80000944:	8b2a                	mv	s6,a0
    80000946:	8aae                	mv	s5,a1
    80000948:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    8000094a:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000094c:	4601                	li	a2,0
    8000094e:	85ce                	mv	a1,s3
    80000950:	855a                	mv	a0,s6
    80000952:	a99ff0ef          	jal	800003ea <walk>
    80000956:	c121                	beqz	a0,80000996 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000958:	6118                	ld	a4,0(a0)
    8000095a:	00177793          	andi	a5,a4,1
    8000095e:	c3b1                	beqz	a5,800009a2 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000960:	00a75593          	srli	a1,a4,0xa
    80000964:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000968:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000096c:	f8aff0ef          	jal	800000f6 <kalloc>
    80000970:	892a                	mv	s2,a0
    80000972:	c129                	beqz	a0,800009b4 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000974:	6605                	lui	a2,0x1
    80000976:	85de                	mv	a1,s7
    80000978:	85bff0ef          	jal	800001d2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000097c:	8726                	mv	a4,s1
    8000097e:	86ca                	mv	a3,s2
    80000980:	6605                	lui	a2,0x1
    80000982:	85ce                	mv	a1,s3
    80000984:	8556                	mv	a0,s5
    80000986:	b3dff0ef          	jal	800004c2 <mappages>
    8000098a:	e115                	bnez	a0,800009ae <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000098c:	6785                	lui	a5,0x1
    8000098e:	99be                	add	s3,s3,a5
    80000990:	fb49eee3          	bltu	s3,s4,8000094c <uvmcopy+0x20>
    80000994:	a805                	j	800009c4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000996:	00006517          	auipc	a0,0x6
    8000099a:	7b250513          	addi	a0,a0,1970 # 80007148 <etext+0x148>
    8000099e:	365040ef          	jal	80005502 <panic>
      panic("uvmcopy: page not present");
    800009a2:	00006517          	auipc	a0,0x6
    800009a6:	7c650513          	addi	a0,a0,1990 # 80007168 <etext+0x168>
    800009aa:	359040ef          	jal	80005502 <panic>
      kfree(mem);
    800009ae:	854a                	mv	a0,s2
    800009b0:	e6cff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009b4:	4685                	li	a3,1
    800009b6:	00c9d613          	srli	a2,s3,0xc
    800009ba:	4581                	li	a1,0
    800009bc:	8556                	mv	a0,s5
    800009be:	cabff0ef          	jal	80000668 <uvmunmap>
  return -1;
    800009c2:	557d                	li	a0,-1
}
    800009c4:	60a6                	ld	ra,72(sp)
    800009c6:	6406                	ld	s0,64(sp)
    800009c8:	74e2                	ld	s1,56(sp)
    800009ca:	7942                	ld	s2,48(sp)
    800009cc:	79a2                	ld	s3,40(sp)
    800009ce:	7a02                	ld	s4,32(sp)
    800009d0:	6ae2                	ld	s5,24(sp)
    800009d2:	6b42                	ld	s6,16(sp)
    800009d4:	6ba2                	ld	s7,8(sp)
    800009d6:	6161                	addi	sp,sp,80
    800009d8:	8082                	ret
  return 0;
    800009da:	4501                	li	a0,0
}
    800009dc:	8082                	ret

00000000800009de <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009de:	1141                	addi	sp,sp,-16
    800009e0:	e406                	sd	ra,8(sp)
    800009e2:	e022                	sd	s0,0(sp)
    800009e4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e6:	4601                	li	a2,0
    800009e8:	a03ff0ef          	jal	800003ea <walk>
  if(pte == 0)
    800009ec:	c901                	beqz	a0,800009fc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ee:	611c                	ld	a5,0(a0)
    800009f0:	9bbd                	andi	a5,a5,-17
    800009f2:	e11c                	sd	a5,0(a0)
}
    800009f4:	60a2                	ld	ra,8(sp)
    800009f6:	6402                	ld	s0,0(sp)
    800009f8:	0141                	addi	sp,sp,16
    800009fa:	8082                	ret
    panic("uvmclear");
    800009fc:	00006517          	auipc	a0,0x6
    80000a00:	78c50513          	addi	a0,a0,1932 # 80007188 <etext+0x188>
    80000a04:	2ff040ef          	jal	80005502 <panic>

0000000080000a08 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a08:	cac1                	beqz	a3,80000a98 <copyout+0x90>
{
    80000a0a:	711d                	addi	sp,sp,-96
    80000a0c:	ec86                	sd	ra,88(sp)
    80000a0e:	e8a2                	sd	s0,80(sp)
    80000a10:	e4a6                	sd	s1,72(sp)
    80000a12:	fc4e                	sd	s3,56(sp)
    80000a14:	f852                	sd	s4,48(sp)
    80000a16:	f456                	sd	s5,40(sp)
    80000a18:	f05a                	sd	s6,32(sp)
    80000a1a:	1080                	addi	s0,sp,96
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8a2e                	mv	s4,a1
    80000a20:	8ab2                	mv	s5,a2
    80000a22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a24:	74fd                	lui	s1,0xfffff
    80000a26:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a28:	57fd                	li	a5,-1
    80000a2a:	83e9                	srli	a5,a5,0x1a
    80000a2c:	0697e863          	bltu	a5,s1,80000a9c <copyout+0x94>
    80000a30:	e0ca                	sd	s2,64(sp)
    80000a32:	ec5e                	sd	s7,24(sp)
    80000a34:	e862                	sd	s8,16(sp)
    80000a36:	e466                	sd	s9,8(sp)
    80000a38:	6c05                	lui	s8,0x1
    80000a3a:	8bbe                	mv	s7,a5
    80000a3c:	a015                	j	80000a60 <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3e:	409a04b3          	sub	s1,s4,s1
    80000a42:	0009061b          	sext.w	a2,s2
    80000a46:	85d6                	mv	a1,s5
    80000a48:	9526                	add	a0,a0,s1
    80000a4a:	f88ff0ef          	jal	800001d2 <memmove>

    len -= n;
    80000a4e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a52:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a54:	02098c63          	beqz	s3,80000a8c <copyout+0x84>
    if (va0 >= MAXVA)
    80000a58:	059be463          	bltu	s7,s9,80000aa0 <copyout+0x98>
    80000a5c:	84e6                	mv	s1,s9
    80000a5e:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a60:	4601                	li	a2,0
    80000a62:	85a6                	mv	a1,s1
    80000a64:	855a                	mv	a0,s6
    80000a66:	985ff0ef          	jal	800003ea <walk>
    80000a6a:	c129                	beqz	a0,80000aac <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a6c:	611c                	ld	a5,0(a0)
    80000a6e:	8b91                	andi	a5,a5,4
    80000a70:	cfa1                	beqz	a5,80000ac8 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a72:	85a6                	mv	a1,s1
    80000a74:	855a                	mv	a0,s6
    80000a76:	a0fff0ef          	jal	80000484 <walkaddr>
    if(pa0 == 0)
    80000a7a:	cd29                	beqz	a0,80000ad4 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a7c:	01848cb3          	add	s9,s1,s8
    80000a80:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a84:	fb29fde3          	bgeu	s3,s2,80000a3e <copyout+0x36>
    80000a88:	894e                	mv	s2,s3
    80000a8a:	bf55                	j	80000a3e <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a8c:	4501                	li	a0,0
    80000a8e:	6906                	ld	s2,64(sp)
    80000a90:	6be2                	ld	s7,24(sp)
    80000a92:	6c42                	ld	s8,16(sp)
    80000a94:	6ca2                	ld	s9,8(sp)
    80000a96:	a005                	j	80000ab6 <copyout+0xae>
    80000a98:	4501                	li	a0,0
}
    80000a9a:	8082                	ret
      return -1;
    80000a9c:	557d                	li	a0,-1
    80000a9e:	a821                	j	80000ab6 <copyout+0xae>
    80000aa0:	557d                	li	a0,-1
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	6be2                	ld	s7,24(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	a031                	j	80000ab6 <copyout+0xae>
      return -1;
    80000aac:	557d                	li	a0,-1
    80000aae:	6906                	ld	s2,64(sp)
    80000ab0:	6be2                	ld	s7,24(sp)
    80000ab2:	6c42                	ld	s8,16(sp)
    80000ab4:	6ca2                	ld	s9,8(sp)
}
    80000ab6:	60e6                	ld	ra,88(sp)
    80000ab8:	6446                	ld	s0,80(sp)
    80000aba:	64a6                	ld	s1,72(sp)
    80000abc:	79e2                	ld	s3,56(sp)
    80000abe:	7a42                	ld	s4,48(sp)
    80000ac0:	7aa2                	ld	s5,40(sp)
    80000ac2:	7b02                	ld	s6,32(sp)
    80000ac4:	6125                	addi	sp,sp,96
    80000ac6:	8082                	ret
      return -1;
    80000ac8:	557d                	li	a0,-1
    80000aca:	6906                	ld	s2,64(sp)
    80000acc:	6be2                	ld	s7,24(sp)
    80000ace:	6c42                	ld	s8,16(sp)
    80000ad0:	6ca2                	ld	s9,8(sp)
    80000ad2:	b7d5                	j	80000ab6 <copyout+0xae>
      return -1;
    80000ad4:	557d                	li	a0,-1
    80000ad6:	6906                	ld	s2,64(sp)
    80000ad8:	6be2                	ld	s7,24(sp)
    80000ada:	6c42                	ld	s8,16(sp)
    80000adc:	6ca2                	ld	s9,8(sp)
    80000ade:	bfe1                	j	80000ab6 <copyout+0xae>

0000000080000ae0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ae0:	c6a5                	beqz	a3,80000b48 <copyin+0x68>
{
    80000ae2:	715d                	addi	sp,sp,-80
    80000ae4:	e486                	sd	ra,72(sp)
    80000ae6:	e0a2                	sd	s0,64(sp)
    80000ae8:	fc26                	sd	s1,56(sp)
    80000aea:	f84a                	sd	s2,48(sp)
    80000aec:	f44e                	sd	s3,40(sp)
    80000aee:	f052                	sd	s4,32(sp)
    80000af0:	ec56                	sd	s5,24(sp)
    80000af2:	e85a                	sd	s6,16(sp)
    80000af4:	e45e                	sd	s7,8(sp)
    80000af6:	e062                	sd	s8,0(sp)
    80000af8:	0880                	addi	s0,sp,80
    80000afa:	8b2a                	mv	s6,a0
    80000afc:	8a2e                	mv	s4,a1
    80000afe:	8c32                	mv	s8,a2
    80000b00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b04:	6a85                	lui	s5,0x1
    80000b06:	a00d                	j	80000b28 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b08:	018505b3          	add	a1,a0,s8
    80000b0c:	0004861b          	sext.w	a2,s1
    80000b10:	412585b3          	sub	a1,a1,s2
    80000b14:	8552                	mv	a0,s4
    80000b16:	ebcff0ef          	jal	800001d2 <memmove>

    len -= n;
    80000b1a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b1e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b20:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b24:	02098063          	beqz	s3,80000b44 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b28:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b2c:	85ca                	mv	a1,s2
    80000b2e:	855a                	mv	a0,s6
    80000b30:	955ff0ef          	jal	80000484 <walkaddr>
    if(pa0 == 0)
    80000b34:	cd01                	beqz	a0,80000b4c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b36:	418904b3          	sub	s1,s2,s8
    80000b3a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b3c:	fc99f6e3          	bgeu	s3,s1,80000b08 <copyin+0x28>
    80000b40:	84ce                	mv	s1,s3
    80000b42:	b7d9                	j	80000b08 <copyin+0x28>
  }
  return 0;
    80000b44:	4501                	li	a0,0
    80000b46:	a021                	j	80000b4e <copyin+0x6e>
    80000b48:	4501                	li	a0,0
}
    80000b4a:	8082                	ret
      return -1;
    80000b4c:	557d                	li	a0,-1
}
    80000b4e:	60a6                	ld	ra,72(sp)
    80000b50:	6406                	ld	s0,64(sp)
    80000b52:	74e2                	ld	s1,56(sp)
    80000b54:	7942                	ld	s2,48(sp)
    80000b56:	79a2                	ld	s3,40(sp)
    80000b58:	7a02                	ld	s4,32(sp)
    80000b5a:	6ae2                	ld	s5,24(sp)
    80000b5c:	6b42                	ld	s6,16(sp)
    80000b5e:	6ba2                	ld	s7,8(sp)
    80000b60:	6c02                	ld	s8,0(sp)
    80000b62:	6161                	addi	sp,sp,80
    80000b64:	8082                	ret

0000000080000b66 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b66:	c6dd                	beqz	a3,80000c14 <copyinstr+0xae>
{
    80000b68:	715d                	addi	sp,sp,-80
    80000b6a:	e486                	sd	ra,72(sp)
    80000b6c:	e0a2                	sd	s0,64(sp)
    80000b6e:	fc26                	sd	s1,56(sp)
    80000b70:	f84a                	sd	s2,48(sp)
    80000b72:	f44e                	sd	s3,40(sp)
    80000b74:	f052                	sd	s4,32(sp)
    80000b76:	ec56                	sd	s5,24(sp)
    80000b78:	e85a                	sd	s6,16(sp)
    80000b7a:	e45e                	sd	s7,8(sp)
    80000b7c:	0880                	addi	s0,sp,80
    80000b7e:	8a2a                	mv	s4,a0
    80000b80:	8b2e                	mv	s6,a1
    80000b82:	8bb2                	mv	s7,a2
    80000b84:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b86:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b88:	6985                	lui	s3,0x1
    80000b8a:	a825                	j	80000bc2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b8c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b90:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b92:	37fd                	addiw	a5,a5,-1
    80000b94:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b98:	60a6                	ld	ra,72(sp)
    80000b9a:	6406                	ld	s0,64(sp)
    80000b9c:	74e2                	ld	s1,56(sp)
    80000b9e:	7942                	ld	s2,48(sp)
    80000ba0:	79a2                	ld	s3,40(sp)
    80000ba2:	7a02                	ld	s4,32(sp)
    80000ba4:	6ae2                	ld	s5,24(sp)
    80000ba6:	6b42                	ld	s6,16(sp)
    80000ba8:	6ba2                	ld	s7,8(sp)
    80000baa:	6161                	addi	sp,sp,80
    80000bac:	8082                	ret
    80000bae:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bb2:	9742                	add	a4,a4,a6
      --max;
    80000bb4:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bb8:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bbc:	04e58463          	beq	a1,a4,80000c04 <copyinstr+0x9e>
{
    80000bc0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bc6:	85a6                	mv	a1,s1
    80000bc8:	8552                	mv	a0,s4
    80000bca:	8bbff0ef          	jal	80000484 <walkaddr>
    if(pa0 == 0)
    80000bce:	cd0d                	beqz	a0,80000c08 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000bd0:	417486b3          	sub	a3,s1,s7
    80000bd4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000bd6:	00d97363          	bgeu	s2,a3,80000bdc <copyinstr+0x76>
    80000bda:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bdc:	955e                	add	a0,a0,s7
    80000bde:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000be0:	c695                	beqz	a3,80000c0c <copyinstr+0xa6>
    80000be2:	87da                	mv	a5,s6
    80000be4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000be6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bea:	96da                	add	a3,a3,s6
    80000bec:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bee:	00f60733          	add	a4,a2,a5
    80000bf2:	00074703          	lbu	a4,0(a4)
    80000bf6:	db59                	beqz	a4,80000b8c <copyinstr+0x26>
        *dst = *p;
    80000bf8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bfc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bfe:	fed797e3          	bne	a5,a3,80000bec <copyinstr+0x86>
    80000c02:	b775                	j	80000bae <copyinstr+0x48>
    80000c04:	4781                	li	a5,0
    80000c06:	b771                	j	80000b92 <copyinstr+0x2c>
      return -1;
    80000c08:	557d                	li	a0,-1
    80000c0a:	b779                	j	80000b98 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c0c:	6b85                	lui	s7,0x1
    80000c0e:	9ba6                	add	s7,s7,s1
    80000c10:	87da                	mv	a5,s6
    80000c12:	b77d                	j	80000bc0 <copyinstr+0x5a>
  int got_null = 0;
    80000c14:	4781                	li	a5,0
  if(got_null){
    80000c16:	37fd                	addiw	a5,a5,-1
    80000c18:	0007851b          	sext.w	a0,a5
}
    80000c1c:	8082                	ret

0000000080000c1e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c1e:	7139                	addi	sp,sp,-64
    80000c20:	fc06                	sd	ra,56(sp)
    80000c22:	f822                	sd	s0,48(sp)
    80000c24:	f426                	sd	s1,40(sp)
    80000c26:	f04a                	sd	s2,32(sp)
    80000c28:	ec4e                	sd	s3,24(sp)
    80000c2a:	e852                	sd	s4,16(sp)
    80000c2c:	e456                	sd	s5,8(sp)
    80000c2e:	e05a                	sd	s6,0(sp)
    80000c30:	0080                	addi	s0,sp,64
    80000c32:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c34:	0000a497          	auipc	s1,0xa
    80000c38:	c5c48493          	addi	s1,s1,-932 # 8000a890 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c3c:	8b26                	mv	s6,s1
    80000c3e:	ff4df937          	lui	s2,0xff4df
    80000c42:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb04d>
    80000c46:	0936                	slli	s2,s2,0xd
    80000c48:	6f590913          	addi	s2,s2,1781
    80000c4c:	0936                	slli	s2,s2,0xd
    80000c4e:	bd390913          	addi	s2,s2,-1069
    80000c52:	0932                	slli	s2,s2,0xc
    80000c54:	7a790913          	addi	s2,s2,1959
    80000c58:	040009b7          	lui	s3,0x4000
    80000c5c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c5e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c60:	00010a97          	auipc	s5,0x10
    80000c64:	830a8a93          	addi	s5,s5,-2000 # 80010490 <tickslock>
    char *pa = kalloc();
    80000c68:	c8eff0ef          	jal	800000f6 <kalloc>
    80000c6c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c6e:	cd15                	beqz	a0,80000caa <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c70:	416485b3          	sub	a1,s1,s6
    80000c74:	8591                	srai	a1,a1,0x4
    80000c76:	032585b3          	mul	a1,a1,s2
    80000c7a:	2585                	addiw	a1,a1,1
    80000c7c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c80:	4719                	li	a4,6
    80000c82:	6685                	lui	a3,0x1
    80000c84:	40b985b3          	sub	a1,s3,a1
    80000c88:	8552                	mv	a0,s4
    80000c8a:	8e9ff0ef          	jal	80000572 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c8e:	17048493          	addi	s1,s1,368
    80000c92:	fd549be3          	bne	s1,s5,80000c68 <proc_mapstacks+0x4a>
  }
}
    80000c96:	70e2                	ld	ra,56(sp)
    80000c98:	7442                	ld	s0,48(sp)
    80000c9a:	74a2                	ld	s1,40(sp)
    80000c9c:	7902                	ld	s2,32(sp)
    80000c9e:	69e2                	ld	s3,24(sp)
    80000ca0:	6a42                	ld	s4,16(sp)
    80000ca2:	6aa2                	ld	s5,8(sp)
    80000ca4:	6b02                	ld	s6,0(sp)
    80000ca6:	6121                	addi	sp,sp,64
    80000ca8:	8082                	ret
      panic("kalloc");
    80000caa:	00006517          	auipc	a0,0x6
    80000cae:	4ee50513          	addi	a0,a0,1262 # 80007198 <etext+0x198>
    80000cb2:	051040ef          	jal	80005502 <panic>

0000000080000cb6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cb6:	7139                	addi	sp,sp,-64
    80000cb8:	fc06                	sd	ra,56(sp)
    80000cba:	f822                	sd	s0,48(sp)
    80000cbc:	f426                	sd	s1,40(sp)
    80000cbe:	f04a                	sd	s2,32(sp)
    80000cc0:	ec4e                	sd	s3,24(sp)
    80000cc2:	e852                	sd	s4,16(sp)
    80000cc4:	e456                	sd	s5,8(sp)
    80000cc6:	e05a                	sd	s6,0(sp)
    80000cc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cca:	00006597          	auipc	a1,0x6
    80000cce:	4d658593          	addi	a1,a1,1238 # 800071a0 <etext+0x1a0>
    80000cd2:	00009517          	auipc	a0,0x9
    80000cd6:	78e50513          	addi	a0,a0,1934 # 8000a460 <pid_lock>
    80000cda:	2d7040ef          	jal	800057b0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cde:	00006597          	auipc	a1,0x6
    80000ce2:	4ca58593          	addi	a1,a1,1226 # 800071a8 <etext+0x1a8>
    80000ce6:	00009517          	auipc	a0,0x9
    80000cea:	79250513          	addi	a0,a0,1938 # 8000a478 <wait_lock>
    80000cee:	2c3040ef          	jal	800057b0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	0000a497          	auipc	s1,0xa
    80000cf6:	b9e48493          	addi	s1,s1,-1122 # 8000a890 <proc>
      initlock(&p->lock, "proc");
    80000cfa:	00006b17          	auipc	s6,0x6
    80000cfe:	4beb0b13          	addi	s6,s6,1214 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d02:	8aa6                	mv	s5,s1
    80000d04:	ff4df937          	lui	s2,0xff4df
    80000d08:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb04d>
    80000d0c:	0936                	slli	s2,s2,0xd
    80000d0e:	6f590913          	addi	s2,s2,1781
    80000d12:	0936                	slli	s2,s2,0xd
    80000d14:	bd390913          	addi	s2,s2,-1069
    80000d18:	0932                	slli	s2,s2,0xc
    80000d1a:	7a790913          	addi	s2,s2,1959
    80000d1e:	040009b7          	lui	s3,0x4000
    80000d22:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d24:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	0000fa17          	auipc	s4,0xf
    80000d2a:	76aa0a13          	addi	s4,s4,1898 # 80010490 <tickslock>
      initlock(&p->lock, "proc");
    80000d2e:	85da                	mv	a1,s6
    80000d30:	8526                	mv	a0,s1
    80000d32:	27f040ef          	jal	800057b0 <initlock>
      p->state = UNUSED;
    80000d36:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d3a:	415487b3          	sub	a5,s1,s5
    80000d3e:	8791                	srai	a5,a5,0x4
    80000d40:	032787b3          	mul	a5,a5,s2
    80000d44:	2785                	addiw	a5,a5,1
    80000d46:	00d7979b          	slliw	a5,a5,0xd
    80000d4a:	40f987b3          	sub	a5,s3,a5
    80000d4e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	17048493          	addi	s1,s1,368
    80000d54:	fd449de3          	bne	s1,s4,80000d2e <procinit+0x78>
  }
}
    80000d58:	70e2                	ld	ra,56(sp)
    80000d5a:	7442                	ld	s0,48(sp)
    80000d5c:	74a2                	ld	s1,40(sp)
    80000d5e:	7902                	ld	s2,32(sp)
    80000d60:	69e2                	ld	s3,24(sp)
    80000d62:	6a42                	ld	s4,16(sp)
    80000d64:	6aa2                	ld	s5,8(sp)
    80000d66:	6b02                	ld	s6,0(sp)
    80000d68:	6121                	addi	sp,sp,64
    80000d6a:	8082                	ret

0000000080000d6c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e422                	sd	s0,8(sp)
    80000d70:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d72:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d74:	2501                	sext.w	a0,a0
    80000d76:	6422                	ld	s0,8(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	addi	s0,sp,16
    80000d82:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d84:	2781                	sext.w	a5,a5
    80000d86:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d88:	00009517          	auipc	a0,0x9
    80000d8c:	70850513          	addi	a0,a0,1800 # 8000a490 <cpus>
    80000d90:	953e                	add	a0,a0,a5
    80000d92:	6422                	ld	s0,8(sp)
    80000d94:	0141                	addi	sp,sp,16
    80000d96:	8082                	ret

0000000080000d98 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d98:	1101                	addi	sp,sp,-32
    80000d9a:	ec06                	sd	ra,24(sp)
    80000d9c:	e822                	sd	s0,16(sp)
    80000d9e:	e426                	sd	s1,8(sp)
    80000da0:	1000                	addi	s0,sp,32
  push_off();
    80000da2:	24f040ef          	jal	800057f0 <push_off>
    80000da6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000da8:	2781                	sext.w	a5,a5
    80000daa:	079e                	slli	a5,a5,0x7
    80000dac:	00009717          	auipc	a4,0x9
    80000db0:	6b470713          	addi	a4,a4,1716 # 8000a460 <pid_lock>
    80000db4:	97ba                	add	a5,a5,a4
    80000db6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000db8:	2bd040ef          	jal	80005874 <pop_off>
  return p;
}
    80000dbc:	8526                	mv	a0,s1
    80000dbe:	60e2                	ld	ra,24(sp)
    80000dc0:	6442                	ld	s0,16(sp)
    80000dc2:	64a2                	ld	s1,8(sp)
    80000dc4:	6105                	addi	sp,sp,32
    80000dc6:	8082                	ret

0000000080000dc8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dc8:	1141                	addi	sp,sp,-16
    80000dca:	e406                	sd	ra,8(sp)
    80000dcc:	e022                	sd	s0,0(sp)
    80000dce:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000dd0:	fc9ff0ef          	jal	80000d98 <myproc>
    80000dd4:	2f5040ef          	jal	800058c8 <release>

  if (first) {
    80000dd8:	00009797          	auipc	a5,0x9
    80000ddc:	5087a783          	lw	a5,1288(a5) # 8000a2e0 <first.1>
    80000de0:	e799                	bnez	a5,80000dee <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000de2:	2fb000ef          	jal	800018dc <usertrapret>
}
    80000de6:	60a2                	ld	ra,8(sp)
    80000de8:	6402                	ld	s0,0(sp)
    80000dea:	0141                	addi	sp,sp,16
    80000dec:	8082                	ret
    fsinit(ROOTDEV);
    80000dee:	4505                	li	a0,1
    80000df0:	730010ef          	jal	80002520 <fsinit>
    first = 0;
    80000df4:	00009797          	auipc	a5,0x9
    80000df8:	4e07a623          	sw	zero,1260(a5) # 8000a2e0 <first.1>
    __sync_synchronize();
    80000dfc:	0330000f          	fence	rw,rw
    80000e00:	b7cd                	j	80000de2 <forkret+0x1a>

0000000080000e02 <allocpid>:
{
    80000e02:	1101                	addi	sp,sp,-32
    80000e04:	ec06                	sd	ra,24(sp)
    80000e06:	e822                	sd	s0,16(sp)
    80000e08:	e426                	sd	s1,8(sp)
    80000e0a:	e04a                	sd	s2,0(sp)
    80000e0c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e0e:	00009917          	auipc	s2,0x9
    80000e12:	65290913          	addi	s2,s2,1618 # 8000a460 <pid_lock>
    80000e16:	854a                	mv	a0,s2
    80000e18:	219040ef          	jal	80005830 <acquire>
  pid = nextpid;
    80000e1c:	00009797          	auipc	a5,0x9
    80000e20:	4c878793          	addi	a5,a5,1224 # 8000a2e4 <nextpid>
    80000e24:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e26:	0014871b          	addiw	a4,s1,1
    80000e2a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e2c:	854a                	mv	a0,s2
    80000e2e:	29b040ef          	jal	800058c8 <release>
}
    80000e32:	8526                	mv	a0,s1
    80000e34:	60e2                	ld	ra,24(sp)
    80000e36:	6442                	ld	s0,16(sp)
    80000e38:	64a2                	ld	s1,8(sp)
    80000e3a:	6902                	ld	s2,0(sp)
    80000e3c:	6105                	addi	sp,sp,32
    80000e3e:	8082                	ret

0000000080000e40 <proc_pagetable>:
{
    80000e40:	1101                	addi	sp,sp,-32
    80000e42:	ec06                	sd	ra,24(sp)
    80000e44:	e822                	sd	s0,16(sp)
    80000e46:	e426                	sd	s1,8(sp)
    80000e48:	e04a                	sd	s2,0(sp)
    80000e4a:	1000                	addi	s0,sp,32
    80000e4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e4e:	8e7ff0ef          	jal	80000734 <uvmcreate>
    80000e52:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e54:	cd05                	beqz	a0,80000e8c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e56:	4729                	li	a4,10
    80000e58:	00005697          	auipc	a3,0x5
    80000e5c:	1a868693          	addi	a3,a3,424 # 80006000 <_trampoline>
    80000e60:	6605                	lui	a2,0x1
    80000e62:	040005b7          	lui	a1,0x4000
    80000e66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e68:	05b2                	slli	a1,a1,0xc
    80000e6a:	e58ff0ef          	jal	800004c2 <mappages>
    80000e6e:	02054663          	bltz	a0,80000e9a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e72:	4719                	li	a4,6
    80000e74:	05893683          	ld	a3,88(s2)
    80000e78:	6605                	lui	a2,0x1
    80000e7a:	020005b7          	lui	a1,0x2000
    80000e7e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e80:	05b6                	slli	a1,a1,0xd
    80000e82:	8526                	mv	a0,s1
    80000e84:	e3eff0ef          	jal	800004c2 <mappages>
    80000e88:	00054f63          	bltz	a0,80000ea6 <proc_pagetable+0x66>
}
    80000e8c:	8526                	mv	a0,s1
    80000e8e:	60e2                	ld	ra,24(sp)
    80000e90:	6442                	ld	s0,16(sp)
    80000e92:	64a2                	ld	s1,8(sp)
    80000e94:	6902                	ld	s2,0(sp)
    80000e96:	6105                	addi	sp,sp,32
    80000e98:	8082                	ret
    uvmfree(pagetable, 0);
    80000e9a:	4581                	li	a1,0
    80000e9c:	8526                	mv	a0,s1
    80000e9e:	a5dff0ef          	jal	800008fa <uvmfree>
    return 0;
    80000ea2:	4481                	li	s1,0
    80000ea4:	b7e5                	j	80000e8c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ea6:	4681                	li	a3,0
    80000ea8:	4605                	li	a2,1
    80000eaa:	040005b7          	lui	a1,0x4000
    80000eae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eb0:	05b2                	slli	a1,a1,0xc
    80000eb2:	8526                	mv	a0,s1
    80000eb4:	fb4ff0ef          	jal	80000668 <uvmunmap>
    uvmfree(pagetable, 0);
    80000eb8:	4581                	li	a1,0
    80000eba:	8526                	mv	a0,s1
    80000ebc:	a3fff0ef          	jal	800008fa <uvmfree>
    return 0;
    80000ec0:	4481                	li	s1,0
    80000ec2:	b7e9                	j	80000e8c <proc_pagetable+0x4c>

0000000080000ec4 <proc_freepagetable>:
{
    80000ec4:	1101                	addi	sp,sp,-32
    80000ec6:	ec06                	sd	ra,24(sp)
    80000ec8:	e822                	sd	s0,16(sp)
    80000eca:	e426                	sd	s1,8(sp)
    80000ecc:	e04a                	sd	s2,0(sp)
    80000ece:	1000                	addi	s0,sp,32
    80000ed0:	84aa                	mv	s1,a0
    80000ed2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ed4:	4681                	li	a3,0
    80000ed6:	4605                	li	a2,1
    80000ed8:	040005b7          	lui	a1,0x4000
    80000edc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ede:	05b2                	slli	a1,a1,0xc
    80000ee0:	f88ff0ef          	jal	80000668 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ee4:	4681                	li	a3,0
    80000ee6:	4605                	li	a2,1
    80000ee8:	020005b7          	lui	a1,0x2000
    80000eec:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eee:	05b6                	slli	a1,a1,0xd
    80000ef0:	8526                	mv	a0,s1
    80000ef2:	f76ff0ef          	jal	80000668 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ef6:	85ca                	mv	a1,s2
    80000ef8:	8526                	mv	a0,s1
    80000efa:	a01ff0ef          	jal	800008fa <uvmfree>
}
    80000efe:	60e2                	ld	ra,24(sp)
    80000f00:	6442                	ld	s0,16(sp)
    80000f02:	64a2                	ld	s1,8(sp)
    80000f04:	6902                	ld	s2,0(sp)
    80000f06:	6105                	addi	sp,sp,32
    80000f08:	8082                	ret

0000000080000f0a <freeproc>:
{
    80000f0a:	1101                	addi	sp,sp,-32
    80000f0c:	ec06                	sd	ra,24(sp)
    80000f0e:	e822                	sd	s0,16(sp)
    80000f10:	e426                	sd	s1,8(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f16:	6d28                	ld	a0,88(a0)
    80000f18:	c119                	beqz	a0,80000f1e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f1a:	902ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f1e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f22:	68a8                	ld	a0,80(s1)
    80000f24:	c501                	beqz	a0,80000f2c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f26:	64ac                	ld	a1,72(s1)
    80000f28:	f9dff0ef          	jal	80000ec4 <proc_freepagetable>
  p->pagetable = 0;
    80000f2c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f30:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f34:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f38:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f3c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f40:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f44:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f48:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f4c:	0004ac23          	sw	zero,24(s1)
}
    80000f50:	60e2                	ld	ra,24(sp)
    80000f52:	6442                	ld	s0,16(sp)
    80000f54:	64a2                	ld	s1,8(sp)
    80000f56:	6105                	addi	sp,sp,32
    80000f58:	8082                	ret

0000000080000f5a <allocproc>:
{
    80000f5a:	1101                	addi	sp,sp,-32
    80000f5c:	ec06                	sd	ra,24(sp)
    80000f5e:	e822                	sd	s0,16(sp)
    80000f60:	e426                	sd	s1,8(sp)
    80000f62:	e04a                	sd	s2,0(sp)
    80000f64:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f66:	0000a497          	auipc	s1,0xa
    80000f6a:	92a48493          	addi	s1,s1,-1750 # 8000a890 <proc>
    80000f6e:	0000f917          	auipc	s2,0xf
    80000f72:	52290913          	addi	s2,s2,1314 # 80010490 <tickslock>
    acquire(&p->lock);
    80000f76:	8526                	mv	a0,s1
    80000f78:	0b9040ef          	jal	80005830 <acquire>
    if(p->state == UNUSED) {
    80000f7c:	4c9c                	lw	a5,24(s1)
    80000f7e:	cb91                	beqz	a5,80000f92 <allocproc+0x38>
      release(&p->lock);
    80000f80:	8526                	mv	a0,s1
    80000f82:	147040ef          	jal	800058c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f86:	17048493          	addi	s1,s1,368
    80000f8a:	ff2496e3          	bne	s1,s2,80000f76 <allocproc+0x1c>
  return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	a099                	j	80000fd6 <allocproc+0x7c>
  p->pid = allocpid();
    80000f92:	e71ff0ef          	jal	80000e02 <allocpid>
    80000f96:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f98:	4785                	li	a5,1
    80000f9a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f9c:	95aff0ef          	jal	800000f6 <kalloc>
    80000fa0:	892a                	mv	s2,a0
    80000fa2:	eca8                	sd	a0,88(s1)
    80000fa4:	c121                	beqz	a0,80000fe4 <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	e99ff0ef          	jal	80000e40 <proc_pagetable>
    80000fac:	892a                	mv	s2,a0
    80000fae:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fb0:	c131                	beqz	a0,80000ff4 <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80000fb2:	07000613          	li	a2,112
    80000fb6:	4581                	li	a1,0
    80000fb8:	06048513          	addi	a0,s1,96
    80000fbc:	9baff0ef          	jal	80000176 <memset>
  p->context.ra = (uint64)forkret;
    80000fc0:	00000797          	auipc	a5,0x0
    80000fc4:	e0878793          	addi	a5,a5,-504 # 80000dc8 <forkret>
    80000fc8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fca:	60bc                	ld	a5,64(s1)
    80000fcc:	6705                	lui	a4,0x1
    80000fce:	97ba                	add	a5,a5,a4
    80000fd0:	f4bc                	sd	a5,104(s1)
  p->trace_mask = 0;
    80000fd2:	1604a423          	sw	zero,360(s1)
}
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	60e2                	ld	ra,24(sp)
    80000fda:	6442                	ld	s0,16(sp)
    80000fdc:	64a2                	ld	s1,8(sp)
    80000fde:	6902                	ld	s2,0(sp)
    80000fe0:	6105                	addi	sp,sp,32
    80000fe2:	8082                	ret
    freeproc(p);
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	f25ff0ef          	jal	80000f0a <freeproc>
    release(&p->lock);
    80000fea:	8526                	mv	a0,s1
    80000fec:	0dd040ef          	jal	800058c8 <release>
    return 0;
    80000ff0:	84ca                	mv	s1,s2
    80000ff2:	b7d5                	j	80000fd6 <allocproc+0x7c>
    freeproc(p);
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	f15ff0ef          	jal	80000f0a <freeproc>
    release(&p->lock);
    80000ffa:	8526                	mv	a0,s1
    80000ffc:	0cd040ef          	jal	800058c8 <release>
    return 0;
    80001000:	84ca                	mv	s1,s2
    80001002:	bfd1                	j	80000fd6 <allocproc+0x7c>

0000000080001004 <userinit>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000100e:	f4dff0ef          	jal	80000f5a <allocproc>
    80001012:	84aa                	mv	s1,a0
  initproc = p;
    80001014:	00009797          	auipc	a5,0x9
    80001018:	40a7b623          	sd	a0,1036(a5) # 8000a420 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000101c:	03400613          	li	a2,52
    80001020:	00009597          	auipc	a1,0x9
    80001024:	2d058593          	addi	a1,a1,720 # 8000a2f0 <initcode>
    80001028:	6928                	ld	a0,80(a0)
    8000102a:	f30ff0ef          	jal	8000075a <uvmfirst>
  p->sz = PGSIZE;
    8000102e:	6785                	lui	a5,0x1
    80001030:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001032:	6cb8                	ld	a4,88(s1)
    80001034:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001038:	6cb8                	ld	a4,88(s1)
    8000103a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000103c:	4641                	li	a2,16
    8000103e:	00006597          	auipc	a1,0x6
    80001042:	18258593          	addi	a1,a1,386 # 800071c0 <etext+0x1c0>
    80001046:	15848513          	addi	a0,s1,344
    8000104a:	a6aff0ef          	jal	800002b4 <safestrcpy>
  p->cwd = namei("/");
    8000104e:	00006517          	auipc	a0,0x6
    80001052:	18250513          	addi	a0,a0,386 # 800071d0 <etext+0x1d0>
    80001056:	5d9010ef          	jal	80002e2e <namei>
    8000105a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000105e:	478d                	li	a5,3
    80001060:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001062:	8526                	mv	a0,s1
    80001064:	065040ef          	jal	800058c8 <release>
}
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6105                	addi	sp,sp,32
    80001070:	8082                	ret

0000000080001072 <growproc>:
{
    80001072:	1101                	addi	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	e04a                	sd	s2,0(sp)
    8000107c:	1000                	addi	s0,sp,32
    8000107e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001080:	d19ff0ef          	jal	80000d98 <myproc>
    80001084:	84aa                	mv	s1,a0
  sz = p->sz;
    80001086:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001088:	01204c63          	bgtz	s2,800010a0 <growproc+0x2e>
  } else if(n < 0){
    8000108c:	02094463          	bltz	s2,800010b4 <growproc+0x42>
  p->sz = sz;
    80001090:	e4ac                	sd	a1,72(s1)
  return 0;
    80001092:	4501                	li	a0,0
}
    80001094:	60e2                	ld	ra,24(sp)
    80001096:	6442                	ld	s0,16(sp)
    80001098:	64a2                	ld	s1,8(sp)
    8000109a:	6902                	ld	s2,0(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010a0:	4691                	li	a3,4
    800010a2:	00b90633          	add	a2,s2,a1
    800010a6:	6928                	ld	a0,80(a0)
    800010a8:	f54ff0ef          	jal	800007fc <uvmalloc>
    800010ac:	85aa                	mv	a1,a0
    800010ae:	f16d                	bnez	a0,80001090 <growproc+0x1e>
      return -1;
    800010b0:	557d                	li	a0,-1
    800010b2:	b7cd                	j	80001094 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010b4:	00b90633          	add	a2,s2,a1
    800010b8:	6928                	ld	a0,80(a0)
    800010ba:	efeff0ef          	jal	800007b8 <uvmdealloc>
    800010be:	85aa                	mv	a1,a0
    800010c0:	bfc1                	j	80001090 <growproc+0x1e>

00000000800010c2 <fork>:
{
    800010c2:	7139                	addi	sp,sp,-64
    800010c4:	fc06                	sd	ra,56(sp)
    800010c6:	f822                	sd	s0,48(sp)
    800010c8:	f04a                	sd	s2,32(sp)
    800010ca:	e456                	sd	s5,8(sp)
    800010cc:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010ce:	ccbff0ef          	jal	80000d98 <myproc>
    800010d2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010d4:	e87ff0ef          	jal	80000f5a <allocproc>
    800010d8:	0e050e63          	beqz	a0,800011d4 <fork+0x112>
    800010dc:	ec4e                	sd	s3,24(sp)
    800010de:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010e0:	048ab603          	ld	a2,72(s5)
    800010e4:	692c                	ld	a1,80(a0)
    800010e6:	050ab503          	ld	a0,80(s5)
    800010ea:	843ff0ef          	jal	8000092c <uvmcopy>
    800010ee:	04054e63          	bltz	a0,8000114a <fork+0x88>
    800010f2:	f426                	sd	s1,40(sp)
    800010f4:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800010f6:	048ab783          	ld	a5,72(s5)
    800010fa:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800010fe:	058ab683          	ld	a3,88(s5)
    80001102:	87b6                	mv	a5,a3
    80001104:	0589b703          	ld	a4,88(s3)
    80001108:	12068693          	addi	a3,a3,288
    8000110c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001110:	6788                	ld	a0,8(a5)
    80001112:	6b8c                	ld	a1,16(a5)
    80001114:	6f90                	ld	a2,24(a5)
    80001116:	01073023          	sd	a6,0(a4)
    8000111a:	e708                	sd	a0,8(a4)
    8000111c:	eb0c                	sd	a1,16(a4)
    8000111e:	ef10                	sd	a2,24(a4)
    80001120:	02078793          	addi	a5,a5,32
    80001124:	02070713          	addi	a4,a4,32
    80001128:	fed792e3          	bne	a5,a3,8000110c <fork+0x4a>
  np->trapframe->a0 = 0;
    8000112c:	0589b783          	ld	a5,88(s3)
    80001130:	0607b823          	sd	zero,112(a5)
  np->trace_mask = p->trace_mask;
    80001134:	168aa783          	lw	a5,360(s5)
    80001138:	16f9a423          	sw	a5,360(s3)
  for(i = 0; i < NOFILE; i++)
    8000113c:	0d0a8493          	addi	s1,s5,208
    80001140:	0d098913          	addi	s2,s3,208
    80001144:	150a8a13          	addi	s4,s5,336
    80001148:	a831                	j	80001164 <fork+0xa2>
    freeproc(np);
    8000114a:	854e                	mv	a0,s3
    8000114c:	dbfff0ef          	jal	80000f0a <freeproc>
    release(&np->lock);
    80001150:	854e                	mv	a0,s3
    80001152:	776040ef          	jal	800058c8 <release>
    return -1;
    80001156:	597d                	li	s2,-1
    80001158:	69e2                	ld	s3,24(sp)
    8000115a:	a0b5                	j	800011c6 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    8000115c:	04a1                	addi	s1,s1,8
    8000115e:	0921                	addi	s2,s2,8
    80001160:	01448963          	beq	s1,s4,80001172 <fork+0xb0>
    if(p->ofile[i])
    80001164:	6088                	ld	a0,0(s1)
    80001166:	d97d                	beqz	a0,8000115c <fork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001168:	256020ef          	jal	800033be <filedup>
    8000116c:	00a93023          	sd	a0,0(s2)
    80001170:	b7f5                	j	8000115c <fork+0x9a>
  np->cwd = idup(p->cwd);
    80001172:	150ab503          	ld	a0,336(s5)
    80001176:	5a8010ef          	jal	8000271e <idup>
    8000117a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000117e:	4641                	li	a2,16
    80001180:	158a8593          	addi	a1,s5,344
    80001184:	15898513          	addi	a0,s3,344
    80001188:	92cff0ef          	jal	800002b4 <safestrcpy>
  pid = np->pid;
    8000118c:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001190:	854e                	mv	a0,s3
    80001192:	736040ef          	jal	800058c8 <release>
  acquire(&wait_lock);
    80001196:	00009497          	auipc	s1,0x9
    8000119a:	2e248493          	addi	s1,s1,738 # 8000a478 <wait_lock>
    8000119e:	8526                	mv	a0,s1
    800011a0:	690040ef          	jal	80005830 <acquire>
  np->parent = p;
    800011a4:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	71e040ef          	jal	800058c8 <release>
  acquire(&np->lock);
    800011ae:	854e                	mv	a0,s3
    800011b0:	680040ef          	jal	80005830 <acquire>
  np->state = RUNNABLE;
    800011b4:	478d                	li	a5,3
    800011b6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011ba:	854e                	mv	a0,s3
    800011bc:	70c040ef          	jal	800058c8 <release>
  return pid;
    800011c0:	74a2                	ld	s1,40(sp)
    800011c2:	69e2                	ld	s3,24(sp)
    800011c4:	6a42                	ld	s4,16(sp)
}
    800011c6:	854a                	mv	a0,s2
    800011c8:	70e2                	ld	ra,56(sp)
    800011ca:	7442                	ld	s0,48(sp)
    800011cc:	7902                	ld	s2,32(sp)
    800011ce:	6aa2                	ld	s5,8(sp)
    800011d0:	6121                	addi	sp,sp,64
    800011d2:	8082                	ret
    return -1;
    800011d4:	597d                	li	s2,-1
    800011d6:	bfc5                	j	800011c6 <fork+0x104>

00000000800011d8 <scheduler>:
{
    800011d8:	715d                	addi	sp,sp,-80
    800011da:	e486                	sd	ra,72(sp)
    800011dc:	e0a2                	sd	s0,64(sp)
    800011de:	fc26                	sd	s1,56(sp)
    800011e0:	f84a                	sd	s2,48(sp)
    800011e2:	f44e                	sd	s3,40(sp)
    800011e4:	f052                	sd	s4,32(sp)
    800011e6:	ec56                	sd	s5,24(sp)
    800011e8:	e85a                	sd	s6,16(sp)
    800011ea:	e45e                	sd	s7,8(sp)
    800011ec:	e062                	sd	s8,0(sp)
    800011ee:	0880                	addi	s0,sp,80
    800011f0:	8792                	mv	a5,tp
  int id = r_tp();
    800011f2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011f4:	00779b13          	slli	s6,a5,0x7
    800011f8:	00009717          	auipc	a4,0x9
    800011fc:	26870713          	addi	a4,a4,616 # 8000a460 <pid_lock>
    80001200:	975a                	add	a4,a4,s6
    80001202:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001206:	00009717          	auipc	a4,0x9
    8000120a:	29270713          	addi	a4,a4,658 # 8000a498 <cpus+0x8>
    8000120e:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001210:	4c11                	li	s8,4
        c->proc = p;
    80001212:	079e                	slli	a5,a5,0x7
    80001214:	00009a17          	auipc	s4,0x9
    80001218:	24ca0a13          	addi	s4,s4,588 # 8000a460 <pid_lock>
    8000121c:	9a3e                	add	s4,s4,a5
        found = 1;
    8000121e:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001220:	0000f997          	auipc	s3,0xf
    80001224:	27098993          	addi	s3,s3,624 # 80010490 <tickslock>
    80001228:	a0a9                	j	80001272 <scheduler+0x9a>
      release(&p->lock);
    8000122a:	8526                	mv	a0,s1
    8000122c:	69c040ef          	jal	800058c8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001230:	17048493          	addi	s1,s1,368
    80001234:	03348563          	beq	s1,s3,8000125e <scheduler+0x86>
      acquire(&p->lock);
    80001238:	8526                	mv	a0,s1
    8000123a:	5f6040ef          	jal	80005830 <acquire>
      if(p->state == RUNNABLE) {
    8000123e:	4c9c                	lw	a5,24(s1)
    80001240:	ff2795e3          	bne	a5,s2,8000122a <scheduler+0x52>
        p->state = RUNNING;
    80001244:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001248:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000124c:	06048593          	addi	a1,s1,96
    80001250:	855a                	mv	a0,s6
    80001252:	5e4000ef          	jal	80001836 <swtch>
        c->proc = 0;
    80001256:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000125a:	8ade                	mv	s5,s7
    8000125c:	b7f9                	j	8000122a <scheduler+0x52>
    if(found == 0) {
    8000125e:	000a9a63          	bnez	s5,80001272 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001262:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001266:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000126a:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000126e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001272:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001276:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000127a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000127e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001280:	00009497          	auipc	s1,0x9
    80001284:	61048493          	addi	s1,s1,1552 # 8000a890 <proc>
      if(p->state == RUNNABLE) {
    80001288:	490d                	li	s2,3
    8000128a:	b77d                	j	80001238 <scheduler+0x60>

000000008000128c <sched>:
{
    8000128c:	7179                	addi	sp,sp,-48
    8000128e:	f406                	sd	ra,40(sp)
    80001290:	f022                	sd	s0,32(sp)
    80001292:	ec26                	sd	s1,24(sp)
    80001294:	e84a                	sd	s2,16(sp)
    80001296:	e44e                	sd	s3,8(sp)
    80001298:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000129a:	affff0ef          	jal	80000d98 <myproc>
    8000129e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012a0:	526040ef          	jal	800057c6 <holding>
    800012a4:	c92d                	beqz	a0,80001316 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012a6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00009717          	auipc	a4,0x9
    800012b0:	1b470713          	addi	a4,a4,436 # 8000a460 <pid_lock>
    800012b4:	97ba                	add	a5,a5,a4
    800012b6:	0a87a703          	lw	a4,168(a5)
    800012ba:	4785                	li	a5,1
    800012bc:	06f71363          	bne	a4,a5,80001322 <sched+0x96>
  if(p->state == RUNNING)
    800012c0:	4c98                	lw	a4,24(s1)
    800012c2:	4791                	li	a5,4
    800012c4:	06f70563          	beq	a4,a5,8000132e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012cc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ce:	e7b5                	bnez	a5,8000133a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012d2:	00009917          	auipc	s2,0x9
    800012d6:	18e90913          	addi	s2,s2,398 # 8000a460 <pid_lock>
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	97ca                	add	a5,a5,s2
    800012e0:	0ac7a983          	lw	s3,172(a5)
    800012e4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	00009597          	auipc	a1,0x9
    800012ee:	1ae58593          	addi	a1,a1,430 # 8000a498 <cpus+0x8>
    800012f2:	95be                	add	a1,a1,a5
    800012f4:	06048513          	addi	a0,s1,96
    800012f8:	53e000ef          	jal	80001836 <swtch>
    800012fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012fe:	2781                	sext.w	a5,a5
    80001300:	079e                	slli	a5,a5,0x7
    80001302:	993e                	add	s2,s2,a5
    80001304:	0b392623          	sw	s3,172(s2)
}
    80001308:	70a2                	ld	ra,40(sp)
    8000130a:	7402                	ld	s0,32(sp)
    8000130c:	64e2                	ld	s1,24(sp)
    8000130e:	6942                	ld	s2,16(sp)
    80001310:	69a2                	ld	s3,8(sp)
    80001312:	6145                	addi	sp,sp,48
    80001314:	8082                	ret
    panic("sched p->lock");
    80001316:	00006517          	auipc	a0,0x6
    8000131a:	ec250513          	addi	a0,a0,-318 # 800071d8 <etext+0x1d8>
    8000131e:	1e4040ef          	jal	80005502 <panic>
    panic("sched locks");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	ec650513          	addi	a0,a0,-314 # 800071e8 <etext+0x1e8>
    8000132a:	1d8040ef          	jal	80005502 <panic>
    panic("sched running");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eca50513          	addi	a0,a0,-310 # 800071f8 <etext+0x1f8>
    80001336:	1cc040ef          	jal	80005502 <panic>
    panic("sched interruptible");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	ece50513          	addi	a0,a0,-306 # 80007208 <etext+0x208>
    80001342:	1c0040ef          	jal	80005502 <panic>

0000000080001346 <yield>:
{
    80001346:	1101                	addi	sp,sp,-32
    80001348:	ec06                	sd	ra,24(sp)
    8000134a:	e822                	sd	s0,16(sp)
    8000134c:	e426                	sd	s1,8(sp)
    8000134e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001350:	a49ff0ef          	jal	80000d98 <myproc>
    80001354:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001356:	4da040ef          	jal	80005830 <acquire>
  p->state = RUNNABLE;
    8000135a:	478d                	li	a5,3
    8000135c:	cc9c                	sw	a5,24(s1)
  sched();
    8000135e:	f2fff0ef          	jal	8000128c <sched>
  release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	564040ef          	jal	800058c8 <release>
}
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret

0000000080001372 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	e84a                	sd	s2,16(sp)
    8000137c:	e44e                	sd	s3,8(sp)
    8000137e:	1800                	addi	s0,sp,48
    80001380:	89aa                	mv	s3,a0
    80001382:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001384:	a15ff0ef          	jal	80000d98 <myproc>
    80001388:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000138a:	4a6040ef          	jal	80005830 <acquire>
  release(lk);
    8000138e:	854a                	mv	a0,s2
    80001390:	538040ef          	jal	800058c8 <release>

  // Go to sleep.
  p->chan = chan;
    80001394:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001398:	4789                	li	a5,2
    8000139a:	cc9c                	sw	a5,24(s1)

  sched();
    8000139c:	ef1ff0ef          	jal	8000128c <sched>

  // Tidy up.
  p->chan = 0;
    800013a0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	522040ef          	jal	800058c8 <release>
  acquire(lk);
    800013aa:	854a                	mv	a0,s2
    800013ac:	484040ef          	jal	80005830 <acquire>
}
    800013b0:	70a2                	ld	ra,40(sp)
    800013b2:	7402                	ld	s0,32(sp)
    800013b4:	64e2                	ld	s1,24(sp)
    800013b6:	6942                	ld	s2,16(sp)
    800013b8:	69a2                	ld	s3,8(sp)
    800013ba:	6145                	addi	sp,sp,48
    800013bc:	8082                	ret

00000000800013be <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013be:	7139                	addi	sp,sp,-64
    800013c0:	fc06                	sd	ra,56(sp)
    800013c2:	f822                	sd	s0,48(sp)
    800013c4:	f426                	sd	s1,40(sp)
    800013c6:	f04a                	sd	s2,32(sp)
    800013c8:	ec4e                	sd	s3,24(sp)
    800013ca:	e852                	sd	s4,16(sp)
    800013cc:	e456                	sd	s5,8(sp)
    800013ce:	0080                	addi	s0,sp,64
    800013d0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	00009497          	auipc	s1,0x9
    800013d6:	4be48493          	addi	s1,s1,1214 # 8000a890 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013da:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013dc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	0000f917          	auipc	s2,0xf
    800013e2:	0b290913          	addi	s2,s2,178 # 80010490 <tickslock>
    800013e6:	a801                	j	800013f6 <wakeup+0x38>
      }
      release(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	4de040ef          	jal	800058c8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	17048493          	addi	s1,s1,368
    800013f2:	03248263          	beq	s1,s2,80001416 <wakeup+0x58>
    if(p != myproc()){
    800013f6:	9a3ff0ef          	jal	80000d98 <myproc>
    800013fa:	fea48ae3          	beq	s1,a0,800013ee <wakeup+0x30>
      acquire(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	430040ef          	jal	80005830 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001404:	4c9c                	lw	a5,24(s1)
    80001406:	ff3791e3          	bne	a5,s3,800013e8 <wakeup+0x2a>
    8000140a:	709c                	ld	a5,32(s1)
    8000140c:	fd479ee3          	bne	a5,s4,800013e8 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001410:	0154ac23          	sw	s5,24(s1)
    80001414:	bfd1                	j	800013e8 <wakeup+0x2a>
    }
  }
}
    80001416:	70e2                	ld	ra,56(sp)
    80001418:	7442                	ld	s0,48(sp)
    8000141a:	74a2                	ld	s1,40(sp)
    8000141c:	7902                	ld	s2,32(sp)
    8000141e:	69e2                	ld	s3,24(sp)
    80001420:	6a42                	ld	s4,16(sp)
    80001422:	6aa2                	ld	s5,8(sp)
    80001424:	6121                	addi	sp,sp,64
    80001426:	8082                	ret

0000000080001428 <reparent>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	e052                	sd	s4,0(sp)
    80001436:	1800                	addi	s0,sp,48
    80001438:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143a:	00009497          	auipc	s1,0x9
    8000143e:	45648493          	addi	s1,s1,1110 # 8000a890 <proc>
      pp->parent = initproc;
    80001442:	00009a17          	auipc	s4,0x9
    80001446:	fdea0a13          	addi	s4,s4,-34 # 8000a420 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144a:	0000f997          	auipc	s3,0xf
    8000144e:	04698993          	addi	s3,s3,70 # 80010490 <tickslock>
    80001452:	a029                	j	8000145c <reparent+0x34>
    80001454:	17048493          	addi	s1,s1,368
    80001458:	01348b63          	beq	s1,s3,8000146e <reparent+0x46>
    if(pp->parent == p){
    8000145c:	7c9c                	ld	a5,56(s1)
    8000145e:	ff279be3          	bne	a5,s2,80001454 <reparent+0x2c>
      pp->parent = initproc;
    80001462:	000a3503          	ld	a0,0(s4)
    80001466:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001468:	f57ff0ef          	jal	800013be <wakeup>
    8000146c:	b7e5                	j	80001454 <reparent+0x2c>
}
    8000146e:	70a2                	ld	ra,40(sp)
    80001470:	7402                	ld	s0,32(sp)
    80001472:	64e2                	ld	s1,24(sp)
    80001474:	6942                	ld	s2,16(sp)
    80001476:	69a2                	ld	s3,8(sp)
    80001478:	6a02                	ld	s4,0(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret

000000008000147e <exit>:
{
    8000147e:	7179                	addi	sp,sp,-48
    80001480:	f406                	sd	ra,40(sp)
    80001482:	f022                	sd	s0,32(sp)
    80001484:	ec26                	sd	s1,24(sp)
    80001486:	e84a                	sd	s2,16(sp)
    80001488:	e44e                	sd	s3,8(sp)
    8000148a:	e052                	sd	s4,0(sp)
    8000148c:	1800                	addi	s0,sp,48
    8000148e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001490:	909ff0ef          	jal	80000d98 <myproc>
    80001494:	89aa                	mv	s3,a0
  if(p == initproc)
    80001496:	00009797          	auipc	a5,0x9
    8000149a:	f8a7b783          	ld	a5,-118(a5) # 8000a420 <initproc>
    8000149e:	0d050493          	addi	s1,a0,208
    800014a2:	15050913          	addi	s2,a0,336
    800014a6:	00a79f63          	bne	a5,a0,800014c4 <exit+0x46>
    panic("init exiting");
    800014aa:	00006517          	auipc	a0,0x6
    800014ae:	d7650513          	addi	a0,a0,-650 # 80007220 <etext+0x220>
    800014b2:	050040ef          	jal	80005502 <panic>
      fileclose(f);
    800014b6:	74f010ef          	jal	80003404 <fileclose>
      p->ofile[fd] = 0;
    800014ba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014be:	04a1                	addi	s1,s1,8
    800014c0:	01248563          	beq	s1,s2,800014ca <exit+0x4c>
    if(p->ofile[fd]){
    800014c4:	6088                	ld	a0,0(s1)
    800014c6:	f965                	bnez	a0,800014b6 <exit+0x38>
    800014c8:	bfdd                	j	800014be <exit+0x40>
  begin_op();
    800014ca:	321010ef          	jal	80002fea <begin_op>
  iput(p->cwd);
    800014ce:	1509b503          	ld	a0,336(s3)
    800014d2:	404010ef          	jal	800028d6 <iput>
  end_op();
    800014d6:	37f010ef          	jal	80003054 <end_op>
  p->cwd = 0;
    800014da:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014de:	00009497          	auipc	s1,0x9
    800014e2:	f9a48493          	addi	s1,s1,-102 # 8000a478 <wait_lock>
    800014e6:	8526                	mv	a0,s1
    800014e8:	348040ef          	jal	80005830 <acquire>
  reparent(p);
    800014ec:	854e                	mv	a0,s3
    800014ee:	f3bff0ef          	jal	80001428 <reparent>
  wakeup(p->parent);
    800014f2:	0389b503          	ld	a0,56(s3)
    800014f6:	ec9ff0ef          	jal	800013be <wakeup>
  acquire(&p->lock);
    800014fa:	854e                	mv	a0,s3
    800014fc:	334040ef          	jal	80005830 <acquire>
  p->xstate = status;
    80001500:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001504:	4795                	li	a5,5
    80001506:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	3bc040ef          	jal	800058c8 <release>
  sched();
    80001510:	d7dff0ef          	jal	8000128c <sched>
  panic("zombie exit");
    80001514:	00006517          	auipc	a0,0x6
    80001518:	d1c50513          	addi	a0,a0,-740 # 80007230 <etext+0x230>
    8000151c:	7e7030ef          	jal	80005502 <panic>

0000000080001520 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001520:	7179                	addi	sp,sp,-48
    80001522:	f406                	sd	ra,40(sp)
    80001524:	f022                	sd	s0,32(sp)
    80001526:	ec26                	sd	s1,24(sp)
    80001528:	e84a                	sd	s2,16(sp)
    8000152a:	e44e                	sd	s3,8(sp)
    8000152c:	1800                	addi	s0,sp,48
    8000152e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001530:	00009497          	auipc	s1,0x9
    80001534:	36048493          	addi	s1,s1,864 # 8000a890 <proc>
    80001538:	0000f997          	auipc	s3,0xf
    8000153c:	f5898993          	addi	s3,s3,-168 # 80010490 <tickslock>
    acquire(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	2ee040ef          	jal	80005830 <acquire>
    if(p->pid == pid){
    80001546:	589c                	lw	a5,48(s1)
    80001548:	01278b63          	beq	a5,s2,8000155e <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	37a040ef          	jal	800058c8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001552:	17048493          	addi	s1,s1,368
    80001556:	ff3495e3          	bne	s1,s3,80001540 <kill+0x20>
  }
  return -1;
    8000155a:	557d                	li	a0,-1
    8000155c:	a819                	j	80001572 <kill+0x52>
      p->killed = 1;
    8000155e:	4785                	li	a5,1
    80001560:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001562:	4c98                	lw	a4,24(s1)
    80001564:	4789                	li	a5,2
    80001566:	00f70d63          	beq	a4,a5,80001580 <kill+0x60>
      release(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	35c040ef          	jal	800058c8 <release>
      return 0;
    80001570:	4501                	li	a0,0
}
    80001572:	70a2                	ld	ra,40(sp)
    80001574:	7402                	ld	s0,32(sp)
    80001576:	64e2                	ld	s1,24(sp)
    80001578:	6942                	ld	s2,16(sp)
    8000157a:	69a2                	ld	s3,8(sp)
    8000157c:	6145                	addi	sp,sp,48
    8000157e:	8082                	ret
        p->state = RUNNABLE;
    80001580:	478d                	li	a5,3
    80001582:	cc9c                	sw	a5,24(s1)
    80001584:	b7dd                	j	8000156a <kill+0x4a>

0000000080001586 <setkilled>:

void
setkilled(struct proc *p)
{
    80001586:	1101                	addi	sp,sp,-32
    80001588:	ec06                	sd	ra,24(sp)
    8000158a:	e822                	sd	s0,16(sp)
    8000158c:	e426                	sd	s1,8(sp)
    8000158e:	1000                	addi	s0,sp,32
    80001590:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001592:	29e040ef          	jal	80005830 <acquire>
  p->killed = 1;
    80001596:	4785                	li	a5,1
    80001598:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	32c040ef          	jal	800058c8 <release>
}
    800015a0:	60e2                	ld	ra,24(sp)
    800015a2:	6442                	ld	s0,16(sp)
    800015a4:	64a2                	ld	s1,8(sp)
    800015a6:	6105                	addi	sp,sp,32
    800015a8:	8082                	ret

00000000800015aa <killed>:

int
killed(struct proc *p)
{
    800015aa:	1101                	addi	sp,sp,-32
    800015ac:	ec06                	sd	ra,24(sp)
    800015ae:	e822                	sd	s0,16(sp)
    800015b0:	e426                	sd	s1,8(sp)
    800015b2:	e04a                	sd	s2,0(sp)
    800015b4:	1000                	addi	s0,sp,32
    800015b6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015b8:	278040ef          	jal	80005830 <acquire>
  k = p->killed;
    800015bc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015c0:	8526                	mv	a0,s1
    800015c2:	306040ef          	jal	800058c8 <release>
  return k;
}
    800015c6:	854a                	mv	a0,s2
    800015c8:	60e2                	ld	ra,24(sp)
    800015ca:	6442                	ld	s0,16(sp)
    800015cc:	64a2                	ld	s1,8(sp)
    800015ce:	6902                	ld	s2,0(sp)
    800015d0:	6105                	addi	sp,sp,32
    800015d2:	8082                	ret

00000000800015d4 <wait>:
{
    800015d4:	715d                	addi	sp,sp,-80
    800015d6:	e486                	sd	ra,72(sp)
    800015d8:	e0a2                	sd	s0,64(sp)
    800015da:	fc26                	sd	s1,56(sp)
    800015dc:	f84a                	sd	s2,48(sp)
    800015de:	f44e                	sd	s3,40(sp)
    800015e0:	f052                	sd	s4,32(sp)
    800015e2:	ec56                	sd	s5,24(sp)
    800015e4:	e85a                	sd	s6,16(sp)
    800015e6:	e45e                	sd	s7,8(sp)
    800015e8:	e062                	sd	s8,0(sp)
    800015ea:	0880                	addi	s0,sp,80
    800015ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ee:	faaff0ef          	jal	80000d98 <myproc>
    800015f2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f4:	00009517          	auipc	a0,0x9
    800015f8:	e8450513          	addi	a0,a0,-380 # 8000a478 <wait_lock>
    800015fc:	234040ef          	jal	80005830 <acquire>
    havekids = 0;
    80001600:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001602:	4a15                	li	s4,5
        havekids = 1;
    80001604:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001606:	0000f997          	auipc	s3,0xf
    8000160a:	e8a98993          	addi	s3,s3,-374 # 80010490 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000160e:	00009c17          	auipc	s8,0x9
    80001612:	e6ac0c13          	addi	s8,s8,-406 # 8000a478 <wait_lock>
    80001616:	a871                	j	800016b2 <wait+0xde>
          pid = pp->pid;
    80001618:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000161c:	000b0c63          	beqz	s6,80001634 <wait+0x60>
    80001620:	4691                	li	a3,4
    80001622:	02c48613          	addi	a2,s1,44
    80001626:	85da                	mv	a1,s6
    80001628:	05093503          	ld	a0,80(s2)
    8000162c:	bdcff0ef          	jal	80000a08 <copyout>
    80001630:	02054b63          	bltz	a0,80001666 <wait+0x92>
          freeproc(pp);
    80001634:	8526                	mv	a0,s1
    80001636:	8d5ff0ef          	jal	80000f0a <freeproc>
          release(&pp->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	28c040ef          	jal	800058c8 <release>
          release(&wait_lock);
    80001640:	00009517          	auipc	a0,0x9
    80001644:	e3850513          	addi	a0,a0,-456 # 8000a478 <wait_lock>
    80001648:	280040ef          	jal	800058c8 <release>
}
    8000164c:	854e                	mv	a0,s3
    8000164e:	60a6                	ld	ra,72(sp)
    80001650:	6406                	ld	s0,64(sp)
    80001652:	74e2                	ld	s1,56(sp)
    80001654:	7942                	ld	s2,48(sp)
    80001656:	79a2                	ld	s3,40(sp)
    80001658:	7a02                	ld	s4,32(sp)
    8000165a:	6ae2                	ld	s5,24(sp)
    8000165c:	6b42                	ld	s6,16(sp)
    8000165e:	6ba2                	ld	s7,8(sp)
    80001660:	6c02                	ld	s8,0(sp)
    80001662:	6161                	addi	sp,sp,80
    80001664:	8082                	ret
            release(&pp->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	260040ef          	jal	800058c8 <release>
            release(&wait_lock);
    8000166c:	00009517          	auipc	a0,0x9
    80001670:	e0c50513          	addi	a0,a0,-500 # 8000a478 <wait_lock>
    80001674:	254040ef          	jal	800058c8 <release>
            return -1;
    80001678:	59fd                	li	s3,-1
    8000167a:	bfc9                	j	8000164c <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000167c:	17048493          	addi	s1,s1,368
    80001680:	03348063          	beq	s1,s3,800016a0 <wait+0xcc>
      if(pp->parent == p){
    80001684:	7c9c                	ld	a5,56(s1)
    80001686:	ff279be3          	bne	a5,s2,8000167c <wait+0xa8>
        acquire(&pp->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	1a4040ef          	jal	80005830 <acquire>
        if(pp->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94783e3          	beq	a5,s4,80001618 <wait+0x44>
        release(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	230040ef          	jal	800058c8 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bff9                	j	8000167c <wait+0xa8>
    if(!havekids || killed(p)){
    800016a0:	cf19                	beqz	a4,800016be <wait+0xea>
    800016a2:	854a                	mv	a0,s2
    800016a4:	f07ff0ef          	jal	800015aa <killed>
    800016a8:	e919                	bnez	a0,800016be <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016aa:	85e2                	mv	a1,s8
    800016ac:	854a                	mv	a0,s2
    800016ae:	cc5ff0ef          	jal	80001372 <sleep>
    havekids = 0;
    800016b2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b4:	00009497          	auipc	s1,0x9
    800016b8:	1dc48493          	addi	s1,s1,476 # 8000a890 <proc>
    800016bc:	b7e1                	j	80001684 <wait+0xb0>
      release(&wait_lock);
    800016be:	00009517          	auipc	a0,0x9
    800016c2:	dba50513          	addi	a0,a0,-582 # 8000a478 <wait_lock>
    800016c6:	202040ef          	jal	800058c8 <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b741                	j	8000164c <wait+0x78>

00000000800016ce <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	e052                	sd	s4,0(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	84aa                	mv	s1,a0
    800016e0:	892e                	mv	s2,a1
    800016e2:	89b2                	mv	s3,a2
    800016e4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e6:	eb2ff0ef          	jal	80000d98 <myproc>
  if(user_dst){
    800016ea:	cc99                	beqz	s1,80001708 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ec:	86d2                	mv	a3,s4
    800016ee:	864e                	mv	a2,s3
    800016f0:	85ca                	mv	a1,s2
    800016f2:	6928                	ld	a0,80(a0)
    800016f4:	b14ff0ef          	jal	80000a08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016f8:	70a2                	ld	ra,40(sp)
    800016fa:	7402                	ld	s0,32(sp)
    800016fc:	64e2                	ld	s1,24(sp)
    800016fe:	6942                	ld	s2,16(sp)
    80001700:	69a2                	ld	s3,8(sp)
    80001702:	6a02                	ld	s4,0(sp)
    80001704:	6145                	addi	sp,sp,48
    80001706:	8082                	ret
    memmove((char *)dst, src, len);
    80001708:	000a061b          	sext.w	a2,s4
    8000170c:	85ce                	mv	a1,s3
    8000170e:	854a                	mv	a0,s2
    80001710:	ac3fe0ef          	jal	800001d2 <memmove>
    return 0;
    80001714:	8526                	mv	a0,s1
    80001716:	b7cd                	j	800016f8 <either_copyout+0x2a>

0000000080001718 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001718:	7179                	addi	sp,sp,-48
    8000171a:	f406                	sd	ra,40(sp)
    8000171c:	f022                	sd	s0,32(sp)
    8000171e:	ec26                	sd	s1,24(sp)
    80001720:	e84a                	sd	s2,16(sp)
    80001722:	e44e                	sd	s3,8(sp)
    80001724:	e052                	sd	s4,0(sp)
    80001726:	1800                	addi	s0,sp,48
    80001728:	892a                	mv	s2,a0
    8000172a:	84ae                	mv	s1,a1
    8000172c:	89b2                	mv	s3,a2
    8000172e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001730:	e68ff0ef          	jal	80000d98 <myproc>
  if(user_src){
    80001734:	cc99                	beqz	s1,80001752 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001736:	86d2                	mv	a3,s4
    80001738:	864e                	mv	a2,s3
    8000173a:	85ca                	mv	a1,s2
    8000173c:	6928                	ld	a0,80(a0)
    8000173e:	ba2ff0ef          	jal	80000ae0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001742:	70a2                	ld	ra,40(sp)
    80001744:	7402                	ld	s0,32(sp)
    80001746:	64e2                	ld	s1,24(sp)
    80001748:	6942                	ld	s2,16(sp)
    8000174a:	69a2                	ld	s3,8(sp)
    8000174c:	6a02                	ld	s4,0(sp)
    8000174e:	6145                	addi	sp,sp,48
    80001750:	8082                	ret
    memmove(dst, (char*)src, len);
    80001752:	000a061b          	sext.w	a2,s4
    80001756:	85ce                	mv	a1,s3
    80001758:	854a                	mv	a0,s2
    8000175a:	a79fe0ef          	jal	800001d2 <memmove>
    return 0;
    8000175e:	8526                	mv	a0,s1
    80001760:	b7cd                	j	80001742 <either_copyin+0x2a>

0000000080001762 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001762:	715d                	addi	sp,sp,-80
    80001764:	e486                	sd	ra,72(sp)
    80001766:	e0a2                	sd	s0,64(sp)
    80001768:	fc26                	sd	s1,56(sp)
    8000176a:	f84a                	sd	s2,48(sp)
    8000176c:	f44e                	sd	s3,40(sp)
    8000176e:	f052                	sd	s4,32(sp)
    80001770:	ec56                	sd	s5,24(sp)
    80001772:	e85a                	sd	s6,16(sp)
    80001774:	e45e                	sd	s7,8(sp)
    80001776:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001778:	00006517          	auipc	a0,0x6
    8000177c:	8c050513          	addi	a0,a0,-1856 # 80007038 <etext+0x38>
    80001780:	2b1030ef          	jal	80005230 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001784:	00009497          	auipc	s1,0x9
    80001788:	26448493          	addi	s1,s1,612 # 8000a9e8 <proc+0x158>
    8000178c:	0000f917          	auipc	s2,0xf
    80001790:	e5c90913          	addi	s2,s2,-420 # 800105e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001794:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001796:	00006997          	auipc	s3,0x6
    8000179a:	aaa98993          	addi	s3,s3,-1366 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    8000179e:	00006a97          	auipc	s5,0x6
    800017a2:	aaaa8a93          	addi	s5,s5,-1366 # 80007248 <etext+0x248>
    printf("\n");
    800017a6:	00006a17          	auipc	s4,0x6
    800017aa:	892a0a13          	addi	s4,s4,-1902 # 80007038 <etext+0x38>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ae:	00006b97          	auipc	s7,0x6
    800017b2:	082b8b93          	addi	s7,s7,130 # 80007830 <states.0>
    800017b6:	a829                	j	800017d0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017b8:	ed86a583          	lw	a1,-296(a3)
    800017bc:	8556                	mv	a0,s5
    800017be:	273030ef          	jal	80005230 <printf>
    printf("\n");
    800017c2:	8552                	mv	a0,s4
    800017c4:	26d030ef          	jal	80005230 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	17048493          	addi	s1,s1,368
    800017cc:	03248263          	beq	s1,s2,800017f0 <procdump+0x8e>
    if(p->state == UNUSED)
    800017d0:	86a6                	mv	a3,s1
    800017d2:	ec04a783          	lw	a5,-320(s1)
    800017d6:	dbed                	beqz	a5,800017c8 <procdump+0x66>
      state = "???";
    800017d8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017da:	fcfb6fe3          	bltu	s6,a5,800017b8 <procdump+0x56>
    800017de:	02079713          	slli	a4,a5,0x20
    800017e2:	01d75793          	srli	a5,a4,0x1d
    800017e6:	97de                	add	a5,a5,s7
    800017e8:	6390                	ld	a2,0(a5)
    800017ea:	f679                	bnez	a2,800017b8 <procdump+0x56>
      state = "???";
    800017ec:	864e                	mv	a2,s3
    800017ee:	b7e9                	j	800017b8 <procdump+0x56>
  }
}
    800017f0:	60a6                	ld	ra,72(sp)
    800017f2:	6406                	ld	s0,64(sp)
    800017f4:	74e2                	ld	s1,56(sp)
    800017f6:	7942                	ld	s2,48(sp)
    800017f8:	79a2                	ld	s3,40(sp)
    800017fa:	7a02                	ld	s4,32(sp)
    800017fc:	6ae2                	ld	s5,24(sp)
    800017fe:	6b42                	ld	s6,16(sp)
    80001800:	6ba2                	ld	s7,8(sp)
    80001802:	6161                	addi	sp,sp,80
    80001804:	8082                	ret

0000000080001806 <nproc>:

uint64
nproc(void){
    80001806:	1141                	addi	sp,sp,-16
    80001808:	e422                	sd	s0,8(sp)
    8000180a:	0800                	addi	s0,sp,16
  int procCount = 0;
  struct proc* p;
  for (p=proc; p<&proc[NPROC]; p++){
    8000180c:	00009797          	auipc	a5,0x9
    80001810:	08478793          	addi	a5,a5,132 # 8000a890 <proc>
  int procCount = 0;
    80001814:	4501                	li	a0,0
  for (p=proc; p<&proc[NPROC]; p++){
    80001816:	0000f697          	auipc	a3,0xf
    8000181a:	c7a68693          	addi	a3,a3,-902 # 80010490 <tickslock>
    8000181e:	a029                	j	80001828 <nproc+0x22>
    80001820:	17078793          	addi	a5,a5,368
    80001824:	00d78663          	beq	a5,a3,80001830 <nproc+0x2a>
    if (p->state != UNUSED){
    80001828:	4f98                	lw	a4,24(a5)
    8000182a:	db7d                	beqz	a4,80001820 <nproc+0x1a>
      procCount++;
    8000182c:	2505                	addiw	a0,a0,1
    8000182e:	bfcd                	j	80001820 <nproc+0x1a>
    }
  }
  return procCount;
    80001830:	6422                	ld	s0,8(sp)
    80001832:	0141                	addi	sp,sp,16
    80001834:	8082                	ret

0000000080001836 <swtch>:
    80001836:	00153023          	sd	ra,0(a0)
    8000183a:	00253423          	sd	sp,8(a0)
    8000183e:	e900                	sd	s0,16(a0)
    80001840:	ed04                	sd	s1,24(a0)
    80001842:	03253023          	sd	s2,32(a0)
    80001846:	03353423          	sd	s3,40(a0)
    8000184a:	03453823          	sd	s4,48(a0)
    8000184e:	03553c23          	sd	s5,56(a0)
    80001852:	05653023          	sd	s6,64(a0)
    80001856:	05753423          	sd	s7,72(a0)
    8000185a:	05853823          	sd	s8,80(a0)
    8000185e:	05953c23          	sd	s9,88(a0)
    80001862:	07a53023          	sd	s10,96(a0)
    80001866:	07b53423          	sd	s11,104(a0)
    8000186a:	0005b083          	ld	ra,0(a1)
    8000186e:	0085b103          	ld	sp,8(a1)
    80001872:	6980                	ld	s0,16(a1)
    80001874:	6d84                	ld	s1,24(a1)
    80001876:	0205b903          	ld	s2,32(a1)
    8000187a:	0285b983          	ld	s3,40(a1)
    8000187e:	0305ba03          	ld	s4,48(a1)
    80001882:	0385ba83          	ld	s5,56(a1)
    80001886:	0405bb03          	ld	s6,64(a1)
    8000188a:	0485bb83          	ld	s7,72(a1)
    8000188e:	0505bc03          	ld	s8,80(a1)
    80001892:	0585bc83          	ld	s9,88(a1)
    80001896:	0605bd03          	ld	s10,96(a1)
    8000189a:	0685bd83          	ld	s11,104(a1)
    8000189e:	8082                	ret

00000000800018a0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018a0:	1141                	addi	sp,sp,-16
    800018a2:	e406                	sd	ra,8(sp)
    800018a4:	e022                	sd	s0,0(sp)
    800018a6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018a8:	00006597          	auipc	a1,0x6
    800018ac:	9e058593          	addi	a1,a1,-1568 # 80007288 <etext+0x288>
    800018b0:	0000f517          	auipc	a0,0xf
    800018b4:	be050513          	addi	a0,a0,-1056 # 80010490 <tickslock>
    800018b8:	6f9030ef          	jal	800057b0 <initlock>
}
    800018bc:	60a2                	ld	ra,8(sp)
    800018be:	6402                	ld	s0,0(sp)
    800018c0:	0141                	addi	sp,sp,16
    800018c2:	8082                	ret

00000000800018c4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018c4:	1141                	addi	sp,sp,-16
    800018c6:	e422                	sd	s0,8(sp)
    800018c8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018ca:	00003797          	auipc	a5,0x3
    800018ce:	ea678793          	addi	a5,a5,-346 # 80004770 <kernelvec>
    800018d2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018d6:	6422                	ld	s0,8(sp)
    800018d8:	0141                	addi	sp,sp,16
    800018da:	8082                	ret

00000000800018dc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018dc:	1141                	addi	sp,sp,-16
    800018de:	e406                	sd	ra,8(sp)
    800018e0:	e022                	sd	s0,0(sp)
    800018e2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018e4:	cb4ff0ef          	jal	80000d98 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018ee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018f2:	00004697          	auipc	a3,0x4
    800018f6:	70e68693          	addi	a3,a3,1806 # 80006000 <_trampoline>
    800018fa:	00004717          	auipc	a4,0x4
    800018fe:	70670713          	addi	a4,a4,1798 # 80006000 <_trampoline>
    80001902:	8f15                	sub	a4,a4,a3
    80001904:	040007b7          	lui	a5,0x4000
    80001908:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000190a:	07b2                	slli	a5,a5,0xc
    8000190c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000190e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001912:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001914:	18002673          	csrr	a2,satp
    80001918:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000191a:	6d30                	ld	a2,88(a0)
    8000191c:	6138                	ld	a4,64(a0)
    8000191e:	6585                	lui	a1,0x1
    80001920:	972e                	add	a4,a4,a1
    80001922:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001924:	6d38                	ld	a4,88(a0)
    80001926:	00000617          	auipc	a2,0x0
    8000192a:	11060613          	addi	a2,a2,272 # 80001a36 <usertrap>
    8000192e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001930:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001932:	8612                	mv	a2,tp
    80001934:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001936:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000193a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000193e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001942:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001946:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001948:	6f18                	ld	a4,24(a4)
    8000194a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000194e:	6928                	ld	a0,80(a0)
    80001950:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001952:	00004717          	auipc	a4,0x4
    80001956:	74a70713          	addi	a4,a4,1866 # 8000609c <userret>
    8000195a:	8f15                	sub	a4,a4,a3
    8000195c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000195e:	577d                	li	a4,-1
    80001960:	177e                	slli	a4,a4,0x3f
    80001962:	8d59                	or	a0,a0,a4
    80001964:	9782                	jalr	a5
}
    80001966:	60a2                	ld	ra,8(sp)
    80001968:	6402                	ld	s0,0(sp)
    8000196a:	0141                	addi	sp,sp,16
    8000196c:	8082                	ret

000000008000196e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000196e:	1101                	addi	sp,sp,-32
    80001970:	ec06                	sd	ra,24(sp)
    80001972:	e822                	sd	s0,16(sp)
    80001974:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001976:	bf6ff0ef          	jal	80000d6c <cpuid>
    8000197a:	cd11                	beqz	a0,80001996 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000197c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001980:	000f4737          	lui	a4,0xf4
    80001984:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001988:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000198a:	14d79073          	csrw	stimecmp,a5
}
    8000198e:	60e2                	ld	ra,24(sp)
    80001990:	6442                	ld	s0,16(sp)
    80001992:	6105                	addi	sp,sp,32
    80001994:	8082                	ret
    80001996:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001998:	0000f497          	auipc	s1,0xf
    8000199c:	af848493          	addi	s1,s1,-1288 # 80010490 <tickslock>
    800019a0:	8526                	mv	a0,s1
    800019a2:	68f030ef          	jal	80005830 <acquire>
    ticks++;
    800019a6:	00009517          	auipc	a0,0x9
    800019aa:	a8250513          	addi	a0,a0,-1406 # 8000a428 <ticks>
    800019ae:	411c                	lw	a5,0(a0)
    800019b0:	2785                	addiw	a5,a5,1
    800019b2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019b4:	a0bff0ef          	jal	800013be <wakeup>
    release(&tickslock);
    800019b8:	8526                	mv	a0,s1
    800019ba:	70f030ef          	jal	800058c8 <release>
    800019be:	64a2                	ld	s1,8(sp)
    800019c0:	bf75                	j	8000197c <clockintr+0xe>

00000000800019c2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ca:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019ce:	57fd                	li	a5,-1
    800019d0:	17fe                	slli	a5,a5,0x3f
    800019d2:	07a5                	addi	a5,a5,9
    800019d4:	00f70c63          	beq	a4,a5,800019ec <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019d8:	57fd                	li	a5,-1
    800019da:	17fe                	slli	a5,a5,0x3f
    800019dc:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019de:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019e0:	04f70763          	beq	a4,a5,80001a2e <devintr+0x6c>
  }
}
    800019e4:	60e2                	ld	ra,24(sp)
    800019e6:	6442                	ld	s0,16(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret
    800019ec:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019ee:	62f020ef          	jal	8000481c <plic_claim>
    800019f2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019f4:	47a9                	li	a5,10
    800019f6:	00f50963          	beq	a0,a5,80001a08 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019fa:	4785                	li	a5,1
    800019fc:	00f50963          	beq	a0,a5,80001a0e <devintr+0x4c>
    return 1;
    80001a00:	4505                	li	a0,1
    } else if(irq){
    80001a02:	e889                	bnez	s1,80001a14 <devintr+0x52>
    80001a04:	64a2                	ld	s1,8(sp)
    80001a06:	bff9                	j	800019e4 <devintr+0x22>
      uartintr();
    80001a08:	56d030ef          	jal	80005774 <uartintr>
    if(irq)
    80001a0c:	a819                	j	80001a22 <devintr+0x60>
      virtio_disk_intr();
    80001a0e:	2d4030ef          	jal	80004ce2 <virtio_disk_intr>
    if(irq)
    80001a12:	a801                	j	80001a22 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a14:	85a6                	mv	a1,s1
    80001a16:	00006517          	auipc	a0,0x6
    80001a1a:	87a50513          	addi	a0,a0,-1926 # 80007290 <etext+0x290>
    80001a1e:	013030ef          	jal	80005230 <printf>
      plic_complete(irq);
    80001a22:	8526                	mv	a0,s1
    80001a24:	619020ef          	jal	8000483c <plic_complete>
    return 1;
    80001a28:	4505                	li	a0,1
    80001a2a:	64a2                	ld	s1,8(sp)
    80001a2c:	bf65                	j	800019e4 <devintr+0x22>
    clockintr();
    80001a2e:	f41ff0ef          	jal	8000196e <clockintr>
    return 2;
    80001a32:	4509                	li	a0,2
    80001a34:	bf45                	j	800019e4 <devintr+0x22>

0000000080001a36 <usertrap>:
{
    80001a36:	1101                	addi	sp,sp,-32
    80001a38:	ec06                	sd	ra,24(sp)
    80001a3a:	e822                	sd	s0,16(sp)
    80001a3c:	e426                	sd	s1,8(sp)
    80001a3e:	e04a                	sd	s2,0(sp)
    80001a40:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a42:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a46:	1007f793          	andi	a5,a5,256
    80001a4a:	ef85                	bnez	a5,80001a82 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a4c:	00003797          	auipc	a5,0x3
    80001a50:	d2478793          	addi	a5,a5,-732 # 80004770 <kernelvec>
    80001a54:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a58:	b40ff0ef          	jal	80000d98 <myproc>
    80001a5c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a5e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a60:	14102773          	csrr	a4,sepc
    80001a64:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a66:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a6a:	47a1                	li	a5,8
    80001a6c:	02f70163          	beq	a4,a5,80001a8e <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a70:	f53ff0ef          	jal	800019c2 <devintr>
    80001a74:	892a                	mv	s2,a0
    80001a76:	c135                	beqz	a0,80001ada <usertrap+0xa4>
  if(killed(p))
    80001a78:	8526                	mv	a0,s1
    80001a7a:	b31ff0ef          	jal	800015aa <killed>
    80001a7e:	cd1d                	beqz	a0,80001abc <usertrap+0x86>
    80001a80:	a81d                	j	80001ab6 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a82:	00006517          	auipc	a0,0x6
    80001a86:	82e50513          	addi	a0,a0,-2002 # 800072b0 <etext+0x2b0>
    80001a8a:	279030ef          	jal	80005502 <panic>
    if(killed(p))
    80001a8e:	b1dff0ef          	jal	800015aa <killed>
    80001a92:	e121                	bnez	a0,80001ad2 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a94:	6cb8                	ld	a4,88(s1)
    80001a96:	6f1c                	ld	a5,24(a4)
    80001a98:	0791                	addi	a5,a5,4
    80001a9a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aa0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aa4:	10079073          	csrw	sstatus,a5
    syscall();
    80001aa8:	248000ef          	jal	80001cf0 <syscall>
  if(killed(p))
    80001aac:	8526                	mv	a0,s1
    80001aae:	afdff0ef          	jal	800015aa <killed>
    80001ab2:	c901                	beqz	a0,80001ac2 <usertrap+0x8c>
    80001ab4:	4901                	li	s2,0
    exit(-1);
    80001ab6:	557d                	li	a0,-1
    80001ab8:	9c7ff0ef          	jal	8000147e <exit>
  if(which_dev == 2)
    80001abc:	4789                	li	a5,2
    80001abe:	04f90563          	beq	s2,a5,80001b08 <usertrap+0xd2>
  usertrapret();
    80001ac2:	e1bff0ef          	jal	800018dc <usertrapret>
}
    80001ac6:	60e2                	ld	ra,24(sp)
    80001ac8:	6442                	ld	s0,16(sp)
    80001aca:	64a2                	ld	s1,8(sp)
    80001acc:	6902                	ld	s2,0(sp)
    80001ace:	6105                	addi	sp,sp,32
    80001ad0:	8082                	ret
      exit(-1);
    80001ad2:	557d                	li	a0,-1
    80001ad4:	9abff0ef          	jal	8000147e <exit>
    80001ad8:	bf75                	j	80001a94 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ada:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ade:	5890                	lw	a2,48(s1)
    80001ae0:	00005517          	auipc	a0,0x5
    80001ae4:	7f050513          	addi	a0,a0,2032 # 800072d0 <etext+0x2d0>
    80001ae8:	748030ef          	jal	80005230 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af0:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001af4:	00006517          	auipc	a0,0x6
    80001af8:	80c50513          	addi	a0,a0,-2036 # 80007300 <etext+0x300>
    80001afc:	734030ef          	jal	80005230 <printf>
    setkilled(p);
    80001b00:	8526                	mv	a0,s1
    80001b02:	a85ff0ef          	jal	80001586 <setkilled>
    80001b06:	b75d                	j	80001aac <usertrap+0x76>
    yield();
    80001b08:	83fff0ef          	jal	80001346 <yield>
    80001b0c:	bf5d                	j	80001ac2 <usertrap+0x8c>

0000000080001b0e <kerneltrap>:
{
    80001b0e:	7179                	addi	sp,sp,-48
    80001b10:	f406                	sd	ra,40(sp)
    80001b12:	f022                	sd	s0,32(sp)
    80001b14:	ec26                	sd	s1,24(sp)
    80001b16:	e84a                	sd	s2,16(sp)
    80001b18:	e44e                	sd	s3,8(sp)
    80001b1a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b1c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b20:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b24:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b28:	1004f793          	andi	a5,s1,256
    80001b2c:	c795                	beqz	a5,80001b58 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b32:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b34:	eb85                	bnez	a5,80001b64 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b36:	e8dff0ef          	jal	800019c2 <devintr>
    80001b3a:	c91d                	beqz	a0,80001b70 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b3c:	4789                	li	a5,2
    80001b3e:	04f50a63          	beq	a0,a5,80001b92 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b42:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b46:	10049073          	csrw	sstatus,s1
}
    80001b4a:	70a2                	ld	ra,40(sp)
    80001b4c:	7402                	ld	s0,32(sp)
    80001b4e:	64e2                	ld	s1,24(sp)
    80001b50:	6942                	ld	s2,16(sp)
    80001b52:	69a2                	ld	s3,8(sp)
    80001b54:	6145                	addi	sp,sp,48
    80001b56:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b58:	00005517          	auipc	a0,0x5
    80001b5c:	7d050513          	addi	a0,a0,2000 # 80007328 <etext+0x328>
    80001b60:	1a3030ef          	jal	80005502 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b64:	00005517          	auipc	a0,0x5
    80001b68:	7ec50513          	addi	a0,a0,2028 # 80007350 <etext+0x350>
    80001b6c:	197030ef          	jal	80005502 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b70:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b74:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b78:	85ce                	mv	a1,s3
    80001b7a:	00005517          	auipc	a0,0x5
    80001b7e:	7f650513          	addi	a0,a0,2038 # 80007370 <etext+0x370>
    80001b82:	6ae030ef          	jal	80005230 <printf>
    panic("kerneltrap");
    80001b86:	00006517          	auipc	a0,0x6
    80001b8a:	81250513          	addi	a0,a0,-2030 # 80007398 <etext+0x398>
    80001b8e:	175030ef          	jal	80005502 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b92:	a06ff0ef          	jal	80000d98 <myproc>
    80001b96:	d555                	beqz	a0,80001b42 <kerneltrap+0x34>
    yield();
    80001b98:	faeff0ef          	jal	80001346 <yield>
    80001b9c:	b75d                	j	80001b42 <kerneltrap+0x34>

0000000080001b9e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
    80001ba8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001baa:	9eeff0ef          	jal	80000d98 <myproc>
  switch (n) {
    80001bae:	4795                	li	a5,5
    80001bb0:	0497e163          	bltu	a5,s1,80001bf2 <argraw+0x54>
    80001bb4:	048a                	slli	s1,s1,0x2
    80001bb6:	00006717          	auipc	a4,0x6
    80001bba:	caa70713          	addi	a4,a4,-854 # 80007860 <states.0+0x30>
    80001bbe:	94ba                	add	s1,s1,a4
    80001bc0:	409c                	lw	a5,0(s1)
    80001bc2:	97ba                	add	a5,a5,a4
    80001bc4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bc6:	6d3c                	ld	a5,88(a0)
    80001bc8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6105                	addi	sp,sp,32
    80001bd2:	8082                	ret
    return p->trapframe->a1;
    80001bd4:	6d3c                	ld	a5,88(a0)
    80001bd6:	7fa8                	ld	a0,120(a5)
    80001bd8:	bfcd                	j	80001bca <argraw+0x2c>
    return p->trapframe->a2;
    80001bda:	6d3c                	ld	a5,88(a0)
    80001bdc:	63c8                	ld	a0,128(a5)
    80001bde:	b7f5                	j	80001bca <argraw+0x2c>
    return p->trapframe->a3;
    80001be0:	6d3c                	ld	a5,88(a0)
    80001be2:	67c8                	ld	a0,136(a5)
    80001be4:	b7dd                	j	80001bca <argraw+0x2c>
    return p->trapframe->a4;
    80001be6:	6d3c                	ld	a5,88(a0)
    80001be8:	6bc8                	ld	a0,144(a5)
    80001bea:	b7c5                	j	80001bca <argraw+0x2c>
    return p->trapframe->a5;
    80001bec:	6d3c                	ld	a5,88(a0)
    80001bee:	6fc8                	ld	a0,152(a5)
    80001bf0:	bfe9                	j	80001bca <argraw+0x2c>
  panic("argraw");
    80001bf2:	00005517          	auipc	a0,0x5
    80001bf6:	7b650513          	addi	a0,a0,1974 # 800073a8 <etext+0x3a8>
    80001bfa:	109030ef          	jal	80005502 <panic>

0000000080001bfe <fetchaddr>:
{
    80001bfe:	1101                	addi	sp,sp,-32
    80001c00:	ec06                	sd	ra,24(sp)
    80001c02:	e822                	sd	s0,16(sp)
    80001c04:	e426                	sd	s1,8(sp)
    80001c06:	e04a                	sd	s2,0(sp)
    80001c08:	1000                	addi	s0,sp,32
    80001c0a:	84aa                	mv	s1,a0
    80001c0c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c0e:	98aff0ef          	jal	80000d98 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c12:	653c                	ld	a5,72(a0)
    80001c14:	02f4f663          	bgeu	s1,a5,80001c40 <fetchaddr+0x42>
    80001c18:	00848713          	addi	a4,s1,8
    80001c1c:	02e7e463          	bltu	a5,a4,80001c44 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c20:	46a1                	li	a3,8
    80001c22:	8626                	mv	a2,s1
    80001c24:	85ca                	mv	a1,s2
    80001c26:	6928                	ld	a0,80(a0)
    80001c28:	eb9fe0ef          	jal	80000ae0 <copyin>
    80001c2c:	00a03533          	snez	a0,a0
    80001c30:	40a00533          	neg	a0,a0
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6902                	ld	s2,0(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret
    return -1;
    80001c40:	557d                	li	a0,-1
    80001c42:	bfcd                	j	80001c34 <fetchaddr+0x36>
    80001c44:	557d                	li	a0,-1
    80001c46:	b7fd                	j	80001c34 <fetchaddr+0x36>

0000000080001c48 <fetchstr>:
{
    80001c48:	7179                	addi	sp,sp,-48
    80001c4a:	f406                	sd	ra,40(sp)
    80001c4c:	f022                	sd	s0,32(sp)
    80001c4e:	ec26                	sd	s1,24(sp)
    80001c50:	e84a                	sd	s2,16(sp)
    80001c52:	e44e                	sd	s3,8(sp)
    80001c54:	1800                	addi	s0,sp,48
    80001c56:	892a                	mv	s2,a0
    80001c58:	84ae                	mv	s1,a1
    80001c5a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c5c:	93cff0ef          	jal	80000d98 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c60:	86ce                	mv	a3,s3
    80001c62:	864a                	mv	a2,s2
    80001c64:	85a6                	mv	a1,s1
    80001c66:	6928                	ld	a0,80(a0)
    80001c68:	efffe0ef          	jal	80000b66 <copyinstr>
    80001c6c:	00054c63          	bltz	a0,80001c84 <fetchstr+0x3c>
  return strlen(buf);
    80001c70:	8526                	mv	a0,s1
    80001c72:	e74fe0ef          	jal	800002e6 <strlen>
}
    80001c76:	70a2                	ld	ra,40(sp)
    80001c78:	7402                	ld	s0,32(sp)
    80001c7a:	64e2                	ld	s1,24(sp)
    80001c7c:	6942                	ld	s2,16(sp)
    80001c7e:	69a2                	ld	s3,8(sp)
    80001c80:	6145                	addi	sp,sp,48
    80001c82:	8082                	ret
    return -1;
    80001c84:	557d                	li	a0,-1
    80001c86:	bfc5                	j	80001c76 <fetchstr+0x2e>

0000000080001c88 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	e426                	sd	s1,8(sp)
    80001c90:	1000                	addi	s0,sp,32
    80001c92:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c94:	f0bff0ef          	jal	80001b9e <argraw>
    80001c98:	c088                	sw	a0,0(s1)
}
    80001c9a:	60e2                	ld	ra,24(sp)
    80001c9c:	6442                	ld	s0,16(sp)
    80001c9e:	64a2                	ld	s1,8(sp)
    80001ca0:	6105                	addi	sp,sp,32
    80001ca2:	8082                	ret

0000000080001ca4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001ca4:	1101                	addi	sp,sp,-32
    80001ca6:	ec06                	sd	ra,24(sp)
    80001ca8:	e822                	sd	s0,16(sp)
    80001caa:	e426                	sd	s1,8(sp)
    80001cac:	1000                	addi	s0,sp,32
    80001cae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb0:	eefff0ef          	jal	80001b9e <argraw>
    80001cb4:	e088                	sd	a0,0(s1)
}
    80001cb6:	60e2                	ld	ra,24(sp)
    80001cb8:	6442                	ld	s0,16(sp)
    80001cba:	64a2                	ld	s1,8(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret

0000000080001cc0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cc0:	7179                	addi	sp,sp,-48
    80001cc2:	f406                	sd	ra,40(sp)
    80001cc4:	f022                	sd	s0,32(sp)
    80001cc6:	ec26                	sd	s1,24(sp)
    80001cc8:	e84a                	sd	s2,16(sp)
    80001cca:	1800                	addi	s0,sp,48
    80001ccc:	84ae                	mv	s1,a1
    80001cce:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cd0:	fd840593          	addi	a1,s0,-40
    80001cd4:	fd1ff0ef          	jal	80001ca4 <argaddr>
  return fetchstr(addr, buf, max);
    80001cd8:	864a                	mv	a2,s2
    80001cda:	85a6                	mv	a1,s1
    80001cdc:	fd843503          	ld	a0,-40(s0)
    80001ce0:	f69ff0ef          	jal	80001c48 <fetchstr>
}
    80001ce4:	70a2                	ld	ra,40(sp)
    80001ce6:	7402                	ld	s0,32(sp)
    80001ce8:	64e2                	ld	s1,24(sp)
    80001cea:	6942                	ld	s2,16(sp)
    80001cec:	6145                	addi	sp,sp,48
    80001cee:	8082                	ret

0000000080001cf0 <syscall>:
  "close","trace","sysinfo",
};

void
syscall(void)
{
    80001cf0:	7179                	addi	sp,sp,-48
    80001cf2:	f406                	sd	ra,40(sp)
    80001cf4:	f022                	sd	s0,32(sp)
    80001cf6:	ec26                	sd	s1,24(sp)
    80001cf8:	e84a                	sd	s2,16(sp)
    80001cfa:	e44e                	sd	s3,8(sp)
    80001cfc:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001cfe:	89aff0ef          	jal	80000d98 <myproc>
    80001d02:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d04:	05853903          	ld	s2,88(a0)
    80001d08:	0a893783          	ld	a5,168(s2)
    80001d0c:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) 
    80001d10:	37fd                	addiw	a5,a5,-1
    80001d12:	4759                	li	a4,22
    80001d14:	04f76563          	bltu	a4,a5,80001d5e <syscall+0x6e>
    80001d18:	00399713          	slli	a4,s3,0x3
    80001d1c:	00006797          	auipc	a5,0x6
    80001d20:	b5c78793          	addi	a5,a5,-1188 # 80007878 <syscalls>
    80001d24:	97ba                	add	a5,a5,a4
    80001d26:	639c                	ld	a5,0(a5)
    80001d28:	cb9d                	beqz	a5,80001d5e <syscall+0x6e>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d2a:	9782                	jalr	a5
    80001d2c:	06a93823          	sd	a0,112(s2)

    if(p->trace_mask & (1 << num)) 
    80001d30:	1684a783          	lw	a5,360(s1)
    80001d34:	4137d7bb          	sraw	a5,a5,s3
    80001d38:	8b85                	andi	a5,a5,1
    80001d3a:	cf9d                	beqz	a5,80001d78 <syscall+0x88>
    {  // Kiểm tra bit tương ứng trong trace_mask
      printf("%d: syscall %s -> %ld\n", p->pid, syscallnames[num], p->trapframe->a0);
    80001d3c:	6cb8                	ld	a4,88(s1)
    80001d3e:	098e                	slli	s3,s3,0x3
    80001d40:	00008797          	auipc	a5,0x8
    80001d44:	5e878793          	addi	a5,a5,1512 # 8000a328 <syscallnames>
    80001d48:	97ce                	add	a5,a5,s3
    80001d4a:	7b34                	ld	a3,112(a4)
    80001d4c:	6390                	ld	a2,0(a5)
    80001d4e:	588c                	lw	a1,48(s1)
    80001d50:	00005517          	auipc	a0,0x5
    80001d54:	66050513          	addi	a0,a0,1632 # 800073b0 <etext+0x3b0>
    80001d58:	4d8030ef          	jal	80005230 <printf>
    80001d5c:	a831                	j	80001d78 <syscall+0x88>
    
    } 
  }
  else 
  {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80001d5e:	86ce                	mv	a3,s3
    80001d60:	15848613          	addi	a2,s1,344
    80001d64:	588c                	lw	a1,48(s1)
    80001d66:	00005517          	auipc	a0,0x5
    80001d6a:	66250513          	addi	a0,a0,1634 # 800073c8 <etext+0x3c8>
    80001d6e:	4c2030ef          	jal	80005230 <printf>
    p->trapframe->a0 = -1;
    80001d72:	6cbc                	ld	a5,88(s1)
    80001d74:	577d                	li	a4,-1
    80001d76:	fbb8                	sd	a4,112(a5)
  }
}
    80001d78:	70a2                	ld	ra,40(sp)
    80001d7a:	7402                	ld	s0,32(sp)
    80001d7c:	64e2                	ld	s1,24(sp)
    80001d7e:	6942                	ld	s2,16(sp)
    80001d80:	69a2                	ld	s3,8(sp)
    80001d82:	6145                	addi	sp,sp,48
    80001d84:	8082                	ret

0000000080001d86 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d8e:	fec40593          	addi	a1,s0,-20
    80001d92:	4501                	li	a0,0
    80001d94:	ef5ff0ef          	jal	80001c88 <argint>
  exit(n);
    80001d98:	fec42503          	lw	a0,-20(s0)
    80001d9c:	ee2ff0ef          	jal	8000147e <exit>
  return 0;  // not reached
}
    80001da0:	4501                	li	a0,0
    80001da2:	60e2                	ld	ra,24(sp)
    80001da4:	6442                	ld	s0,16(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret

0000000080001daa <sys_getpid>:

uint64
sys_getpid(void)
{
    80001daa:	1141                	addi	sp,sp,-16
    80001dac:	e406                	sd	ra,8(sp)
    80001dae:	e022                	sd	s0,0(sp)
    80001db0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001db2:	fe7fe0ef          	jal	80000d98 <myproc>
}
    80001db6:	5908                	lw	a0,48(a0)
    80001db8:	60a2                	ld	ra,8(sp)
    80001dba:	6402                	ld	s0,0(sp)
    80001dbc:	0141                	addi	sp,sp,16
    80001dbe:	8082                	ret

0000000080001dc0 <sys_fork>:

uint64
sys_fork(void)
{
    80001dc0:	1141                	addi	sp,sp,-16
    80001dc2:	e406                	sd	ra,8(sp)
    80001dc4:	e022                	sd	s0,0(sp)
    80001dc6:	0800                	addi	s0,sp,16
  return fork();
    80001dc8:	afaff0ef          	jal	800010c2 <fork>
}
    80001dcc:	60a2                	ld	ra,8(sp)
    80001dce:	6402                	ld	s0,0(sp)
    80001dd0:	0141                	addi	sp,sp,16
    80001dd2:	8082                	ret

0000000080001dd4 <sys_wait>:

uint64
sys_wait(void)
{
    80001dd4:	1101                	addi	sp,sp,-32
    80001dd6:	ec06                	sd	ra,24(sp)
    80001dd8:	e822                	sd	s0,16(sp)
    80001dda:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001ddc:	fe840593          	addi	a1,s0,-24
    80001de0:	4501                	li	a0,0
    80001de2:	ec3ff0ef          	jal	80001ca4 <argaddr>
  return wait(p);
    80001de6:	fe843503          	ld	a0,-24(s0)
    80001dea:	feaff0ef          	jal	800015d4 <wait>
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	6105                	addi	sp,sp,32
    80001df4:	8082                	ret

0000000080001df6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001df6:	7179                	addi	sp,sp,-48
    80001df8:	f406                	sd	ra,40(sp)
    80001dfa:	f022                	sd	s0,32(sp)
    80001dfc:	ec26                	sd	s1,24(sp)
    80001dfe:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e00:	fdc40593          	addi	a1,s0,-36
    80001e04:	4501                	li	a0,0
    80001e06:	e83ff0ef          	jal	80001c88 <argint>
  addr = myproc()->sz;
    80001e0a:	f8ffe0ef          	jal	80000d98 <myproc>
    80001e0e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e10:	fdc42503          	lw	a0,-36(s0)
    80001e14:	a5eff0ef          	jal	80001072 <growproc>
    80001e18:	00054863          	bltz	a0,80001e28 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e1c:	8526                	mv	a0,s1
    80001e1e:	70a2                	ld	ra,40(sp)
    80001e20:	7402                	ld	s0,32(sp)
    80001e22:	64e2                	ld	s1,24(sp)
    80001e24:	6145                	addi	sp,sp,48
    80001e26:	8082                	ret
    return -1;
    80001e28:	54fd                	li	s1,-1
    80001e2a:	bfcd                	j	80001e1c <sys_sbrk+0x26>

0000000080001e2c <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e2c:	7139                	addi	sp,sp,-64
    80001e2e:	fc06                	sd	ra,56(sp)
    80001e30:	f822                	sd	s0,48(sp)
    80001e32:	f04a                	sd	s2,32(sp)
    80001e34:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e36:	fcc40593          	addi	a1,s0,-52
    80001e3a:	4501                	li	a0,0
    80001e3c:	e4dff0ef          	jal	80001c88 <argint>
  if(n < 0)
    80001e40:	fcc42783          	lw	a5,-52(s0)
    80001e44:	0607c763          	bltz	a5,80001eb2 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e48:	0000e517          	auipc	a0,0xe
    80001e4c:	64850513          	addi	a0,a0,1608 # 80010490 <tickslock>
    80001e50:	1e1030ef          	jal	80005830 <acquire>
  ticks0 = ticks;
    80001e54:	00008917          	auipc	s2,0x8
    80001e58:	5d492903          	lw	s2,1492(s2) # 8000a428 <ticks>
  while(ticks - ticks0 < n){
    80001e5c:	fcc42783          	lw	a5,-52(s0)
    80001e60:	cf8d                	beqz	a5,80001e9a <sys_sleep+0x6e>
    80001e62:	f426                	sd	s1,40(sp)
    80001e64:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e66:	0000e997          	auipc	s3,0xe
    80001e6a:	62a98993          	addi	s3,s3,1578 # 80010490 <tickslock>
    80001e6e:	00008497          	auipc	s1,0x8
    80001e72:	5ba48493          	addi	s1,s1,1466 # 8000a428 <ticks>
    if(killed(myproc())){
    80001e76:	f23fe0ef          	jal	80000d98 <myproc>
    80001e7a:	f30ff0ef          	jal	800015aa <killed>
    80001e7e:	ed0d                	bnez	a0,80001eb8 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e80:	85ce                	mv	a1,s3
    80001e82:	8526                	mv	a0,s1
    80001e84:	ceeff0ef          	jal	80001372 <sleep>
  while(ticks - ticks0 < n){
    80001e88:	409c                	lw	a5,0(s1)
    80001e8a:	412787bb          	subw	a5,a5,s2
    80001e8e:	fcc42703          	lw	a4,-52(s0)
    80001e92:	fee7e2e3          	bltu	a5,a4,80001e76 <sys_sleep+0x4a>
    80001e96:	74a2                	ld	s1,40(sp)
    80001e98:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e9a:	0000e517          	auipc	a0,0xe
    80001e9e:	5f650513          	addi	a0,a0,1526 # 80010490 <tickslock>
    80001ea2:	227030ef          	jal	800058c8 <release>
  return 0;
    80001ea6:	4501                	li	a0,0
}
    80001ea8:	70e2                	ld	ra,56(sp)
    80001eaa:	7442                	ld	s0,48(sp)
    80001eac:	7902                	ld	s2,32(sp)
    80001eae:	6121                	addi	sp,sp,64
    80001eb0:	8082                	ret
    n = 0;
    80001eb2:	fc042623          	sw	zero,-52(s0)
    80001eb6:	bf49                	j	80001e48 <sys_sleep+0x1c>
      release(&tickslock);
    80001eb8:	0000e517          	auipc	a0,0xe
    80001ebc:	5d850513          	addi	a0,a0,1496 # 80010490 <tickslock>
    80001ec0:	209030ef          	jal	800058c8 <release>
      return -1;
    80001ec4:	557d                	li	a0,-1
    80001ec6:	74a2                	ld	s1,40(sp)
    80001ec8:	69e2                	ld	s3,24(sp)
    80001eca:	bff9                	j	80001ea8 <sys_sleep+0x7c>

0000000080001ecc <sys_kill>:

uint64
sys_kill(void)
{
    80001ecc:	1101                	addi	sp,sp,-32
    80001ece:	ec06                	sd	ra,24(sp)
    80001ed0:	e822                	sd	s0,16(sp)
    80001ed2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ed4:	fec40593          	addi	a1,s0,-20
    80001ed8:	4501                	li	a0,0
    80001eda:	dafff0ef          	jal	80001c88 <argint>
  return kill(pid);
    80001ede:	fec42503          	lw	a0,-20(s0)
    80001ee2:	e3eff0ef          	jal	80001520 <kill>
}
    80001ee6:	60e2                	ld	ra,24(sp)
    80001ee8:	6442                	ld	s0,16(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret

0000000080001eee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001ef8:	0000e517          	auipc	a0,0xe
    80001efc:	59850513          	addi	a0,a0,1432 # 80010490 <tickslock>
    80001f00:	131030ef          	jal	80005830 <acquire>
  xticks = ticks;
    80001f04:	00008497          	auipc	s1,0x8
    80001f08:	5244a483          	lw	s1,1316(s1) # 8000a428 <ticks>
  release(&tickslock);
    80001f0c:	0000e517          	auipc	a0,0xe
    80001f10:	58450513          	addi	a0,a0,1412 # 80010490 <tickslock>
    80001f14:	1b5030ef          	jal	800058c8 <release>
  return xticks;
}
    80001f18:	02049513          	slli	a0,s1,0x20
    80001f1c:	9101                	srli	a0,a0,0x20
    80001f1e:	60e2                	ld	ra,24(sp)
    80001f20:	6442                	ld	s0,16(sp)
    80001f22:	64a2                	ld	s1,8(sp)
    80001f24:	6105                	addi	sp,sp,32
    80001f26:	8082                	ret

0000000080001f28 <sys_trace>:

uint64
sys_trace(void)
{
    80001f28:	1101                	addi	sp,sp,-32
    80001f2a:	ec06                	sd	ra,24(sp)
    80001f2c:	e822                	sd	s0,16(sp)
    80001f2e:	1000                	addi	s0,sp,32
  int mask;

  // Lấy tham số từ user space
  argint(0, &mask);
    80001f30:	fec40593          	addi	a1,s0,-20
    80001f34:	4501                	li	a0,0
    80001f36:	d53ff0ef          	jal	80001c88 <argint>

  // Lưu giá trị mask vào biến trace_mask của tiến trình hiện tại
  struct proc *p = myproc();
    80001f3a:	e5ffe0ef          	jal	80000d98 <myproc>
  p->trace_mask = mask;
    80001f3e:	fec42783          	lw	a5,-20(s0)
    80001f42:	16f52423          	sw	a5,360(a0)

  return 0; // Trả về thành công
}
    80001f46:	4501                	li	a0,0
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	6105                	addi	sp,sp,32
    80001f4e:	8082                	ret

0000000080001f50 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001f50:	7139                	addi	sp,sp,-64
    80001f52:	fc06                	sd	ra,56(sp)
    80001f54:	f822                	sd	s0,48(sp)
    80001f56:	f426                	sd	s1,40(sp)
    80001f58:	0080                	addi	s0,sp,64
  uint64 addr;
  struct sysinfo info;
  struct proc* p = myproc();
    80001f5a:	e3ffe0ef          	jal	80000d98 <myproc>
    80001f5e:	84aa                	mv	s1,a0
  argaddr(0, &addr);
    80001f60:	fd840593          	addi	a1,s0,-40
    80001f64:	4501                	li	a0,0
    80001f66:	d3fff0ef          	jal	80001ca4 <argaddr>
  info.freemem = nfree();
    80001f6a:	9cafe0ef          	jal	80000134 <nfree>
    80001f6e:	fca43423          	sd	a0,-56(s0)
  info.nproc = nproc();
    80001f72:	895ff0ef          	jal	80001806 <nproc>
    80001f76:	fca43823          	sd	a0,-48(s0)

  if(copyout(p->pagetable, addr, (char*)&info, sizeof(info)) < 0)
    80001f7a:	46c1                	li	a3,16
    80001f7c:	fc840613          	addi	a2,s0,-56
    80001f80:	fd843583          	ld	a1,-40(s0)
    80001f84:	68a8                	ld	a0,80(s1)
    80001f86:	a83fe0ef          	jal	80000a08 <copyout>
    return -1;
  return 0;
}
    80001f8a:	957d                	srai	a0,a0,0x3f
    80001f8c:	70e2                	ld	ra,56(sp)
    80001f8e:	7442                	ld	s0,48(sp)
    80001f90:	74a2                	ld	s1,40(sp)
    80001f92:	6121                	addi	sp,sp,64
    80001f94:	8082                	ret

0000000080001f96 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f96:	7179                	addi	sp,sp,-48
    80001f98:	f406                	sd	ra,40(sp)
    80001f9a:	f022                	sd	s0,32(sp)
    80001f9c:	ec26                	sd	s1,24(sp)
    80001f9e:	e84a                	sd	s2,16(sp)
    80001fa0:	e44e                	sd	s3,8(sp)
    80001fa2:	e052                	sd	s4,0(sp)
    80001fa4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fa6:	00005597          	auipc	a1,0x5
    80001faa:	4f258593          	addi	a1,a1,1266 # 80007498 <etext+0x498>
    80001fae:	0000e517          	auipc	a0,0xe
    80001fb2:	4fa50513          	addi	a0,a0,1274 # 800104a8 <bcache>
    80001fb6:	7fa030ef          	jal	800057b0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fba:	00016797          	auipc	a5,0x16
    80001fbe:	4ee78793          	addi	a5,a5,1262 # 800184a8 <bcache+0x8000>
    80001fc2:	00016717          	auipc	a4,0x16
    80001fc6:	74e70713          	addi	a4,a4,1870 # 80018710 <bcache+0x8268>
    80001fca:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fce:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fd2:	0000e497          	auipc	s1,0xe
    80001fd6:	4ee48493          	addi	s1,s1,1262 # 800104c0 <bcache+0x18>
    b->next = bcache.head.next;
    80001fda:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fdc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fde:	00005a17          	auipc	s4,0x5
    80001fe2:	4c2a0a13          	addi	s4,s4,1218 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80001fe6:	2b893783          	ld	a5,696(s2)
    80001fea:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fec:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ff0:	85d2                	mv	a1,s4
    80001ff2:	01048513          	addi	a0,s1,16
    80001ff6:	248010ef          	jal	8000323e <initsleeplock>
    bcache.head.next->prev = b;
    80001ffa:	2b893783          	ld	a5,696(s2)
    80001ffe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002000:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002004:	45848493          	addi	s1,s1,1112
    80002008:	fd349fe3          	bne	s1,s3,80001fe6 <binit+0x50>
  }
}
    8000200c:	70a2                	ld	ra,40(sp)
    8000200e:	7402                	ld	s0,32(sp)
    80002010:	64e2                	ld	s1,24(sp)
    80002012:	6942                	ld	s2,16(sp)
    80002014:	69a2                	ld	s3,8(sp)
    80002016:	6a02                	ld	s4,0(sp)
    80002018:	6145                	addi	sp,sp,48
    8000201a:	8082                	ret

000000008000201c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000201c:	7179                	addi	sp,sp,-48
    8000201e:	f406                	sd	ra,40(sp)
    80002020:	f022                	sd	s0,32(sp)
    80002022:	ec26                	sd	s1,24(sp)
    80002024:	e84a                	sd	s2,16(sp)
    80002026:	e44e                	sd	s3,8(sp)
    80002028:	1800                	addi	s0,sp,48
    8000202a:	892a                	mv	s2,a0
    8000202c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000202e:	0000e517          	auipc	a0,0xe
    80002032:	47a50513          	addi	a0,a0,1146 # 800104a8 <bcache>
    80002036:	7fa030ef          	jal	80005830 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000203a:	00016497          	auipc	s1,0x16
    8000203e:	7264b483          	ld	s1,1830(s1) # 80018760 <bcache+0x82b8>
    80002042:	00016797          	auipc	a5,0x16
    80002046:	6ce78793          	addi	a5,a5,1742 # 80018710 <bcache+0x8268>
    8000204a:	02f48b63          	beq	s1,a5,80002080 <bread+0x64>
    8000204e:	873e                	mv	a4,a5
    80002050:	a021                	j	80002058 <bread+0x3c>
    80002052:	68a4                	ld	s1,80(s1)
    80002054:	02e48663          	beq	s1,a4,80002080 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002058:	449c                	lw	a5,8(s1)
    8000205a:	ff279ce3          	bne	a5,s2,80002052 <bread+0x36>
    8000205e:	44dc                	lw	a5,12(s1)
    80002060:	ff3799e3          	bne	a5,s3,80002052 <bread+0x36>
      b->refcnt++;
    80002064:	40bc                	lw	a5,64(s1)
    80002066:	2785                	addiw	a5,a5,1
    80002068:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000206a:	0000e517          	auipc	a0,0xe
    8000206e:	43e50513          	addi	a0,a0,1086 # 800104a8 <bcache>
    80002072:	057030ef          	jal	800058c8 <release>
      acquiresleep(&b->lock);
    80002076:	01048513          	addi	a0,s1,16
    8000207a:	1fa010ef          	jal	80003274 <acquiresleep>
      return b;
    8000207e:	a889                	j	800020d0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002080:	00016497          	auipc	s1,0x16
    80002084:	6d84b483          	ld	s1,1752(s1) # 80018758 <bcache+0x82b0>
    80002088:	00016797          	auipc	a5,0x16
    8000208c:	68878793          	addi	a5,a5,1672 # 80018710 <bcache+0x8268>
    80002090:	00f48863          	beq	s1,a5,800020a0 <bread+0x84>
    80002094:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002096:	40bc                	lw	a5,64(s1)
    80002098:	cb91                	beqz	a5,800020ac <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000209a:	64a4                	ld	s1,72(s1)
    8000209c:	fee49de3          	bne	s1,a4,80002096 <bread+0x7a>
  panic("bget: no buffers");
    800020a0:	00005517          	auipc	a0,0x5
    800020a4:	40850513          	addi	a0,a0,1032 # 800074a8 <etext+0x4a8>
    800020a8:	45a030ef          	jal	80005502 <panic>
      b->dev = dev;
    800020ac:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020b0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020b4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020b8:	4785                	li	a5,1
    800020ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020bc:	0000e517          	auipc	a0,0xe
    800020c0:	3ec50513          	addi	a0,a0,1004 # 800104a8 <bcache>
    800020c4:	005030ef          	jal	800058c8 <release>
      acquiresleep(&b->lock);
    800020c8:	01048513          	addi	a0,s1,16
    800020cc:	1a8010ef          	jal	80003274 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020d0:	409c                	lw	a5,0(s1)
    800020d2:	cb89                	beqz	a5,800020e4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020d4:	8526                	mv	a0,s1
    800020d6:	70a2                	ld	ra,40(sp)
    800020d8:	7402                	ld	s0,32(sp)
    800020da:	64e2                	ld	s1,24(sp)
    800020dc:	6942                	ld	s2,16(sp)
    800020de:	69a2                	ld	s3,8(sp)
    800020e0:	6145                	addi	sp,sp,48
    800020e2:	8082                	ret
    virtio_disk_rw(b, 0);
    800020e4:	4581                	li	a1,0
    800020e6:	8526                	mv	a0,s1
    800020e8:	1e9020ef          	jal	80004ad0 <virtio_disk_rw>
    b->valid = 1;
    800020ec:	4785                	li	a5,1
    800020ee:	c09c                	sw	a5,0(s1)
  return b;
    800020f0:	b7d5                	j	800020d4 <bread+0xb8>

00000000800020f2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
    800020fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020fe:	0541                	addi	a0,a0,16
    80002100:	1f2010ef          	jal	800032f2 <holdingsleep>
    80002104:	c911                	beqz	a0,80002118 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002106:	4585                	li	a1,1
    80002108:	8526                	mv	a0,s1
    8000210a:	1c7020ef          	jal	80004ad0 <virtio_disk_rw>
}
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	64a2                	ld	s1,8(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret
    panic("bwrite");
    80002118:	00005517          	auipc	a0,0x5
    8000211c:	3a850513          	addi	a0,a0,936 # 800074c0 <etext+0x4c0>
    80002120:	3e2030ef          	jal	80005502 <panic>

0000000080002124 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	e426                	sd	s1,8(sp)
    8000212c:	e04a                	sd	s2,0(sp)
    8000212e:	1000                	addi	s0,sp,32
    80002130:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002132:	01050913          	addi	s2,a0,16
    80002136:	854a                	mv	a0,s2
    80002138:	1ba010ef          	jal	800032f2 <holdingsleep>
    8000213c:	c135                	beqz	a0,800021a0 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000213e:	854a                	mv	a0,s2
    80002140:	17a010ef          	jal	800032ba <releasesleep>

  acquire(&bcache.lock);
    80002144:	0000e517          	auipc	a0,0xe
    80002148:	36450513          	addi	a0,a0,868 # 800104a8 <bcache>
    8000214c:	6e4030ef          	jal	80005830 <acquire>
  b->refcnt--;
    80002150:	40bc                	lw	a5,64(s1)
    80002152:	37fd                	addiw	a5,a5,-1
    80002154:	0007871b          	sext.w	a4,a5
    80002158:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000215a:	e71d                	bnez	a4,80002188 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000215c:	68b8                	ld	a4,80(s1)
    8000215e:	64bc                	ld	a5,72(s1)
    80002160:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002162:	68b8                	ld	a4,80(s1)
    80002164:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002166:	00016797          	auipc	a5,0x16
    8000216a:	34278793          	addi	a5,a5,834 # 800184a8 <bcache+0x8000>
    8000216e:	2b87b703          	ld	a4,696(a5)
    80002172:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002174:	00016717          	auipc	a4,0x16
    80002178:	59c70713          	addi	a4,a4,1436 # 80018710 <bcache+0x8268>
    8000217c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000217e:	2b87b703          	ld	a4,696(a5)
    80002182:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002184:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002188:	0000e517          	auipc	a0,0xe
    8000218c:	32050513          	addi	a0,a0,800 # 800104a8 <bcache>
    80002190:	738030ef          	jal	800058c8 <release>
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6902                	ld	s2,0(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret
    panic("brelse");
    800021a0:	00005517          	auipc	a0,0x5
    800021a4:	32850513          	addi	a0,a0,808 # 800074c8 <etext+0x4c8>
    800021a8:	35a030ef          	jal	80005502 <panic>

00000000800021ac <bpin>:

void
bpin(struct buf *b) {
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	e426                	sd	s1,8(sp)
    800021b4:	1000                	addi	s0,sp,32
    800021b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021b8:	0000e517          	auipc	a0,0xe
    800021bc:	2f050513          	addi	a0,a0,752 # 800104a8 <bcache>
    800021c0:	670030ef          	jal	80005830 <acquire>
  b->refcnt++;
    800021c4:	40bc                	lw	a5,64(s1)
    800021c6:	2785                	addiw	a5,a5,1
    800021c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ca:	0000e517          	auipc	a0,0xe
    800021ce:	2de50513          	addi	a0,a0,734 # 800104a8 <bcache>
    800021d2:	6f6030ef          	jal	800058c8 <release>
}
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	64a2                	ld	s1,8(sp)
    800021dc:	6105                	addi	sp,sp,32
    800021de:	8082                	ret

00000000800021e0 <bunpin>:

void
bunpin(struct buf *b) {
    800021e0:	1101                	addi	sp,sp,-32
    800021e2:	ec06                	sd	ra,24(sp)
    800021e4:	e822                	sd	s0,16(sp)
    800021e6:	e426                	sd	s1,8(sp)
    800021e8:	1000                	addi	s0,sp,32
    800021ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021ec:	0000e517          	auipc	a0,0xe
    800021f0:	2bc50513          	addi	a0,a0,700 # 800104a8 <bcache>
    800021f4:	63c030ef          	jal	80005830 <acquire>
  b->refcnt--;
    800021f8:	40bc                	lw	a5,64(s1)
    800021fa:	37fd                	addiw	a5,a5,-1
    800021fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021fe:	0000e517          	auipc	a0,0xe
    80002202:	2aa50513          	addi	a0,a0,682 # 800104a8 <bcache>
    80002206:	6c2030ef          	jal	800058c8 <release>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	64a2                	ld	s1,8(sp)
    80002210:	6105                	addi	sp,sp,32
    80002212:	8082                	ret

0000000080002214 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	e426                	sd	s1,8(sp)
    8000221c:	e04a                	sd	s2,0(sp)
    8000221e:	1000                	addi	s0,sp,32
    80002220:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002222:	00d5d59b          	srliw	a1,a1,0xd
    80002226:	00017797          	auipc	a5,0x17
    8000222a:	95e7a783          	lw	a5,-1698(a5) # 80018b84 <sb+0x1c>
    8000222e:	9dbd                	addw	a1,a1,a5
    80002230:	dedff0ef          	jal	8000201c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002234:	0074f713          	andi	a4,s1,7
    80002238:	4785                	li	a5,1
    8000223a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000223e:	14ce                	slli	s1,s1,0x33
    80002240:	90d9                	srli	s1,s1,0x36
    80002242:	00950733          	add	a4,a0,s1
    80002246:	05874703          	lbu	a4,88(a4)
    8000224a:	00e7f6b3          	and	a3,a5,a4
    8000224e:	c29d                	beqz	a3,80002274 <bfree+0x60>
    80002250:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002252:	94aa                	add	s1,s1,a0
    80002254:	fff7c793          	not	a5,a5
    80002258:	8f7d                	and	a4,a4,a5
    8000225a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000225e:	711000ef          	jal	8000316e <log_write>
  brelse(bp);
    80002262:	854a                	mv	a0,s2
    80002264:	ec1ff0ef          	jal	80002124 <brelse>
}
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	64a2                	ld	s1,8(sp)
    8000226e:	6902                	ld	s2,0(sp)
    80002270:	6105                	addi	sp,sp,32
    80002272:	8082                	ret
    panic("freeing free block");
    80002274:	00005517          	auipc	a0,0x5
    80002278:	25c50513          	addi	a0,a0,604 # 800074d0 <etext+0x4d0>
    8000227c:	286030ef          	jal	80005502 <panic>

0000000080002280 <balloc>:
{
    80002280:	711d                	addi	sp,sp,-96
    80002282:	ec86                	sd	ra,88(sp)
    80002284:	e8a2                	sd	s0,80(sp)
    80002286:	e4a6                	sd	s1,72(sp)
    80002288:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000228a:	00017797          	auipc	a5,0x17
    8000228e:	8e27a783          	lw	a5,-1822(a5) # 80018b6c <sb+0x4>
    80002292:	0e078f63          	beqz	a5,80002390 <balloc+0x110>
    80002296:	e0ca                	sd	s2,64(sp)
    80002298:	fc4e                	sd	s3,56(sp)
    8000229a:	f852                	sd	s4,48(sp)
    8000229c:	f456                	sd	s5,40(sp)
    8000229e:	f05a                	sd	s6,32(sp)
    800022a0:	ec5e                	sd	s7,24(sp)
    800022a2:	e862                	sd	s8,16(sp)
    800022a4:	e466                	sd	s9,8(sp)
    800022a6:	8baa                	mv	s7,a0
    800022a8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022aa:	00017b17          	auipc	s6,0x17
    800022ae:	8beb0b13          	addi	s6,s6,-1858 # 80018b68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022b2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022b4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022b6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022b8:	6c89                	lui	s9,0x2
    800022ba:	a0b5                	j	80002326 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022bc:	97ca                	add	a5,a5,s2
    800022be:	8e55                	or	a2,a2,a3
    800022c0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022c4:	854a                	mv	a0,s2
    800022c6:	6a9000ef          	jal	8000316e <log_write>
        brelse(bp);
    800022ca:	854a                	mv	a0,s2
    800022cc:	e59ff0ef          	jal	80002124 <brelse>
  bp = bread(dev, bno);
    800022d0:	85a6                	mv	a1,s1
    800022d2:	855e                	mv	a0,s7
    800022d4:	d49ff0ef          	jal	8000201c <bread>
    800022d8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022da:	40000613          	li	a2,1024
    800022de:	4581                	li	a1,0
    800022e0:	05850513          	addi	a0,a0,88
    800022e4:	e93fd0ef          	jal	80000176 <memset>
  log_write(bp);
    800022e8:	854a                	mv	a0,s2
    800022ea:	685000ef          	jal	8000316e <log_write>
  brelse(bp);
    800022ee:	854a                	mv	a0,s2
    800022f0:	e35ff0ef          	jal	80002124 <brelse>
}
    800022f4:	6906                	ld	s2,64(sp)
    800022f6:	79e2                	ld	s3,56(sp)
    800022f8:	7a42                	ld	s4,48(sp)
    800022fa:	7aa2                	ld	s5,40(sp)
    800022fc:	7b02                	ld	s6,32(sp)
    800022fe:	6be2                	ld	s7,24(sp)
    80002300:	6c42                	ld	s8,16(sp)
    80002302:	6ca2                	ld	s9,8(sp)
}
    80002304:	8526                	mv	a0,s1
    80002306:	60e6                	ld	ra,88(sp)
    80002308:	6446                	ld	s0,80(sp)
    8000230a:	64a6                	ld	s1,72(sp)
    8000230c:	6125                	addi	sp,sp,96
    8000230e:	8082                	ret
    brelse(bp);
    80002310:	854a                	mv	a0,s2
    80002312:	e13ff0ef          	jal	80002124 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002316:	015c87bb          	addw	a5,s9,s5
    8000231a:	00078a9b          	sext.w	s5,a5
    8000231e:	004b2703          	lw	a4,4(s6)
    80002322:	04eaff63          	bgeu	s5,a4,80002380 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002326:	41fad79b          	sraiw	a5,s5,0x1f
    8000232a:	0137d79b          	srliw	a5,a5,0x13
    8000232e:	015787bb          	addw	a5,a5,s5
    80002332:	40d7d79b          	sraiw	a5,a5,0xd
    80002336:	01cb2583          	lw	a1,28(s6)
    8000233a:	9dbd                	addw	a1,a1,a5
    8000233c:	855e                	mv	a0,s7
    8000233e:	cdfff0ef          	jal	8000201c <bread>
    80002342:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002344:	004b2503          	lw	a0,4(s6)
    80002348:	000a849b          	sext.w	s1,s5
    8000234c:	8762                	mv	a4,s8
    8000234e:	fca4f1e3          	bgeu	s1,a0,80002310 <balloc+0x90>
      m = 1 << (bi % 8);
    80002352:	00777693          	andi	a3,a4,7
    80002356:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000235a:	41f7579b          	sraiw	a5,a4,0x1f
    8000235e:	01d7d79b          	srliw	a5,a5,0x1d
    80002362:	9fb9                	addw	a5,a5,a4
    80002364:	4037d79b          	sraiw	a5,a5,0x3
    80002368:	00f90633          	add	a2,s2,a5
    8000236c:	05864603          	lbu	a2,88(a2)
    80002370:	00c6f5b3          	and	a1,a3,a2
    80002374:	d5a1                	beqz	a1,800022bc <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002376:	2705                	addiw	a4,a4,1
    80002378:	2485                	addiw	s1,s1,1
    8000237a:	fd471ae3          	bne	a4,s4,8000234e <balloc+0xce>
    8000237e:	bf49                	j	80002310 <balloc+0x90>
    80002380:	6906                	ld	s2,64(sp)
    80002382:	79e2                	ld	s3,56(sp)
    80002384:	7a42                	ld	s4,48(sp)
    80002386:	7aa2                	ld	s5,40(sp)
    80002388:	7b02                	ld	s6,32(sp)
    8000238a:	6be2                	ld	s7,24(sp)
    8000238c:	6c42                	ld	s8,16(sp)
    8000238e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002390:	00005517          	auipc	a0,0x5
    80002394:	15850513          	addi	a0,a0,344 # 800074e8 <etext+0x4e8>
    80002398:	699020ef          	jal	80005230 <printf>
  return 0;
    8000239c:	4481                	li	s1,0
    8000239e:	b79d                	j	80002304 <balloc+0x84>

00000000800023a0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023a0:	7179                	addi	sp,sp,-48
    800023a2:	f406                	sd	ra,40(sp)
    800023a4:	f022                	sd	s0,32(sp)
    800023a6:	ec26                	sd	s1,24(sp)
    800023a8:	e84a                	sd	s2,16(sp)
    800023aa:	e44e                	sd	s3,8(sp)
    800023ac:	1800                	addi	s0,sp,48
    800023ae:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023b0:	47ad                	li	a5,11
    800023b2:	02b7e663          	bltu	a5,a1,800023de <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023b6:	02059793          	slli	a5,a1,0x20
    800023ba:	01e7d593          	srli	a1,a5,0x1e
    800023be:	00b504b3          	add	s1,a0,a1
    800023c2:	0504a903          	lw	s2,80(s1)
    800023c6:	06091a63          	bnez	s2,8000243a <bmap+0x9a>
      addr = balloc(ip->dev);
    800023ca:	4108                	lw	a0,0(a0)
    800023cc:	eb5ff0ef          	jal	80002280 <balloc>
    800023d0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023d4:	06090363          	beqz	s2,8000243a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023d8:	0524a823          	sw	s2,80(s1)
    800023dc:	a8b9                	j	8000243a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023de:	ff45849b          	addiw	s1,a1,-12
    800023e2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023e6:	0ff00793          	li	a5,255
    800023ea:	06e7ee63          	bltu	a5,a4,80002466 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023ee:	08052903          	lw	s2,128(a0)
    800023f2:	00091d63          	bnez	s2,8000240c <bmap+0x6c>
      addr = balloc(ip->dev);
    800023f6:	4108                	lw	a0,0(a0)
    800023f8:	e89ff0ef          	jal	80002280 <balloc>
    800023fc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002400:	02090d63          	beqz	s2,8000243a <bmap+0x9a>
    80002404:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002406:	0929a023          	sw	s2,128(s3)
    8000240a:	a011                	j	8000240e <bmap+0x6e>
    8000240c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000240e:	85ca                	mv	a1,s2
    80002410:	0009a503          	lw	a0,0(s3)
    80002414:	c09ff0ef          	jal	8000201c <bread>
    80002418:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000241a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000241e:	02049713          	slli	a4,s1,0x20
    80002422:	01e75593          	srli	a1,a4,0x1e
    80002426:	00b784b3          	add	s1,a5,a1
    8000242a:	0004a903          	lw	s2,0(s1)
    8000242e:	00090e63          	beqz	s2,8000244a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002432:	8552                	mv	a0,s4
    80002434:	cf1ff0ef          	jal	80002124 <brelse>
    return addr;
    80002438:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000243a:	854a                	mv	a0,s2
    8000243c:	70a2                	ld	ra,40(sp)
    8000243e:	7402                	ld	s0,32(sp)
    80002440:	64e2                	ld	s1,24(sp)
    80002442:	6942                	ld	s2,16(sp)
    80002444:	69a2                	ld	s3,8(sp)
    80002446:	6145                	addi	sp,sp,48
    80002448:	8082                	ret
      addr = balloc(ip->dev);
    8000244a:	0009a503          	lw	a0,0(s3)
    8000244e:	e33ff0ef          	jal	80002280 <balloc>
    80002452:	0005091b          	sext.w	s2,a0
      if(addr){
    80002456:	fc090ee3          	beqz	s2,80002432 <bmap+0x92>
        a[bn] = addr;
    8000245a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000245e:	8552                	mv	a0,s4
    80002460:	50f000ef          	jal	8000316e <log_write>
    80002464:	b7f9                	j	80002432 <bmap+0x92>
    80002466:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002468:	00005517          	auipc	a0,0x5
    8000246c:	09850513          	addi	a0,a0,152 # 80007500 <etext+0x500>
    80002470:	092030ef          	jal	80005502 <panic>

0000000080002474 <iget>:
{
    80002474:	7179                	addi	sp,sp,-48
    80002476:	f406                	sd	ra,40(sp)
    80002478:	f022                	sd	s0,32(sp)
    8000247a:	ec26                	sd	s1,24(sp)
    8000247c:	e84a                	sd	s2,16(sp)
    8000247e:	e44e                	sd	s3,8(sp)
    80002480:	e052                	sd	s4,0(sp)
    80002482:	1800                	addi	s0,sp,48
    80002484:	89aa                	mv	s3,a0
    80002486:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002488:	00016517          	auipc	a0,0x16
    8000248c:	70050513          	addi	a0,a0,1792 # 80018b88 <itable>
    80002490:	3a0030ef          	jal	80005830 <acquire>
  empty = 0;
    80002494:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002496:	00016497          	auipc	s1,0x16
    8000249a:	70a48493          	addi	s1,s1,1802 # 80018ba0 <itable+0x18>
    8000249e:	00018697          	auipc	a3,0x18
    800024a2:	19268693          	addi	a3,a3,402 # 8001a630 <log>
    800024a6:	a039                	j	800024b4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024a8:	02090963          	beqz	s2,800024da <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024ac:	08848493          	addi	s1,s1,136
    800024b0:	02d48863          	beq	s1,a3,800024e0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024b4:	449c                	lw	a5,8(s1)
    800024b6:	fef059e3          	blez	a5,800024a8 <iget+0x34>
    800024ba:	4098                	lw	a4,0(s1)
    800024bc:	ff3716e3          	bne	a4,s3,800024a8 <iget+0x34>
    800024c0:	40d8                	lw	a4,4(s1)
    800024c2:	ff4713e3          	bne	a4,s4,800024a8 <iget+0x34>
      ip->ref++;
    800024c6:	2785                	addiw	a5,a5,1
    800024c8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024ca:	00016517          	auipc	a0,0x16
    800024ce:	6be50513          	addi	a0,a0,1726 # 80018b88 <itable>
    800024d2:	3f6030ef          	jal	800058c8 <release>
      return ip;
    800024d6:	8926                	mv	s2,s1
    800024d8:	a02d                	j	80002502 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024da:	fbe9                	bnez	a5,800024ac <iget+0x38>
      empty = ip;
    800024dc:	8926                	mv	s2,s1
    800024de:	b7f9                	j	800024ac <iget+0x38>
  if(empty == 0)
    800024e0:	02090a63          	beqz	s2,80002514 <iget+0xa0>
  ip->dev = dev;
    800024e4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024e8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024ec:	4785                	li	a5,1
    800024ee:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024f2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024f6:	00016517          	auipc	a0,0x16
    800024fa:	69250513          	addi	a0,a0,1682 # 80018b88 <itable>
    800024fe:	3ca030ef          	jal	800058c8 <release>
}
    80002502:	854a                	mv	a0,s2
    80002504:	70a2                	ld	ra,40(sp)
    80002506:	7402                	ld	s0,32(sp)
    80002508:	64e2                	ld	s1,24(sp)
    8000250a:	6942                	ld	s2,16(sp)
    8000250c:	69a2                	ld	s3,8(sp)
    8000250e:	6a02                	ld	s4,0(sp)
    80002510:	6145                	addi	sp,sp,48
    80002512:	8082                	ret
    panic("iget: no inodes");
    80002514:	00005517          	auipc	a0,0x5
    80002518:	00450513          	addi	a0,a0,4 # 80007518 <etext+0x518>
    8000251c:	7e7020ef          	jal	80005502 <panic>

0000000080002520 <fsinit>:
fsinit(int dev) {
    80002520:	7179                	addi	sp,sp,-48
    80002522:	f406                	sd	ra,40(sp)
    80002524:	f022                	sd	s0,32(sp)
    80002526:	ec26                	sd	s1,24(sp)
    80002528:	e84a                	sd	s2,16(sp)
    8000252a:	e44e                	sd	s3,8(sp)
    8000252c:	1800                	addi	s0,sp,48
    8000252e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002530:	4585                	li	a1,1
    80002532:	aebff0ef          	jal	8000201c <bread>
    80002536:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002538:	00016997          	auipc	s3,0x16
    8000253c:	63098993          	addi	s3,s3,1584 # 80018b68 <sb>
    80002540:	02000613          	li	a2,32
    80002544:	05850593          	addi	a1,a0,88
    80002548:	854e                	mv	a0,s3
    8000254a:	c89fd0ef          	jal	800001d2 <memmove>
  brelse(bp);
    8000254e:	8526                	mv	a0,s1
    80002550:	bd5ff0ef          	jal	80002124 <brelse>
  if(sb.magic != FSMAGIC)
    80002554:	0009a703          	lw	a4,0(s3)
    80002558:	102037b7          	lui	a5,0x10203
    8000255c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002560:	02f71063          	bne	a4,a5,80002580 <fsinit+0x60>
  initlog(dev, &sb);
    80002564:	00016597          	auipc	a1,0x16
    80002568:	60458593          	addi	a1,a1,1540 # 80018b68 <sb>
    8000256c:	854a                	mv	a0,s2
    8000256e:	1f9000ef          	jal	80002f66 <initlog>
}
    80002572:	70a2                	ld	ra,40(sp)
    80002574:	7402                	ld	s0,32(sp)
    80002576:	64e2                	ld	s1,24(sp)
    80002578:	6942                	ld	s2,16(sp)
    8000257a:	69a2                	ld	s3,8(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret
    panic("invalid file system");
    80002580:	00005517          	auipc	a0,0x5
    80002584:	fa850513          	addi	a0,a0,-88 # 80007528 <etext+0x528>
    80002588:	77b020ef          	jal	80005502 <panic>

000000008000258c <iinit>:
{
    8000258c:	7179                	addi	sp,sp,-48
    8000258e:	f406                	sd	ra,40(sp)
    80002590:	f022                	sd	s0,32(sp)
    80002592:	ec26                	sd	s1,24(sp)
    80002594:	e84a                	sd	s2,16(sp)
    80002596:	e44e                	sd	s3,8(sp)
    80002598:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000259a:	00005597          	auipc	a1,0x5
    8000259e:	fa658593          	addi	a1,a1,-90 # 80007540 <etext+0x540>
    800025a2:	00016517          	auipc	a0,0x16
    800025a6:	5e650513          	addi	a0,a0,1510 # 80018b88 <itable>
    800025aa:	206030ef          	jal	800057b0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025ae:	00016497          	auipc	s1,0x16
    800025b2:	60248493          	addi	s1,s1,1538 # 80018bb0 <itable+0x28>
    800025b6:	00018997          	auipc	s3,0x18
    800025ba:	08a98993          	addi	s3,s3,138 # 8001a640 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025be:	00005917          	auipc	s2,0x5
    800025c2:	f8a90913          	addi	s2,s2,-118 # 80007548 <etext+0x548>
    800025c6:	85ca                	mv	a1,s2
    800025c8:	8526                	mv	a0,s1
    800025ca:	475000ef          	jal	8000323e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025ce:	08848493          	addi	s1,s1,136
    800025d2:	ff349ae3          	bne	s1,s3,800025c6 <iinit+0x3a>
}
    800025d6:	70a2                	ld	ra,40(sp)
    800025d8:	7402                	ld	s0,32(sp)
    800025da:	64e2                	ld	s1,24(sp)
    800025dc:	6942                	ld	s2,16(sp)
    800025de:	69a2                	ld	s3,8(sp)
    800025e0:	6145                	addi	sp,sp,48
    800025e2:	8082                	ret

00000000800025e4 <ialloc>:
{
    800025e4:	7139                	addi	sp,sp,-64
    800025e6:	fc06                	sd	ra,56(sp)
    800025e8:	f822                	sd	s0,48(sp)
    800025ea:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025ec:	00016717          	auipc	a4,0x16
    800025f0:	58872703          	lw	a4,1416(a4) # 80018b74 <sb+0xc>
    800025f4:	4785                	li	a5,1
    800025f6:	06e7f063          	bgeu	a5,a4,80002656 <ialloc+0x72>
    800025fa:	f426                	sd	s1,40(sp)
    800025fc:	f04a                	sd	s2,32(sp)
    800025fe:	ec4e                	sd	s3,24(sp)
    80002600:	e852                	sd	s4,16(sp)
    80002602:	e456                	sd	s5,8(sp)
    80002604:	e05a                	sd	s6,0(sp)
    80002606:	8aaa                	mv	s5,a0
    80002608:	8b2e                	mv	s6,a1
    8000260a:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000260c:	00016a17          	auipc	s4,0x16
    80002610:	55ca0a13          	addi	s4,s4,1372 # 80018b68 <sb>
    80002614:	00495593          	srli	a1,s2,0x4
    80002618:	018a2783          	lw	a5,24(s4)
    8000261c:	9dbd                	addw	a1,a1,a5
    8000261e:	8556                	mv	a0,s5
    80002620:	9fdff0ef          	jal	8000201c <bread>
    80002624:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002626:	05850993          	addi	s3,a0,88
    8000262a:	00f97793          	andi	a5,s2,15
    8000262e:	079a                	slli	a5,a5,0x6
    80002630:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002632:	00099783          	lh	a5,0(s3)
    80002636:	cb9d                	beqz	a5,8000266c <ialloc+0x88>
    brelse(bp);
    80002638:	aedff0ef          	jal	80002124 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000263c:	0905                	addi	s2,s2,1
    8000263e:	00ca2703          	lw	a4,12(s4)
    80002642:	0009079b          	sext.w	a5,s2
    80002646:	fce7e7e3          	bltu	a5,a4,80002614 <ialloc+0x30>
    8000264a:	74a2                	ld	s1,40(sp)
    8000264c:	7902                	ld	s2,32(sp)
    8000264e:	69e2                	ld	s3,24(sp)
    80002650:	6a42                	ld	s4,16(sp)
    80002652:	6aa2                	ld	s5,8(sp)
    80002654:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002656:	00005517          	auipc	a0,0x5
    8000265a:	efa50513          	addi	a0,a0,-262 # 80007550 <etext+0x550>
    8000265e:	3d3020ef          	jal	80005230 <printf>
  return 0;
    80002662:	4501                	li	a0,0
}
    80002664:	70e2                	ld	ra,56(sp)
    80002666:	7442                	ld	s0,48(sp)
    80002668:	6121                	addi	sp,sp,64
    8000266a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000266c:	04000613          	li	a2,64
    80002670:	4581                	li	a1,0
    80002672:	854e                	mv	a0,s3
    80002674:	b03fd0ef          	jal	80000176 <memset>
      dip->type = type;
    80002678:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000267c:	8526                	mv	a0,s1
    8000267e:	2f1000ef          	jal	8000316e <log_write>
      brelse(bp);
    80002682:	8526                	mv	a0,s1
    80002684:	aa1ff0ef          	jal	80002124 <brelse>
      return iget(dev, inum);
    80002688:	0009059b          	sext.w	a1,s2
    8000268c:	8556                	mv	a0,s5
    8000268e:	de7ff0ef          	jal	80002474 <iget>
    80002692:	74a2                	ld	s1,40(sp)
    80002694:	7902                	ld	s2,32(sp)
    80002696:	69e2                	ld	s3,24(sp)
    80002698:	6a42                	ld	s4,16(sp)
    8000269a:	6aa2                	ld	s5,8(sp)
    8000269c:	6b02                	ld	s6,0(sp)
    8000269e:	b7d9                	j	80002664 <ialloc+0x80>

00000000800026a0 <iupdate>:
{
    800026a0:	1101                	addi	sp,sp,-32
    800026a2:	ec06                	sd	ra,24(sp)
    800026a4:	e822                	sd	s0,16(sp)
    800026a6:	e426                	sd	s1,8(sp)
    800026a8:	e04a                	sd	s2,0(sp)
    800026aa:	1000                	addi	s0,sp,32
    800026ac:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026ae:	415c                	lw	a5,4(a0)
    800026b0:	0047d79b          	srliw	a5,a5,0x4
    800026b4:	00016597          	auipc	a1,0x16
    800026b8:	4cc5a583          	lw	a1,1228(a1) # 80018b80 <sb+0x18>
    800026bc:	9dbd                	addw	a1,a1,a5
    800026be:	4108                	lw	a0,0(a0)
    800026c0:	95dff0ef          	jal	8000201c <bread>
    800026c4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026c6:	05850793          	addi	a5,a0,88
    800026ca:	40d8                	lw	a4,4(s1)
    800026cc:	8b3d                	andi	a4,a4,15
    800026ce:	071a                	slli	a4,a4,0x6
    800026d0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026d2:	04449703          	lh	a4,68(s1)
    800026d6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026da:	04649703          	lh	a4,70(s1)
    800026de:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026e2:	04849703          	lh	a4,72(s1)
    800026e6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026ea:	04a49703          	lh	a4,74(s1)
    800026ee:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026f2:	44f8                	lw	a4,76(s1)
    800026f4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026f6:	03400613          	li	a2,52
    800026fa:	05048593          	addi	a1,s1,80
    800026fe:	00c78513          	addi	a0,a5,12
    80002702:	ad1fd0ef          	jal	800001d2 <memmove>
  log_write(bp);
    80002706:	854a                	mv	a0,s2
    80002708:	267000ef          	jal	8000316e <log_write>
  brelse(bp);
    8000270c:	854a                	mv	a0,s2
    8000270e:	a17ff0ef          	jal	80002124 <brelse>
}
    80002712:	60e2                	ld	ra,24(sp)
    80002714:	6442                	ld	s0,16(sp)
    80002716:	64a2                	ld	s1,8(sp)
    80002718:	6902                	ld	s2,0(sp)
    8000271a:	6105                	addi	sp,sp,32
    8000271c:	8082                	ret

000000008000271e <idup>:
{
    8000271e:	1101                	addi	sp,sp,-32
    80002720:	ec06                	sd	ra,24(sp)
    80002722:	e822                	sd	s0,16(sp)
    80002724:	e426                	sd	s1,8(sp)
    80002726:	1000                	addi	s0,sp,32
    80002728:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000272a:	00016517          	auipc	a0,0x16
    8000272e:	45e50513          	addi	a0,a0,1118 # 80018b88 <itable>
    80002732:	0fe030ef          	jal	80005830 <acquire>
  ip->ref++;
    80002736:	449c                	lw	a5,8(s1)
    80002738:	2785                	addiw	a5,a5,1
    8000273a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000273c:	00016517          	auipc	a0,0x16
    80002740:	44c50513          	addi	a0,a0,1100 # 80018b88 <itable>
    80002744:	184030ef          	jal	800058c8 <release>
}
    80002748:	8526                	mv	a0,s1
    8000274a:	60e2                	ld	ra,24(sp)
    8000274c:	6442                	ld	s0,16(sp)
    8000274e:	64a2                	ld	s1,8(sp)
    80002750:	6105                	addi	sp,sp,32
    80002752:	8082                	ret

0000000080002754 <ilock>:
{
    80002754:	1101                	addi	sp,sp,-32
    80002756:	ec06                	sd	ra,24(sp)
    80002758:	e822                	sd	s0,16(sp)
    8000275a:	e426                	sd	s1,8(sp)
    8000275c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000275e:	cd19                	beqz	a0,8000277c <ilock+0x28>
    80002760:	84aa                	mv	s1,a0
    80002762:	451c                	lw	a5,8(a0)
    80002764:	00f05c63          	blez	a5,8000277c <ilock+0x28>
  acquiresleep(&ip->lock);
    80002768:	0541                	addi	a0,a0,16
    8000276a:	30b000ef          	jal	80003274 <acquiresleep>
  if(ip->valid == 0){
    8000276e:	40bc                	lw	a5,64(s1)
    80002770:	cf89                	beqz	a5,8000278a <ilock+0x36>
}
    80002772:	60e2                	ld	ra,24(sp)
    80002774:	6442                	ld	s0,16(sp)
    80002776:	64a2                	ld	s1,8(sp)
    80002778:	6105                	addi	sp,sp,32
    8000277a:	8082                	ret
    8000277c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000277e:	00005517          	auipc	a0,0x5
    80002782:	dea50513          	addi	a0,a0,-534 # 80007568 <etext+0x568>
    80002786:	57d020ef          	jal	80005502 <panic>
    8000278a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000278c:	40dc                	lw	a5,4(s1)
    8000278e:	0047d79b          	srliw	a5,a5,0x4
    80002792:	00016597          	auipc	a1,0x16
    80002796:	3ee5a583          	lw	a1,1006(a1) # 80018b80 <sb+0x18>
    8000279a:	9dbd                	addw	a1,a1,a5
    8000279c:	4088                	lw	a0,0(s1)
    8000279e:	87fff0ef          	jal	8000201c <bread>
    800027a2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027a4:	05850593          	addi	a1,a0,88
    800027a8:	40dc                	lw	a5,4(s1)
    800027aa:	8bbd                	andi	a5,a5,15
    800027ac:	079a                	slli	a5,a5,0x6
    800027ae:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027b0:	00059783          	lh	a5,0(a1)
    800027b4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027b8:	00259783          	lh	a5,2(a1)
    800027bc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027c0:	00459783          	lh	a5,4(a1)
    800027c4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027c8:	00659783          	lh	a5,6(a1)
    800027cc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027d0:	459c                	lw	a5,8(a1)
    800027d2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027d4:	03400613          	li	a2,52
    800027d8:	05b1                	addi	a1,a1,12
    800027da:	05048513          	addi	a0,s1,80
    800027de:	9f5fd0ef          	jal	800001d2 <memmove>
    brelse(bp);
    800027e2:	854a                	mv	a0,s2
    800027e4:	941ff0ef          	jal	80002124 <brelse>
    ip->valid = 1;
    800027e8:	4785                	li	a5,1
    800027ea:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027ec:	04449783          	lh	a5,68(s1)
    800027f0:	c399                	beqz	a5,800027f6 <ilock+0xa2>
    800027f2:	6902                	ld	s2,0(sp)
    800027f4:	bfbd                	j	80002772 <ilock+0x1e>
      panic("ilock: no type");
    800027f6:	00005517          	auipc	a0,0x5
    800027fa:	d7a50513          	addi	a0,a0,-646 # 80007570 <etext+0x570>
    800027fe:	505020ef          	jal	80005502 <panic>

0000000080002802 <iunlock>:
{
    80002802:	1101                	addi	sp,sp,-32
    80002804:	ec06                	sd	ra,24(sp)
    80002806:	e822                	sd	s0,16(sp)
    80002808:	e426                	sd	s1,8(sp)
    8000280a:	e04a                	sd	s2,0(sp)
    8000280c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000280e:	c505                	beqz	a0,80002836 <iunlock+0x34>
    80002810:	84aa                	mv	s1,a0
    80002812:	01050913          	addi	s2,a0,16
    80002816:	854a                	mv	a0,s2
    80002818:	2db000ef          	jal	800032f2 <holdingsleep>
    8000281c:	cd09                	beqz	a0,80002836 <iunlock+0x34>
    8000281e:	449c                	lw	a5,8(s1)
    80002820:	00f05b63          	blez	a5,80002836 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002824:	854a                	mv	a0,s2
    80002826:	295000ef          	jal	800032ba <releasesleep>
}
    8000282a:	60e2                	ld	ra,24(sp)
    8000282c:	6442                	ld	s0,16(sp)
    8000282e:	64a2                	ld	s1,8(sp)
    80002830:	6902                	ld	s2,0(sp)
    80002832:	6105                	addi	sp,sp,32
    80002834:	8082                	ret
    panic("iunlock");
    80002836:	00005517          	auipc	a0,0x5
    8000283a:	d4a50513          	addi	a0,a0,-694 # 80007580 <etext+0x580>
    8000283e:	4c5020ef          	jal	80005502 <panic>

0000000080002842 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002842:	7179                	addi	sp,sp,-48
    80002844:	f406                	sd	ra,40(sp)
    80002846:	f022                	sd	s0,32(sp)
    80002848:	ec26                	sd	s1,24(sp)
    8000284a:	e84a                	sd	s2,16(sp)
    8000284c:	e44e                	sd	s3,8(sp)
    8000284e:	1800                	addi	s0,sp,48
    80002850:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002852:	05050493          	addi	s1,a0,80
    80002856:	08050913          	addi	s2,a0,128
    8000285a:	a021                	j	80002862 <itrunc+0x20>
    8000285c:	0491                	addi	s1,s1,4
    8000285e:	01248b63          	beq	s1,s2,80002874 <itrunc+0x32>
    if(ip->addrs[i]){
    80002862:	408c                	lw	a1,0(s1)
    80002864:	dde5                	beqz	a1,8000285c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002866:	0009a503          	lw	a0,0(s3)
    8000286a:	9abff0ef          	jal	80002214 <bfree>
      ip->addrs[i] = 0;
    8000286e:	0004a023          	sw	zero,0(s1)
    80002872:	b7ed                	j	8000285c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002874:	0809a583          	lw	a1,128(s3)
    80002878:	ed89                	bnez	a1,80002892 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000287a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000287e:	854e                	mv	a0,s3
    80002880:	e21ff0ef          	jal	800026a0 <iupdate>
}
    80002884:	70a2                	ld	ra,40(sp)
    80002886:	7402                	ld	s0,32(sp)
    80002888:	64e2                	ld	s1,24(sp)
    8000288a:	6942                	ld	s2,16(sp)
    8000288c:	69a2                	ld	s3,8(sp)
    8000288e:	6145                	addi	sp,sp,48
    80002890:	8082                	ret
    80002892:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002894:	0009a503          	lw	a0,0(s3)
    80002898:	f84ff0ef          	jal	8000201c <bread>
    8000289c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000289e:	05850493          	addi	s1,a0,88
    800028a2:	45850913          	addi	s2,a0,1112
    800028a6:	a021                	j	800028ae <itrunc+0x6c>
    800028a8:	0491                	addi	s1,s1,4
    800028aa:	01248963          	beq	s1,s2,800028bc <itrunc+0x7a>
      if(a[j])
    800028ae:	408c                	lw	a1,0(s1)
    800028b0:	dde5                	beqz	a1,800028a8 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028b2:	0009a503          	lw	a0,0(s3)
    800028b6:	95fff0ef          	jal	80002214 <bfree>
    800028ba:	b7fd                	j	800028a8 <itrunc+0x66>
    brelse(bp);
    800028bc:	8552                	mv	a0,s4
    800028be:	867ff0ef          	jal	80002124 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028c2:	0809a583          	lw	a1,128(s3)
    800028c6:	0009a503          	lw	a0,0(s3)
    800028ca:	94bff0ef          	jal	80002214 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028ce:	0809a023          	sw	zero,128(s3)
    800028d2:	6a02                	ld	s4,0(sp)
    800028d4:	b75d                	j	8000287a <itrunc+0x38>

00000000800028d6 <iput>:
{
    800028d6:	1101                	addi	sp,sp,-32
    800028d8:	ec06                	sd	ra,24(sp)
    800028da:	e822                	sd	s0,16(sp)
    800028dc:	e426                	sd	s1,8(sp)
    800028de:	1000                	addi	s0,sp,32
    800028e0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028e2:	00016517          	auipc	a0,0x16
    800028e6:	2a650513          	addi	a0,a0,678 # 80018b88 <itable>
    800028ea:	747020ef          	jal	80005830 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028ee:	4498                	lw	a4,8(s1)
    800028f0:	4785                	li	a5,1
    800028f2:	02f70063          	beq	a4,a5,80002912 <iput+0x3c>
  ip->ref--;
    800028f6:	449c                	lw	a5,8(s1)
    800028f8:	37fd                	addiw	a5,a5,-1
    800028fa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028fc:	00016517          	auipc	a0,0x16
    80002900:	28c50513          	addi	a0,a0,652 # 80018b88 <itable>
    80002904:	7c5020ef          	jal	800058c8 <release>
}
    80002908:	60e2                	ld	ra,24(sp)
    8000290a:	6442                	ld	s0,16(sp)
    8000290c:	64a2                	ld	s1,8(sp)
    8000290e:	6105                	addi	sp,sp,32
    80002910:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002912:	40bc                	lw	a5,64(s1)
    80002914:	d3ed                	beqz	a5,800028f6 <iput+0x20>
    80002916:	04a49783          	lh	a5,74(s1)
    8000291a:	fff1                	bnez	a5,800028f6 <iput+0x20>
    8000291c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000291e:	01048913          	addi	s2,s1,16
    80002922:	854a                	mv	a0,s2
    80002924:	151000ef          	jal	80003274 <acquiresleep>
    release(&itable.lock);
    80002928:	00016517          	auipc	a0,0x16
    8000292c:	26050513          	addi	a0,a0,608 # 80018b88 <itable>
    80002930:	799020ef          	jal	800058c8 <release>
    itrunc(ip);
    80002934:	8526                	mv	a0,s1
    80002936:	f0dff0ef          	jal	80002842 <itrunc>
    ip->type = 0;
    8000293a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000293e:	8526                	mv	a0,s1
    80002940:	d61ff0ef          	jal	800026a0 <iupdate>
    ip->valid = 0;
    80002944:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002948:	854a                	mv	a0,s2
    8000294a:	171000ef          	jal	800032ba <releasesleep>
    acquire(&itable.lock);
    8000294e:	00016517          	auipc	a0,0x16
    80002952:	23a50513          	addi	a0,a0,570 # 80018b88 <itable>
    80002956:	6db020ef          	jal	80005830 <acquire>
    8000295a:	6902                	ld	s2,0(sp)
    8000295c:	bf69                	j	800028f6 <iput+0x20>

000000008000295e <iunlockput>:
{
    8000295e:	1101                	addi	sp,sp,-32
    80002960:	ec06                	sd	ra,24(sp)
    80002962:	e822                	sd	s0,16(sp)
    80002964:	e426                	sd	s1,8(sp)
    80002966:	1000                	addi	s0,sp,32
    80002968:	84aa                	mv	s1,a0
  iunlock(ip);
    8000296a:	e99ff0ef          	jal	80002802 <iunlock>
  iput(ip);
    8000296e:	8526                	mv	a0,s1
    80002970:	f67ff0ef          	jal	800028d6 <iput>
}
    80002974:	60e2                	ld	ra,24(sp)
    80002976:	6442                	ld	s0,16(sp)
    80002978:	64a2                	ld	s1,8(sp)
    8000297a:	6105                	addi	sp,sp,32
    8000297c:	8082                	ret

000000008000297e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000297e:	1141                	addi	sp,sp,-16
    80002980:	e422                	sd	s0,8(sp)
    80002982:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002984:	411c                	lw	a5,0(a0)
    80002986:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002988:	415c                	lw	a5,4(a0)
    8000298a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000298c:	04451783          	lh	a5,68(a0)
    80002990:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002994:	04a51783          	lh	a5,74(a0)
    80002998:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000299c:	04c56783          	lwu	a5,76(a0)
    800029a0:	e99c                	sd	a5,16(a1)
}
    800029a2:	6422                	ld	s0,8(sp)
    800029a4:	0141                	addi	sp,sp,16
    800029a6:	8082                	ret

00000000800029a8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029a8:	457c                	lw	a5,76(a0)
    800029aa:	0ed7eb63          	bltu	a5,a3,80002aa0 <readi+0xf8>
{
    800029ae:	7159                	addi	sp,sp,-112
    800029b0:	f486                	sd	ra,104(sp)
    800029b2:	f0a2                	sd	s0,96(sp)
    800029b4:	eca6                	sd	s1,88(sp)
    800029b6:	e0d2                	sd	s4,64(sp)
    800029b8:	fc56                	sd	s5,56(sp)
    800029ba:	f85a                	sd	s6,48(sp)
    800029bc:	f45e                	sd	s7,40(sp)
    800029be:	1880                	addi	s0,sp,112
    800029c0:	8b2a                	mv	s6,a0
    800029c2:	8bae                	mv	s7,a1
    800029c4:	8a32                	mv	s4,a2
    800029c6:	84b6                	mv	s1,a3
    800029c8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029ca:	9f35                	addw	a4,a4,a3
    return 0;
    800029cc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029ce:	0cd76063          	bltu	a4,a3,80002a8e <readi+0xe6>
    800029d2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029d4:	00e7f463          	bgeu	a5,a4,800029dc <readi+0x34>
    n = ip->size - off;
    800029d8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029dc:	080a8f63          	beqz	s5,80002a7a <readi+0xd2>
    800029e0:	e8ca                	sd	s2,80(sp)
    800029e2:	f062                	sd	s8,32(sp)
    800029e4:	ec66                	sd	s9,24(sp)
    800029e6:	e86a                	sd	s10,16(sp)
    800029e8:	e46e                	sd	s11,8(sp)
    800029ea:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029ec:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029f0:	5c7d                	li	s8,-1
    800029f2:	a80d                	j	80002a24 <readi+0x7c>
    800029f4:	020d1d93          	slli	s11,s10,0x20
    800029f8:	020ddd93          	srli	s11,s11,0x20
    800029fc:	05890613          	addi	a2,s2,88
    80002a00:	86ee                	mv	a3,s11
    80002a02:	963a                	add	a2,a2,a4
    80002a04:	85d2                	mv	a1,s4
    80002a06:	855e                	mv	a0,s7
    80002a08:	cc7fe0ef          	jal	800016ce <either_copyout>
    80002a0c:	05850763          	beq	a0,s8,80002a5a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a10:	854a                	mv	a0,s2
    80002a12:	f12ff0ef          	jal	80002124 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a16:	013d09bb          	addw	s3,s10,s3
    80002a1a:	009d04bb          	addw	s1,s10,s1
    80002a1e:	9a6e                	add	s4,s4,s11
    80002a20:	0559f763          	bgeu	s3,s5,80002a6e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a24:	00a4d59b          	srliw	a1,s1,0xa
    80002a28:	855a                	mv	a0,s6
    80002a2a:	977ff0ef          	jal	800023a0 <bmap>
    80002a2e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a32:	c5b1                	beqz	a1,80002a7e <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a34:	000b2503          	lw	a0,0(s6)
    80002a38:	de4ff0ef          	jal	8000201c <bread>
    80002a3c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a3e:	3ff4f713          	andi	a4,s1,1023
    80002a42:	40ec87bb          	subw	a5,s9,a4
    80002a46:	413a86bb          	subw	a3,s5,s3
    80002a4a:	8d3e                	mv	s10,a5
    80002a4c:	2781                	sext.w	a5,a5
    80002a4e:	0006861b          	sext.w	a2,a3
    80002a52:	faf671e3          	bgeu	a2,a5,800029f4 <readi+0x4c>
    80002a56:	8d36                	mv	s10,a3
    80002a58:	bf71                	j	800029f4 <readi+0x4c>
      brelse(bp);
    80002a5a:	854a                	mv	a0,s2
    80002a5c:	ec8ff0ef          	jal	80002124 <brelse>
      tot = -1;
    80002a60:	59fd                	li	s3,-1
      break;
    80002a62:	6946                	ld	s2,80(sp)
    80002a64:	7c02                	ld	s8,32(sp)
    80002a66:	6ce2                	ld	s9,24(sp)
    80002a68:	6d42                	ld	s10,16(sp)
    80002a6a:	6da2                	ld	s11,8(sp)
    80002a6c:	a831                	j	80002a88 <readi+0xe0>
    80002a6e:	6946                	ld	s2,80(sp)
    80002a70:	7c02                	ld	s8,32(sp)
    80002a72:	6ce2                	ld	s9,24(sp)
    80002a74:	6d42                	ld	s10,16(sp)
    80002a76:	6da2                	ld	s11,8(sp)
    80002a78:	a801                	j	80002a88 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a7a:	89d6                	mv	s3,s5
    80002a7c:	a031                	j	80002a88 <readi+0xe0>
    80002a7e:	6946                	ld	s2,80(sp)
    80002a80:	7c02                	ld	s8,32(sp)
    80002a82:	6ce2                	ld	s9,24(sp)
    80002a84:	6d42                	ld	s10,16(sp)
    80002a86:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a88:	0009851b          	sext.w	a0,s3
    80002a8c:	69a6                	ld	s3,72(sp)
}
    80002a8e:	70a6                	ld	ra,104(sp)
    80002a90:	7406                	ld	s0,96(sp)
    80002a92:	64e6                	ld	s1,88(sp)
    80002a94:	6a06                	ld	s4,64(sp)
    80002a96:	7ae2                	ld	s5,56(sp)
    80002a98:	7b42                	ld	s6,48(sp)
    80002a9a:	7ba2                	ld	s7,40(sp)
    80002a9c:	6165                	addi	sp,sp,112
    80002a9e:	8082                	ret
    return 0;
    80002aa0:	4501                	li	a0,0
}
    80002aa2:	8082                	ret

0000000080002aa4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002aa4:	457c                	lw	a5,76(a0)
    80002aa6:	10d7e063          	bltu	a5,a3,80002ba6 <writei+0x102>
{
    80002aaa:	7159                	addi	sp,sp,-112
    80002aac:	f486                	sd	ra,104(sp)
    80002aae:	f0a2                	sd	s0,96(sp)
    80002ab0:	e8ca                	sd	s2,80(sp)
    80002ab2:	e0d2                	sd	s4,64(sp)
    80002ab4:	fc56                	sd	s5,56(sp)
    80002ab6:	f85a                	sd	s6,48(sp)
    80002ab8:	f45e                	sd	s7,40(sp)
    80002aba:	1880                	addi	s0,sp,112
    80002abc:	8aaa                	mv	s5,a0
    80002abe:	8bae                	mv	s7,a1
    80002ac0:	8a32                	mv	s4,a2
    80002ac2:	8936                	mv	s2,a3
    80002ac4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ac6:	00e687bb          	addw	a5,a3,a4
    80002aca:	0ed7e063          	bltu	a5,a3,80002baa <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ace:	00043737          	lui	a4,0x43
    80002ad2:	0cf76e63          	bltu	a4,a5,80002bae <writei+0x10a>
    80002ad6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ad8:	0a0b0f63          	beqz	s6,80002b96 <writei+0xf2>
    80002adc:	eca6                	sd	s1,88(sp)
    80002ade:	f062                	sd	s8,32(sp)
    80002ae0:	ec66                	sd	s9,24(sp)
    80002ae2:	e86a                	sd	s10,16(sp)
    80002ae4:	e46e                	sd	s11,8(sp)
    80002ae6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ae8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002aec:	5c7d                	li	s8,-1
    80002aee:	a825                	j	80002b26 <writei+0x82>
    80002af0:	020d1d93          	slli	s11,s10,0x20
    80002af4:	020ddd93          	srli	s11,s11,0x20
    80002af8:	05848513          	addi	a0,s1,88
    80002afc:	86ee                	mv	a3,s11
    80002afe:	8652                	mv	a2,s4
    80002b00:	85de                	mv	a1,s7
    80002b02:	953a                	add	a0,a0,a4
    80002b04:	c15fe0ef          	jal	80001718 <either_copyin>
    80002b08:	05850a63          	beq	a0,s8,80002b5c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b0c:	8526                	mv	a0,s1
    80002b0e:	660000ef          	jal	8000316e <log_write>
    brelse(bp);
    80002b12:	8526                	mv	a0,s1
    80002b14:	e10ff0ef          	jal	80002124 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b18:	013d09bb          	addw	s3,s10,s3
    80002b1c:	012d093b          	addw	s2,s10,s2
    80002b20:	9a6e                	add	s4,s4,s11
    80002b22:	0569f063          	bgeu	s3,s6,80002b62 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b26:	00a9559b          	srliw	a1,s2,0xa
    80002b2a:	8556                	mv	a0,s5
    80002b2c:	875ff0ef          	jal	800023a0 <bmap>
    80002b30:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b34:	c59d                	beqz	a1,80002b62 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b36:	000aa503          	lw	a0,0(s5)
    80002b3a:	ce2ff0ef          	jal	8000201c <bread>
    80002b3e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b40:	3ff97713          	andi	a4,s2,1023
    80002b44:	40ec87bb          	subw	a5,s9,a4
    80002b48:	413b06bb          	subw	a3,s6,s3
    80002b4c:	8d3e                	mv	s10,a5
    80002b4e:	2781                	sext.w	a5,a5
    80002b50:	0006861b          	sext.w	a2,a3
    80002b54:	f8f67ee3          	bgeu	a2,a5,80002af0 <writei+0x4c>
    80002b58:	8d36                	mv	s10,a3
    80002b5a:	bf59                	j	80002af0 <writei+0x4c>
      brelse(bp);
    80002b5c:	8526                	mv	a0,s1
    80002b5e:	dc6ff0ef          	jal	80002124 <brelse>
  }

  if(off > ip->size)
    80002b62:	04caa783          	lw	a5,76(s5)
    80002b66:	0327fa63          	bgeu	a5,s2,80002b9a <writei+0xf6>
    ip->size = off;
    80002b6a:	052aa623          	sw	s2,76(s5)
    80002b6e:	64e6                	ld	s1,88(sp)
    80002b70:	7c02                	ld	s8,32(sp)
    80002b72:	6ce2                	ld	s9,24(sp)
    80002b74:	6d42                	ld	s10,16(sp)
    80002b76:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b78:	8556                	mv	a0,s5
    80002b7a:	b27ff0ef          	jal	800026a0 <iupdate>

  return tot;
    80002b7e:	0009851b          	sext.w	a0,s3
    80002b82:	69a6                	ld	s3,72(sp)
}
    80002b84:	70a6                	ld	ra,104(sp)
    80002b86:	7406                	ld	s0,96(sp)
    80002b88:	6946                	ld	s2,80(sp)
    80002b8a:	6a06                	ld	s4,64(sp)
    80002b8c:	7ae2                	ld	s5,56(sp)
    80002b8e:	7b42                	ld	s6,48(sp)
    80002b90:	7ba2                	ld	s7,40(sp)
    80002b92:	6165                	addi	sp,sp,112
    80002b94:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b96:	89da                	mv	s3,s6
    80002b98:	b7c5                	j	80002b78 <writei+0xd4>
    80002b9a:	64e6                	ld	s1,88(sp)
    80002b9c:	7c02                	ld	s8,32(sp)
    80002b9e:	6ce2                	ld	s9,24(sp)
    80002ba0:	6d42                	ld	s10,16(sp)
    80002ba2:	6da2                	ld	s11,8(sp)
    80002ba4:	bfd1                	j	80002b78 <writei+0xd4>
    return -1;
    80002ba6:	557d                	li	a0,-1
}
    80002ba8:	8082                	ret
    return -1;
    80002baa:	557d                	li	a0,-1
    80002bac:	bfe1                	j	80002b84 <writei+0xe0>
    return -1;
    80002bae:	557d                	li	a0,-1
    80002bb0:	bfd1                	j	80002b84 <writei+0xe0>

0000000080002bb2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bb2:	1141                	addi	sp,sp,-16
    80002bb4:	e406                	sd	ra,8(sp)
    80002bb6:	e022                	sd	s0,0(sp)
    80002bb8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bba:	4639                	li	a2,14
    80002bbc:	e86fd0ef          	jal	80000242 <strncmp>
}
    80002bc0:	60a2                	ld	ra,8(sp)
    80002bc2:	6402                	ld	s0,0(sp)
    80002bc4:	0141                	addi	sp,sp,16
    80002bc6:	8082                	ret

0000000080002bc8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bc8:	7139                	addi	sp,sp,-64
    80002bca:	fc06                	sd	ra,56(sp)
    80002bcc:	f822                	sd	s0,48(sp)
    80002bce:	f426                	sd	s1,40(sp)
    80002bd0:	f04a                	sd	s2,32(sp)
    80002bd2:	ec4e                	sd	s3,24(sp)
    80002bd4:	e852                	sd	s4,16(sp)
    80002bd6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002bd8:	04451703          	lh	a4,68(a0)
    80002bdc:	4785                	li	a5,1
    80002bde:	00f71a63          	bne	a4,a5,80002bf2 <dirlookup+0x2a>
    80002be2:	892a                	mv	s2,a0
    80002be4:	89ae                	mv	s3,a1
    80002be6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002be8:	457c                	lw	a5,76(a0)
    80002bea:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bec:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bee:	e39d                	bnez	a5,80002c14 <dirlookup+0x4c>
    80002bf0:	a095                	j	80002c54 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002bf2:	00005517          	auipc	a0,0x5
    80002bf6:	99650513          	addi	a0,a0,-1642 # 80007588 <etext+0x588>
    80002bfa:	109020ef          	jal	80005502 <panic>
      panic("dirlookup read");
    80002bfe:	00005517          	auipc	a0,0x5
    80002c02:	9a250513          	addi	a0,a0,-1630 # 800075a0 <etext+0x5a0>
    80002c06:	0fd020ef          	jal	80005502 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c0a:	24c1                	addiw	s1,s1,16
    80002c0c:	04c92783          	lw	a5,76(s2)
    80002c10:	04f4f163          	bgeu	s1,a5,80002c52 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c14:	4741                	li	a4,16
    80002c16:	86a6                	mv	a3,s1
    80002c18:	fc040613          	addi	a2,s0,-64
    80002c1c:	4581                	li	a1,0
    80002c1e:	854a                	mv	a0,s2
    80002c20:	d89ff0ef          	jal	800029a8 <readi>
    80002c24:	47c1                	li	a5,16
    80002c26:	fcf51ce3          	bne	a0,a5,80002bfe <dirlookup+0x36>
    if(de.inum == 0)
    80002c2a:	fc045783          	lhu	a5,-64(s0)
    80002c2e:	dff1                	beqz	a5,80002c0a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c30:	fc240593          	addi	a1,s0,-62
    80002c34:	854e                	mv	a0,s3
    80002c36:	f7dff0ef          	jal	80002bb2 <namecmp>
    80002c3a:	f961                	bnez	a0,80002c0a <dirlookup+0x42>
      if(poff)
    80002c3c:	000a0463          	beqz	s4,80002c44 <dirlookup+0x7c>
        *poff = off;
    80002c40:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c44:	fc045583          	lhu	a1,-64(s0)
    80002c48:	00092503          	lw	a0,0(s2)
    80002c4c:	829ff0ef          	jal	80002474 <iget>
    80002c50:	a011                	j	80002c54 <dirlookup+0x8c>
  return 0;
    80002c52:	4501                	li	a0,0
}
    80002c54:	70e2                	ld	ra,56(sp)
    80002c56:	7442                	ld	s0,48(sp)
    80002c58:	74a2                	ld	s1,40(sp)
    80002c5a:	7902                	ld	s2,32(sp)
    80002c5c:	69e2                	ld	s3,24(sp)
    80002c5e:	6a42                	ld	s4,16(sp)
    80002c60:	6121                	addi	sp,sp,64
    80002c62:	8082                	ret

0000000080002c64 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c64:	711d                	addi	sp,sp,-96
    80002c66:	ec86                	sd	ra,88(sp)
    80002c68:	e8a2                	sd	s0,80(sp)
    80002c6a:	e4a6                	sd	s1,72(sp)
    80002c6c:	e0ca                	sd	s2,64(sp)
    80002c6e:	fc4e                	sd	s3,56(sp)
    80002c70:	f852                	sd	s4,48(sp)
    80002c72:	f456                	sd	s5,40(sp)
    80002c74:	f05a                	sd	s6,32(sp)
    80002c76:	ec5e                	sd	s7,24(sp)
    80002c78:	e862                	sd	s8,16(sp)
    80002c7a:	e466                	sd	s9,8(sp)
    80002c7c:	1080                	addi	s0,sp,96
    80002c7e:	84aa                	mv	s1,a0
    80002c80:	8b2e                	mv	s6,a1
    80002c82:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c84:	00054703          	lbu	a4,0(a0)
    80002c88:	02f00793          	li	a5,47
    80002c8c:	00f70e63          	beq	a4,a5,80002ca8 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c90:	908fe0ef          	jal	80000d98 <myproc>
    80002c94:	15053503          	ld	a0,336(a0)
    80002c98:	a87ff0ef          	jal	8000271e <idup>
    80002c9c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c9e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002ca2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002ca4:	4b85                	li	s7,1
    80002ca6:	a871                	j	80002d42 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002ca8:	4585                	li	a1,1
    80002caa:	4505                	li	a0,1
    80002cac:	fc8ff0ef          	jal	80002474 <iget>
    80002cb0:	8a2a                	mv	s4,a0
    80002cb2:	b7f5                	j	80002c9e <namex+0x3a>
      iunlockput(ip);
    80002cb4:	8552                	mv	a0,s4
    80002cb6:	ca9ff0ef          	jal	8000295e <iunlockput>
      return 0;
    80002cba:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cbc:	8552                	mv	a0,s4
    80002cbe:	60e6                	ld	ra,88(sp)
    80002cc0:	6446                	ld	s0,80(sp)
    80002cc2:	64a6                	ld	s1,72(sp)
    80002cc4:	6906                	ld	s2,64(sp)
    80002cc6:	79e2                	ld	s3,56(sp)
    80002cc8:	7a42                	ld	s4,48(sp)
    80002cca:	7aa2                	ld	s5,40(sp)
    80002ccc:	7b02                	ld	s6,32(sp)
    80002cce:	6be2                	ld	s7,24(sp)
    80002cd0:	6c42                	ld	s8,16(sp)
    80002cd2:	6ca2                	ld	s9,8(sp)
    80002cd4:	6125                	addi	sp,sp,96
    80002cd6:	8082                	ret
      iunlock(ip);
    80002cd8:	8552                	mv	a0,s4
    80002cda:	b29ff0ef          	jal	80002802 <iunlock>
      return ip;
    80002cde:	bff9                	j	80002cbc <namex+0x58>
      iunlockput(ip);
    80002ce0:	8552                	mv	a0,s4
    80002ce2:	c7dff0ef          	jal	8000295e <iunlockput>
      return 0;
    80002ce6:	8a4e                	mv	s4,s3
    80002ce8:	bfd1                	j	80002cbc <namex+0x58>
  len = path - s;
    80002cea:	40998633          	sub	a2,s3,s1
    80002cee:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002cf2:	099c5063          	bge	s8,s9,80002d72 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002cf6:	4639                	li	a2,14
    80002cf8:	85a6                	mv	a1,s1
    80002cfa:	8556                	mv	a0,s5
    80002cfc:	cd6fd0ef          	jal	800001d2 <memmove>
    80002d00:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d02:	0004c783          	lbu	a5,0(s1)
    80002d06:	01279763          	bne	a5,s2,80002d14 <namex+0xb0>
    path++;
    80002d0a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d0c:	0004c783          	lbu	a5,0(s1)
    80002d10:	ff278de3          	beq	a5,s2,80002d0a <namex+0xa6>
    ilock(ip);
    80002d14:	8552                	mv	a0,s4
    80002d16:	a3fff0ef          	jal	80002754 <ilock>
    if(ip->type != T_DIR){
    80002d1a:	044a1783          	lh	a5,68(s4)
    80002d1e:	f9779be3          	bne	a5,s7,80002cb4 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d22:	000b0563          	beqz	s6,80002d2c <namex+0xc8>
    80002d26:	0004c783          	lbu	a5,0(s1)
    80002d2a:	d7dd                	beqz	a5,80002cd8 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d2c:	4601                	li	a2,0
    80002d2e:	85d6                	mv	a1,s5
    80002d30:	8552                	mv	a0,s4
    80002d32:	e97ff0ef          	jal	80002bc8 <dirlookup>
    80002d36:	89aa                	mv	s3,a0
    80002d38:	d545                	beqz	a0,80002ce0 <namex+0x7c>
    iunlockput(ip);
    80002d3a:	8552                	mv	a0,s4
    80002d3c:	c23ff0ef          	jal	8000295e <iunlockput>
    ip = next;
    80002d40:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d42:	0004c783          	lbu	a5,0(s1)
    80002d46:	01279763          	bne	a5,s2,80002d54 <namex+0xf0>
    path++;
    80002d4a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d4c:	0004c783          	lbu	a5,0(s1)
    80002d50:	ff278de3          	beq	a5,s2,80002d4a <namex+0xe6>
  if(*path == 0)
    80002d54:	cb8d                	beqz	a5,80002d86 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d56:	0004c783          	lbu	a5,0(s1)
    80002d5a:	89a6                	mv	s3,s1
  len = path - s;
    80002d5c:	4c81                	li	s9,0
    80002d5e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d60:	01278963          	beq	a5,s2,80002d72 <namex+0x10e>
    80002d64:	d3d9                	beqz	a5,80002cea <namex+0x86>
    path++;
    80002d66:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d68:	0009c783          	lbu	a5,0(s3)
    80002d6c:	ff279ce3          	bne	a5,s2,80002d64 <namex+0x100>
    80002d70:	bfad                	j	80002cea <namex+0x86>
    memmove(name, s, len);
    80002d72:	2601                	sext.w	a2,a2
    80002d74:	85a6                	mv	a1,s1
    80002d76:	8556                	mv	a0,s5
    80002d78:	c5afd0ef          	jal	800001d2 <memmove>
    name[len] = 0;
    80002d7c:	9cd6                	add	s9,s9,s5
    80002d7e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d82:	84ce                	mv	s1,s3
    80002d84:	bfbd                	j	80002d02 <namex+0x9e>
  if(nameiparent){
    80002d86:	f20b0be3          	beqz	s6,80002cbc <namex+0x58>
    iput(ip);
    80002d8a:	8552                	mv	a0,s4
    80002d8c:	b4bff0ef          	jal	800028d6 <iput>
    return 0;
    80002d90:	4a01                	li	s4,0
    80002d92:	b72d                	j	80002cbc <namex+0x58>

0000000080002d94 <dirlink>:
{
    80002d94:	7139                	addi	sp,sp,-64
    80002d96:	fc06                	sd	ra,56(sp)
    80002d98:	f822                	sd	s0,48(sp)
    80002d9a:	f04a                	sd	s2,32(sp)
    80002d9c:	ec4e                	sd	s3,24(sp)
    80002d9e:	e852                	sd	s4,16(sp)
    80002da0:	0080                	addi	s0,sp,64
    80002da2:	892a                	mv	s2,a0
    80002da4:	8a2e                	mv	s4,a1
    80002da6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002da8:	4601                	li	a2,0
    80002daa:	e1fff0ef          	jal	80002bc8 <dirlookup>
    80002dae:	e535                	bnez	a0,80002e1a <dirlink+0x86>
    80002db0:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002db2:	04c92483          	lw	s1,76(s2)
    80002db6:	c48d                	beqz	s1,80002de0 <dirlink+0x4c>
    80002db8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dba:	4741                	li	a4,16
    80002dbc:	86a6                	mv	a3,s1
    80002dbe:	fc040613          	addi	a2,s0,-64
    80002dc2:	4581                	li	a1,0
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	be3ff0ef          	jal	800029a8 <readi>
    80002dca:	47c1                	li	a5,16
    80002dcc:	04f51b63          	bne	a0,a5,80002e22 <dirlink+0x8e>
    if(de.inum == 0)
    80002dd0:	fc045783          	lhu	a5,-64(s0)
    80002dd4:	c791                	beqz	a5,80002de0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dd6:	24c1                	addiw	s1,s1,16
    80002dd8:	04c92783          	lw	a5,76(s2)
    80002ddc:	fcf4efe3          	bltu	s1,a5,80002dba <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002de0:	4639                	li	a2,14
    80002de2:	85d2                	mv	a1,s4
    80002de4:	fc240513          	addi	a0,s0,-62
    80002de8:	c90fd0ef          	jal	80000278 <strncpy>
  de.inum = inum;
    80002dec:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002df0:	4741                	li	a4,16
    80002df2:	86a6                	mv	a3,s1
    80002df4:	fc040613          	addi	a2,s0,-64
    80002df8:	4581                	li	a1,0
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	ca9ff0ef          	jal	80002aa4 <writei>
    80002e00:	1541                	addi	a0,a0,-16
    80002e02:	00a03533          	snez	a0,a0
    80002e06:	40a00533          	neg	a0,a0
    80002e0a:	74a2                	ld	s1,40(sp)
}
    80002e0c:	70e2                	ld	ra,56(sp)
    80002e0e:	7442                	ld	s0,48(sp)
    80002e10:	7902                	ld	s2,32(sp)
    80002e12:	69e2                	ld	s3,24(sp)
    80002e14:	6a42                	ld	s4,16(sp)
    80002e16:	6121                	addi	sp,sp,64
    80002e18:	8082                	ret
    iput(ip);
    80002e1a:	abdff0ef          	jal	800028d6 <iput>
    return -1;
    80002e1e:	557d                	li	a0,-1
    80002e20:	b7f5                	j	80002e0c <dirlink+0x78>
      panic("dirlink read");
    80002e22:	00004517          	auipc	a0,0x4
    80002e26:	78e50513          	addi	a0,a0,1934 # 800075b0 <etext+0x5b0>
    80002e2a:	6d8020ef          	jal	80005502 <panic>

0000000080002e2e <namei>:

struct inode*
namei(char *path)
{
    80002e2e:	1101                	addi	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e36:	fe040613          	addi	a2,s0,-32
    80002e3a:	4581                	li	a1,0
    80002e3c:	e29ff0ef          	jal	80002c64 <namex>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret

0000000080002e48 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e48:	1141                	addi	sp,sp,-16
    80002e4a:	e406                	sd	ra,8(sp)
    80002e4c:	e022                	sd	s0,0(sp)
    80002e4e:	0800                	addi	s0,sp,16
    80002e50:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e52:	4585                	li	a1,1
    80002e54:	e11ff0ef          	jal	80002c64 <namex>
}
    80002e58:	60a2                	ld	ra,8(sp)
    80002e5a:	6402                	ld	s0,0(sp)
    80002e5c:	0141                	addi	sp,sp,16
    80002e5e:	8082                	ret

0000000080002e60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	e426                	sd	s1,8(sp)
    80002e68:	e04a                	sd	s2,0(sp)
    80002e6a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e6c:	00017917          	auipc	s2,0x17
    80002e70:	7c490913          	addi	s2,s2,1988 # 8001a630 <log>
    80002e74:	01892583          	lw	a1,24(s2)
    80002e78:	02892503          	lw	a0,40(s2)
    80002e7c:	9a0ff0ef          	jal	8000201c <bread>
    80002e80:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e82:	02c92603          	lw	a2,44(s2)
    80002e86:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e88:	00c05f63          	blez	a2,80002ea6 <write_head+0x46>
    80002e8c:	00017717          	auipc	a4,0x17
    80002e90:	7d470713          	addi	a4,a4,2004 # 8001a660 <log+0x30>
    80002e94:	87aa                	mv	a5,a0
    80002e96:	060a                	slli	a2,a2,0x2
    80002e98:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e9a:	4314                	lw	a3,0(a4)
    80002e9c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e9e:	0711                	addi	a4,a4,4
    80002ea0:	0791                	addi	a5,a5,4
    80002ea2:	fec79ce3          	bne	a5,a2,80002e9a <write_head+0x3a>
  }
  bwrite(buf);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	a4aff0ef          	jal	800020f2 <bwrite>
  brelse(buf);
    80002eac:	8526                	mv	a0,s1
    80002eae:	a76ff0ef          	jal	80002124 <brelse>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6902                	ld	s2,0(sp)
    80002eba:	6105                	addi	sp,sp,32
    80002ebc:	8082                	ret

0000000080002ebe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ebe:	00017797          	auipc	a5,0x17
    80002ec2:	79e7a783          	lw	a5,1950(a5) # 8001a65c <log+0x2c>
    80002ec6:	08f05f63          	blez	a5,80002f64 <install_trans+0xa6>
{
    80002eca:	7139                	addi	sp,sp,-64
    80002ecc:	fc06                	sd	ra,56(sp)
    80002ece:	f822                	sd	s0,48(sp)
    80002ed0:	f426                	sd	s1,40(sp)
    80002ed2:	f04a                	sd	s2,32(sp)
    80002ed4:	ec4e                	sd	s3,24(sp)
    80002ed6:	e852                	sd	s4,16(sp)
    80002ed8:	e456                	sd	s5,8(sp)
    80002eda:	e05a                	sd	s6,0(sp)
    80002edc:	0080                	addi	s0,sp,64
    80002ede:	8b2a                	mv	s6,a0
    80002ee0:	00017a97          	auipc	s5,0x17
    80002ee4:	780a8a93          	addi	s5,s5,1920 # 8001a660 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ee8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002eea:	00017997          	auipc	s3,0x17
    80002eee:	74698993          	addi	s3,s3,1862 # 8001a630 <log>
    80002ef2:	a829                	j	80002f0c <install_trans+0x4e>
    brelse(lbuf);
    80002ef4:	854a                	mv	a0,s2
    80002ef6:	a2eff0ef          	jal	80002124 <brelse>
    brelse(dbuf);
    80002efa:	8526                	mv	a0,s1
    80002efc:	a28ff0ef          	jal	80002124 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f00:	2a05                	addiw	s4,s4,1
    80002f02:	0a91                	addi	s5,s5,4
    80002f04:	02c9a783          	lw	a5,44(s3)
    80002f08:	04fa5463          	bge	s4,a5,80002f50 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f0c:	0189a583          	lw	a1,24(s3)
    80002f10:	014585bb          	addw	a1,a1,s4
    80002f14:	2585                	addiw	a1,a1,1
    80002f16:	0289a503          	lw	a0,40(s3)
    80002f1a:	902ff0ef          	jal	8000201c <bread>
    80002f1e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f20:	000aa583          	lw	a1,0(s5)
    80002f24:	0289a503          	lw	a0,40(s3)
    80002f28:	8f4ff0ef          	jal	8000201c <bread>
    80002f2c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f2e:	40000613          	li	a2,1024
    80002f32:	05890593          	addi	a1,s2,88
    80002f36:	05850513          	addi	a0,a0,88
    80002f3a:	a98fd0ef          	jal	800001d2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f3e:	8526                	mv	a0,s1
    80002f40:	9b2ff0ef          	jal	800020f2 <bwrite>
    if(recovering == 0)
    80002f44:	fa0b18e3          	bnez	s6,80002ef4 <install_trans+0x36>
      bunpin(dbuf);
    80002f48:	8526                	mv	a0,s1
    80002f4a:	a96ff0ef          	jal	800021e0 <bunpin>
    80002f4e:	b75d                	j	80002ef4 <install_trans+0x36>
}
    80002f50:	70e2                	ld	ra,56(sp)
    80002f52:	7442                	ld	s0,48(sp)
    80002f54:	74a2                	ld	s1,40(sp)
    80002f56:	7902                	ld	s2,32(sp)
    80002f58:	69e2                	ld	s3,24(sp)
    80002f5a:	6a42                	ld	s4,16(sp)
    80002f5c:	6aa2                	ld	s5,8(sp)
    80002f5e:	6b02                	ld	s6,0(sp)
    80002f60:	6121                	addi	sp,sp,64
    80002f62:	8082                	ret
    80002f64:	8082                	ret

0000000080002f66 <initlog>:
{
    80002f66:	7179                	addi	sp,sp,-48
    80002f68:	f406                	sd	ra,40(sp)
    80002f6a:	f022                	sd	s0,32(sp)
    80002f6c:	ec26                	sd	s1,24(sp)
    80002f6e:	e84a                	sd	s2,16(sp)
    80002f70:	e44e                	sd	s3,8(sp)
    80002f72:	1800                	addi	s0,sp,48
    80002f74:	892a                	mv	s2,a0
    80002f76:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f78:	00017497          	auipc	s1,0x17
    80002f7c:	6b848493          	addi	s1,s1,1720 # 8001a630 <log>
    80002f80:	00004597          	auipc	a1,0x4
    80002f84:	64058593          	addi	a1,a1,1600 # 800075c0 <etext+0x5c0>
    80002f88:	8526                	mv	a0,s1
    80002f8a:	027020ef          	jal	800057b0 <initlock>
  log.start = sb->logstart;
    80002f8e:	0149a583          	lw	a1,20(s3)
    80002f92:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f94:	0109a783          	lw	a5,16(s3)
    80002f98:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f9a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	87cff0ef          	jal	8000201c <bread>
  log.lh.n = lh->n;
    80002fa4:	4d30                	lw	a2,88(a0)
    80002fa6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fa8:	00c05f63          	blez	a2,80002fc6 <initlog+0x60>
    80002fac:	87aa                	mv	a5,a0
    80002fae:	00017717          	auipc	a4,0x17
    80002fb2:	6b270713          	addi	a4,a4,1714 # 8001a660 <log+0x30>
    80002fb6:	060a                	slli	a2,a2,0x2
    80002fb8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fba:	4ff4                	lw	a3,92(a5)
    80002fbc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fbe:	0791                	addi	a5,a5,4
    80002fc0:	0711                	addi	a4,a4,4
    80002fc2:	fec79ce3          	bne	a5,a2,80002fba <initlog+0x54>
  brelse(buf);
    80002fc6:	95eff0ef          	jal	80002124 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fca:	4505                	li	a0,1
    80002fcc:	ef3ff0ef          	jal	80002ebe <install_trans>
  log.lh.n = 0;
    80002fd0:	00017797          	auipc	a5,0x17
    80002fd4:	6807a623          	sw	zero,1676(a5) # 8001a65c <log+0x2c>
  write_head(); // clear the log
    80002fd8:	e89ff0ef          	jal	80002e60 <write_head>
}
    80002fdc:	70a2                	ld	ra,40(sp)
    80002fde:	7402                	ld	s0,32(sp)
    80002fe0:	64e2                	ld	s1,24(sp)
    80002fe2:	6942                	ld	s2,16(sp)
    80002fe4:	69a2                	ld	s3,8(sp)
    80002fe6:	6145                	addi	sp,sp,48
    80002fe8:	8082                	ret

0000000080002fea <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002fea:	1101                	addi	sp,sp,-32
    80002fec:	ec06                	sd	ra,24(sp)
    80002fee:	e822                	sd	s0,16(sp)
    80002ff0:	e426                	sd	s1,8(sp)
    80002ff2:	e04a                	sd	s2,0(sp)
    80002ff4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ff6:	00017517          	auipc	a0,0x17
    80002ffa:	63a50513          	addi	a0,a0,1594 # 8001a630 <log>
    80002ffe:	033020ef          	jal	80005830 <acquire>
  while(1){
    if(log.committing){
    80003002:	00017497          	auipc	s1,0x17
    80003006:	62e48493          	addi	s1,s1,1582 # 8001a630 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000300a:	4979                	li	s2,30
    8000300c:	a029                	j	80003016 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000300e:	85a6                	mv	a1,s1
    80003010:	8526                	mv	a0,s1
    80003012:	b60fe0ef          	jal	80001372 <sleep>
    if(log.committing){
    80003016:	50dc                	lw	a5,36(s1)
    80003018:	fbfd                	bnez	a5,8000300e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000301a:	5098                	lw	a4,32(s1)
    8000301c:	2705                	addiw	a4,a4,1
    8000301e:	0027179b          	slliw	a5,a4,0x2
    80003022:	9fb9                	addw	a5,a5,a4
    80003024:	0017979b          	slliw	a5,a5,0x1
    80003028:	54d4                	lw	a3,44(s1)
    8000302a:	9fb5                	addw	a5,a5,a3
    8000302c:	00f95763          	bge	s2,a5,8000303a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003030:	85a6                	mv	a1,s1
    80003032:	8526                	mv	a0,s1
    80003034:	b3efe0ef          	jal	80001372 <sleep>
    80003038:	bff9                	j	80003016 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000303a:	00017517          	auipc	a0,0x17
    8000303e:	5f650513          	addi	a0,a0,1526 # 8001a630 <log>
    80003042:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003044:	085020ef          	jal	800058c8 <release>
      break;
    }
  }
}
    80003048:	60e2                	ld	ra,24(sp)
    8000304a:	6442                	ld	s0,16(sp)
    8000304c:	64a2                	ld	s1,8(sp)
    8000304e:	6902                	ld	s2,0(sp)
    80003050:	6105                	addi	sp,sp,32
    80003052:	8082                	ret

0000000080003054 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003054:	7139                	addi	sp,sp,-64
    80003056:	fc06                	sd	ra,56(sp)
    80003058:	f822                	sd	s0,48(sp)
    8000305a:	f426                	sd	s1,40(sp)
    8000305c:	f04a                	sd	s2,32(sp)
    8000305e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003060:	00017497          	auipc	s1,0x17
    80003064:	5d048493          	addi	s1,s1,1488 # 8001a630 <log>
    80003068:	8526                	mv	a0,s1
    8000306a:	7c6020ef          	jal	80005830 <acquire>
  log.outstanding -= 1;
    8000306e:	509c                	lw	a5,32(s1)
    80003070:	37fd                	addiw	a5,a5,-1
    80003072:	0007891b          	sext.w	s2,a5
    80003076:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003078:	50dc                	lw	a5,36(s1)
    8000307a:	ef9d                	bnez	a5,800030b8 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000307c:	04091763          	bnez	s2,800030ca <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003080:	00017497          	auipc	s1,0x17
    80003084:	5b048493          	addi	s1,s1,1456 # 8001a630 <log>
    80003088:	4785                	li	a5,1
    8000308a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000308c:	8526                	mv	a0,s1
    8000308e:	03b020ef          	jal	800058c8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003092:	54dc                	lw	a5,44(s1)
    80003094:	04f04b63          	bgtz	a5,800030ea <end_op+0x96>
    acquire(&log.lock);
    80003098:	00017497          	auipc	s1,0x17
    8000309c:	59848493          	addi	s1,s1,1432 # 8001a630 <log>
    800030a0:	8526                	mv	a0,s1
    800030a2:	78e020ef          	jal	80005830 <acquire>
    log.committing = 0;
    800030a6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030aa:	8526                	mv	a0,s1
    800030ac:	b12fe0ef          	jal	800013be <wakeup>
    release(&log.lock);
    800030b0:	8526                	mv	a0,s1
    800030b2:	017020ef          	jal	800058c8 <release>
}
    800030b6:	a025                	j	800030de <end_op+0x8a>
    800030b8:	ec4e                	sd	s3,24(sp)
    800030ba:	e852                	sd	s4,16(sp)
    800030bc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030be:	00004517          	auipc	a0,0x4
    800030c2:	50a50513          	addi	a0,a0,1290 # 800075c8 <etext+0x5c8>
    800030c6:	43c020ef          	jal	80005502 <panic>
    wakeup(&log);
    800030ca:	00017497          	auipc	s1,0x17
    800030ce:	56648493          	addi	s1,s1,1382 # 8001a630 <log>
    800030d2:	8526                	mv	a0,s1
    800030d4:	aeafe0ef          	jal	800013be <wakeup>
  release(&log.lock);
    800030d8:	8526                	mv	a0,s1
    800030da:	7ee020ef          	jal	800058c8 <release>
}
    800030de:	70e2                	ld	ra,56(sp)
    800030e0:	7442                	ld	s0,48(sp)
    800030e2:	74a2                	ld	s1,40(sp)
    800030e4:	7902                	ld	s2,32(sp)
    800030e6:	6121                	addi	sp,sp,64
    800030e8:	8082                	ret
    800030ea:	ec4e                	sd	s3,24(sp)
    800030ec:	e852                	sd	s4,16(sp)
    800030ee:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030f0:	00017a97          	auipc	s5,0x17
    800030f4:	570a8a93          	addi	s5,s5,1392 # 8001a660 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800030f8:	00017a17          	auipc	s4,0x17
    800030fc:	538a0a13          	addi	s4,s4,1336 # 8001a630 <log>
    80003100:	018a2583          	lw	a1,24(s4)
    80003104:	012585bb          	addw	a1,a1,s2
    80003108:	2585                	addiw	a1,a1,1
    8000310a:	028a2503          	lw	a0,40(s4)
    8000310e:	f0ffe0ef          	jal	8000201c <bread>
    80003112:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003114:	000aa583          	lw	a1,0(s5)
    80003118:	028a2503          	lw	a0,40(s4)
    8000311c:	f01fe0ef          	jal	8000201c <bread>
    80003120:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003122:	40000613          	li	a2,1024
    80003126:	05850593          	addi	a1,a0,88
    8000312a:	05848513          	addi	a0,s1,88
    8000312e:	8a4fd0ef          	jal	800001d2 <memmove>
    bwrite(to);  // write the log
    80003132:	8526                	mv	a0,s1
    80003134:	fbffe0ef          	jal	800020f2 <bwrite>
    brelse(from);
    80003138:	854e                	mv	a0,s3
    8000313a:	febfe0ef          	jal	80002124 <brelse>
    brelse(to);
    8000313e:	8526                	mv	a0,s1
    80003140:	fe5fe0ef          	jal	80002124 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003144:	2905                	addiw	s2,s2,1
    80003146:	0a91                	addi	s5,s5,4
    80003148:	02ca2783          	lw	a5,44(s4)
    8000314c:	faf94ae3          	blt	s2,a5,80003100 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003150:	d11ff0ef          	jal	80002e60 <write_head>
    install_trans(0); // Now install writes to home locations
    80003154:	4501                	li	a0,0
    80003156:	d69ff0ef          	jal	80002ebe <install_trans>
    log.lh.n = 0;
    8000315a:	00017797          	auipc	a5,0x17
    8000315e:	5007a123          	sw	zero,1282(a5) # 8001a65c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003162:	cffff0ef          	jal	80002e60 <write_head>
    80003166:	69e2                	ld	s3,24(sp)
    80003168:	6a42                	ld	s4,16(sp)
    8000316a:	6aa2                	ld	s5,8(sp)
    8000316c:	b735                	j	80003098 <end_op+0x44>

000000008000316e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	e426                	sd	s1,8(sp)
    80003176:	e04a                	sd	s2,0(sp)
    80003178:	1000                	addi	s0,sp,32
    8000317a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000317c:	00017917          	auipc	s2,0x17
    80003180:	4b490913          	addi	s2,s2,1204 # 8001a630 <log>
    80003184:	854a                	mv	a0,s2
    80003186:	6aa020ef          	jal	80005830 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000318a:	02c92603          	lw	a2,44(s2)
    8000318e:	47f5                	li	a5,29
    80003190:	06c7c363          	blt	a5,a2,800031f6 <log_write+0x88>
    80003194:	00017797          	auipc	a5,0x17
    80003198:	4b87a783          	lw	a5,1208(a5) # 8001a64c <log+0x1c>
    8000319c:	37fd                	addiw	a5,a5,-1
    8000319e:	04f65c63          	bge	a2,a5,800031f6 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031a2:	00017797          	auipc	a5,0x17
    800031a6:	4ae7a783          	lw	a5,1198(a5) # 8001a650 <log+0x20>
    800031aa:	04f05c63          	blez	a5,80003202 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031ae:	4781                	li	a5,0
    800031b0:	04c05f63          	blez	a2,8000320e <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031b4:	44cc                	lw	a1,12(s1)
    800031b6:	00017717          	auipc	a4,0x17
    800031ba:	4aa70713          	addi	a4,a4,1194 # 8001a660 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031be:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031c0:	4314                	lw	a3,0(a4)
    800031c2:	04b68663          	beq	a3,a1,8000320e <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031c6:	2785                	addiw	a5,a5,1
    800031c8:	0711                	addi	a4,a4,4
    800031ca:	fef61be3          	bne	a2,a5,800031c0 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031ce:	0621                	addi	a2,a2,8
    800031d0:	060a                	slli	a2,a2,0x2
    800031d2:	00017797          	auipc	a5,0x17
    800031d6:	45e78793          	addi	a5,a5,1118 # 8001a630 <log>
    800031da:	97b2                	add	a5,a5,a2
    800031dc:	44d8                	lw	a4,12(s1)
    800031de:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031e0:	8526                	mv	a0,s1
    800031e2:	fcbfe0ef          	jal	800021ac <bpin>
    log.lh.n++;
    800031e6:	00017717          	auipc	a4,0x17
    800031ea:	44a70713          	addi	a4,a4,1098 # 8001a630 <log>
    800031ee:	575c                	lw	a5,44(a4)
    800031f0:	2785                	addiw	a5,a5,1
    800031f2:	d75c                	sw	a5,44(a4)
    800031f4:	a80d                	j	80003226 <log_write+0xb8>
    panic("too big a transaction");
    800031f6:	00004517          	auipc	a0,0x4
    800031fa:	3e250513          	addi	a0,a0,994 # 800075d8 <etext+0x5d8>
    800031fe:	304020ef          	jal	80005502 <panic>
    panic("log_write outside of trans");
    80003202:	00004517          	auipc	a0,0x4
    80003206:	3ee50513          	addi	a0,a0,1006 # 800075f0 <etext+0x5f0>
    8000320a:	2f8020ef          	jal	80005502 <panic>
  log.lh.block[i] = b->blockno;
    8000320e:	00878693          	addi	a3,a5,8
    80003212:	068a                	slli	a3,a3,0x2
    80003214:	00017717          	auipc	a4,0x17
    80003218:	41c70713          	addi	a4,a4,1052 # 8001a630 <log>
    8000321c:	9736                	add	a4,a4,a3
    8000321e:	44d4                	lw	a3,12(s1)
    80003220:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003222:	faf60fe3          	beq	a2,a5,800031e0 <log_write+0x72>
  }
  release(&log.lock);
    80003226:	00017517          	auipc	a0,0x17
    8000322a:	40a50513          	addi	a0,a0,1034 # 8001a630 <log>
    8000322e:	69a020ef          	jal	800058c8 <release>
}
    80003232:	60e2                	ld	ra,24(sp)
    80003234:	6442                	ld	s0,16(sp)
    80003236:	64a2                	ld	s1,8(sp)
    80003238:	6902                	ld	s2,0(sp)
    8000323a:	6105                	addi	sp,sp,32
    8000323c:	8082                	ret

000000008000323e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000323e:	1101                	addi	sp,sp,-32
    80003240:	ec06                	sd	ra,24(sp)
    80003242:	e822                	sd	s0,16(sp)
    80003244:	e426                	sd	s1,8(sp)
    80003246:	e04a                	sd	s2,0(sp)
    80003248:	1000                	addi	s0,sp,32
    8000324a:	84aa                	mv	s1,a0
    8000324c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000324e:	00004597          	auipc	a1,0x4
    80003252:	3c258593          	addi	a1,a1,962 # 80007610 <etext+0x610>
    80003256:	0521                	addi	a0,a0,8
    80003258:	558020ef          	jal	800057b0 <initlock>
  lk->name = name;
    8000325c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003260:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003264:	0204a423          	sw	zero,40(s1)
}
    80003268:	60e2                	ld	ra,24(sp)
    8000326a:	6442                	ld	s0,16(sp)
    8000326c:	64a2                	ld	s1,8(sp)
    8000326e:	6902                	ld	s2,0(sp)
    80003270:	6105                	addi	sp,sp,32
    80003272:	8082                	ret

0000000080003274 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003274:	1101                	addi	sp,sp,-32
    80003276:	ec06                	sd	ra,24(sp)
    80003278:	e822                	sd	s0,16(sp)
    8000327a:	e426                	sd	s1,8(sp)
    8000327c:	e04a                	sd	s2,0(sp)
    8000327e:	1000                	addi	s0,sp,32
    80003280:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003282:	00850913          	addi	s2,a0,8
    80003286:	854a                	mv	a0,s2
    80003288:	5a8020ef          	jal	80005830 <acquire>
  while (lk->locked) {
    8000328c:	409c                	lw	a5,0(s1)
    8000328e:	c799                	beqz	a5,8000329c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003290:	85ca                	mv	a1,s2
    80003292:	8526                	mv	a0,s1
    80003294:	8defe0ef          	jal	80001372 <sleep>
  while (lk->locked) {
    80003298:	409c                	lw	a5,0(s1)
    8000329a:	fbfd                	bnez	a5,80003290 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000329c:	4785                	li	a5,1
    8000329e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032a0:	af9fd0ef          	jal	80000d98 <myproc>
    800032a4:	591c                	lw	a5,48(a0)
    800032a6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032a8:	854a                	mv	a0,s2
    800032aa:	61e020ef          	jal	800058c8 <release>
}
    800032ae:	60e2                	ld	ra,24(sp)
    800032b0:	6442                	ld	s0,16(sp)
    800032b2:	64a2                	ld	s1,8(sp)
    800032b4:	6902                	ld	s2,0(sp)
    800032b6:	6105                	addi	sp,sp,32
    800032b8:	8082                	ret

00000000800032ba <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	e04a                	sd	s2,0(sp)
    800032c4:	1000                	addi	s0,sp,32
    800032c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032c8:	00850913          	addi	s2,a0,8
    800032cc:	854a                	mv	a0,s2
    800032ce:	562020ef          	jal	80005830 <acquire>
  lk->locked = 0;
    800032d2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032d6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032da:	8526                	mv	a0,s1
    800032dc:	8e2fe0ef          	jal	800013be <wakeup>
  release(&lk->lk);
    800032e0:	854a                	mv	a0,s2
    800032e2:	5e6020ef          	jal	800058c8 <release>
}
    800032e6:	60e2                	ld	ra,24(sp)
    800032e8:	6442                	ld	s0,16(sp)
    800032ea:	64a2                	ld	s1,8(sp)
    800032ec:	6902                	ld	s2,0(sp)
    800032ee:	6105                	addi	sp,sp,32
    800032f0:	8082                	ret

00000000800032f2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032f2:	7179                	addi	sp,sp,-48
    800032f4:	f406                	sd	ra,40(sp)
    800032f6:	f022                	sd	s0,32(sp)
    800032f8:	ec26                	sd	s1,24(sp)
    800032fa:	e84a                	sd	s2,16(sp)
    800032fc:	1800                	addi	s0,sp,48
    800032fe:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003300:	00850913          	addi	s2,a0,8
    80003304:	854a                	mv	a0,s2
    80003306:	52a020ef          	jal	80005830 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000330a:	409c                	lw	a5,0(s1)
    8000330c:	ef81                	bnez	a5,80003324 <holdingsleep+0x32>
    8000330e:	4481                	li	s1,0
  release(&lk->lk);
    80003310:	854a                	mv	a0,s2
    80003312:	5b6020ef          	jal	800058c8 <release>
  return r;
}
    80003316:	8526                	mv	a0,s1
    80003318:	70a2                	ld	ra,40(sp)
    8000331a:	7402                	ld	s0,32(sp)
    8000331c:	64e2                	ld	s1,24(sp)
    8000331e:	6942                	ld	s2,16(sp)
    80003320:	6145                	addi	sp,sp,48
    80003322:	8082                	ret
    80003324:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003326:	0284a983          	lw	s3,40(s1)
    8000332a:	a6ffd0ef          	jal	80000d98 <myproc>
    8000332e:	5904                	lw	s1,48(a0)
    80003330:	413484b3          	sub	s1,s1,s3
    80003334:	0014b493          	seqz	s1,s1
    80003338:	69a2                	ld	s3,8(sp)
    8000333a:	bfd9                	j	80003310 <holdingsleep+0x1e>

000000008000333c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000333c:	1141                	addi	sp,sp,-16
    8000333e:	e406                	sd	ra,8(sp)
    80003340:	e022                	sd	s0,0(sp)
    80003342:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003344:	00004597          	auipc	a1,0x4
    80003348:	2dc58593          	addi	a1,a1,732 # 80007620 <etext+0x620>
    8000334c:	00017517          	auipc	a0,0x17
    80003350:	42c50513          	addi	a0,a0,1068 # 8001a778 <ftable>
    80003354:	45c020ef          	jal	800057b0 <initlock>
}
    80003358:	60a2                	ld	ra,8(sp)
    8000335a:	6402                	ld	s0,0(sp)
    8000335c:	0141                	addi	sp,sp,16
    8000335e:	8082                	ret

0000000080003360 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003360:	1101                	addi	sp,sp,-32
    80003362:	ec06                	sd	ra,24(sp)
    80003364:	e822                	sd	s0,16(sp)
    80003366:	e426                	sd	s1,8(sp)
    80003368:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000336a:	00017517          	auipc	a0,0x17
    8000336e:	40e50513          	addi	a0,a0,1038 # 8001a778 <ftable>
    80003372:	4be020ef          	jal	80005830 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003376:	00017497          	auipc	s1,0x17
    8000337a:	41a48493          	addi	s1,s1,1050 # 8001a790 <ftable+0x18>
    8000337e:	00018717          	auipc	a4,0x18
    80003382:	3b270713          	addi	a4,a4,946 # 8001b730 <disk>
    if(f->ref == 0){
    80003386:	40dc                	lw	a5,4(s1)
    80003388:	cf89                	beqz	a5,800033a2 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000338a:	02848493          	addi	s1,s1,40
    8000338e:	fee49ce3          	bne	s1,a4,80003386 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003392:	00017517          	auipc	a0,0x17
    80003396:	3e650513          	addi	a0,a0,998 # 8001a778 <ftable>
    8000339a:	52e020ef          	jal	800058c8 <release>
  return 0;
    8000339e:	4481                	li	s1,0
    800033a0:	a809                	j	800033b2 <filealloc+0x52>
      f->ref = 1;
    800033a2:	4785                	li	a5,1
    800033a4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033a6:	00017517          	auipc	a0,0x17
    800033aa:	3d250513          	addi	a0,a0,978 # 8001a778 <ftable>
    800033ae:	51a020ef          	jal	800058c8 <release>
}
    800033b2:	8526                	mv	a0,s1
    800033b4:	60e2                	ld	ra,24(sp)
    800033b6:	6442                	ld	s0,16(sp)
    800033b8:	64a2                	ld	s1,8(sp)
    800033ba:	6105                	addi	sp,sp,32
    800033bc:	8082                	ret

00000000800033be <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033be:	1101                	addi	sp,sp,-32
    800033c0:	ec06                	sd	ra,24(sp)
    800033c2:	e822                	sd	s0,16(sp)
    800033c4:	e426                	sd	s1,8(sp)
    800033c6:	1000                	addi	s0,sp,32
    800033c8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033ca:	00017517          	auipc	a0,0x17
    800033ce:	3ae50513          	addi	a0,a0,942 # 8001a778 <ftable>
    800033d2:	45e020ef          	jal	80005830 <acquire>
  if(f->ref < 1)
    800033d6:	40dc                	lw	a5,4(s1)
    800033d8:	02f05063          	blez	a5,800033f8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033dc:	2785                	addiw	a5,a5,1
    800033de:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033e0:	00017517          	auipc	a0,0x17
    800033e4:	39850513          	addi	a0,a0,920 # 8001a778 <ftable>
    800033e8:	4e0020ef          	jal	800058c8 <release>
  return f;
}
    800033ec:	8526                	mv	a0,s1
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	64a2                	ld	s1,8(sp)
    800033f4:	6105                	addi	sp,sp,32
    800033f6:	8082                	ret
    panic("filedup");
    800033f8:	00004517          	auipc	a0,0x4
    800033fc:	23050513          	addi	a0,a0,560 # 80007628 <etext+0x628>
    80003400:	102020ef          	jal	80005502 <panic>

0000000080003404 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003404:	7139                	addi	sp,sp,-64
    80003406:	fc06                	sd	ra,56(sp)
    80003408:	f822                	sd	s0,48(sp)
    8000340a:	f426                	sd	s1,40(sp)
    8000340c:	0080                	addi	s0,sp,64
    8000340e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003410:	00017517          	auipc	a0,0x17
    80003414:	36850513          	addi	a0,a0,872 # 8001a778 <ftable>
    80003418:	418020ef          	jal	80005830 <acquire>
  if(f->ref < 1)
    8000341c:	40dc                	lw	a5,4(s1)
    8000341e:	04f05a63          	blez	a5,80003472 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003422:	37fd                	addiw	a5,a5,-1
    80003424:	0007871b          	sext.w	a4,a5
    80003428:	c0dc                	sw	a5,4(s1)
    8000342a:	04e04e63          	bgtz	a4,80003486 <fileclose+0x82>
    8000342e:	f04a                	sd	s2,32(sp)
    80003430:	ec4e                	sd	s3,24(sp)
    80003432:	e852                	sd	s4,16(sp)
    80003434:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003436:	0004a903          	lw	s2,0(s1)
    8000343a:	0094ca83          	lbu	s5,9(s1)
    8000343e:	0104ba03          	ld	s4,16(s1)
    80003442:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003446:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000344a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000344e:	00017517          	auipc	a0,0x17
    80003452:	32a50513          	addi	a0,a0,810 # 8001a778 <ftable>
    80003456:	472020ef          	jal	800058c8 <release>

  if(ff.type == FD_PIPE){
    8000345a:	4785                	li	a5,1
    8000345c:	04f90063          	beq	s2,a5,8000349c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003460:	3979                	addiw	s2,s2,-2
    80003462:	4785                	li	a5,1
    80003464:	0527f563          	bgeu	a5,s2,800034ae <fileclose+0xaa>
    80003468:	7902                	ld	s2,32(sp)
    8000346a:	69e2                	ld	s3,24(sp)
    8000346c:	6a42                	ld	s4,16(sp)
    8000346e:	6aa2                	ld	s5,8(sp)
    80003470:	a00d                	j	80003492 <fileclose+0x8e>
    80003472:	f04a                	sd	s2,32(sp)
    80003474:	ec4e                	sd	s3,24(sp)
    80003476:	e852                	sd	s4,16(sp)
    80003478:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000347a:	00004517          	auipc	a0,0x4
    8000347e:	1b650513          	addi	a0,a0,438 # 80007630 <etext+0x630>
    80003482:	080020ef          	jal	80005502 <panic>
    release(&ftable.lock);
    80003486:	00017517          	auipc	a0,0x17
    8000348a:	2f250513          	addi	a0,a0,754 # 8001a778 <ftable>
    8000348e:	43a020ef          	jal	800058c8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003492:	70e2                	ld	ra,56(sp)
    80003494:	7442                	ld	s0,48(sp)
    80003496:	74a2                	ld	s1,40(sp)
    80003498:	6121                	addi	sp,sp,64
    8000349a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000349c:	85d6                	mv	a1,s5
    8000349e:	8552                	mv	a0,s4
    800034a0:	336000ef          	jal	800037d6 <pipeclose>
    800034a4:	7902                	ld	s2,32(sp)
    800034a6:	69e2                	ld	s3,24(sp)
    800034a8:	6a42                	ld	s4,16(sp)
    800034aa:	6aa2                	ld	s5,8(sp)
    800034ac:	b7dd                	j	80003492 <fileclose+0x8e>
    begin_op();
    800034ae:	b3dff0ef          	jal	80002fea <begin_op>
    iput(ff.ip);
    800034b2:	854e                	mv	a0,s3
    800034b4:	c22ff0ef          	jal	800028d6 <iput>
    end_op();
    800034b8:	b9dff0ef          	jal	80003054 <end_op>
    800034bc:	7902                	ld	s2,32(sp)
    800034be:	69e2                	ld	s3,24(sp)
    800034c0:	6a42                	ld	s4,16(sp)
    800034c2:	6aa2                	ld	s5,8(sp)
    800034c4:	b7f9                	j	80003492 <fileclose+0x8e>

00000000800034c6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034c6:	715d                	addi	sp,sp,-80
    800034c8:	e486                	sd	ra,72(sp)
    800034ca:	e0a2                	sd	s0,64(sp)
    800034cc:	fc26                	sd	s1,56(sp)
    800034ce:	f44e                	sd	s3,40(sp)
    800034d0:	0880                	addi	s0,sp,80
    800034d2:	84aa                	mv	s1,a0
    800034d4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034d6:	8c3fd0ef          	jal	80000d98 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034da:	409c                	lw	a5,0(s1)
    800034dc:	37f9                	addiw	a5,a5,-2
    800034de:	4705                	li	a4,1
    800034e0:	04f76063          	bltu	a4,a5,80003520 <filestat+0x5a>
    800034e4:	f84a                	sd	s2,48(sp)
    800034e6:	892a                	mv	s2,a0
    ilock(f->ip);
    800034e8:	6c88                	ld	a0,24(s1)
    800034ea:	a6aff0ef          	jal	80002754 <ilock>
    stati(f->ip, &st);
    800034ee:	fb840593          	addi	a1,s0,-72
    800034f2:	6c88                	ld	a0,24(s1)
    800034f4:	c8aff0ef          	jal	8000297e <stati>
    iunlock(f->ip);
    800034f8:	6c88                	ld	a0,24(s1)
    800034fa:	b08ff0ef          	jal	80002802 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800034fe:	46e1                	li	a3,24
    80003500:	fb840613          	addi	a2,s0,-72
    80003504:	85ce                	mv	a1,s3
    80003506:	05093503          	ld	a0,80(s2)
    8000350a:	cfefd0ef          	jal	80000a08 <copyout>
    8000350e:	41f5551b          	sraiw	a0,a0,0x1f
    80003512:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003514:	60a6                	ld	ra,72(sp)
    80003516:	6406                	ld	s0,64(sp)
    80003518:	74e2                	ld	s1,56(sp)
    8000351a:	79a2                	ld	s3,40(sp)
    8000351c:	6161                	addi	sp,sp,80
    8000351e:	8082                	ret
  return -1;
    80003520:	557d                	li	a0,-1
    80003522:	bfcd                	j	80003514 <filestat+0x4e>

0000000080003524 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003524:	7179                	addi	sp,sp,-48
    80003526:	f406                	sd	ra,40(sp)
    80003528:	f022                	sd	s0,32(sp)
    8000352a:	e84a                	sd	s2,16(sp)
    8000352c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000352e:	00854783          	lbu	a5,8(a0)
    80003532:	cfd1                	beqz	a5,800035ce <fileread+0xaa>
    80003534:	ec26                	sd	s1,24(sp)
    80003536:	e44e                	sd	s3,8(sp)
    80003538:	84aa                	mv	s1,a0
    8000353a:	89ae                	mv	s3,a1
    8000353c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000353e:	411c                	lw	a5,0(a0)
    80003540:	4705                	li	a4,1
    80003542:	04e78363          	beq	a5,a4,80003588 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003546:	470d                	li	a4,3
    80003548:	04e78763          	beq	a5,a4,80003596 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000354c:	4709                	li	a4,2
    8000354e:	06e79a63          	bne	a5,a4,800035c2 <fileread+0x9e>
    ilock(f->ip);
    80003552:	6d08                	ld	a0,24(a0)
    80003554:	a00ff0ef          	jal	80002754 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003558:	874a                	mv	a4,s2
    8000355a:	5094                	lw	a3,32(s1)
    8000355c:	864e                	mv	a2,s3
    8000355e:	4585                	li	a1,1
    80003560:	6c88                	ld	a0,24(s1)
    80003562:	c46ff0ef          	jal	800029a8 <readi>
    80003566:	892a                	mv	s2,a0
    80003568:	00a05563          	blez	a0,80003572 <fileread+0x4e>
      f->off += r;
    8000356c:	509c                	lw	a5,32(s1)
    8000356e:	9fa9                	addw	a5,a5,a0
    80003570:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003572:	6c88                	ld	a0,24(s1)
    80003574:	a8eff0ef          	jal	80002802 <iunlock>
    80003578:	64e2                	ld	s1,24(sp)
    8000357a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000357c:	854a                	mv	a0,s2
    8000357e:	70a2                	ld	ra,40(sp)
    80003580:	7402                	ld	s0,32(sp)
    80003582:	6942                	ld	s2,16(sp)
    80003584:	6145                	addi	sp,sp,48
    80003586:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003588:	6908                	ld	a0,16(a0)
    8000358a:	388000ef          	jal	80003912 <piperead>
    8000358e:	892a                	mv	s2,a0
    80003590:	64e2                	ld	s1,24(sp)
    80003592:	69a2                	ld	s3,8(sp)
    80003594:	b7e5                	j	8000357c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003596:	02451783          	lh	a5,36(a0)
    8000359a:	03079693          	slli	a3,a5,0x30
    8000359e:	92c1                	srli	a3,a3,0x30
    800035a0:	4725                	li	a4,9
    800035a2:	02d76863          	bltu	a4,a3,800035d2 <fileread+0xae>
    800035a6:	0792                	slli	a5,a5,0x4
    800035a8:	00017717          	auipc	a4,0x17
    800035ac:	13070713          	addi	a4,a4,304 # 8001a6d8 <devsw>
    800035b0:	97ba                	add	a5,a5,a4
    800035b2:	639c                	ld	a5,0(a5)
    800035b4:	c39d                	beqz	a5,800035da <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035b6:	4505                	li	a0,1
    800035b8:	9782                	jalr	a5
    800035ba:	892a                	mv	s2,a0
    800035bc:	64e2                	ld	s1,24(sp)
    800035be:	69a2                	ld	s3,8(sp)
    800035c0:	bf75                	j	8000357c <fileread+0x58>
    panic("fileread");
    800035c2:	00004517          	auipc	a0,0x4
    800035c6:	07e50513          	addi	a0,a0,126 # 80007640 <etext+0x640>
    800035ca:	739010ef          	jal	80005502 <panic>
    return -1;
    800035ce:	597d                	li	s2,-1
    800035d0:	b775                	j	8000357c <fileread+0x58>
      return -1;
    800035d2:	597d                	li	s2,-1
    800035d4:	64e2                	ld	s1,24(sp)
    800035d6:	69a2                	ld	s3,8(sp)
    800035d8:	b755                	j	8000357c <fileread+0x58>
    800035da:	597d                	li	s2,-1
    800035dc:	64e2                	ld	s1,24(sp)
    800035de:	69a2                	ld	s3,8(sp)
    800035e0:	bf71                	j	8000357c <fileread+0x58>

00000000800035e2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035e2:	00954783          	lbu	a5,9(a0)
    800035e6:	10078b63          	beqz	a5,800036fc <filewrite+0x11a>
{
    800035ea:	715d                	addi	sp,sp,-80
    800035ec:	e486                	sd	ra,72(sp)
    800035ee:	e0a2                	sd	s0,64(sp)
    800035f0:	f84a                	sd	s2,48(sp)
    800035f2:	f052                	sd	s4,32(sp)
    800035f4:	e85a                	sd	s6,16(sp)
    800035f6:	0880                	addi	s0,sp,80
    800035f8:	892a                	mv	s2,a0
    800035fa:	8b2e                	mv	s6,a1
    800035fc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800035fe:	411c                	lw	a5,0(a0)
    80003600:	4705                	li	a4,1
    80003602:	02e78763          	beq	a5,a4,80003630 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003606:	470d                	li	a4,3
    80003608:	02e78863          	beq	a5,a4,80003638 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000360c:	4709                	li	a4,2
    8000360e:	0ce79c63          	bne	a5,a4,800036e6 <filewrite+0x104>
    80003612:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003614:	0ac05863          	blez	a2,800036c4 <filewrite+0xe2>
    80003618:	fc26                	sd	s1,56(sp)
    8000361a:	ec56                	sd	s5,24(sp)
    8000361c:	e45e                	sd	s7,8(sp)
    8000361e:	e062                	sd	s8,0(sp)
    int i = 0;
    80003620:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003622:	6b85                	lui	s7,0x1
    80003624:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003628:	6c05                	lui	s8,0x1
    8000362a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000362e:	a8b5                	j	800036aa <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003630:	6908                	ld	a0,16(a0)
    80003632:	1fc000ef          	jal	8000382e <pipewrite>
    80003636:	a04d                	j	800036d8 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003638:	02451783          	lh	a5,36(a0)
    8000363c:	03079693          	slli	a3,a5,0x30
    80003640:	92c1                	srli	a3,a3,0x30
    80003642:	4725                	li	a4,9
    80003644:	0ad76e63          	bltu	a4,a3,80003700 <filewrite+0x11e>
    80003648:	0792                	slli	a5,a5,0x4
    8000364a:	00017717          	auipc	a4,0x17
    8000364e:	08e70713          	addi	a4,a4,142 # 8001a6d8 <devsw>
    80003652:	97ba                	add	a5,a5,a4
    80003654:	679c                	ld	a5,8(a5)
    80003656:	c7dd                	beqz	a5,80003704 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003658:	4505                	li	a0,1
    8000365a:	9782                	jalr	a5
    8000365c:	a8b5                	j	800036d8 <filewrite+0xf6>
      if(n1 > max)
    8000365e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003662:	989ff0ef          	jal	80002fea <begin_op>
      ilock(f->ip);
    80003666:	01893503          	ld	a0,24(s2)
    8000366a:	8eaff0ef          	jal	80002754 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000366e:	8756                	mv	a4,s5
    80003670:	02092683          	lw	a3,32(s2)
    80003674:	01698633          	add	a2,s3,s6
    80003678:	4585                	li	a1,1
    8000367a:	01893503          	ld	a0,24(s2)
    8000367e:	c26ff0ef          	jal	80002aa4 <writei>
    80003682:	84aa                	mv	s1,a0
    80003684:	00a05763          	blez	a0,80003692 <filewrite+0xb0>
        f->off += r;
    80003688:	02092783          	lw	a5,32(s2)
    8000368c:	9fa9                	addw	a5,a5,a0
    8000368e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003692:	01893503          	ld	a0,24(s2)
    80003696:	96cff0ef          	jal	80002802 <iunlock>
      end_op();
    8000369a:	9bbff0ef          	jal	80003054 <end_op>

      if(r != n1){
    8000369e:	029a9563          	bne	s5,s1,800036c8 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036a2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036a6:	0149da63          	bge	s3,s4,800036ba <filewrite+0xd8>
      int n1 = n - i;
    800036aa:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036ae:	0004879b          	sext.w	a5,s1
    800036b2:	fafbd6e3          	bge	s7,a5,8000365e <filewrite+0x7c>
    800036b6:	84e2                	mv	s1,s8
    800036b8:	b75d                	j	8000365e <filewrite+0x7c>
    800036ba:	74e2                	ld	s1,56(sp)
    800036bc:	6ae2                	ld	s5,24(sp)
    800036be:	6ba2                	ld	s7,8(sp)
    800036c0:	6c02                	ld	s8,0(sp)
    800036c2:	a039                	j	800036d0 <filewrite+0xee>
    int i = 0;
    800036c4:	4981                	li	s3,0
    800036c6:	a029                	j	800036d0 <filewrite+0xee>
    800036c8:	74e2                	ld	s1,56(sp)
    800036ca:	6ae2                	ld	s5,24(sp)
    800036cc:	6ba2                	ld	s7,8(sp)
    800036ce:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800036d0:	033a1c63          	bne	s4,s3,80003708 <filewrite+0x126>
    800036d4:	8552                	mv	a0,s4
    800036d6:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036d8:	60a6                	ld	ra,72(sp)
    800036da:	6406                	ld	s0,64(sp)
    800036dc:	7942                	ld	s2,48(sp)
    800036de:	7a02                	ld	s4,32(sp)
    800036e0:	6b42                	ld	s6,16(sp)
    800036e2:	6161                	addi	sp,sp,80
    800036e4:	8082                	ret
    800036e6:	fc26                	sd	s1,56(sp)
    800036e8:	f44e                	sd	s3,40(sp)
    800036ea:	ec56                	sd	s5,24(sp)
    800036ec:	e45e                	sd	s7,8(sp)
    800036ee:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800036f0:	00004517          	auipc	a0,0x4
    800036f4:	f6050513          	addi	a0,a0,-160 # 80007650 <etext+0x650>
    800036f8:	60b010ef          	jal	80005502 <panic>
    return -1;
    800036fc:	557d                	li	a0,-1
}
    800036fe:	8082                	ret
      return -1;
    80003700:	557d                	li	a0,-1
    80003702:	bfd9                	j	800036d8 <filewrite+0xf6>
    80003704:	557d                	li	a0,-1
    80003706:	bfc9                	j	800036d8 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003708:	557d                	li	a0,-1
    8000370a:	79a2                	ld	s3,40(sp)
    8000370c:	b7f1                	j	800036d8 <filewrite+0xf6>

000000008000370e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000370e:	7179                	addi	sp,sp,-48
    80003710:	f406                	sd	ra,40(sp)
    80003712:	f022                	sd	s0,32(sp)
    80003714:	ec26                	sd	s1,24(sp)
    80003716:	e052                	sd	s4,0(sp)
    80003718:	1800                	addi	s0,sp,48
    8000371a:	84aa                	mv	s1,a0
    8000371c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000371e:	0005b023          	sd	zero,0(a1)
    80003722:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003726:	c3bff0ef          	jal	80003360 <filealloc>
    8000372a:	e088                	sd	a0,0(s1)
    8000372c:	c549                	beqz	a0,800037b6 <pipealloc+0xa8>
    8000372e:	c33ff0ef          	jal	80003360 <filealloc>
    80003732:	00aa3023          	sd	a0,0(s4)
    80003736:	cd25                	beqz	a0,800037ae <pipealloc+0xa0>
    80003738:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000373a:	9bdfc0ef          	jal	800000f6 <kalloc>
    8000373e:	892a                	mv	s2,a0
    80003740:	c12d                	beqz	a0,800037a2 <pipealloc+0x94>
    80003742:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003744:	4985                	li	s3,1
    80003746:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000374a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000374e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003752:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003756:	00004597          	auipc	a1,0x4
    8000375a:	caa58593          	addi	a1,a1,-854 # 80007400 <etext+0x400>
    8000375e:	052020ef          	jal	800057b0 <initlock>
  (*f0)->type = FD_PIPE;
    80003762:	609c                	ld	a5,0(s1)
    80003764:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003768:	609c                	ld	a5,0(s1)
    8000376a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000376e:	609c                	ld	a5,0(s1)
    80003770:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003774:	609c                	ld	a5,0(s1)
    80003776:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000377a:	000a3783          	ld	a5,0(s4)
    8000377e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003782:	000a3783          	ld	a5,0(s4)
    80003786:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000378a:	000a3783          	ld	a5,0(s4)
    8000378e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003792:	000a3783          	ld	a5,0(s4)
    80003796:	0127b823          	sd	s2,16(a5)
  return 0;
    8000379a:	4501                	li	a0,0
    8000379c:	6942                	ld	s2,16(sp)
    8000379e:	69a2                	ld	s3,8(sp)
    800037a0:	a01d                	j	800037c6 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037a2:	6088                	ld	a0,0(s1)
    800037a4:	c119                	beqz	a0,800037aa <pipealloc+0x9c>
    800037a6:	6942                	ld	s2,16(sp)
    800037a8:	a029                	j	800037b2 <pipealloc+0xa4>
    800037aa:	6942                	ld	s2,16(sp)
    800037ac:	a029                	j	800037b6 <pipealloc+0xa8>
    800037ae:	6088                	ld	a0,0(s1)
    800037b0:	c10d                	beqz	a0,800037d2 <pipealloc+0xc4>
    fileclose(*f0);
    800037b2:	c53ff0ef          	jal	80003404 <fileclose>
  if(*f1)
    800037b6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037ba:	557d                	li	a0,-1
  if(*f1)
    800037bc:	c789                	beqz	a5,800037c6 <pipealloc+0xb8>
    fileclose(*f1);
    800037be:	853e                	mv	a0,a5
    800037c0:	c45ff0ef          	jal	80003404 <fileclose>
  return -1;
    800037c4:	557d                	li	a0,-1
}
    800037c6:	70a2                	ld	ra,40(sp)
    800037c8:	7402                	ld	s0,32(sp)
    800037ca:	64e2                	ld	s1,24(sp)
    800037cc:	6a02                	ld	s4,0(sp)
    800037ce:	6145                	addi	sp,sp,48
    800037d0:	8082                	ret
  return -1;
    800037d2:	557d                	li	a0,-1
    800037d4:	bfcd                	j	800037c6 <pipealloc+0xb8>

00000000800037d6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037d6:	1101                	addi	sp,sp,-32
    800037d8:	ec06                	sd	ra,24(sp)
    800037da:	e822                	sd	s0,16(sp)
    800037dc:	e426                	sd	s1,8(sp)
    800037de:	e04a                	sd	s2,0(sp)
    800037e0:	1000                	addi	s0,sp,32
    800037e2:	84aa                	mv	s1,a0
    800037e4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037e6:	04a020ef          	jal	80005830 <acquire>
  if(writable){
    800037ea:	02090763          	beqz	s2,80003818 <pipeclose+0x42>
    pi->writeopen = 0;
    800037ee:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800037f2:	21848513          	addi	a0,s1,536
    800037f6:	bc9fd0ef          	jal	800013be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800037fa:	2204b783          	ld	a5,544(s1)
    800037fe:	e785                	bnez	a5,80003826 <pipeclose+0x50>
    release(&pi->lock);
    80003800:	8526                	mv	a0,s1
    80003802:	0c6020ef          	jal	800058c8 <release>
    kfree((char*)pi);
    80003806:	8526                	mv	a0,s1
    80003808:	815fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000380c:	60e2                	ld	ra,24(sp)
    8000380e:	6442                	ld	s0,16(sp)
    80003810:	64a2                	ld	s1,8(sp)
    80003812:	6902                	ld	s2,0(sp)
    80003814:	6105                	addi	sp,sp,32
    80003816:	8082                	ret
    pi->readopen = 0;
    80003818:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000381c:	21c48513          	addi	a0,s1,540
    80003820:	b9ffd0ef          	jal	800013be <wakeup>
    80003824:	bfd9                	j	800037fa <pipeclose+0x24>
    release(&pi->lock);
    80003826:	8526                	mv	a0,s1
    80003828:	0a0020ef          	jal	800058c8 <release>
}
    8000382c:	b7c5                	j	8000380c <pipeclose+0x36>

000000008000382e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000382e:	711d                	addi	sp,sp,-96
    80003830:	ec86                	sd	ra,88(sp)
    80003832:	e8a2                	sd	s0,80(sp)
    80003834:	e4a6                	sd	s1,72(sp)
    80003836:	e0ca                	sd	s2,64(sp)
    80003838:	fc4e                	sd	s3,56(sp)
    8000383a:	f852                	sd	s4,48(sp)
    8000383c:	f456                	sd	s5,40(sp)
    8000383e:	1080                	addi	s0,sp,96
    80003840:	84aa                	mv	s1,a0
    80003842:	8aae                	mv	s5,a1
    80003844:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003846:	d52fd0ef          	jal	80000d98 <myproc>
    8000384a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000384c:	8526                	mv	a0,s1
    8000384e:	7e3010ef          	jal	80005830 <acquire>
  while(i < n){
    80003852:	0b405a63          	blez	s4,80003906 <pipewrite+0xd8>
    80003856:	f05a                	sd	s6,32(sp)
    80003858:	ec5e                	sd	s7,24(sp)
    8000385a:	e862                	sd	s8,16(sp)
  int i = 0;
    8000385c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000385e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003860:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003864:	21c48b93          	addi	s7,s1,540
    80003868:	a81d                	j	8000389e <pipewrite+0x70>
      release(&pi->lock);
    8000386a:	8526                	mv	a0,s1
    8000386c:	05c020ef          	jal	800058c8 <release>
      return -1;
    80003870:	597d                	li	s2,-1
    80003872:	7b02                	ld	s6,32(sp)
    80003874:	6be2                	ld	s7,24(sp)
    80003876:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003878:	854a                	mv	a0,s2
    8000387a:	60e6                	ld	ra,88(sp)
    8000387c:	6446                	ld	s0,80(sp)
    8000387e:	64a6                	ld	s1,72(sp)
    80003880:	6906                	ld	s2,64(sp)
    80003882:	79e2                	ld	s3,56(sp)
    80003884:	7a42                	ld	s4,48(sp)
    80003886:	7aa2                	ld	s5,40(sp)
    80003888:	6125                	addi	sp,sp,96
    8000388a:	8082                	ret
      wakeup(&pi->nread);
    8000388c:	8562                	mv	a0,s8
    8000388e:	b31fd0ef          	jal	800013be <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003892:	85a6                	mv	a1,s1
    80003894:	855e                	mv	a0,s7
    80003896:	addfd0ef          	jal	80001372 <sleep>
  while(i < n){
    8000389a:	05495b63          	bge	s2,s4,800038f0 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000389e:	2204a783          	lw	a5,544(s1)
    800038a2:	d7e1                	beqz	a5,8000386a <pipewrite+0x3c>
    800038a4:	854e                	mv	a0,s3
    800038a6:	d05fd0ef          	jal	800015aa <killed>
    800038aa:	f161                	bnez	a0,8000386a <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038ac:	2184a783          	lw	a5,536(s1)
    800038b0:	21c4a703          	lw	a4,540(s1)
    800038b4:	2007879b          	addiw	a5,a5,512
    800038b8:	fcf70ae3          	beq	a4,a5,8000388c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038bc:	4685                	li	a3,1
    800038be:	01590633          	add	a2,s2,s5
    800038c2:	faf40593          	addi	a1,s0,-81
    800038c6:	0509b503          	ld	a0,80(s3)
    800038ca:	a16fd0ef          	jal	80000ae0 <copyin>
    800038ce:	03650e63          	beq	a0,s6,8000390a <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038d2:	21c4a783          	lw	a5,540(s1)
    800038d6:	0017871b          	addiw	a4,a5,1
    800038da:	20e4ae23          	sw	a4,540(s1)
    800038de:	1ff7f793          	andi	a5,a5,511
    800038e2:	97a6                	add	a5,a5,s1
    800038e4:	faf44703          	lbu	a4,-81(s0)
    800038e8:	00e78c23          	sb	a4,24(a5)
      i++;
    800038ec:	2905                	addiw	s2,s2,1
    800038ee:	b775                	j	8000389a <pipewrite+0x6c>
    800038f0:	7b02                	ld	s6,32(sp)
    800038f2:	6be2                	ld	s7,24(sp)
    800038f4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800038f6:	21848513          	addi	a0,s1,536
    800038fa:	ac5fd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    800038fe:	8526                	mv	a0,s1
    80003900:	7c9010ef          	jal	800058c8 <release>
  return i;
    80003904:	bf95                	j	80003878 <pipewrite+0x4a>
  int i = 0;
    80003906:	4901                	li	s2,0
    80003908:	b7fd                	j	800038f6 <pipewrite+0xc8>
    8000390a:	7b02                	ld	s6,32(sp)
    8000390c:	6be2                	ld	s7,24(sp)
    8000390e:	6c42                	ld	s8,16(sp)
    80003910:	b7dd                	j	800038f6 <pipewrite+0xc8>

0000000080003912 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003912:	715d                	addi	sp,sp,-80
    80003914:	e486                	sd	ra,72(sp)
    80003916:	e0a2                	sd	s0,64(sp)
    80003918:	fc26                	sd	s1,56(sp)
    8000391a:	f84a                	sd	s2,48(sp)
    8000391c:	f44e                	sd	s3,40(sp)
    8000391e:	f052                	sd	s4,32(sp)
    80003920:	ec56                	sd	s5,24(sp)
    80003922:	0880                	addi	s0,sp,80
    80003924:	84aa                	mv	s1,a0
    80003926:	892e                	mv	s2,a1
    80003928:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000392a:	c6efd0ef          	jal	80000d98 <myproc>
    8000392e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003930:	8526                	mv	a0,s1
    80003932:	6ff010ef          	jal	80005830 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003936:	2184a703          	lw	a4,536(s1)
    8000393a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000393e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003942:	02f71563          	bne	a4,a5,8000396c <piperead+0x5a>
    80003946:	2244a783          	lw	a5,548(s1)
    8000394a:	cb85                	beqz	a5,8000397a <piperead+0x68>
    if(killed(pr)){
    8000394c:	8552                	mv	a0,s4
    8000394e:	c5dfd0ef          	jal	800015aa <killed>
    80003952:	ed19                	bnez	a0,80003970 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003954:	85a6                	mv	a1,s1
    80003956:	854e                	mv	a0,s3
    80003958:	a1bfd0ef          	jal	80001372 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000395c:	2184a703          	lw	a4,536(s1)
    80003960:	21c4a783          	lw	a5,540(s1)
    80003964:	fef701e3          	beq	a4,a5,80003946 <piperead+0x34>
    80003968:	e85a                	sd	s6,16(sp)
    8000396a:	a809                	j	8000397c <piperead+0x6a>
    8000396c:	e85a                	sd	s6,16(sp)
    8000396e:	a039                	j	8000397c <piperead+0x6a>
      release(&pi->lock);
    80003970:	8526                	mv	a0,s1
    80003972:	757010ef          	jal	800058c8 <release>
      return -1;
    80003976:	59fd                	li	s3,-1
    80003978:	a8b1                	j	800039d4 <piperead+0xc2>
    8000397a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000397c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000397e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003980:	05505263          	blez	s5,800039c4 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003984:	2184a783          	lw	a5,536(s1)
    80003988:	21c4a703          	lw	a4,540(s1)
    8000398c:	02f70c63          	beq	a4,a5,800039c4 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003990:	0017871b          	addiw	a4,a5,1
    80003994:	20e4ac23          	sw	a4,536(s1)
    80003998:	1ff7f793          	andi	a5,a5,511
    8000399c:	97a6                	add	a5,a5,s1
    8000399e:	0187c783          	lbu	a5,24(a5)
    800039a2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039a6:	4685                	li	a3,1
    800039a8:	fbf40613          	addi	a2,s0,-65
    800039ac:	85ca                	mv	a1,s2
    800039ae:	050a3503          	ld	a0,80(s4)
    800039b2:	856fd0ef          	jal	80000a08 <copyout>
    800039b6:	01650763          	beq	a0,s6,800039c4 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039ba:	2985                	addiw	s3,s3,1
    800039bc:	0905                	addi	s2,s2,1
    800039be:	fd3a93e3          	bne	s5,s3,80003984 <piperead+0x72>
    800039c2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039c4:	21c48513          	addi	a0,s1,540
    800039c8:	9f7fd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    800039cc:	8526                	mv	a0,s1
    800039ce:	6fb010ef          	jal	800058c8 <release>
    800039d2:	6b42                	ld	s6,16(sp)
  return i;
}
    800039d4:	854e                	mv	a0,s3
    800039d6:	60a6                	ld	ra,72(sp)
    800039d8:	6406                	ld	s0,64(sp)
    800039da:	74e2                	ld	s1,56(sp)
    800039dc:	7942                	ld	s2,48(sp)
    800039de:	79a2                	ld	s3,40(sp)
    800039e0:	7a02                	ld	s4,32(sp)
    800039e2:	6ae2                	ld	s5,24(sp)
    800039e4:	6161                	addi	sp,sp,80
    800039e6:	8082                	ret

00000000800039e8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800039e8:	1141                	addi	sp,sp,-16
    800039ea:	e422                	sd	s0,8(sp)
    800039ec:	0800                	addi	s0,sp,16
    800039ee:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800039f0:	8905                	andi	a0,a0,1
    800039f2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800039f4:	8b89                	andi	a5,a5,2
    800039f6:	c399                	beqz	a5,800039fc <flags2perm+0x14>
      perm |= PTE_W;
    800039f8:	00456513          	ori	a0,a0,4
    return perm;
}
    800039fc:	6422                	ld	s0,8(sp)
    800039fe:	0141                	addi	sp,sp,16
    80003a00:	8082                	ret

0000000080003a02 <exec>:

int
exec(char *path, char **argv)
{
    80003a02:	df010113          	addi	sp,sp,-528
    80003a06:	20113423          	sd	ra,520(sp)
    80003a0a:	20813023          	sd	s0,512(sp)
    80003a0e:	ffa6                	sd	s1,504(sp)
    80003a10:	fbca                	sd	s2,496(sp)
    80003a12:	0c00                	addi	s0,sp,528
    80003a14:	892a                	mv	s2,a0
    80003a16:	dea43c23          	sd	a0,-520(s0)
    80003a1a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a1e:	b7afd0ef          	jal	80000d98 <myproc>
    80003a22:	84aa                	mv	s1,a0

  begin_op();
    80003a24:	dc6ff0ef          	jal	80002fea <begin_op>

  if((ip = namei(path)) == 0){
    80003a28:	854a                	mv	a0,s2
    80003a2a:	c04ff0ef          	jal	80002e2e <namei>
    80003a2e:	c931                	beqz	a0,80003a82 <exec+0x80>
    80003a30:	f3d2                	sd	s4,480(sp)
    80003a32:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a34:	d21fe0ef          	jal	80002754 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a38:	04000713          	li	a4,64
    80003a3c:	4681                	li	a3,0
    80003a3e:	e5040613          	addi	a2,s0,-432
    80003a42:	4581                	li	a1,0
    80003a44:	8552                	mv	a0,s4
    80003a46:	f63fe0ef          	jal	800029a8 <readi>
    80003a4a:	04000793          	li	a5,64
    80003a4e:	00f51a63          	bne	a0,a5,80003a62 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a52:	e5042703          	lw	a4,-432(s0)
    80003a56:	464c47b7          	lui	a5,0x464c4
    80003a5a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a5e:	02f70663          	beq	a4,a5,80003a8a <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a62:	8552                	mv	a0,s4
    80003a64:	efbfe0ef          	jal	8000295e <iunlockput>
    end_op();
    80003a68:	decff0ef          	jal	80003054 <end_op>
  }
  return -1;
    80003a6c:	557d                	li	a0,-1
    80003a6e:	7a1e                	ld	s4,480(sp)
}
    80003a70:	20813083          	ld	ra,520(sp)
    80003a74:	20013403          	ld	s0,512(sp)
    80003a78:	74fe                	ld	s1,504(sp)
    80003a7a:	795e                	ld	s2,496(sp)
    80003a7c:	21010113          	addi	sp,sp,528
    80003a80:	8082                	ret
    end_op();
    80003a82:	dd2ff0ef          	jal	80003054 <end_op>
    return -1;
    80003a86:	557d                	li	a0,-1
    80003a88:	b7e5                	j	80003a70 <exec+0x6e>
    80003a8a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	bb2fd0ef          	jal	80000e40 <proc_pagetable>
    80003a92:	8b2a                	mv	s6,a0
    80003a94:	2c050b63          	beqz	a0,80003d6a <exec+0x368>
    80003a98:	f7ce                	sd	s3,488(sp)
    80003a9a:	efd6                	sd	s5,472(sp)
    80003a9c:	e7de                	sd	s7,456(sp)
    80003a9e:	e3e2                	sd	s8,448(sp)
    80003aa0:	ff66                	sd	s9,440(sp)
    80003aa2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aa4:	e7042d03          	lw	s10,-400(s0)
    80003aa8:	e8845783          	lhu	a5,-376(s0)
    80003aac:	12078963          	beqz	a5,80003bde <exec+0x1dc>
    80003ab0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ab2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ab4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003ab6:	6c85                	lui	s9,0x1
    80003ab8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003abc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ac0:	6a85                	lui	s5,0x1
    80003ac2:	a085                	j	80003b22 <exec+0x120>
      panic("loadseg: address should exist");
    80003ac4:	00004517          	auipc	a0,0x4
    80003ac8:	b9c50513          	addi	a0,a0,-1124 # 80007660 <etext+0x660>
    80003acc:	237010ef          	jal	80005502 <panic>
    if(sz - i < PGSIZE)
    80003ad0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ad2:	8726                	mv	a4,s1
    80003ad4:	012c06bb          	addw	a3,s8,s2
    80003ad8:	4581                	li	a1,0
    80003ada:	8552                	mv	a0,s4
    80003adc:	ecdfe0ef          	jal	800029a8 <readi>
    80003ae0:	2501                	sext.w	a0,a0
    80003ae2:	24a49a63          	bne	s1,a0,80003d36 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003ae6:	012a893b          	addw	s2,s5,s2
    80003aea:	03397363          	bgeu	s2,s3,80003b10 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003aee:	02091593          	slli	a1,s2,0x20
    80003af2:	9181                	srli	a1,a1,0x20
    80003af4:	95de                	add	a1,a1,s7
    80003af6:	855a                	mv	a0,s6
    80003af8:	98dfc0ef          	jal	80000484 <walkaddr>
    80003afc:	862a                	mv	a2,a0
    if(pa == 0)
    80003afe:	d179                	beqz	a0,80003ac4 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b00:	412984bb          	subw	s1,s3,s2
    80003b04:	0004879b          	sext.w	a5,s1
    80003b08:	fcfcf4e3          	bgeu	s9,a5,80003ad0 <exec+0xce>
    80003b0c:	84d6                	mv	s1,s5
    80003b0e:	b7c9                	j	80003ad0 <exec+0xce>
    sz = sz1;
    80003b10:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b14:	2d85                	addiw	s11,s11,1
    80003b16:	038d0d1b          	addiw	s10,s10,56
    80003b1a:	e8845783          	lhu	a5,-376(s0)
    80003b1e:	08fdd063          	bge	s11,a5,80003b9e <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b22:	2d01                	sext.w	s10,s10
    80003b24:	03800713          	li	a4,56
    80003b28:	86ea                	mv	a3,s10
    80003b2a:	e1840613          	addi	a2,s0,-488
    80003b2e:	4581                	li	a1,0
    80003b30:	8552                	mv	a0,s4
    80003b32:	e77fe0ef          	jal	800029a8 <readi>
    80003b36:	03800793          	li	a5,56
    80003b3a:	1cf51663          	bne	a0,a5,80003d06 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b3e:	e1842783          	lw	a5,-488(s0)
    80003b42:	4705                	li	a4,1
    80003b44:	fce798e3          	bne	a5,a4,80003b14 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003b48:	e4043483          	ld	s1,-448(s0)
    80003b4c:	e3843783          	ld	a5,-456(s0)
    80003b50:	1af4ef63          	bltu	s1,a5,80003d0e <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b54:	e2843783          	ld	a5,-472(s0)
    80003b58:	94be                	add	s1,s1,a5
    80003b5a:	1af4ee63          	bltu	s1,a5,80003d16 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003b5e:	df043703          	ld	a4,-528(s0)
    80003b62:	8ff9                	and	a5,a5,a4
    80003b64:	1a079d63          	bnez	a5,80003d1e <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b68:	e1c42503          	lw	a0,-484(s0)
    80003b6c:	e7dff0ef          	jal	800039e8 <flags2perm>
    80003b70:	86aa                	mv	a3,a0
    80003b72:	8626                	mv	a2,s1
    80003b74:	85ca                	mv	a1,s2
    80003b76:	855a                	mv	a0,s6
    80003b78:	c85fc0ef          	jal	800007fc <uvmalloc>
    80003b7c:	e0a43423          	sd	a0,-504(s0)
    80003b80:	1a050363          	beqz	a0,80003d26 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b84:	e2843b83          	ld	s7,-472(s0)
    80003b88:	e2042c03          	lw	s8,-480(s0)
    80003b8c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b90:	00098463          	beqz	s3,80003b98 <exec+0x196>
    80003b94:	4901                	li	s2,0
    80003b96:	bfa1                	j	80003aee <exec+0xec>
    sz = sz1;
    80003b98:	e0843903          	ld	s2,-504(s0)
    80003b9c:	bfa5                	j	80003b14 <exec+0x112>
    80003b9e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003ba0:	8552                	mv	a0,s4
    80003ba2:	dbdfe0ef          	jal	8000295e <iunlockput>
  end_op();
    80003ba6:	caeff0ef          	jal	80003054 <end_op>
  p = myproc();
    80003baa:	9eefd0ef          	jal	80000d98 <myproc>
    80003bae:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bb0:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003bb4:	6985                	lui	s3,0x1
    80003bb6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bb8:	99ca                	add	s3,s3,s2
    80003bba:	77fd                	lui	a5,0xfffff
    80003bbc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bc0:	4691                	li	a3,4
    80003bc2:	6609                	lui	a2,0x2
    80003bc4:	964e                	add	a2,a2,s3
    80003bc6:	85ce                	mv	a1,s3
    80003bc8:	855a                	mv	a0,s6
    80003bca:	c33fc0ef          	jal	800007fc <uvmalloc>
    80003bce:	892a                	mv	s2,a0
    80003bd0:	e0a43423          	sd	a0,-504(s0)
    80003bd4:	e519                	bnez	a0,80003be2 <exec+0x1e0>
  if(pagetable)
    80003bd6:	e1343423          	sd	s3,-504(s0)
    80003bda:	4a01                	li	s4,0
    80003bdc:	aab1                	j	80003d38 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003bde:	4901                	li	s2,0
    80003be0:	b7c1                	j	80003ba0 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003be2:	75f9                	lui	a1,0xffffe
    80003be4:	95aa                	add	a1,a1,a0
    80003be6:	855a                	mv	a0,s6
    80003be8:	df7fc0ef          	jal	800009de <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003bec:	7bfd                	lui	s7,0xfffff
    80003bee:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003bf0:	e0043783          	ld	a5,-512(s0)
    80003bf4:	6388                	ld	a0,0(a5)
    80003bf6:	cd39                	beqz	a0,80003c54 <exec+0x252>
    80003bf8:	e9040993          	addi	s3,s0,-368
    80003bfc:	f9040c13          	addi	s8,s0,-112
    80003c00:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c02:	ee4fc0ef          	jal	800002e6 <strlen>
    80003c06:	0015079b          	addiw	a5,a0,1
    80003c0a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c0e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c12:	11796e63          	bltu	s2,s7,80003d2e <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c16:	e0043d03          	ld	s10,-512(s0)
    80003c1a:	000d3a03          	ld	s4,0(s10)
    80003c1e:	8552                	mv	a0,s4
    80003c20:	ec6fc0ef          	jal	800002e6 <strlen>
    80003c24:	0015069b          	addiw	a3,a0,1
    80003c28:	8652                	mv	a2,s4
    80003c2a:	85ca                	mv	a1,s2
    80003c2c:	855a                	mv	a0,s6
    80003c2e:	ddbfc0ef          	jal	80000a08 <copyout>
    80003c32:	10054063          	bltz	a0,80003d32 <exec+0x330>
    ustack[argc] = sp;
    80003c36:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c3a:	0485                	addi	s1,s1,1
    80003c3c:	008d0793          	addi	a5,s10,8
    80003c40:	e0f43023          	sd	a5,-512(s0)
    80003c44:	008d3503          	ld	a0,8(s10)
    80003c48:	c909                	beqz	a0,80003c5a <exec+0x258>
    if(argc >= MAXARG)
    80003c4a:	09a1                	addi	s3,s3,8
    80003c4c:	fb899be3          	bne	s3,s8,80003c02 <exec+0x200>
  ip = 0;
    80003c50:	4a01                	li	s4,0
    80003c52:	a0dd                	j	80003d38 <exec+0x336>
  sp = sz;
    80003c54:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003c58:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c5a:	00349793          	slli	a5,s1,0x3
    80003c5e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb620>
    80003c62:	97a2                	add	a5,a5,s0
    80003c64:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c68:	00148693          	addi	a3,s1,1
    80003c6c:	068e                	slli	a3,a3,0x3
    80003c6e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c72:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c76:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c7a:	f5796ee3          	bltu	s2,s7,80003bd6 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c7e:	e9040613          	addi	a2,s0,-368
    80003c82:	85ca                	mv	a1,s2
    80003c84:	855a                	mv	a0,s6
    80003c86:	d83fc0ef          	jal	80000a08 <copyout>
    80003c8a:	0e054263          	bltz	a0,80003d6e <exec+0x36c>
  p->trapframe->a1 = sp;
    80003c8e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c92:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c96:	df843783          	ld	a5,-520(s0)
    80003c9a:	0007c703          	lbu	a4,0(a5)
    80003c9e:	cf11                	beqz	a4,80003cba <exec+0x2b8>
    80003ca0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ca2:	02f00693          	li	a3,47
    80003ca6:	a039                	j	80003cb4 <exec+0x2b2>
      last = s+1;
    80003ca8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003cac:	0785                	addi	a5,a5,1
    80003cae:	fff7c703          	lbu	a4,-1(a5)
    80003cb2:	c701                	beqz	a4,80003cba <exec+0x2b8>
    if(*s == '/')
    80003cb4:	fed71ce3          	bne	a4,a3,80003cac <exec+0x2aa>
    80003cb8:	bfc5                	j	80003ca8 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cba:	4641                	li	a2,16
    80003cbc:	df843583          	ld	a1,-520(s0)
    80003cc0:	158a8513          	addi	a0,s5,344
    80003cc4:	df0fc0ef          	jal	800002b4 <safestrcpy>
  oldpagetable = p->pagetable;
    80003cc8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003ccc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003cd0:	e0843783          	ld	a5,-504(s0)
    80003cd4:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003cd8:	058ab783          	ld	a5,88(s5)
    80003cdc:	e6843703          	ld	a4,-408(s0)
    80003ce0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ce2:	058ab783          	ld	a5,88(s5)
    80003ce6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003cea:	85e6                	mv	a1,s9
    80003cec:	9d8fd0ef          	jal	80000ec4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003cf0:	0004851b          	sext.w	a0,s1
    80003cf4:	79be                	ld	s3,488(sp)
    80003cf6:	7a1e                	ld	s4,480(sp)
    80003cf8:	6afe                	ld	s5,472(sp)
    80003cfa:	6b5e                	ld	s6,464(sp)
    80003cfc:	6bbe                	ld	s7,456(sp)
    80003cfe:	6c1e                	ld	s8,448(sp)
    80003d00:	7cfa                	ld	s9,440(sp)
    80003d02:	7d5a                	ld	s10,432(sp)
    80003d04:	b3b5                	j	80003a70 <exec+0x6e>
    80003d06:	e1243423          	sd	s2,-504(s0)
    80003d0a:	7dba                	ld	s11,424(sp)
    80003d0c:	a035                	j	80003d38 <exec+0x336>
    80003d0e:	e1243423          	sd	s2,-504(s0)
    80003d12:	7dba                	ld	s11,424(sp)
    80003d14:	a015                	j	80003d38 <exec+0x336>
    80003d16:	e1243423          	sd	s2,-504(s0)
    80003d1a:	7dba                	ld	s11,424(sp)
    80003d1c:	a831                	j	80003d38 <exec+0x336>
    80003d1e:	e1243423          	sd	s2,-504(s0)
    80003d22:	7dba                	ld	s11,424(sp)
    80003d24:	a811                	j	80003d38 <exec+0x336>
    80003d26:	e1243423          	sd	s2,-504(s0)
    80003d2a:	7dba                	ld	s11,424(sp)
    80003d2c:	a031                	j	80003d38 <exec+0x336>
  ip = 0;
    80003d2e:	4a01                	li	s4,0
    80003d30:	a021                	j	80003d38 <exec+0x336>
    80003d32:	4a01                	li	s4,0
  if(pagetable)
    80003d34:	a011                	j	80003d38 <exec+0x336>
    80003d36:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d38:	e0843583          	ld	a1,-504(s0)
    80003d3c:	855a                	mv	a0,s6
    80003d3e:	986fd0ef          	jal	80000ec4 <proc_freepagetable>
  return -1;
    80003d42:	557d                	li	a0,-1
  if(ip){
    80003d44:	000a1b63          	bnez	s4,80003d5a <exec+0x358>
    80003d48:	79be                	ld	s3,488(sp)
    80003d4a:	7a1e                	ld	s4,480(sp)
    80003d4c:	6afe                	ld	s5,472(sp)
    80003d4e:	6b5e                	ld	s6,464(sp)
    80003d50:	6bbe                	ld	s7,456(sp)
    80003d52:	6c1e                	ld	s8,448(sp)
    80003d54:	7cfa                	ld	s9,440(sp)
    80003d56:	7d5a                	ld	s10,432(sp)
    80003d58:	bb21                	j	80003a70 <exec+0x6e>
    80003d5a:	79be                	ld	s3,488(sp)
    80003d5c:	6afe                	ld	s5,472(sp)
    80003d5e:	6b5e                	ld	s6,464(sp)
    80003d60:	6bbe                	ld	s7,456(sp)
    80003d62:	6c1e                	ld	s8,448(sp)
    80003d64:	7cfa                	ld	s9,440(sp)
    80003d66:	7d5a                	ld	s10,432(sp)
    80003d68:	b9ed                	j	80003a62 <exec+0x60>
    80003d6a:	6b5e                	ld	s6,464(sp)
    80003d6c:	b9dd                	j	80003a62 <exec+0x60>
  sz = sz1;
    80003d6e:	e0843983          	ld	s3,-504(s0)
    80003d72:	b595                	j	80003bd6 <exec+0x1d4>

0000000080003d74 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d74:	7179                	addi	sp,sp,-48
    80003d76:	f406                	sd	ra,40(sp)
    80003d78:	f022                	sd	s0,32(sp)
    80003d7a:	ec26                	sd	s1,24(sp)
    80003d7c:	e84a                	sd	s2,16(sp)
    80003d7e:	1800                	addi	s0,sp,48
    80003d80:	892e                	mv	s2,a1
    80003d82:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d84:	fdc40593          	addi	a1,s0,-36
    80003d88:	f01fd0ef          	jal	80001c88 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d8c:	fdc42703          	lw	a4,-36(s0)
    80003d90:	47bd                	li	a5,15
    80003d92:	02e7e963          	bltu	a5,a4,80003dc4 <argfd+0x50>
    80003d96:	802fd0ef          	jal	80000d98 <myproc>
    80003d9a:	fdc42703          	lw	a4,-36(s0)
    80003d9e:	01a70793          	addi	a5,a4,26
    80003da2:	078e                	slli	a5,a5,0x3
    80003da4:	953e                	add	a0,a0,a5
    80003da6:	611c                	ld	a5,0(a0)
    80003da8:	c385                	beqz	a5,80003dc8 <argfd+0x54>
    return -1;
  if(pfd)
    80003daa:	00090463          	beqz	s2,80003db2 <argfd+0x3e>
    *pfd = fd;
    80003dae:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003db2:	4501                	li	a0,0
  if(pf)
    80003db4:	c091                	beqz	s1,80003db8 <argfd+0x44>
    *pf = f;
    80003db6:	e09c                	sd	a5,0(s1)
}
    80003db8:	70a2                	ld	ra,40(sp)
    80003dba:	7402                	ld	s0,32(sp)
    80003dbc:	64e2                	ld	s1,24(sp)
    80003dbe:	6942                	ld	s2,16(sp)
    80003dc0:	6145                	addi	sp,sp,48
    80003dc2:	8082                	ret
    return -1;
    80003dc4:	557d                	li	a0,-1
    80003dc6:	bfcd                	j	80003db8 <argfd+0x44>
    80003dc8:	557d                	li	a0,-1
    80003dca:	b7fd                	j	80003db8 <argfd+0x44>

0000000080003dcc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003dcc:	1101                	addi	sp,sp,-32
    80003dce:	ec06                	sd	ra,24(sp)
    80003dd0:	e822                	sd	s0,16(sp)
    80003dd2:	e426                	sd	s1,8(sp)
    80003dd4:	1000                	addi	s0,sp,32
    80003dd6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003dd8:	fc1fc0ef          	jal	80000d98 <myproc>
    80003ddc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003dde:	0d050793          	addi	a5,a0,208
    80003de2:	4501                	li	a0,0
    80003de4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003de6:	6398                	ld	a4,0(a5)
    80003de8:	cb19                	beqz	a4,80003dfe <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003dea:	2505                	addiw	a0,a0,1
    80003dec:	07a1                	addi	a5,a5,8
    80003dee:	fed51ce3          	bne	a0,a3,80003de6 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003df2:	557d                	li	a0,-1
}
    80003df4:	60e2                	ld	ra,24(sp)
    80003df6:	6442                	ld	s0,16(sp)
    80003df8:	64a2                	ld	s1,8(sp)
    80003dfa:	6105                	addi	sp,sp,32
    80003dfc:	8082                	ret
      p->ofile[fd] = f;
    80003dfe:	01a50793          	addi	a5,a0,26
    80003e02:	078e                	slli	a5,a5,0x3
    80003e04:	963e                	add	a2,a2,a5
    80003e06:	e204                	sd	s1,0(a2)
      return fd;
    80003e08:	b7f5                	j	80003df4 <fdalloc+0x28>

0000000080003e0a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e0a:	715d                	addi	sp,sp,-80
    80003e0c:	e486                	sd	ra,72(sp)
    80003e0e:	e0a2                	sd	s0,64(sp)
    80003e10:	fc26                	sd	s1,56(sp)
    80003e12:	f84a                	sd	s2,48(sp)
    80003e14:	f44e                	sd	s3,40(sp)
    80003e16:	ec56                	sd	s5,24(sp)
    80003e18:	e85a                	sd	s6,16(sp)
    80003e1a:	0880                	addi	s0,sp,80
    80003e1c:	8b2e                	mv	s6,a1
    80003e1e:	89b2                	mv	s3,a2
    80003e20:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e22:	fb040593          	addi	a1,s0,-80
    80003e26:	822ff0ef          	jal	80002e48 <nameiparent>
    80003e2a:	84aa                	mv	s1,a0
    80003e2c:	10050a63          	beqz	a0,80003f40 <create+0x136>
    return 0;

  ilock(dp);
    80003e30:	925fe0ef          	jal	80002754 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e34:	4601                	li	a2,0
    80003e36:	fb040593          	addi	a1,s0,-80
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	d8dfe0ef          	jal	80002bc8 <dirlookup>
    80003e40:	8aaa                	mv	s5,a0
    80003e42:	c129                	beqz	a0,80003e84 <create+0x7a>
    iunlockput(dp);
    80003e44:	8526                	mv	a0,s1
    80003e46:	b19fe0ef          	jal	8000295e <iunlockput>
    ilock(ip);
    80003e4a:	8556                	mv	a0,s5
    80003e4c:	909fe0ef          	jal	80002754 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e50:	4789                	li	a5,2
    80003e52:	02fb1463          	bne	s6,a5,80003e7a <create+0x70>
    80003e56:	044ad783          	lhu	a5,68(s5)
    80003e5a:	37f9                	addiw	a5,a5,-2
    80003e5c:	17c2                	slli	a5,a5,0x30
    80003e5e:	93c1                	srli	a5,a5,0x30
    80003e60:	4705                	li	a4,1
    80003e62:	00f76c63          	bltu	a4,a5,80003e7a <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e66:	8556                	mv	a0,s5
    80003e68:	60a6                	ld	ra,72(sp)
    80003e6a:	6406                	ld	s0,64(sp)
    80003e6c:	74e2                	ld	s1,56(sp)
    80003e6e:	7942                	ld	s2,48(sp)
    80003e70:	79a2                	ld	s3,40(sp)
    80003e72:	6ae2                	ld	s5,24(sp)
    80003e74:	6b42                	ld	s6,16(sp)
    80003e76:	6161                	addi	sp,sp,80
    80003e78:	8082                	ret
    iunlockput(ip);
    80003e7a:	8556                	mv	a0,s5
    80003e7c:	ae3fe0ef          	jal	8000295e <iunlockput>
    return 0;
    80003e80:	4a81                	li	s5,0
    80003e82:	b7d5                	j	80003e66 <create+0x5c>
    80003e84:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e86:	85da                	mv	a1,s6
    80003e88:	4088                	lw	a0,0(s1)
    80003e8a:	f5afe0ef          	jal	800025e4 <ialloc>
    80003e8e:	8a2a                	mv	s4,a0
    80003e90:	cd15                	beqz	a0,80003ecc <create+0xc2>
  ilock(ip);
    80003e92:	8c3fe0ef          	jal	80002754 <ilock>
  ip->major = major;
    80003e96:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e9a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e9e:	4905                	li	s2,1
    80003ea0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003ea4:	8552                	mv	a0,s4
    80003ea6:	ffafe0ef          	jal	800026a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003eaa:	032b0763          	beq	s6,s2,80003ed8 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003eae:	004a2603          	lw	a2,4(s4)
    80003eb2:	fb040593          	addi	a1,s0,-80
    80003eb6:	8526                	mv	a0,s1
    80003eb8:	eddfe0ef          	jal	80002d94 <dirlink>
    80003ebc:	06054563          	bltz	a0,80003f26 <create+0x11c>
  iunlockput(dp);
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	a9dfe0ef          	jal	8000295e <iunlockput>
  return ip;
    80003ec6:	8ad2                	mv	s5,s4
    80003ec8:	7a02                	ld	s4,32(sp)
    80003eca:	bf71                	j	80003e66 <create+0x5c>
    iunlockput(dp);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	a91fe0ef          	jal	8000295e <iunlockput>
    return 0;
    80003ed2:	8ad2                	mv	s5,s4
    80003ed4:	7a02                	ld	s4,32(sp)
    80003ed6:	bf41                	j	80003e66 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003ed8:	004a2603          	lw	a2,4(s4)
    80003edc:	00003597          	auipc	a1,0x3
    80003ee0:	7a458593          	addi	a1,a1,1956 # 80007680 <etext+0x680>
    80003ee4:	8552                	mv	a0,s4
    80003ee6:	eaffe0ef          	jal	80002d94 <dirlink>
    80003eea:	02054e63          	bltz	a0,80003f26 <create+0x11c>
    80003eee:	40d0                	lw	a2,4(s1)
    80003ef0:	00003597          	auipc	a1,0x3
    80003ef4:	79858593          	addi	a1,a1,1944 # 80007688 <etext+0x688>
    80003ef8:	8552                	mv	a0,s4
    80003efa:	e9bfe0ef          	jal	80002d94 <dirlink>
    80003efe:	02054463          	bltz	a0,80003f26 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f02:	004a2603          	lw	a2,4(s4)
    80003f06:	fb040593          	addi	a1,s0,-80
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	e89fe0ef          	jal	80002d94 <dirlink>
    80003f10:	00054b63          	bltz	a0,80003f26 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f14:	04a4d783          	lhu	a5,74(s1)
    80003f18:	2785                	addiw	a5,a5,1
    80003f1a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	f80fe0ef          	jal	800026a0 <iupdate>
    80003f24:	bf71                	j	80003ec0 <create+0xb6>
  ip->nlink = 0;
    80003f26:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f2a:	8552                	mv	a0,s4
    80003f2c:	f74fe0ef          	jal	800026a0 <iupdate>
  iunlockput(ip);
    80003f30:	8552                	mv	a0,s4
    80003f32:	a2dfe0ef          	jal	8000295e <iunlockput>
  iunlockput(dp);
    80003f36:	8526                	mv	a0,s1
    80003f38:	a27fe0ef          	jal	8000295e <iunlockput>
  return 0;
    80003f3c:	7a02                	ld	s4,32(sp)
    80003f3e:	b725                	j	80003e66 <create+0x5c>
    return 0;
    80003f40:	8aaa                	mv	s5,a0
    80003f42:	b715                	j	80003e66 <create+0x5c>

0000000080003f44 <sys_dup>:
{
    80003f44:	7179                	addi	sp,sp,-48
    80003f46:	f406                	sd	ra,40(sp)
    80003f48:	f022                	sd	s0,32(sp)
    80003f4a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f4c:	fd840613          	addi	a2,s0,-40
    80003f50:	4581                	li	a1,0
    80003f52:	4501                	li	a0,0
    80003f54:	e21ff0ef          	jal	80003d74 <argfd>
    return -1;
    80003f58:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f5a:	02054363          	bltz	a0,80003f80 <sys_dup+0x3c>
    80003f5e:	ec26                	sd	s1,24(sp)
    80003f60:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f62:	fd843903          	ld	s2,-40(s0)
    80003f66:	854a                	mv	a0,s2
    80003f68:	e65ff0ef          	jal	80003dcc <fdalloc>
    80003f6c:	84aa                	mv	s1,a0
    return -1;
    80003f6e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f70:	00054d63          	bltz	a0,80003f8a <sys_dup+0x46>
  filedup(f);
    80003f74:	854a                	mv	a0,s2
    80003f76:	c48ff0ef          	jal	800033be <filedup>
  return fd;
    80003f7a:	87a6                	mv	a5,s1
    80003f7c:	64e2                	ld	s1,24(sp)
    80003f7e:	6942                	ld	s2,16(sp)
}
    80003f80:	853e                	mv	a0,a5
    80003f82:	70a2                	ld	ra,40(sp)
    80003f84:	7402                	ld	s0,32(sp)
    80003f86:	6145                	addi	sp,sp,48
    80003f88:	8082                	ret
    80003f8a:	64e2                	ld	s1,24(sp)
    80003f8c:	6942                	ld	s2,16(sp)
    80003f8e:	bfcd                	j	80003f80 <sys_dup+0x3c>

0000000080003f90 <sys_read>:
{
    80003f90:	7179                	addi	sp,sp,-48
    80003f92:	f406                	sd	ra,40(sp)
    80003f94:	f022                	sd	s0,32(sp)
    80003f96:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f98:	fd840593          	addi	a1,s0,-40
    80003f9c:	4505                	li	a0,1
    80003f9e:	d07fd0ef          	jal	80001ca4 <argaddr>
  argint(2, &n);
    80003fa2:	fe440593          	addi	a1,s0,-28
    80003fa6:	4509                	li	a0,2
    80003fa8:	ce1fd0ef          	jal	80001c88 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fac:	fe840613          	addi	a2,s0,-24
    80003fb0:	4581                	li	a1,0
    80003fb2:	4501                	li	a0,0
    80003fb4:	dc1ff0ef          	jal	80003d74 <argfd>
    80003fb8:	87aa                	mv	a5,a0
    return -1;
    80003fba:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fbc:	0007ca63          	bltz	a5,80003fd0 <sys_read+0x40>
  return fileread(f, p, n);
    80003fc0:	fe442603          	lw	a2,-28(s0)
    80003fc4:	fd843583          	ld	a1,-40(s0)
    80003fc8:	fe843503          	ld	a0,-24(s0)
    80003fcc:	d58ff0ef          	jal	80003524 <fileread>
}
    80003fd0:	70a2                	ld	ra,40(sp)
    80003fd2:	7402                	ld	s0,32(sp)
    80003fd4:	6145                	addi	sp,sp,48
    80003fd6:	8082                	ret

0000000080003fd8 <sys_write>:
{
    80003fd8:	7179                	addi	sp,sp,-48
    80003fda:	f406                	sd	ra,40(sp)
    80003fdc:	f022                	sd	s0,32(sp)
    80003fde:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fe0:	fd840593          	addi	a1,s0,-40
    80003fe4:	4505                	li	a0,1
    80003fe6:	cbffd0ef          	jal	80001ca4 <argaddr>
  argint(2, &n);
    80003fea:	fe440593          	addi	a1,s0,-28
    80003fee:	4509                	li	a0,2
    80003ff0:	c99fd0ef          	jal	80001c88 <argint>
  if(argfd(0, 0, &f) < 0)
    80003ff4:	fe840613          	addi	a2,s0,-24
    80003ff8:	4581                	li	a1,0
    80003ffa:	4501                	li	a0,0
    80003ffc:	d79ff0ef          	jal	80003d74 <argfd>
    80004000:	87aa                	mv	a5,a0
    return -1;
    80004002:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004004:	0007ca63          	bltz	a5,80004018 <sys_write+0x40>
  return filewrite(f, p, n);
    80004008:	fe442603          	lw	a2,-28(s0)
    8000400c:	fd843583          	ld	a1,-40(s0)
    80004010:	fe843503          	ld	a0,-24(s0)
    80004014:	dceff0ef          	jal	800035e2 <filewrite>
}
    80004018:	70a2                	ld	ra,40(sp)
    8000401a:	7402                	ld	s0,32(sp)
    8000401c:	6145                	addi	sp,sp,48
    8000401e:	8082                	ret

0000000080004020 <sys_close>:
{
    80004020:	1101                	addi	sp,sp,-32
    80004022:	ec06                	sd	ra,24(sp)
    80004024:	e822                	sd	s0,16(sp)
    80004026:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004028:	fe040613          	addi	a2,s0,-32
    8000402c:	fec40593          	addi	a1,s0,-20
    80004030:	4501                	li	a0,0
    80004032:	d43ff0ef          	jal	80003d74 <argfd>
    return -1;
    80004036:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004038:	02054063          	bltz	a0,80004058 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000403c:	d5dfc0ef          	jal	80000d98 <myproc>
    80004040:	fec42783          	lw	a5,-20(s0)
    80004044:	07e9                	addi	a5,a5,26
    80004046:	078e                	slli	a5,a5,0x3
    80004048:	953e                	add	a0,a0,a5
    8000404a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000404e:	fe043503          	ld	a0,-32(s0)
    80004052:	bb2ff0ef          	jal	80003404 <fileclose>
  return 0;
    80004056:	4781                	li	a5,0
}
    80004058:	853e                	mv	a0,a5
    8000405a:	60e2                	ld	ra,24(sp)
    8000405c:	6442                	ld	s0,16(sp)
    8000405e:	6105                	addi	sp,sp,32
    80004060:	8082                	ret

0000000080004062 <sys_fstat>:
{
    80004062:	1101                	addi	sp,sp,-32
    80004064:	ec06                	sd	ra,24(sp)
    80004066:	e822                	sd	s0,16(sp)
    80004068:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000406a:	fe040593          	addi	a1,s0,-32
    8000406e:	4505                	li	a0,1
    80004070:	c35fd0ef          	jal	80001ca4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004074:	fe840613          	addi	a2,s0,-24
    80004078:	4581                	li	a1,0
    8000407a:	4501                	li	a0,0
    8000407c:	cf9ff0ef          	jal	80003d74 <argfd>
    80004080:	87aa                	mv	a5,a0
    return -1;
    80004082:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004084:	0007c863          	bltz	a5,80004094 <sys_fstat+0x32>
  return filestat(f, st);
    80004088:	fe043583          	ld	a1,-32(s0)
    8000408c:	fe843503          	ld	a0,-24(s0)
    80004090:	c36ff0ef          	jal	800034c6 <filestat>
}
    80004094:	60e2                	ld	ra,24(sp)
    80004096:	6442                	ld	s0,16(sp)
    80004098:	6105                	addi	sp,sp,32
    8000409a:	8082                	ret

000000008000409c <sys_link>:
{
    8000409c:	7169                	addi	sp,sp,-304
    8000409e:	f606                	sd	ra,296(sp)
    800040a0:	f222                	sd	s0,288(sp)
    800040a2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040a4:	08000613          	li	a2,128
    800040a8:	ed040593          	addi	a1,s0,-304
    800040ac:	4501                	li	a0,0
    800040ae:	c13fd0ef          	jal	80001cc0 <argstr>
    return -1;
    800040b2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040b4:	0c054e63          	bltz	a0,80004190 <sys_link+0xf4>
    800040b8:	08000613          	li	a2,128
    800040bc:	f5040593          	addi	a1,s0,-176
    800040c0:	4505                	li	a0,1
    800040c2:	bfffd0ef          	jal	80001cc0 <argstr>
    return -1;
    800040c6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040c8:	0c054463          	bltz	a0,80004190 <sys_link+0xf4>
    800040cc:	ee26                	sd	s1,280(sp)
  begin_op();
    800040ce:	f1dfe0ef          	jal	80002fea <begin_op>
  if((ip = namei(old)) == 0){
    800040d2:	ed040513          	addi	a0,s0,-304
    800040d6:	d59fe0ef          	jal	80002e2e <namei>
    800040da:	84aa                	mv	s1,a0
    800040dc:	c53d                	beqz	a0,8000414a <sys_link+0xae>
  ilock(ip);
    800040de:	e76fe0ef          	jal	80002754 <ilock>
  if(ip->type == T_DIR){
    800040e2:	04449703          	lh	a4,68(s1)
    800040e6:	4785                	li	a5,1
    800040e8:	06f70663          	beq	a4,a5,80004154 <sys_link+0xb8>
    800040ec:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800040ee:	04a4d783          	lhu	a5,74(s1)
    800040f2:	2785                	addiw	a5,a5,1
    800040f4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800040f8:	8526                	mv	a0,s1
    800040fa:	da6fe0ef          	jal	800026a0 <iupdate>
  iunlock(ip);
    800040fe:	8526                	mv	a0,s1
    80004100:	f02fe0ef          	jal	80002802 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004104:	fd040593          	addi	a1,s0,-48
    80004108:	f5040513          	addi	a0,s0,-176
    8000410c:	d3dfe0ef          	jal	80002e48 <nameiparent>
    80004110:	892a                	mv	s2,a0
    80004112:	cd21                	beqz	a0,8000416a <sys_link+0xce>
  ilock(dp);
    80004114:	e40fe0ef          	jal	80002754 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004118:	00092703          	lw	a4,0(s2)
    8000411c:	409c                	lw	a5,0(s1)
    8000411e:	04f71363          	bne	a4,a5,80004164 <sys_link+0xc8>
    80004122:	40d0                	lw	a2,4(s1)
    80004124:	fd040593          	addi	a1,s0,-48
    80004128:	854a                	mv	a0,s2
    8000412a:	c6bfe0ef          	jal	80002d94 <dirlink>
    8000412e:	02054b63          	bltz	a0,80004164 <sys_link+0xc8>
  iunlockput(dp);
    80004132:	854a                	mv	a0,s2
    80004134:	82bfe0ef          	jal	8000295e <iunlockput>
  iput(ip);
    80004138:	8526                	mv	a0,s1
    8000413a:	f9cfe0ef          	jal	800028d6 <iput>
  end_op();
    8000413e:	f17fe0ef          	jal	80003054 <end_op>
  return 0;
    80004142:	4781                	li	a5,0
    80004144:	64f2                	ld	s1,280(sp)
    80004146:	6952                	ld	s2,272(sp)
    80004148:	a0a1                	j	80004190 <sys_link+0xf4>
    end_op();
    8000414a:	f0bfe0ef          	jal	80003054 <end_op>
    return -1;
    8000414e:	57fd                	li	a5,-1
    80004150:	64f2                	ld	s1,280(sp)
    80004152:	a83d                	j	80004190 <sys_link+0xf4>
    iunlockput(ip);
    80004154:	8526                	mv	a0,s1
    80004156:	809fe0ef          	jal	8000295e <iunlockput>
    end_op();
    8000415a:	efbfe0ef          	jal	80003054 <end_op>
    return -1;
    8000415e:	57fd                	li	a5,-1
    80004160:	64f2                	ld	s1,280(sp)
    80004162:	a03d                	j	80004190 <sys_link+0xf4>
    iunlockput(dp);
    80004164:	854a                	mv	a0,s2
    80004166:	ff8fe0ef          	jal	8000295e <iunlockput>
  ilock(ip);
    8000416a:	8526                	mv	a0,s1
    8000416c:	de8fe0ef          	jal	80002754 <ilock>
  ip->nlink--;
    80004170:	04a4d783          	lhu	a5,74(s1)
    80004174:	37fd                	addiw	a5,a5,-1
    80004176:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000417a:	8526                	mv	a0,s1
    8000417c:	d24fe0ef          	jal	800026a0 <iupdate>
  iunlockput(ip);
    80004180:	8526                	mv	a0,s1
    80004182:	fdcfe0ef          	jal	8000295e <iunlockput>
  end_op();
    80004186:	ecffe0ef          	jal	80003054 <end_op>
  return -1;
    8000418a:	57fd                	li	a5,-1
    8000418c:	64f2                	ld	s1,280(sp)
    8000418e:	6952                	ld	s2,272(sp)
}
    80004190:	853e                	mv	a0,a5
    80004192:	70b2                	ld	ra,296(sp)
    80004194:	7412                	ld	s0,288(sp)
    80004196:	6155                	addi	sp,sp,304
    80004198:	8082                	ret

000000008000419a <sys_unlink>:
{
    8000419a:	7151                	addi	sp,sp,-240
    8000419c:	f586                	sd	ra,232(sp)
    8000419e:	f1a2                	sd	s0,224(sp)
    800041a0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800041a2:	08000613          	li	a2,128
    800041a6:	f3040593          	addi	a1,s0,-208
    800041aa:	4501                	li	a0,0
    800041ac:	b15fd0ef          	jal	80001cc0 <argstr>
    800041b0:	16054063          	bltz	a0,80004310 <sys_unlink+0x176>
    800041b4:	eda6                	sd	s1,216(sp)
  begin_op();
    800041b6:	e35fe0ef          	jal	80002fea <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041ba:	fb040593          	addi	a1,s0,-80
    800041be:	f3040513          	addi	a0,s0,-208
    800041c2:	c87fe0ef          	jal	80002e48 <nameiparent>
    800041c6:	84aa                	mv	s1,a0
    800041c8:	c945                	beqz	a0,80004278 <sys_unlink+0xde>
  ilock(dp);
    800041ca:	d8afe0ef          	jal	80002754 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041ce:	00003597          	auipc	a1,0x3
    800041d2:	4b258593          	addi	a1,a1,1202 # 80007680 <etext+0x680>
    800041d6:	fb040513          	addi	a0,s0,-80
    800041da:	9d9fe0ef          	jal	80002bb2 <namecmp>
    800041de:	10050e63          	beqz	a0,800042fa <sys_unlink+0x160>
    800041e2:	00003597          	auipc	a1,0x3
    800041e6:	4a658593          	addi	a1,a1,1190 # 80007688 <etext+0x688>
    800041ea:	fb040513          	addi	a0,s0,-80
    800041ee:	9c5fe0ef          	jal	80002bb2 <namecmp>
    800041f2:	10050463          	beqz	a0,800042fa <sys_unlink+0x160>
    800041f6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800041f8:	f2c40613          	addi	a2,s0,-212
    800041fc:	fb040593          	addi	a1,s0,-80
    80004200:	8526                	mv	a0,s1
    80004202:	9c7fe0ef          	jal	80002bc8 <dirlookup>
    80004206:	892a                	mv	s2,a0
    80004208:	0e050863          	beqz	a0,800042f8 <sys_unlink+0x15e>
  ilock(ip);
    8000420c:	d48fe0ef          	jal	80002754 <ilock>
  if(ip->nlink < 1)
    80004210:	04a91783          	lh	a5,74(s2)
    80004214:	06f05763          	blez	a5,80004282 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004218:	04491703          	lh	a4,68(s2)
    8000421c:	4785                	li	a5,1
    8000421e:	06f70963          	beq	a4,a5,80004290 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004222:	4641                	li	a2,16
    80004224:	4581                	li	a1,0
    80004226:	fc040513          	addi	a0,s0,-64
    8000422a:	f4dfb0ef          	jal	80000176 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000422e:	4741                	li	a4,16
    80004230:	f2c42683          	lw	a3,-212(s0)
    80004234:	fc040613          	addi	a2,s0,-64
    80004238:	4581                	li	a1,0
    8000423a:	8526                	mv	a0,s1
    8000423c:	869fe0ef          	jal	80002aa4 <writei>
    80004240:	47c1                	li	a5,16
    80004242:	08f51b63          	bne	a0,a5,800042d8 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004246:	04491703          	lh	a4,68(s2)
    8000424a:	4785                	li	a5,1
    8000424c:	08f70d63          	beq	a4,a5,800042e6 <sys_unlink+0x14c>
  iunlockput(dp);
    80004250:	8526                	mv	a0,s1
    80004252:	f0cfe0ef          	jal	8000295e <iunlockput>
  ip->nlink--;
    80004256:	04a95783          	lhu	a5,74(s2)
    8000425a:	37fd                	addiw	a5,a5,-1
    8000425c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004260:	854a                	mv	a0,s2
    80004262:	c3efe0ef          	jal	800026a0 <iupdate>
  iunlockput(ip);
    80004266:	854a                	mv	a0,s2
    80004268:	ef6fe0ef          	jal	8000295e <iunlockput>
  end_op();
    8000426c:	de9fe0ef          	jal	80003054 <end_op>
  return 0;
    80004270:	4501                	li	a0,0
    80004272:	64ee                	ld	s1,216(sp)
    80004274:	694e                	ld	s2,208(sp)
    80004276:	a849                	j	80004308 <sys_unlink+0x16e>
    end_op();
    80004278:	dddfe0ef          	jal	80003054 <end_op>
    return -1;
    8000427c:	557d                	li	a0,-1
    8000427e:	64ee                	ld	s1,216(sp)
    80004280:	a061                	j	80004308 <sys_unlink+0x16e>
    80004282:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004284:	00003517          	auipc	a0,0x3
    80004288:	40c50513          	addi	a0,a0,1036 # 80007690 <etext+0x690>
    8000428c:	276010ef          	jal	80005502 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004290:	04c92703          	lw	a4,76(s2)
    80004294:	02000793          	li	a5,32
    80004298:	f8e7f5e3          	bgeu	a5,a4,80004222 <sys_unlink+0x88>
    8000429c:	e5ce                	sd	s3,200(sp)
    8000429e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042a2:	4741                	li	a4,16
    800042a4:	86ce                	mv	a3,s3
    800042a6:	f1840613          	addi	a2,s0,-232
    800042aa:	4581                	li	a1,0
    800042ac:	854a                	mv	a0,s2
    800042ae:	efafe0ef          	jal	800029a8 <readi>
    800042b2:	47c1                	li	a5,16
    800042b4:	00f51c63          	bne	a0,a5,800042cc <sys_unlink+0x132>
    if(de.inum != 0)
    800042b8:	f1845783          	lhu	a5,-232(s0)
    800042bc:	efa1                	bnez	a5,80004314 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042be:	29c1                	addiw	s3,s3,16
    800042c0:	04c92783          	lw	a5,76(s2)
    800042c4:	fcf9efe3          	bltu	s3,a5,800042a2 <sys_unlink+0x108>
    800042c8:	69ae                	ld	s3,200(sp)
    800042ca:	bfa1                	j	80004222 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800042cc:	00003517          	auipc	a0,0x3
    800042d0:	3dc50513          	addi	a0,a0,988 # 800076a8 <etext+0x6a8>
    800042d4:	22e010ef          	jal	80005502 <panic>
    800042d8:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800042da:	00003517          	auipc	a0,0x3
    800042de:	3e650513          	addi	a0,a0,998 # 800076c0 <etext+0x6c0>
    800042e2:	220010ef          	jal	80005502 <panic>
    dp->nlink--;
    800042e6:	04a4d783          	lhu	a5,74(s1)
    800042ea:	37fd                	addiw	a5,a5,-1
    800042ec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800042f0:	8526                	mv	a0,s1
    800042f2:	baefe0ef          	jal	800026a0 <iupdate>
    800042f6:	bfa9                	j	80004250 <sys_unlink+0xb6>
    800042f8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800042fa:	8526                	mv	a0,s1
    800042fc:	e62fe0ef          	jal	8000295e <iunlockput>
  end_op();
    80004300:	d55fe0ef          	jal	80003054 <end_op>
  return -1;
    80004304:	557d                	li	a0,-1
    80004306:	64ee                	ld	s1,216(sp)
}
    80004308:	70ae                	ld	ra,232(sp)
    8000430a:	740e                	ld	s0,224(sp)
    8000430c:	616d                	addi	sp,sp,240
    8000430e:	8082                	ret
    return -1;
    80004310:	557d                	li	a0,-1
    80004312:	bfdd                	j	80004308 <sys_unlink+0x16e>
    iunlockput(ip);
    80004314:	854a                	mv	a0,s2
    80004316:	e48fe0ef          	jal	8000295e <iunlockput>
    goto bad;
    8000431a:	694e                	ld	s2,208(sp)
    8000431c:	69ae                	ld	s3,200(sp)
    8000431e:	bff1                	j	800042fa <sys_unlink+0x160>

0000000080004320 <sys_open>:

uint64
sys_open(void)
{
    80004320:	7131                	addi	sp,sp,-192
    80004322:	fd06                	sd	ra,184(sp)
    80004324:	f922                	sd	s0,176(sp)
    80004326:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004328:	f4c40593          	addi	a1,s0,-180
    8000432c:	4505                	li	a0,1
    8000432e:	95bfd0ef          	jal	80001c88 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004332:	08000613          	li	a2,128
    80004336:	f5040593          	addi	a1,s0,-176
    8000433a:	4501                	li	a0,0
    8000433c:	985fd0ef          	jal	80001cc0 <argstr>
    80004340:	87aa                	mv	a5,a0
    return -1;
    80004342:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004344:	0a07c263          	bltz	a5,800043e8 <sys_open+0xc8>
    80004348:	f526                	sd	s1,168(sp)

  begin_op();
    8000434a:	ca1fe0ef          	jal	80002fea <begin_op>

  if(omode & O_CREATE){
    8000434e:	f4c42783          	lw	a5,-180(s0)
    80004352:	2007f793          	andi	a5,a5,512
    80004356:	c3d5                	beqz	a5,800043fa <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004358:	4681                	li	a3,0
    8000435a:	4601                	li	a2,0
    8000435c:	4589                	li	a1,2
    8000435e:	f5040513          	addi	a0,s0,-176
    80004362:	aa9ff0ef          	jal	80003e0a <create>
    80004366:	84aa                	mv	s1,a0
    if(ip == 0){
    80004368:	c541                	beqz	a0,800043f0 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000436a:	04449703          	lh	a4,68(s1)
    8000436e:	478d                	li	a5,3
    80004370:	00f71763          	bne	a4,a5,8000437e <sys_open+0x5e>
    80004374:	0464d703          	lhu	a4,70(s1)
    80004378:	47a5                	li	a5,9
    8000437a:	0ae7ed63          	bltu	a5,a4,80004434 <sys_open+0x114>
    8000437e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004380:	fe1fe0ef          	jal	80003360 <filealloc>
    80004384:	892a                	mv	s2,a0
    80004386:	c179                	beqz	a0,8000444c <sys_open+0x12c>
    80004388:	ed4e                	sd	s3,152(sp)
    8000438a:	a43ff0ef          	jal	80003dcc <fdalloc>
    8000438e:	89aa                	mv	s3,a0
    80004390:	0a054a63          	bltz	a0,80004444 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004394:	04449703          	lh	a4,68(s1)
    80004398:	478d                	li	a5,3
    8000439a:	0cf70263          	beq	a4,a5,8000445e <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000439e:	4789                	li	a5,2
    800043a0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800043a4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800043a8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800043ac:	f4c42783          	lw	a5,-180(s0)
    800043b0:	0017c713          	xori	a4,a5,1
    800043b4:	8b05                	andi	a4,a4,1
    800043b6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043ba:	0037f713          	andi	a4,a5,3
    800043be:	00e03733          	snez	a4,a4
    800043c2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043c6:	4007f793          	andi	a5,a5,1024
    800043ca:	c791                	beqz	a5,800043d6 <sys_open+0xb6>
    800043cc:	04449703          	lh	a4,68(s1)
    800043d0:	4789                	li	a5,2
    800043d2:	08f70d63          	beq	a4,a5,8000446c <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800043d6:	8526                	mv	a0,s1
    800043d8:	c2afe0ef          	jal	80002802 <iunlock>
  end_op();
    800043dc:	c79fe0ef          	jal	80003054 <end_op>

  return fd;
    800043e0:	854e                	mv	a0,s3
    800043e2:	74aa                	ld	s1,168(sp)
    800043e4:	790a                	ld	s2,160(sp)
    800043e6:	69ea                	ld	s3,152(sp)
}
    800043e8:	70ea                	ld	ra,184(sp)
    800043ea:	744a                	ld	s0,176(sp)
    800043ec:	6129                	addi	sp,sp,192
    800043ee:	8082                	ret
      end_op();
    800043f0:	c65fe0ef          	jal	80003054 <end_op>
      return -1;
    800043f4:	557d                	li	a0,-1
    800043f6:	74aa                	ld	s1,168(sp)
    800043f8:	bfc5                	j	800043e8 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800043fa:	f5040513          	addi	a0,s0,-176
    800043fe:	a31fe0ef          	jal	80002e2e <namei>
    80004402:	84aa                	mv	s1,a0
    80004404:	c11d                	beqz	a0,8000442a <sys_open+0x10a>
    ilock(ip);
    80004406:	b4efe0ef          	jal	80002754 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000440a:	04449703          	lh	a4,68(s1)
    8000440e:	4785                	li	a5,1
    80004410:	f4f71de3          	bne	a4,a5,8000436a <sys_open+0x4a>
    80004414:	f4c42783          	lw	a5,-180(s0)
    80004418:	d3bd                	beqz	a5,8000437e <sys_open+0x5e>
      iunlockput(ip);
    8000441a:	8526                	mv	a0,s1
    8000441c:	d42fe0ef          	jal	8000295e <iunlockput>
      end_op();
    80004420:	c35fe0ef          	jal	80003054 <end_op>
      return -1;
    80004424:	557d                	li	a0,-1
    80004426:	74aa                	ld	s1,168(sp)
    80004428:	b7c1                	j	800043e8 <sys_open+0xc8>
      end_op();
    8000442a:	c2bfe0ef          	jal	80003054 <end_op>
      return -1;
    8000442e:	557d                	li	a0,-1
    80004430:	74aa                	ld	s1,168(sp)
    80004432:	bf5d                	j	800043e8 <sys_open+0xc8>
    iunlockput(ip);
    80004434:	8526                	mv	a0,s1
    80004436:	d28fe0ef          	jal	8000295e <iunlockput>
    end_op();
    8000443a:	c1bfe0ef          	jal	80003054 <end_op>
    return -1;
    8000443e:	557d                	li	a0,-1
    80004440:	74aa                	ld	s1,168(sp)
    80004442:	b75d                	j	800043e8 <sys_open+0xc8>
      fileclose(f);
    80004444:	854a                	mv	a0,s2
    80004446:	fbffe0ef          	jal	80003404 <fileclose>
    8000444a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000444c:	8526                	mv	a0,s1
    8000444e:	d10fe0ef          	jal	8000295e <iunlockput>
    end_op();
    80004452:	c03fe0ef          	jal	80003054 <end_op>
    return -1;
    80004456:	557d                	li	a0,-1
    80004458:	74aa                	ld	s1,168(sp)
    8000445a:	790a                	ld	s2,160(sp)
    8000445c:	b771                	j	800043e8 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000445e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004462:	04649783          	lh	a5,70(s1)
    80004466:	02f91223          	sh	a5,36(s2)
    8000446a:	bf3d                	j	800043a8 <sys_open+0x88>
    itrunc(ip);
    8000446c:	8526                	mv	a0,s1
    8000446e:	bd4fe0ef          	jal	80002842 <itrunc>
    80004472:	b795                	j	800043d6 <sys_open+0xb6>

0000000080004474 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004474:	7175                	addi	sp,sp,-144
    80004476:	e506                	sd	ra,136(sp)
    80004478:	e122                	sd	s0,128(sp)
    8000447a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000447c:	b6ffe0ef          	jal	80002fea <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004480:	08000613          	li	a2,128
    80004484:	f7040593          	addi	a1,s0,-144
    80004488:	4501                	li	a0,0
    8000448a:	837fd0ef          	jal	80001cc0 <argstr>
    8000448e:	02054363          	bltz	a0,800044b4 <sys_mkdir+0x40>
    80004492:	4681                	li	a3,0
    80004494:	4601                	li	a2,0
    80004496:	4585                	li	a1,1
    80004498:	f7040513          	addi	a0,s0,-144
    8000449c:	96fff0ef          	jal	80003e0a <create>
    800044a0:	c911                	beqz	a0,800044b4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044a2:	cbcfe0ef          	jal	8000295e <iunlockput>
  end_op();
    800044a6:	baffe0ef          	jal	80003054 <end_op>
  return 0;
    800044aa:	4501                	li	a0,0
}
    800044ac:	60aa                	ld	ra,136(sp)
    800044ae:	640a                	ld	s0,128(sp)
    800044b0:	6149                	addi	sp,sp,144
    800044b2:	8082                	ret
    end_op();
    800044b4:	ba1fe0ef          	jal	80003054 <end_op>
    return -1;
    800044b8:	557d                	li	a0,-1
    800044ba:	bfcd                	j	800044ac <sys_mkdir+0x38>

00000000800044bc <sys_mknod>:

uint64
sys_mknod(void)
{
    800044bc:	7135                	addi	sp,sp,-160
    800044be:	ed06                	sd	ra,152(sp)
    800044c0:	e922                	sd	s0,144(sp)
    800044c2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044c4:	b27fe0ef          	jal	80002fea <begin_op>
  argint(1, &major);
    800044c8:	f6c40593          	addi	a1,s0,-148
    800044cc:	4505                	li	a0,1
    800044ce:	fbafd0ef          	jal	80001c88 <argint>
  argint(2, &minor);
    800044d2:	f6840593          	addi	a1,s0,-152
    800044d6:	4509                	li	a0,2
    800044d8:	fb0fd0ef          	jal	80001c88 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044dc:	08000613          	li	a2,128
    800044e0:	f7040593          	addi	a1,s0,-144
    800044e4:	4501                	li	a0,0
    800044e6:	fdafd0ef          	jal	80001cc0 <argstr>
    800044ea:	02054563          	bltz	a0,80004514 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800044ee:	f6841683          	lh	a3,-152(s0)
    800044f2:	f6c41603          	lh	a2,-148(s0)
    800044f6:	458d                	li	a1,3
    800044f8:	f7040513          	addi	a0,s0,-144
    800044fc:	90fff0ef          	jal	80003e0a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004500:	c911                	beqz	a0,80004514 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004502:	c5cfe0ef          	jal	8000295e <iunlockput>
  end_op();
    80004506:	b4ffe0ef          	jal	80003054 <end_op>
  return 0;
    8000450a:	4501                	li	a0,0
}
    8000450c:	60ea                	ld	ra,152(sp)
    8000450e:	644a                	ld	s0,144(sp)
    80004510:	610d                	addi	sp,sp,160
    80004512:	8082                	ret
    end_op();
    80004514:	b41fe0ef          	jal	80003054 <end_op>
    return -1;
    80004518:	557d                	li	a0,-1
    8000451a:	bfcd                	j	8000450c <sys_mknod+0x50>

000000008000451c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000451c:	7135                	addi	sp,sp,-160
    8000451e:	ed06                	sd	ra,152(sp)
    80004520:	e922                	sd	s0,144(sp)
    80004522:	e14a                	sd	s2,128(sp)
    80004524:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004526:	873fc0ef          	jal	80000d98 <myproc>
    8000452a:	892a                	mv	s2,a0
  
  begin_op();
    8000452c:	abffe0ef          	jal	80002fea <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004530:	08000613          	li	a2,128
    80004534:	f6040593          	addi	a1,s0,-160
    80004538:	4501                	li	a0,0
    8000453a:	f86fd0ef          	jal	80001cc0 <argstr>
    8000453e:	04054363          	bltz	a0,80004584 <sys_chdir+0x68>
    80004542:	e526                	sd	s1,136(sp)
    80004544:	f6040513          	addi	a0,s0,-160
    80004548:	8e7fe0ef          	jal	80002e2e <namei>
    8000454c:	84aa                	mv	s1,a0
    8000454e:	c915                	beqz	a0,80004582 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004550:	a04fe0ef          	jal	80002754 <ilock>
  if(ip->type != T_DIR){
    80004554:	04449703          	lh	a4,68(s1)
    80004558:	4785                	li	a5,1
    8000455a:	02f71963          	bne	a4,a5,8000458c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000455e:	8526                	mv	a0,s1
    80004560:	aa2fe0ef          	jal	80002802 <iunlock>
  iput(p->cwd);
    80004564:	15093503          	ld	a0,336(s2)
    80004568:	b6efe0ef          	jal	800028d6 <iput>
  end_op();
    8000456c:	ae9fe0ef          	jal	80003054 <end_op>
  p->cwd = ip;
    80004570:	14993823          	sd	s1,336(s2)
  return 0;
    80004574:	4501                	li	a0,0
    80004576:	64aa                	ld	s1,136(sp)
}
    80004578:	60ea                	ld	ra,152(sp)
    8000457a:	644a                	ld	s0,144(sp)
    8000457c:	690a                	ld	s2,128(sp)
    8000457e:	610d                	addi	sp,sp,160
    80004580:	8082                	ret
    80004582:	64aa                	ld	s1,136(sp)
    end_op();
    80004584:	ad1fe0ef          	jal	80003054 <end_op>
    return -1;
    80004588:	557d                	li	a0,-1
    8000458a:	b7fd                	j	80004578 <sys_chdir+0x5c>
    iunlockput(ip);
    8000458c:	8526                	mv	a0,s1
    8000458e:	bd0fe0ef          	jal	8000295e <iunlockput>
    end_op();
    80004592:	ac3fe0ef          	jal	80003054 <end_op>
    return -1;
    80004596:	557d                	li	a0,-1
    80004598:	64aa                	ld	s1,136(sp)
    8000459a:	bff9                	j	80004578 <sys_chdir+0x5c>

000000008000459c <sys_exec>:

uint64
sys_exec(void)
{
    8000459c:	7121                	addi	sp,sp,-448
    8000459e:	ff06                	sd	ra,440(sp)
    800045a0:	fb22                	sd	s0,432(sp)
    800045a2:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045a4:	e4840593          	addi	a1,s0,-440
    800045a8:	4505                	li	a0,1
    800045aa:	efafd0ef          	jal	80001ca4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045ae:	08000613          	li	a2,128
    800045b2:	f5040593          	addi	a1,s0,-176
    800045b6:	4501                	li	a0,0
    800045b8:	f08fd0ef          	jal	80001cc0 <argstr>
    800045bc:	87aa                	mv	a5,a0
    return -1;
    800045be:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045c0:	0c07c463          	bltz	a5,80004688 <sys_exec+0xec>
    800045c4:	f726                	sd	s1,424(sp)
    800045c6:	f34a                	sd	s2,416(sp)
    800045c8:	ef4e                	sd	s3,408(sp)
    800045ca:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800045cc:	10000613          	li	a2,256
    800045d0:	4581                	li	a1,0
    800045d2:	e5040513          	addi	a0,s0,-432
    800045d6:	ba1fb0ef          	jal	80000176 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800045da:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800045de:	89a6                	mv	s3,s1
    800045e0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800045e2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800045e6:	00391513          	slli	a0,s2,0x3
    800045ea:	e4040593          	addi	a1,s0,-448
    800045ee:	e4843783          	ld	a5,-440(s0)
    800045f2:	953e                	add	a0,a0,a5
    800045f4:	e0afd0ef          	jal	80001bfe <fetchaddr>
    800045f8:	02054663          	bltz	a0,80004624 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800045fc:	e4043783          	ld	a5,-448(s0)
    80004600:	c3a9                	beqz	a5,80004642 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004602:	af5fb0ef          	jal	800000f6 <kalloc>
    80004606:	85aa                	mv	a1,a0
    80004608:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000460c:	cd01                	beqz	a0,80004624 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000460e:	6605                	lui	a2,0x1
    80004610:	e4043503          	ld	a0,-448(s0)
    80004614:	e34fd0ef          	jal	80001c48 <fetchstr>
    80004618:	00054663          	bltz	a0,80004624 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000461c:	0905                	addi	s2,s2,1
    8000461e:	09a1                	addi	s3,s3,8
    80004620:	fd4913e3          	bne	s2,s4,800045e6 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004624:	f5040913          	addi	s2,s0,-176
    80004628:	6088                	ld	a0,0(s1)
    8000462a:	c931                	beqz	a0,8000467e <sys_exec+0xe2>
    kfree(argv[i]);
    8000462c:	9f1fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004630:	04a1                	addi	s1,s1,8
    80004632:	ff249be3          	bne	s1,s2,80004628 <sys_exec+0x8c>
  return -1;
    80004636:	557d                	li	a0,-1
    80004638:	74ba                	ld	s1,424(sp)
    8000463a:	791a                	ld	s2,416(sp)
    8000463c:	69fa                	ld	s3,408(sp)
    8000463e:	6a5a                	ld	s4,400(sp)
    80004640:	a0a1                	j	80004688 <sys_exec+0xec>
      argv[i] = 0;
    80004642:	0009079b          	sext.w	a5,s2
    80004646:	078e                	slli	a5,a5,0x3
    80004648:	fd078793          	addi	a5,a5,-48
    8000464c:	97a2                	add	a5,a5,s0
    8000464e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004652:	e5040593          	addi	a1,s0,-432
    80004656:	f5040513          	addi	a0,s0,-176
    8000465a:	ba8ff0ef          	jal	80003a02 <exec>
    8000465e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004660:	f5040993          	addi	s3,s0,-176
    80004664:	6088                	ld	a0,0(s1)
    80004666:	c511                	beqz	a0,80004672 <sys_exec+0xd6>
    kfree(argv[i]);
    80004668:	9b5fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000466c:	04a1                	addi	s1,s1,8
    8000466e:	ff349be3          	bne	s1,s3,80004664 <sys_exec+0xc8>
  return ret;
    80004672:	854a                	mv	a0,s2
    80004674:	74ba                	ld	s1,424(sp)
    80004676:	791a                	ld	s2,416(sp)
    80004678:	69fa                	ld	s3,408(sp)
    8000467a:	6a5a                	ld	s4,400(sp)
    8000467c:	a031                	j	80004688 <sys_exec+0xec>
  return -1;
    8000467e:	557d                	li	a0,-1
    80004680:	74ba                	ld	s1,424(sp)
    80004682:	791a                	ld	s2,416(sp)
    80004684:	69fa                	ld	s3,408(sp)
    80004686:	6a5a                	ld	s4,400(sp)
}
    80004688:	70fa                	ld	ra,440(sp)
    8000468a:	745a                	ld	s0,432(sp)
    8000468c:	6139                	addi	sp,sp,448
    8000468e:	8082                	ret

0000000080004690 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004690:	7139                	addi	sp,sp,-64
    80004692:	fc06                	sd	ra,56(sp)
    80004694:	f822                	sd	s0,48(sp)
    80004696:	f426                	sd	s1,40(sp)
    80004698:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000469a:	efefc0ef          	jal	80000d98 <myproc>
    8000469e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046a0:	fd840593          	addi	a1,s0,-40
    800046a4:	4501                	li	a0,0
    800046a6:	dfefd0ef          	jal	80001ca4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046aa:	fc840593          	addi	a1,s0,-56
    800046ae:	fd040513          	addi	a0,s0,-48
    800046b2:	85cff0ef          	jal	8000370e <pipealloc>
    return -1;
    800046b6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046b8:	0a054463          	bltz	a0,80004760 <sys_pipe+0xd0>
  fd0 = -1;
    800046bc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046c0:	fd043503          	ld	a0,-48(s0)
    800046c4:	f08ff0ef          	jal	80003dcc <fdalloc>
    800046c8:	fca42223          	sw	a0,-60(s0)
    800046cc:	08054163          	bltz	a0,8000474e <sys_pipe+0xbe>
    800046d0:	fc843503          	ld	a0,-56(s0)
    800046d4:	ef8ff0ef          	jal	80003dcc <fdalloc>
    800046d8:	fca42023          	sw	a0,-64(s0)
    800046dc:	06054063          	bltz	a0,8000473c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046e0:	4691                	li	a3,4
    800046e2:	fc440613          	addi	a2,s0,-60
    800046e6:	fd843583          	ld	a1,-40(s0)
    800046ea:	68a8                	ld	a0,80(s1)
    800046ec:	b1cfc0ef          	jal	80000a08 <copyout>
    800046f0:	00054e63          	bltz	a0,8000470c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800046f4:	4691                	li	a3,4
    800046f6:	fc040613          	addi	a2,s0,-64
    800046fa:	fd843583          	ld	a1,-40(s0)
    800046fe:	0591                	addi	a1,a1,4
    80004700:	68a8                	ld	a0,80(s1)
    80004702:	b06fc0ef          	jal	80000a08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004706:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004708:	04055c63          	bgez	a0,80004760 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000470c:	fc442783          	lw	a5,-60(s0)
    80004710:	07e9                	addi	a5,a5,26
    80004712:	078e                	slli	a5,a5,0x3
    80004714:	97a6                	add	a5,a5,s1
    80004716:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000471a:	fc042783          	lw	a5,-64(s0)
    8000471e:	07e9                	addi	a5,a5,26
    80004720:	078e                	slli	a5,a5,0x3
    80004722:	94be                	add	s1,s1,a5
    80004724:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004728:	fd043503          	ld	a0,-48(s0)
    8000472c:	cd9fe0ef          	jal	80003404 <fileclose>
    fileclose(wf);
    80004730:	fc843503          	ld	a0,-56(s0)
    80004734:	cd1fe0ef          	jal	80003404 <fileclose>
    return -1;
    80004738:	57fd                	li	a5,-1
    8000473a:	a01d                	j	80004760 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000473c:	fc442783          	lw	a5,-60(s0)
    80004740:	0007c763          	bltz	a5,8000474e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004744:	07e9                	addi	a5,a5,26
    80004746:	078e                	slli	a5,a5,0x3
    80004748:	97a6                	add	a5,a5,s1
    8000474a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000474e:	fd043503          	ld	a0,-48(s0)
    80004752:	cb3fe0ef          	jal	80003404 <fileclose>
    fileclose(wf);
    80004756:	fc843503          	ld	a0,-56(s0)
    8000475a:	cabfe0ef          	jal	80003404 <fileclose>
    return -1;
    8000475e:	57fd                	li	a5,-1
}
    80004760:	853e                	mv	a0,a5
    80004762:	70e2                	ld	ra,56(sp)
    80004764:	7442                	ld	s0,48(sp)
    80004766:	74a2                	ld	s1,40(sp)
    80004768:	6121                	addi	sp,sp,64
    8000476a:	8082                	ret
    8000476c:	0000                	unimp
	...

0000000080004770 <kernelvec>:
    80004770:	7111                	addi	sp,sp,-256
    80004772:	e006                	sd	ra,0(sp)
    80004774:	e40a                	sd	sp,8(sp)
    80004776:	e80e                	sd	gp,16(sp)
    80004778:	ec12                	sd	tp,24(sp)
    8000477a:	f016                	sd	t0,32(sp)
    8000477c:	f41a                	sd	t1,40(sp)
    8000477e:	f81e                	sd	t2,48(sp)
    80004780:	e4aa                	sd	a0,72(sp)
    80004782:	e8ae                	sd	a1,80(sp)
    80004784:	ecb2                	sd	a2,88(sp)
    80004786:	f0b6                	sd	a3,96(sp)
    80004788:	f4ba                	sd	a4,104(sp)
    8000478a:	f8be                	sd	a5,112(sp)
    8000478c:	fcc2                	sd	a6,120(sp)
    8000478e:	e146                	sd	a7,128(sp)
    80004790:	edf2                	sd	t3,216(sp)
    80004792:	f1f6                	sd	t4,224(sp)
    80004794:	f5fa                	sd	t5,232(sp)
    80004796:	f9fe                	sd	t6,240(sp)
    80004798:	b76fd0ef          	jal	80001b0e <kerneltrap>
    8000479c:	6082                	ld	ra,0(sp)
    8000479e:	6122                	ld	sp,8(sp)
    800047a0:	61c2                	ld	gp,16(sp)
    800047a2:	7282                	ld	t0,32(sp)
    800047a4:	7322                	ld	t1,40(sp)
    800047a6:	73c2                	ld	t2,48(sp)
    800047a8:	6526                	ld	a0,72(sp)
    800047aa:	65c6                	ld	a1,80(sp)
    800047ac:	6666                	ld	a2,88(sp)
    800047ae:	7686                	ld	a3,96(sp)
    800047b0:	7726                	ld	a4,104(sp)
    800047b2:	77c6                	ld	a5,112(sp)
    800047b4:	7866                	ld	a6,120(sp)
    800047b6:	688a                	ld	a7,128(sp)
    800047b8:	6e6e                	ld	t3,216(sp)
    800047ba:	7e8e                	ld	t4,224(sp)
    800047bc:	7f2e                	ld	t5,232(sp)
    800047be:	7fce                	ld	t6,240(sp)
    800047c0:	6111                	addi	sp,sp,256
    800047c2:	10200073          	sret
	...

00000000800047ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800047ce:	1141                	addi	sp,sp,-16
    800047d0:	e422                	sd	s0,8(sp)
    800047d2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800047d4:	0c0007b7          	lui	a5,0xc000
    800047d8:	4705                	li	a4,1
    800047da:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800047dc:	0c0007b7          	lui	a5,0xc000
    800047e0:	c3d8                	sw	a4,4(a5)
}
    800047e2:	6422                	ld	s0,8(sp)
    800047e4:	0141                	addi	sp,sp,16
    800047e6:	8082                	ret

00000000800047e8 <plicinithart>:

void
plicinithart(void)
{
    800047e8:	1141                	addi	sp,sp,-16
    800047ea:	e406                	sd	ra,8(sp)
    800047ec:	e022                	sd	s0,0(sp)
    800047ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047f0:	d7cfc0ef          	jal	80000d6c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800047f4:	0085171b          	slliw	a4,a0,0x8
    800047f8:	0c0027b7          	lui	a5,0xc002
    800047fc:	97ba                	add	a5,a5,a4
    800047fe:	40200713          	li	a4,1026
    80004802:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004806:	00d5151b          	slliw	a0,a0,0xd
    8000480a:	0c2017b7          	lui	a5,0xc201
    8000480e:	97aa                	add	a5,a5,a0
    80004810:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004814:	60a2                	ld	ra,8(sp)
    80004816:	6402                	ld	s0,0(sp)
    80004818:	0141                	addi	sp,sp,16
    8000481a:	8082                	ret

000000008000481c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000481c:	1141                	addi	sp,sp,-16
    8000481e:	e406                	sd	ra,8(sp)
    80004820:	e022                	sd	s0,0(sp)
    80004822:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004824:	d48fc0ef          	jal	80000d6c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004828:	00d5151b          	slliw	a0,a0,0xd
    8000482c:	0c2017b7          	lui	a5,0xc201
    80004830:	97aa                	add	a5,a5,a0
  return irq;
}
    80004832:	43c8                	lw	a0,4(a5)
    80004834:	60a2                	ld	ra,8(sp)
    80004836:	6402                	ld	s0,0(sp)
    80004838:	0141                	addi	sp,sp,16
    8000483a:	8082                	ret

000000008000483c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000483c:	1101                	addi	sp,sp,-32
    8000483e:	ec06                	sd	ra,24(sp)
    80004840:	e822                	sd	s0,16(sp)
    80004842:	e426                	sd	s1,8(sp)
    80004844:	1000                	addi	s0,sp,32
    80004846:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004848:	d24fc0ef          	jal	80000d6c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000484c:	00d5151b          	slliw	a0,a0,0xd
    80004850:	0c2017b7          	lui	a5,0xc201
    80004854:	97aa                	add	a5,a5,a0
    80004856:	c3c4                	sw	s1,4(a5)
}
    80004858:	60e2                	ld	ra,24(sp)
    8000485a:	6442                	ld	s0,16(sp)
    8000485c:	64a2                	ld	s1,8(sp)
    8000485e:	6105                	addi	sp,sp,32
    80004860:	8082                	ret

0000000080004862 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004862:	1141                	addi	sp,sp,-16
    80004864:	e406                	sd	ra,8(sp)
    80004866:	e022                	sd	s0,0(sp)
    80004868:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000486a:	479d                	li	a5,7
    8000486c:	04a7ca63          	blt	a5,a0,800048c0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004870:	00017797          	auipc	a5,0x17
    80004874:	ec078793          	addi	a5,a5,-320 # 8001b730 <disk>
    80004878:	97aa                	add	a5,a5,a0
    8000487a:	0187c783          	lbu	a5,24(a5)
    8000487e:	e7b9                	bnez	a5,800048cc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004880:	00451693          	slli	a3,a0,0x4
    80004884:	00017797          	auipc	a5,0x17
    80004888:	eac78793          	addi	a5,a5,-340 # 8001b730 <disk>
    8000488c:	6398                	ld	a4,0(a5)
    8000488e:	9736                	add	a4,a4,a3
    80004890:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004894:	6398                	ld	a4,0(a5)
    80004896:	9736                	add	a4,a4,a3
    80004898:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000489c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048a0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048a4:	97aa                	add	a5,a5,a0
    800048a6:	4705                	li	a4,1
    800048a8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800048ac:	00017517          	auipc	a0,0x17
    800048b0:	e9c50513          	addi	a0,a0,-356 # 8001b748 <disk+0x18>
    800048b4:	b0bfc0ef          	jal	800013be <wakeup>
}
    800048b8:	60a2                	ld	ra,8(sp)
    800048ba:	6402                	ld	s0,0(sp)
    800048bc:	0141                	addi	sp,sp,16
    800048be:	8082                	ret
    panic("free_desc 1");
    800048c0:	00003517          	auipc	a0,0x3
    800048c4:	e1050513          	addi	a0,a0,-496 # 800076d0 <etext+0x6d0>
    800048c8:	43b000ef          	jal	80005502 <panic>
    panic("free_desc 2");
    800048cc:	00003517          	auipc	a0,0x3
    800048d0:	e1450513          	addi	a0,a0,-492 # 800076e0 <etext+0x6e0>
    800048d4:	42f000ef          	jal	80005502 <panic>

00000000800048d8 <virtio_disk_init>:
{
    800048d8:	1101                	addi	sp,sp,-32
    800048da:	ec06                	sd	ra,24(sp)
    800048dc:	e822                	sd	s0,16(sp)
    800048de:	e426                	sd	s1,8(sp)
    800048e0:	e04a                	sd	s2,0(sp)
    800048e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800048e4:	00003597          	auipc	a1,0x3
    800048e8:	e0c58593          	addi	a1,a1,-500 # 800076f0 <etext+0x6f0>
    800048ec:	00017517          	auipc	a0,0x17
    800048f0:	f6c50513          	addi	a0,a0,-148 # 8001b858 <disk+0x128>
    800048f4:	6bd000ef          	jal	800057b0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800048f8:	100017b7          	lui	a5,0x10001
    800048fc:	4398                	lw	a4,0(a5)
    800048fe:	2701                	sext.w	a4,a4
    80004900:	747277b7          	lui	a5,0x74727
    80004904:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004908:	18f71063          	bne	a4,a5,80004a88 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000490c:	100017b7          	lui	a5,0x10001
    80004910:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004912:	439c                	lw	a5,0(a5)
    80004914:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004916:	4709                	li	a4,2
    80004918:	16e79863          	bne	a5,a4,80004a88 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000491c:	100017b7          	lui	a5,0x10001
    80004920:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004922:	439c                	lw	a5,0(a5)
    80004924:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004926:	16e79163          	bne	a5,a4,80004a88 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000492a:	100017b7          	lui	a5,0x10001
    8000492e:	47d8                	lw	a4,12(a5)
    80004930:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004932:	554d47b7          	lui	a5,0x554d4
    80004936:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000493a:	14f71763          	bne	a4,a5,80004a88 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000493e:	100017b7          	lui	a5,0x10001
    80004942:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004946:	4705                	li	a4,1
    80004948:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000494a:	470d                	li	a4,3
    8000494c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000494e:	10001737          	lui	a4,0x10001
    80004952:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004954:	c7ffe737          	lui	a4,0xc7ffe
    80004958:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdadef>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000495c:	8ef9                	and	a3,a3,a4
    8000495e:	10001737          	lui	a4,0x10001
    80004962:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004964:	472d                	li	a4,11
    80004966:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004968:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000496c:	439c                	lw	a5,0(a5)
    8000496e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004972:	8ba1                	andi	a5,a5,8
    80004974:	12078063          	beqz	a5,80004a94 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004978:	100017b7          	lui	a5,0x10001
    8000497c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004980:	100017b7          	lui	a5,0x10001
    80004984:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004988:	439c                	lw	a5,0(a5)
    8000498a:	2781                	sext.w	a5,a5
    8000498c:	10079a63          	bnez	a5,80004aa0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004990:	100017b7          	lui	a5,0x10001
    80004994:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004998:	439c                	lw	a5,0(a5)
    8000499a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000499c:	10078863          	beqz	a5,80004aac <virtio_disk_init+0x1d4>
  if(max < NUM)
    800049a0:	471d                	li	a4,7
    800049a2:	10f77b63          	bgeu	a4,a5,80004ab8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800049a6:	f50fb0ef          	jal	800000f6 <kalloc>
    800049aa:	00017497          	auipc	s1,0x17
    800049ae:	d8648493          	addi	s1,s1,-634 # 8001b730 <disk>
    800049b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049b4:	f42fb0ef          	jal	800000f6 <kalloc>
    800049b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049ba:	f3cfb0ef          	jal	800000f6 <kalloc>
    800049be:	87aa                	mv	a5,a0
    800049c0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049c2:	6088                	ld	a0,0(s1)
    800049c4:	10050063          	beqz	a0,80004ac4 <virtio_disk_init+0x1ec>
    800049c8:	00017717          	auipc	a4,0x17
    800049cc:	d7073703          	ld	a4,-656(a4) # 8001b738 <disk+0x8>
    800049d0:	0e070a63          	beqz	a4,80004ac4 <virtio_disk_init+0x1ec>
    800049d4:	0e078863          	beqz	a5,80004ac4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800049d8:	6605                	lui	a2,0x1
    800049da:	4581                	li	a1,0
    800049dc:	f9afb0ef          	jal	80000176 <memset>
  memset(disk.avail, 0, PGSIZE);
    800049e0:	00017497          	auipc	s1,0x17
    800049e4:	d5048493          	addi	s1,s1,-688 # 8001b730 <disk>
    800049e8:	6605                	lui	a2,0x1
    800049ea:	4581                	li	a1,0
    800049ec:	6488                	ld	a0,8(s1)
    800049ee:	f88fb0ef          	jal	80000176 <memset>
  memset(disk.used, 0, PGSIZE);
    800049f2:	6605                	lui	a2,0x1
    800049f4:	4581                	li	a1,0
    800049f6:	6888                	ld	a0,16(s1)
    800049f8:	f7efb0ef          	jal	80000176 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800049fc:	100017b7          	lui	a5,0x10001
    80004a00:	4721                	li	a4,8
    80004a02:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a04:	4098                	lw	a4,0(s1)
    80004a06:	100017b7          	lui	a5,0x10001
    80004a0a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a0e:	40d8                	lw	a4,4(s1)
    80004a10:	100017b7          	lui	a5,0x10001
    80004a14:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a18:	649c                	ld	a5,8(s1)
    80004a1a:	0007869b          	sext.w	a3,a5
    80004a1e:	10001737          	lui	a4,0x10001
    80004a22:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a26:	9781                	srai	a5,a5,0x20
    80004a28:	10001737          	lui	a4,0x10001
    80004a2c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a30:	689c                	ld	a5,16(s1)
    80004a32:	0007869b          	sext.w	a3,a5
    80004a36:	10001737          	lui	a4,0x10001
    80004a3a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a3e:	9781                	srai	a5,a5,0x20
    80004a40:	10001737          	lui	a4,0x10001
    80004a44:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a48:	10001737          	lui	a4,0x10001
    80004a4c:	4785                	li	a5,1
    80004a4e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004a50:	00f48c23          	sb	a5,24(s1)
    80004a54:	00f48ca3          	sb	a5,25(s1)
    80004a58:	00f48d23          	sb	a5,26(s1)
    80004a5c:	00f48da3          	sb	a5,27(s1)
    80004a60:	00f48e23          	sb	a5,28(s1)
    80004a64:	00f48ea3          	sb	a5,29(s1)
    80004a68:	00f48f23          	sb	a5,30(s1)
    80004a6c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a70:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a74:	100017b7          	lui	a5,0x10001
    80004a78:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004a7c:	60e2                	ld	ra,24(sp)
    80004a7e:	6442                	ld	s0,16(sp)
    80004a80:	64a2                	ld	s1,8(sp)
    80004a82:	6902                	ld	s2,0(sp)
    80004a84:	6105                	addi	sp,sp,32
    80004a86:	8082                	ret
    panic("could not find virtio disk");
    80004a88:	00003517          	auipc	a0,0x3
    80004a8c:	c7850513          	addi	a0,a0,-904 # 80007700 <etext+0x700>
    80004a90:	273000ef          	jal	80005502 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a94:	00003517          	auipc	a0,0x3
    80004a98:	c8c50513          	addi	a0,a0,-884 # 80007720 <etext+0x720>
    80004a9c:	267000ef          	jal	80005502 <panic>
    panic("virtio disk should not be ready");
    80004aa0:	00003517          	auipc	a0,0x3
    80004aa4:	ca050513          	addi	a0,a0,-864 # 80007740 <etext+0x740>
    80004aa8:	25b000ef          	jal	80005502 <panic>
    panic("virtio disk has no queue 0");
    80004aac:	00003517          	auipc	a0,0x3
    80004ab0:	cb450513          	addi	a0,a0,-844 # 80007760 <etext+0x760>
    80004ab4:	24f000ef          	jal	80005502 <panic>
    panic("virtio disk max queue too short");
    80004ab8:	00003517          	auipc	a0,0x3
    80004abc:	cc850513          	addi	a0,a0,-824 # 80007780 <etext+0x780>
    80004ac0:	243000ef          	jal	80005502 <panic>
    panic("virtio disk kalloc");
    80004ac4:	00003517          	auipc	a0,0x3
    80004ac8:	cdc50513          	addi	a0,a0,-804 # 800077a0 <etext+0x7a0>
    80004acc:	237000ef          	jal	80005502 <panic>

0000000080004ad0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ad0:	7159                	addi	sp,sp,-112
    80004ad2:	f486                	sd	ra,104(sp)
    80004ad4:	f0a2                	sd	s0,96(sp)
    80004ad6:	eca6                	sd	s1,88(sp)
    80004ad8:	e8ca                	sd	s2,80(sp)
    80004ada:	e4ce                	sd	s3,72(sp)
    80004adc:	e0d2                	sd	s4,64(sp)
    80004ade:	fc56                	sd	s5,56(sp)
    80004ae0:	f85a                	sd	s6,48(sp)
    80004ae2:	f45e                	sd	s7,40(sp)
    80004ae4:	f062                	sd	s8,32(sp)
    80004ae6:	ec66                	sd	s9,24(sp)
    80004ae8:	1880                	addi	s0,sp,112
    80004aea:	8a2a                	mv	s4,a0
    80004aec:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004aee:	00c52c83          	lw	s9,12(a0)
    80004af2:	001c9c9b          	slliw	s9,s9,0x1
    80004af6:	1c82                	slli	s9,s9,0x20
    80004af8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004afc:	00017517          	auipc	a0,0x17
    80004b00:	d5c50513          	addi	a0,a0,-676 # 8001b858 <disk+0x128>
    80004b04:	52d000ef          	jal	80005830 <acquire>
  for(int i = 0; i < 3; i++){
    80004b08:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b0a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b0c:	00017b17          	auipc	s6,0x17
    80004b10:	c24b0b13          	addi	s6,s6,-988 # 8001b730 <disk>
  for(int i = 0; i < 3; i++){
    80004b14:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b16:	00017c17          	auipc	s8,0x17
    80004b1a:	d42c0c13          	addi	s8,s8,-702 # 8001b858 <disk+0x128>
    80004b1e:	a8b9                	j	80004b7c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004b20:	00fb0733          	add	a4,s6,a5
    80004b24:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004b28:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b2a:	0207c563          	bltz	a5,80004b54 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004b2e:	2905                	addiw	s2,s2,1
    80004b30:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b32:	05590963          	beq	s2,s5,80004b84 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004b36:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b38:	00017717          	auipc	a4,0x17
    80004b3c:	bf870713          	addi	a4,a4,-1032 # 8001b730 <disk>
    80004b40:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004b42:	01874683          	lbu	a3,24(a4)
    80004b46:	fee9                	bnez	a3,80004b20 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004b48:	2785                	addiw	a5,a5,1
    80004b4a:	0705                	addi	a4,a4,1
    80004b4c:	fe979be3          	bne	a5,s1,80004b42 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004b50:	57fd                	li	a5,-1
    80004b52:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004b54:	01205d63          	blez	s2,80004b6e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b58:	f9042503          	lw	a0,-112(s0)
    80004b5c:	d07ff0ef          	jal	80004862 <free_desc>
      for(int j = 0; j < i; j++)
    80004b60:	4785                	li	a5,1
    80004b62:	0127d663          	bge	a5,s2,80004b6e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b66:	f9442503          	lw	a0,-108(s0)
    80004b6a:	cf9ff0ef          	jal	80004862 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b6e:	85e2                	mv	a1,s8
    80004b70:	00017517          	auipc	a0,0x17
    80004b74:	bd850513          	addi	a0,a0,-1064 # 8001b748 <disk+0x18>
    80004b78:	ffafc0ef          	jal	80001372 <sleep>
  for(int i = 0; i < 3; i++){
    80004b7c:	f9040613          	addi	a2,s0,-112
    80004b80:	894e                	mv	s2,s3
    80004b82:	bf55                	j	80004b36 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b84:	f9042503          	lw	a0,-112(s0)
    80004b88:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b8c:	00017797          	auipc	a5,0x17
    80004b90:	ba478793          	addi	a5,a5,-1116 # 8001b730 <disk>
    80004b94:	00a50713          	addi	a4,a0,10
    80004b98:	0712                	slli	a4,a4,0x4
    80004b9a:	973e                	add	a4,a4,a5
    80004b9c:	01703633          	snez	a2,s7
    80004ba0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004ba2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ba6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004baa:	6398                	ld	a4,0(a5)
    80004bac:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004bae:	0a868613          	addi	a2,a3,168
    80004bb2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bb4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004bb6:	6390                	ld	a2,0(a5)
    80004bb8:	00d605b3          	add	a1,a2,a3
    80004bbc:	4741                	li	a4,16
    80004bbe:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004bc0:	4805                	li	a6,1
    80004bc2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004bc6:	f9442703          	lw	a4,-108(s0)
    80004bca:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bce:	0712                	slli	a4,a4,0x4
    80004bd0:	963a                	add	a2,a2,a4
    80004bd2:	058a0593          	addi	a1,s4,88
    80004bd6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004bd8:	0007b883          	ld	a7,0(a5)
    80004bdc:	9746                	add	a4,a4,a7
    80004bde:	40000613          	li	a2,1024
    80004be2:	c710                	sw	a2,8(a4)
  if(write)
    80004be4:	001bb613          	seqz	a2,s7
    80004be8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bec:	00166613          	ori	a2,a2,1
    80004bf0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004bf4:	f9842583          	lw	a1,-104(s0)
    80004bf8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004bfc:	00250613          	addi	a2,a0,2
    80004c00:	0612                	slli	a2,a2,0x4
    80004c02:	963e                	add	a2,a2,a5
    80004c04:	577d                	li	a4,-1
    80004c06:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c0a:	0592                	slli	a1,a1,0x4
    80004c0c:	98ae                	add	a7,a7,a1
    80004c0e:	03068713          	addi	a4,a3,48
    80004c12:	973e                	add	a4,a4,a5
    80004c14:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c18:	6398                	ld	a4,0(a5)
    80004c1a:	972e                	add	a4,a4,a1
    80004c1c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c20:	4689                	li	a3,2
    80004c22:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c26:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c2a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004c2e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c32:	6794                	ld	a3,8(a5)
    80004c34:	0026d703          	lhu	a4,2(a3)
    80004c38:	8b1d                	andi	a4,a4,7
    80004c3a:	0706                	slli	a4,a4,0x1
    80004c3c:	96ba                	add	a3,a3,a4
    80004c3e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004c42:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c46:	6798                	ld	a4,8(a5)
    80004c48:	00275783          	lhu	a5,2(a4)
    80004c4c:	2785                	addiw	a5,a5,1
    80004c4e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c52:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c56:	100017b7          	lui	a5,0x10001
    80004c5a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c5e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004c62:	00017917          	auipc	s2,0x17
    80004c66:	bf690913          	addi	s2,s2,-1034 # 8001b858 <disk+0x128>
  while(b->disk == 1) {
    80004c6a:	4485                	li	s1,1
    80004c6c:	01079a63          	bne	a5,a6,80004c80 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004c70:	85ca                	mv	a1,s2
    80004c72:	8552                	mv	a0,s4
    80004c74:	efefc0ef          	jal	80001372 <sleep>
  while(b->disk == 1) {
    80004c78:	004a2783          	lw	a5,4(s4)
    80004c7c:	fe978ae3          	beq	a5,s1,80004c70 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004c80:	f9042903          	lw	s2,-112(s0)
    80004c84:	00290713          	addi	a4,s2,2
    80004c88:	0712                	slli	a4,a4,0x4
    80004c8a:	00017797          	auipc	a5,0x17
    80004c8e:	aa678793          	addi	a5,a5,-1370 # 8001b730 <disk>
    80004c92:	97ba                	add	a5,a5,a4
    80004c94:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c98:	00017997          	auipc	s3,0x17
    80004c9c:	a9898993          	addi	s3,s3,-1384 # 8001b730 <disk>
    80004ca0:	00491713          	slli	a4,s2,0x4
    80004ca4:	0009b783          	ld	a5,0(s3)
    80004ca8:	97ba                	add	a5,a5,a4
    80004caa:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004cae:	854a                	mv	a0,s2
    80004cb0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004cb4:	bafff0ef          	jal	80004862 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004cb8:	8885                	andi	s1,s1,1
    80004cba:	f0fd                	bnez	s1,80004ca0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004cbc:	00017517          	auipc	a0,0x17
    80004cc0:	b9c50513          	addi	a0,a0,-1124 # 8001b858 <disk+0x128>
    80004cc4:	405000ef          	jal	800058c8 <release>
}
    80004cc8:	70a6                	ld	ra,104(sp)
    80004cca:	7406                	ld	s0,96(sp)
    80004ccc:	64e6                	ld	s1,88(sp)
    80004cce:	6946                	ld	s2,80(sp)
    80004cd0:	69a6                	ld	s3,72(sp)
    80004cd2:	6a06                	ld	s4,64(sp)
    80004cd4:	7ae2                	ld	s5,56(sp)
    80004cd6:	7b42                	ld	s6,48(sp)
    80004cd8:	7ba2                	ld	s7,40(sp)
    80004cda:	7c02                	ld	s8,32(sp)
    80004cdc:	6ce2                	ld	s9,24(sp)
    80004cde:	6165                	addi	sp,sp,112
    80004ce0:	8082                	ret

0000000080004ce2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004ce2:	1101                	addi	sp,sp,-32
    80004ce4:	ec06                	sd	ra,24(sp)
    80004ce6:	e822                	sd	s0,16(sp)
    80004ce8:	e426                	sd	s1,8(sp)
    80004cea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004cec:	00017497          	auipc	s1,0x17
    80004cf0:	a4448493          	addi	s1,s1,-1468 # 8001b730 <disk>
    80004cf4:	00017517          	auipc	a0,0x17
    80004cf8:	b6450513          	addi	a0,a0,-1180 # 8001b858 <disk+0x128>
    80004cfc:	335000ef          	jal	80005830 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d00:	100017b7          	lui	a5,0x10001
    80004d04:	53b8                	lw	a4,96(a5)
    80004d06:	8b0d                	andi	a4,a4,3
    80004d08:	100017b7          	lui	a5,0x10001
    80004d0c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004d0e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d12:	689c                	ld	a5,16(s1)
    80004d14:	0204d703          	lhu	a4,32(s1)
    80004d18:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d1c:	04f70663          	beq	a4,a5,80004d68 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d20:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d24:	6898                	ld	a4,16(s1)
    80004d26:	0204d783          	lhu	a5,32(s1)
    80004d2a:	8b9d                	andi	a5,a5,7
    80004d2c:	078e                	slli	a5,a5,0x3
    80004d2e:	97ba                	add	a5,a5,a4
    80004d30:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d32:	00278713          	addi	a4,a5,2
    80004d36:	0712                	slli	a4,a4,0x4
    80004d38:	9726                	add	a4,a4,s1
    80004d3a:	01074703          	lbu	a4,16(a4)
    80004d3e:	e321                	bnez	a4,80004d7e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d40:	0789                	addi	a5,a5,2
    80004d42:	0792                	slli	a5,a5,0x4
    80004d44:	97a6                	add	a5,a5,s1
    80004d46:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d48:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d4c:	e72fc0ef          	jal	800013be <wakeup>

    disk.used_idx += 1;
    80004d50:	0204d783          	lhu	a5,32(s1)
    80004d54:	2785                	addiw	a5,a5,1
    80004d56:	17c2                	slli	a5,a5,0x30
    80004d58:	93c1                	srli	a5,a5,0x30
    80004d5a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d5e:	6898                	ld	a4,16(s1)
    80004d60:	00275703          	lhu	a4,2(a4)
    80004d64:	faf71ee3          	bne	a4,a5,80004d20 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d68:	00017517          	auipc	a0,0x17
    80004d6c:	af050513          	addi	a0,a0,-1296 # 8001b858 <disk+0x128>
    80004d70:	359000ef          	jal	800058c8 <release>
}
    80004d74:	60e2                	ld	ra,24(sp)
    80004d76:	6442                	ld	s0,16(sp)
    80004d78:	64a2                	ld	s1,8(sp)
    80004d7a:	6105                	addi	sp,sp,32
    80004d7c:	8082                	ret
      panic("virtio_disk_intr status");
    80004d7e:	00003517          	auipc	a0,0x3
    80004d82:	a3a50513          	addi	a0,a0,-1478 # 800077b8 <etext+0x7b8>
    80004d86:	77c000ef          	jal	80005502 <panic>

0000000080004d8a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d8a:	1141                	addi	sp,sp,-16
    80004d8c:	e422                	sd	s0,8(sp)
    80004d8e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d90:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d94:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d98:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d9c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004da0:	577d                	li	a4,-1
    80004da2:	177e                	slli	a4,a4,0x3f
    80004da4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004da6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004daa:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004dae:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004db2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004db6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004dba:	000f4737          	lui	a4,0xf4
    80004dbe:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004dc2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004dc4:	14d79073          	csrw	stimecmp,a5
}
    80004dc8:	6422                	ld	s0,8(sp)
    80004dca:	0141                	addi	sp,sp,16
    80004dcc:	8082                	ret

0000000080004dce <start>:
{
    80004dce:	1141                	addi	sp,sp,-16
    80004dd0:	e406                	sd	ra,8(sp)
    80004dd2:	e022                	sd	s0,0(sp)
    80004dd4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004dd6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004dda:	7779                	lui	a4,0xffffe
    80004ddc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdae8f>
    80004de0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004de2:	6705                	lui	a4,0x1
    80004de4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004de8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004dea:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004dee:	ffffb797          	auipc	a5,0xffffb
    80004df2:	52278793          	addi	a5,a5,1314 # 80000310 <main>
    80004df6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004dfa:	4781                	li	a5,0
    80004dfc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e00:	67c1                	lui	a5,0x10
    80004e02:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e04:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e08:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e0c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e10:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e14:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e18:	57fd                	li	a5,-1
    80004e1a:	83a9                	srli	a5,a5,0xa
    80004e1c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e20:	47bd                	li	a5,15
    80004e22:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e26:	f65ff0ef          	jal	80004d8a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e2a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e2e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e30:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e32:	30200073          	mret
}
    80004e36:	60a2                	ld	ra,8(sp)
    80004e38:	6402                	ld	s0,0(sp)
    80004e3a:	0141                	addi	sp,sp,16
    80004e3c:	8082                	ret

0000000080004e3e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e3e:	715d                	addi	sp,sp,-80
    80004e40:	e486                	sd	ra,72(sp)
    80004e42:	e0a2                	sd	s0,64(sp)
    80004e44:	f84a                	sd	s2,48(sp)
    80004e46:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004e48:	04c05263          	blez	a2,80004e8c <consolewrite+0x4e>
    80004e4c:	fc26                	sd	s1,56(sp)
    80004e4e:	f44e                	sd	s3,40(sp)
    80004e50:	f052                	sd	s4,32(sp)
    80004e52:	ec56                	sd	s5,24(sp)
    80004e54:	8a2a                	mv	s4,a0
    80004e56:	84ae                	mv	s1,a1
    80004e58:	89b2                	mv	s3,a2
    80004e5a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e5c:	5afd                	li	s5,-1
    80004e5e:	4685                	li	a3,1
    80004e60:	8626                	mv	a2,s1
    80004e62:	85d2                	mv	a1,s4
    80004e64:	fbf40513          	addi	a0,s0,-65
    80004e68:	8b1fc0ef          	jal	80001718 <either_copyin>
    80004e6c:	03550263          	beq	a0,s5,80004e90 <consolewrite+0x52>
      break;
    uartputc(c);
    80004e70:	fbf44503          	lbu	a0,-65(s0)
    80004e74:	035000ef          	jal	800056a8 <uartputc>
  for(i = 0; i < n; i++){
    80004e78:	2905                	addiw	s2,s2,1
    80004e7a:	0485                	addi	s1,s1,1
    80004e7c:	ff2991e3          	bne	s3,s2,80004e5e <consolewrite+0x20>
    80004e80:	894e                	mv	s2,s3
    80004e82:	74e2                	ld	s1,56(sp)
    80004e84:	79a2                	ld	s3,40(sp)
    80004e86:	7a02                	ld	s4,32(sp)
    80004e88:	6ae2                	ld	s5,24(sp)
    80004e8a:	a039                	j	80004e98 <consolewrite+0x5a>
    80004e8c:	4901                	li	s2,0
    80004e8e:	a029                	j	80004e98 <consolewrite+0x5a>
    80004e90:	74e2                	ld	s1,56(sp)
    80004e92:	79a2                	ld	s3,40(sp)
    80004e94:	7a02                	ld	s4,32(sp)
    80004e96:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004e98:	854a                	mv	a0,s2
    80004e9a:	60a6                	ld	ra,72(sp)
    80004e9c:	6406                	ld	s0,64(sp)
    80004e9e:	7942                	ld	s2,48(sp)
    80004ea0:	6161                	addi	sp,sp,80
    80004ea2:	8082                	ret

0000000080004ea4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004ea4:	711d                	addi	sp,sp,-96
    80004ea6:	ec86                	sd	ra,88(sp)
    80004ea8:	e8a2                	sd	s0,80(sp)
    80004eaa:	e4a6                	sd	s1,72(sp)
    80004eac:	e0ca                	sd	s2,64(sp)
    80004eae:	fc4e                	sd	s3,56(sp)
    80004eb0:	f852                	sd	s4,48(sp)
    80004eb2:	f456                	sd	s5,40(sp)
    80004eb4:	f05a                	sd	s6,32(sp)
    80004eb6:	1080                	addi	s0,sp,96
    80004eb8:	8aaa                	mv	s5,a0
    80004eba:	8a2e                	mv	s4,a1
    80004ebc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004ebe:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004ec2:	0001f517          	auipc	a0,0x1f
    80004ec6:	9ae50513          	addi	a0,a0,-1618 # 80023870 <cons>
    80004eca:	167000ef          	jal	80005830 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004ece:	0001f497          	auipc	s1,0x1f
    80004ed2:	9a248493          	addi	s1,s1,-1630 # 80023870 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ed6:	0001f917          	auipc	s2,0x1f
    80004eda:	a3290913          	addi	s2,s2,-1486 # 80023908 <cons+0x98>
  while(n > 0){
    80004ede:	0b305d63          	blez	s3,80004f98 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004ee2:	0984a783          	lw	a5,152(s1)
    80004ee6:	09c4a703          	lw	a4,156(s1)
    80004eea:	0af71263          	bne	a4,a5,80004f8e <consoleread+0xea>
      if(killed(myproc())){
    80004eee:	eabfb0ef          	jal	80000d98 <myproc>
    80004ef2:	eb8fc0ef          	jal	800015aa <killed>
    80004ef6:	e12d                	bnez	a0,80004f58 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004ef8:	85a6                	mv	a1,s1
    80004efa:	854a                	mv	a0,s2
    80004efc:	c76fc0ef          	jal	80001372 <sleep>
    while(cons.r == cons.w){
    80004f00:	0984a783          	lw	a5,152(s1)
    80004f04:	09c4a703          	lw	a4,156(s1)
    80004f08:	fef703e3          	beq	a4,a5,80004eee <consoleread+0x4a>
    80004f0c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f0e:	0001f717          	auipc	a4,0x1f
    80004f12:	96270713          	addi	a4,a4,-1694 # 80023870 <cons>
    80004f16:	0017869b          	addiw	a3,a5,1
    80004f1a:	08d72c23          	sw	a3,152(a4)
    80004f1e:	07f7f693          	andi	a3,a5,127
    80004f22:	9736                	add	a4,a4,a3
    80004f24:	01874703          	lbu	a4,24(a4)
    80004f28:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f2c:	4691                	li	a3,4
    80004f2e:	04db8663          	beq	s7,a3,80004f7a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f32:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f36:	4685                	li	a3,1
    80004f38:	faf40613          	addi	a2,s0,-81
    80004f3c:	85d2                	mv	a1,s4
    80004f3e:	8556                	mv	a0,s5
    80004f40:	f8efc0ef          	jal	800016ce <either_copyout>
    80004f44:	57fd                	li	a5,-1
    80004f46:	04f50863          	beq	a0,a5,80004f96 <consoleread+0xf2>
      break;

    dst++;
    80004f4a:	0a05                	addi	s4,s4,1
    --n;
    80004f4c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004f4e:	47a9                	li	a5,10
    80004f50:	04fb8d63          	beq	s7,a5,80004faa <consoleread+0x106>
    80004f54:	6be2                	ld	s7,24(sp)
    80004f56:	b761                	j	80004ede <consoleread+0x3a>
        release(&cons.lock);
    80004f58:	0001f517          	auipc	a0,0x1f
    80004f5c:	91850513          	addi	a0,a0,-1768 # 80023870 <cons>
    80004f60:	169000ef          	jal	800058c8 <release>
        return -1;
    80004f64:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f66:	60e6                	ld	ra,88(sp)
    80004f68:	6446                	ld	s0,80(sp)
    80004f6a:	64a6                	ld	s1,72(sp)
    80004f6c:	6906                	ld	s2,64(sp)
    80004f6e:	79e2                	ld	s3,56(sp)
    80004f70:	7a42                	ld	s4,48(sp)
    80004f72:	7aa2                	ld	s5,40(sp)
    80004f74:	7b02                	ld	s6,32(sp)
    80004f76:	6125                	addi	sp,sp,96
    80004f78:	8082                	ret
      if(n < target){
    80004f7a:	0009871b          	sext.w	a4,s3
    80004f7e:	01677a63          	bgeu	a4,s6,80004f92 <consoleread+0xee>
        cons.r--;
    80004f82:	0001f717          	auipc	a4,0x1f
    80004f86:	98f72323          	sw	a5,-1658(a4) # 80023908 <cons+0x98>
    80004f8a:	6be2                	ld	s7,24(sp)
    80004f8c:	a031                	j	80004f98 <consoleread+0xf4>
    80004f8e:	ec5e                	sd	s7,24(sp)
    80004f90:	bfbd                	j	80004f0e <consoleread+0x6a>
    80004f92:	6be2                	ld	s7,24(sp)
    80004f94:	a011                	j	80004f98 <consoleread+0xf4>
    80004f96:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004f98:	0001f517          	auipc	a0,0x1f
    80004f9c:	8d850513          	addi	a0,a0,-1832 # 80023870 <cons>
    80004fa0:	129000ef          	jal	800058c8 <release>
  return target - n;
    80004fa4:	413b053b          	subw	a0,s6,s3
    80004fa8:	bf7d                	j	80004f66 <consoleread+0xc2>
    80004faa:	6be2                	ld	s7,24(sp)
    80004fac:	b7f5                	j	80004f98 <consoleread+0xf4>

0000000080004fae <consputc>:
{
    80004fae:	1141                	addi	sp,sp,-16
    80004fb0:	e406                	sd	ra,8(sp)
    80004fb2:	e022                	sd	s0,0(sp)
    80004fb4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004fb6:	10000793          	li	a5,256
    80004fba:	00f50863          	beq	a0,a5,80004fca <consputc+0x1c>
    uartputc_sync(c);
    80004fbe:	604000ef          	jal	800055c2 <uartputc_sync>
}
    80004fc2:	60a2                	ld	ra,8(sp)
    80004fc4:	6402                	ld	s0,0(sp)
    80004fc6:	0141                	addi	sp,sp,16
    80004fc8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004fca:	4521                	li	a0,8
    80004fcc:	5f6000ef          	jal	800055c2 <uartputc_sync>
    80004fd0:	02000513          	li	a0,32
    80004fd4:	5ee000ef          	jal	800055c2 <uartputc_sync>
    80004fd8:	4521                	li	a0,8
    80004fda:	5e8000ef          	jal	800055c2 <uartputc_sync>
    80004fde:	b7d5                	j	80004fc2 <consputc+0x14>

0000000080004fe0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004fe0:	1101                	addi	sp,sp,-32
    80004fe2:	ec06                	sd	ra,24(sp)
    80004fe4:	e822                	sd	s0,16(sp)
    80004fe6:	e426                	sd	s1,8(sp)
    80004fe8:	1000                	addi	s0,sp,32
    80004fea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004fec:	0001f517          	auipc	a0,0x1f
    80004ff0:	88450513          	addi	a0,a0,-1916 # 80023870 <cons>
    80004ff4:	03d000ef          	jal	80005830 <acquire>

  switch(c){
    80004ff8:	47d5                	li	a5,21
    80004ffa:	08f48f63          	beq	s1,a5,80005098 <consoleintr+0xb8>
    80004ffe:	0297c563          	blt	a5,s1,80005028 <consoleintr+0x48>
    80005002:	47a1                	li	a5,8
    80005004:	0ef48463          	beq	s1,a5,800050ec <consoleintr+0x10c>
    80005008:	47c1                	li	a5,16
    8000500a:	10f49563          	bne	s1,a5,80005114 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000500e:	f54fc0ef          	jal	80001762 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005012:	0001f517          	auipc	a0,0x1f
    80005016:	85e50513          	addi	a0,a0,-1954 # 80023870 <cons>
    8000501a:	0af000ef          	jal	800058c8 <release>
}
    8000501e:	60e2                	ld	ra,24(sp)
    80005020:	6442                	ld	s0,16(sp)
    80005022:	64a2                	ld	s1,8(sp)
    80005024:	6105                	addi	sp,sp,32
    80005026:	8082                	ret
  switch(c){
    80005028:	07f00793          	li	a5,127
    8000502c:	0cf48063          	beq	s1,a5,800050ec <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005030:	0001f717          	auipc	a4,0x1f
    80005034:	84070713          	addi	a4,a4,-1984 # 80023870 <cons>
    80005038:	0a072783          	lw	a5,160(a4)
    8000503c:	09872703          	lw	a4,152(a4)
    80005040:	9f99                	subw	a5,a5,a4
    80005042:	07f00713          	li	a4,127
    80005046:	fcf766e3          	bltu	a4,a5,80005012 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000504a:	47b5                	li	a5,13
    8000504c:	0cf48763          	beq	s1,a5,8000511a <consoleintr+0x13a>
      consputc(c);
    80005050:	8526                	mv	a0,s1
    80005052:	f5dff0ef          	jal	80004fae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005056:	0001f797          	auipc	a5,0x1f
    8000505a:	81a78793          	addi	a5,a5,-2022 # 80023870 <cons>
    8000505e:	0a07a683          	lw	a3,160(a5)
    80005062:	0016871b          	addiw	a4,a3,1
    80005066:	0007061b          	sext.w	a2,a4
    8000506a:	0ae7a023          	sw	a4,160(a5)
    8000506e:	07f6f693          	andi	a3,a3,127
    80005072:	97b6                	add	a5,a5,a3
    80005074:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005078:	47a9                	li	a5,10
    8000507a:	0cf48563          	beq	s1,a5,80005144 <consoleintr+0x164>
    8000507e:	4791                	li	a5,4
    80005080:	0cf48263          	beq	s1,a5,80005144 <consoleintr+0x164>
    80005084:	0001f797          	auipc	a5,0x1f
    80005088:	8847a783          	lw	a5,-1916(a5) # 80023908 <cons+0x98>
    8000508c:	9f1d                	subw	a4,a4,a5
    8000508e:	08000793          	li	a5,128
    80005092:	f8f710e3          	bne	a4,a5,80005012 <consoleintr+0x32>
    80005096:	a07d                	j	80005144 <consoleintr+0x164>
    80005098:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000509a:	0001e717          	auipc	a4,0x1e
    8000509e:	7d670713          	addi	a4,a4,2006 # 80023870 <cons>
    800050a2:	0a072783          	lw	a5,160(a4)
    800050a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050aa:	0001e497          	auipc	s1,0x1e
    800050ae:	7c648493          	addi	s1,s1,1990 # 80023870 <cons>
    while(cons.e != cons.w &&
    800050b2:	4929                	li	s2,10
    800050b4:	02f70863          	beq	a4,a5,800050e4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050b8:	37fd                	addiw	a5,a5,-1
    800050ba:	07f7f713          	andi	a4,a5,127
    800050be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800050c0:	01874703          	lbu	a4,24(a4)
    800050c4:	03270263          	beq	a4,s2,800050e8 <consoleintr+0x108>
      cons.e--;
    800050c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800050cc:	10000513          	li	a0,256
    800050d0:	edfff0ef          	jal	80004fae <consputc>
    while(cons.e != cons.w &&
    800050d4:	0a04a783          	lw	a5,160(s1)
    800050d8:	09c4a703          	lw	a4,156(s1)
    800050dc:	fcf71ee3          	bne	a4,a5,800050b8 <consoleintr+0xd8>
    800050e0:	6902                	ld	s2,0(sp)
    800050e2:	bf05                	j	80005012 <consoleintr+0x32>
    800050e4:	6902                	ld	s2,0(sp)
    800050e6:	b735                	j	80005012 <consoleintr+0x32>
    800050e8:	6902                	ld	s2,0(sp)
    800050ea:	b725                	j	80005012 <consoleintr+0x32>
    if(cons.e != cons.w){
    800050ec:	0001e717          	auipc	a4,0x1e
    800050f0:	78470713          	addi	a4,a4,1924 # 80023870 <cons>
    800050f4:	0a072783          	lw	a5,160(a4)
    800050f8:	09c72703          	lw	a4,156(a4)
    800050fc:	f0f70be3          	beq	a4,a5,80005012 <consoleintr+0x32>
      cons.e--;
    80005100:	37fd                	addiw	a5,a5,-1
    80005102:	0001f717          	auipc	a4,0x1f
    80005106:	80f72723          	sw	a5,-2034(a4) # 80023910 <cons+0xa0>
      consputc(BACKSPACE);
    8000510a:	10000513          	li	a0,256
    8000510e:	ea1ff0ef          	jal	80004fae <consputc>
    80005112:	b701                	j	80005012 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005114:	ee048fe3          	beqz	s1,80005012 <consoleintr+0x32>
    80005118:	bf21                	j	80005030 <consoleintr+0x50>
      consputc(c);
    8000511a:	4529                	li	a0,10
    8000511c:	e93ff0ef          	jal	80004fae <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005120:	0001e797          	auipc	a5,0x1e
    80005124:	75078793          	addi	a5,a5,1872 # 80023870 <cons>
    80005128:	0a07a703          	lw	a4,160(a5)
    8000512c:	0017069b          	addiw	a3,a4,1
    80005130:	0006861b          	sext.w	a2,a3
    80005134:	0ad7a023          	sw	a3,160(a5)
    80005138:	07f77713          	andi	a4,a4,127
    8000513c:	97ba                	add	a5,a5,a4
    8000513e:	4729                	li	a4,10
    80005140:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005144:	0001e797          	auipc	a5,0x1e
    80005148:	7cc7a423          	sw	a2,1992(a5) # 8002390c <cons+0x9c>
        wakeup(&cons.r);
    8000514c:	0001e517          	auipc	a0,0x1e
    80005150:	7bc50513          	addi	a0,a0,1980 # 80023908 <cons+0x98>
    80005154:	a6afc0ef          	jal	800013be <wakeup>
    80005158:	bd6d                	j	80005012 <consoleintr+0x32>

000000008000515a <consoleinit>:

void
consoleinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e406                	sd	ra,8(sp)
    8000515e:	e022                	sd	s0,0(sp)
    80005160:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005162:	00002597          	auipc	a1,0x2
    80005166:	66e58593          	addi	a1,a1,1646 # 800077d0 <etext+0x7d0>
    8000516a:	0001e517          	auipc	a0,0x1e
    8000516e:	70650513          	addi	a0,a0,1798 # 80023870 <cons>
    80005172:	63e000ef          	jal	800057b0 <initlock>

  uartinit();
    80005176:	3f4000ef          	jal	8000556a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000517a:	00015797          	auipc	a5,0x15
    8000517e:	55e78793          	addi	a5,a5,1374 # 8001a6d8 <devsw>
    80005182:	00000717          	auipc	a4,0x0
    80005186:	d2270713          	addi	a4,a4,-734 # 80004ea4 <consoleread>
    8000518a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000518c:	00000717          	auipc	a4,0x0
    80005190:	cb270713          	addi	a4,a4,-846 # 80004e3e <consolewrite>
    80005194:	ef98                	sd	a4,24(a5)
}
    80005196:	60a2                	ld	ra,8(sp)
    80005198:	6402                	ld	s0,0(sp)
    8000519a:	0141                	addi	sp,sp,16
    8000519c:	8082                	ret

000000008000519e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000519e:	7179                	addi	sp,sp,-48
    800051a0:	f406                	sd	ra,40(sp)
    800051a2:	f022                	sd	s0,32(sp)
    800051a4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800051a6:	c219                	beqz	a2,800051ac <printint+0xe>
    800051a8:	08054063          	bltz	a0,80005228 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800051ac:	4881                	li	a7,0
    800051ae:	fd040693          	addi	a3,s0,-48

  i = 0;
    800051b2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800051b4:	00002617          	auipc	a2,0x2
    800051b8:	78460613          	addi	a2,a2,1924 # 80007938 <digits>
    800051bc:	883e                	mv	a6,a5
    800051be:	2785                	addiw	a5,a5,1
    800051c0:	02b57733          	remu	a4,a0,a1
    800051c4:	9732                	add	a4,a4,a2
    800051c6:	00074703          	lbu	a4,0(a4)
    800051ca:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800051ce:	872a                	mv	a4,a0
    800051d0:	02b55533          	divu	a0,a0,a1
    800051d4:	0685                	addi	a3,a3,1
    800051d6:	feb773e3          	bgeu	a4,a1,800051bc <printint+0x1e>

  if(sign)
    800051da:	00088a63          	beqz	a7,800051ee <printint+0x50>
    buf[i++] = '-';
    800051de:	1781                	addi	a5,a5,-32
    800051e0:	97a2                	add	a5,a5,s0
    800051e2:	02d00713          	li	a4,45
    800051e6:	fee78823          	sb	a4,-16(a5)
    800051ea:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800051ee:	02f05963          	blez	a5,80005220 <printint+0x82>
    800051f2:	ec26                	sd	s1,24(sp)
    800051f4:	e84a                	sd	s2,16(sp)
    800051f6:	fd040713          	addi	a4,s0,-48
    800051fa:	00f704b3          	add	s1,a4,a5
    800051fe:	fff70913          	addi	s2,a4,-1
    80005202:	993e                	add	s2,s2,a5
    80005204:	37fd                	addiw	a5,a5,-1
    80005206:	1782                	slli	a5,a5,0x20
    80005208:	9381                	srli	a5,a5,0x20
    8000520a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000520e:	fff4c503          	lbu	a0,-1(s1)
    80005212:	d9dff0ef          	jal	80004fae <consputc>
  while(--i >= 0)
    80005216:	14fd                	addi	s1,s1,-1
    80005218:	ff249be3          	bne	s1,s2,8000520e <printint+0x70>
    8000521c:	64e2                	ld	s1,24(sp)
    8000521e:	6942                	ld	s2,16(sp)
}
    80005220:	70a2                	ld	ra,40(sp)
    80005222:	7402                	ld	s0,32(sp)
    80005224:	6145                	addi	sp,sp,48
    80005226:	8082                	ret
    x = -xx;
    80005228:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000522c:	4885                	li	a7,1
    x = -xx;
    8000522e:	b741                	j	800051ae <printint+0x10>

0000000080005230 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005230:	7155                	addi	sp,sp,-208
    80005232:	e506                	sd	ra,136(sp)
    80005234:	e122                	sd	s0,128(sp)
    80005236:	f0d2                	sd	s4,96(sp)
    80005238:	0900                	addi	s0,sp,144
    8000523a:	8a2a                	mv	s4,a0
    8000523c:	e40c                	sd	a1,8(s0)
    8000523e:	e810                	sd	a2,16(s0)
    80005240:	ec14                	sd	a3,24(s0)
    80005242:	f018                	sd	a4,32(s0)
    80005244:	f41c                	sd	a5,40(s0)
    80005246:	03043823          	sd	a6,48(s0)
    8000524a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000524e:	0001e797          	auipc	a5,0x1e
    80005252:	6e27a783          	lw	a5,1762(a5) # 80023930 <pr+0x18>
    80005256:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000525a:	e3a1                	bnez	a5,8000529a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000525c:	00840793          	addi	a5,s0,8
    80005260:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005264:	00054503          	lbu	a0,0(a0)
    80005268:	26050763          	beqz	a0,800054d6 <printf+0x2a6>
    8000526c:	fca6                	sd	s1,120(sp)
    8000526e:	f8ca                	sd	s2,112(sp)
    80005270:	f4ce                	sd	s3,104(sp)
    80005272:	ecd6                	sd	s5,88(sp)
    80005274:	e8da                	sd	s6,80(sp)
    80005276:	e0e2                	sd	s8,64(sp)
    80005278:	fc66                	sd	s9,56(sp)
    8000527a:	f86a                	sd	s10,48(sp)
    8000527c:	f46e                	sd	s11,40(sp)
    8000527e:	4981                	li	s3,0
    if(cx != '%'){
    80005280:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005284:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005288:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000528c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005290:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005294:	07000d93          	li	s11,112
    80005298:	a815                	j	800052cc <printf+0x9c>
    acquire(&pr.lock);
    8000529a:	0001e517          	auipc	a0,0x1e
    8000529e:	67e50513          	addi	a0,a0,1662 # 80023918 <pr>
    800052a2:	58e000ef          	jal	80005830 <acquire>
  va_start(ap, fmt);
    800052a6:	00840793          	addi	a5,s0,8
    800052aa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052ae:	000a4503          	lbu	a0,0(s4)
    800052b2:	fd4d                	bnez	a0,8000526c <printf+0x3c>
    800052b4:	a481                	j	800054f4 <printf+0x2c4>
      consputc(cx);
    800052b6:	cf9ff0ef          	jal	80004fae <consputc>
      continue;
    800052ba:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052bc:	0014899b          	addiw	s3,s1,1
    800052c0:	013a07b3          	add	a5,s4,s3
    800052c4:	0007c503          	lbu	a0,0(a5)
    800052c8:	1e050b63          	beqz	a0,800054be <printf+0x28e>
    if(cx != '%'){
    800052cc:	ff5515e3          	bne	a0,s5,800052b6 <printf+0x86>
    i++;
    800052d0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800052d4:	009a07b3          	add	a5,s4,s1
    800052d8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800052dc:	1e090163          	beqz	s2,800054be <printf+0x28e>
    800052e0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800052e4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800052e6:	c789                	beqz	a5,800052f0 <printf+0xc0>
    800052e8:	009a0733          	add	a4,s4,s1
    800052ec:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800052f0:	03690763          	beq	s2,s6,8000531e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800052f4:	05890163          	beq	s2,s8,80005336 <printf+0x106>
    } else if(c0 == 'u'){
    800052f8:	0d990b63          	beq	s2,s9,800053ce <printf+0x19e>
    } else if(c0 == 'x'){
    800052fc:	13a90163          	beq	s2,s10,8000541e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005300:	13b90b63          	beq	s2,s11,80005436 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005304:	07300793          	li	a5,115
    80005308:	16f90a63          	beq	s2,a5,8000547c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000530c:	1b590463          	beq	s2,s5,800054b4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005310:	8556                	mv	a0,s5
    80005312:	c9dff0ef          	jal	80004fae <consputc>
      consputc(c0);
    80005316:	854a                	mv	a0,s2
    80005318:	c97ff0ef          	jal	80004fae <consputc>
    8000531c:	b745                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000531e:	f8843783          	ld	a5,-120(s0)
    80005322:	00878713          	addi	a4,a5,8
    80005326:	f8e43423          	sd	a4,-120(s0)
    8000532a:	4605                	li	a2,1
    8000532c:	45a9                	li	a1,10
    8000532e:	4388                	lw	a0,0(a5)
    80005330:	e6fff0ef          	jal	8000519e <printint>
    80005334:	b761                	j	800052bc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005336:	03678663          	beq	a5,s6,80005362 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000533a:	05878263          	beq	a5,s8,8000537e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000533e:	0b978463          	beq	a5,s9,800053e6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005342:	fda797e3          	bne	a5,s10,80005310 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005346:	f8843783          	ld	a5,-120(s0)
    8000534a:	00878713          	addi	a4,a5,8
    8000534e:	f8e43423          	sd	a4,-120(s0)
    80005352:	4601                	li	a2,0
    80005354:	45c1                	li	a1,16
    80005356:	6388                	ld	a0,0(a5)
    80005358:	e47ff0ef          	jal	8000519e <printint>
      i += 1;
    8000535c:	0029849b          	addiw	s1,s3,2
    80005360:	bfb1                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005362:	f8843783          	ld	a5,-120(s0)
    80005366:	00878713          	addi	a4,a5,8
    8000536a:	f8e43423          	sd	a4,-120(s0)
    8000536e:	4605                	li	a2,1
    80005370:	45a9                	li	a1,10
    80005372:	6388                	ld	a0,0(a5)
    80005374:	e2bff0ef          	jal	8000519e <printint>
      i += 1;
    80005378:	0029849b          	addiw	s1,s3,2
    8000537c:	b781                	j	800052bc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000537e:	06400793          	li	a5,100
    80005382:	02f68863          	beq	a3,a5,800053b2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005386:	07500793          	li	a5,117
    8000538a:	06f68c63          	beq	a3,a5,80005402 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000538e:	07800793          	li	a5,120
    80005392:	f6f69fe3          	bne	a3,a5,80005310 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005396:	f8843783          	ld	a5,-120(s0)
    8000539a:	00878713          	addi	a4,a5,8
    8000539e:	f8e43423          	sd	a4,-120(s0)
    800053a2:	4601                	li	a2,0
    800053a4:	45c1                	li	a1,16
    800053a6:	6388                	ld	a0,0(a5)
    800053a8:	df7ff0ef          	jal	8000519e <printint>
      i += 2;
    800053ac:	0039849b          	addiw	s1,s3,3
    800053b0:	b731                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053b2:	f8843783          	ld	a5,-120(s0)
    800053b6:	00878713          	addi	a4,a5,8
    800053ba:	f8e43423          	sd	a4,-120(s0)
    800053be:	4605                	li	a2,1
    800053c0:	45a9                	li	a1,10
    800053c2:	6388                	ld	a0,0(a5)
    800053c4:	ddbff0ef          	jal	8000519e <printint>
      i += 2;
    800053c8:	0039849b          	addiw	s1,s3,3
    800053cc:	bdc5                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800053ce:	f8843783          	ld	a5,-120(s0)
    800053d2:	00878713          	addi	a4,a5,8
    800053d6:	f8e43423          	sd	a4,-120(s0)
    800053da:	4601                	li	a2,0
    800053dc:	45a9                	li	a1,10
    800053de:	4388                	lw	a0,0(a5)
    800053e0:	dbfff0ef          	jal	8000519e <printint>
    800053e4:	bde1                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053e6:	f8843783          	ld	a5,-120(s0)
    800053ea:	00878713          	addi	a4,a5,8
    800053ee:	f8e43423          	sd	a4,-120(s0)
    800053f2:	4601                	li	a2,0
    800053f4:	45a9                	li	a1,10
    800053f6:	6388                	ld	a0,0(a5)
    800053f8:	da7ff0ef          	jal	8000519e <printint>
      i += 1;
    800053fc:	0029849b          	addiw	s1,s3,2
    80005400:	bd75                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005402:	f8843783          	ld	a5,-120(s0)
    80005406:	00878713          	addi	a4,a5,8
    8000540a:	f8e43423          	sd	a4,-120(s0)
    8000540e:	4601                	li	a2,0
    80005410:	45a9                	li	a1,10
    80005412:	6388                	ld	a0,0(a5)
    80005414:	d8bff0ef          	jal	8000519e <printint>
      i += 2;
    80005418:	0039849b          	addiw	s1,s3,3
    8000541c:	b545                	j	800052bc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000541e:	f8843783          	ld	a5,-120(s0)
    80005422:	00878713          	addi	a4,a5,8
    80005426:	f8e43423          	sd	a4,-120(s0)
    8000542a:	4601                	li	a2,0
    8000542c:	45c1                	li	a1,16
    8000542e:	4388                	lw	a0,0(a5)
    80005430:	d6fff0ef          	jal	8000519e <printint>
    80005434:	b561                	j	800052bc <printf+0x8c>
    80005436:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005438:	f8843783          	ld	a5,-120(s0)
    8000543c:	00878713          	addi	a4,a5,8
    80005440:	f8e43423          	sd	a4,-120(s0)
    80005444:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005448:	03000513          	li	a0,48
    8000544c:	b63ff0ef          	jal	80004fae <consputc>
  consputc('x');
    80005450:	07800513          	li	a0,120
    80005454:	b5bff0ef          	jal	80004fae <consputc>
    80005458:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000545a:	00002b97          	auipc	s7,0x2
    8000545e:	4deb8b93          	addi	s7,s7,1246 # 80007938 <digits>
    80005462:	03c9d793          	srli	a5,s3,0x3c
    80005466:	97de                	add	a5,a5,s7
    80005468:	0007c503          	lbu	a0,0(a5)
    8000546c:	b43ff0ef          	jal	80004fae <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005470:	0992                	slli	s3,s3,0x4
    80005472:	397d                	addiw	s2,s2,-1
    80005474:	fe0917e3          	bnez	s2,80005462 <printf+0x232>
    80005478:	6ba6                	ld	s7,72(sp)
    8000547a:	b589                	j	800052bc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000547c:	f8843783          	ld	a5,-120(s0)
    80005480:	00878713          	addi	a4,a5,8
    80005484:	f8e43423          	sd	a4,-120(s0)
    80005488:	0007b903          	ld	s2,0(a5)
    8000548c:	00090d63          	beqz	s2,800054a6 <printf+0x276>
      for(; *s; s++)
    80005490:	00094503          	lbu	a0,0(s2)
    80005494:	e20504e3          	beqz	a0,800052bc <printf+0x8c>
        consputc(*s);
    80005498:	b17ff0ef          	jal	80004fae <consputc>
      for(; *s; s++)
    8000549c:	0905                	addi	s2,s2,1
    8000549e:	00094503          	lbu	a0,0(s2)
    800054a2:	f97d                	bnez	a0,80005498 <printf+0x268>
    800054a4:	bd21                	j	800052bc <printf+0x8c>
        s = "(null)";
    800054a6:	00002917          	auipc	s2,0x2
    800054aa:	33290913          	addi	s2,s2,818 # 800077d8 <etext+0x7d8>
      for(; *s; s++)
    800054ae:	02800513          	li	a0,40
    800054b2:	b7dd                	j	80005498 <printf+0x268>
      consputc('%');
    800054b4:	02500513          	li	a0,37
    800054b8:	af7ff0ef          	jal	80004fae <consputc>
    800054bc:	b501                	j	800052bc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800054be:	f7843783          	ld	a5,-136(s0)
    800054c2:	e385                	bnez	a5,800054e2 <printf+0x2b2>
    800054c4:	74e6                	ld	s1,120(sp)
    800054c6:	7946                	ld	s2,112(sp)
    800054c8:	79a6                	ld	s3,104(sp)
    800054ca:	6ae6                	ld	s5,88(sp)
    800054cc:	6b46                	ld	s6,80(sp)
    800054ce:	6c06                	ld	s8,64(sp)
    800054d0:	7ce2                	ld	s9,56(sp)
    800054d2:	7d42                	ld	s10,48(sp)
    800054d4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800054d6:	4501                	li	a0,0
    800054d8:	60aa                	ld	ra,136(sp)
    800054da:	640a                	ld	s0,128(sp)
    800054dc:	7a06                	ld	s4,96(sp)
    800054de:	6169                	addi	sp,sp,208
    800054e0:	8082                	ret
    800054e2:	74e6                	ld	s1,120(sp)
    800054e4:	7946                	ld	s2,112(sp)
    800054e6:	79a6                	ld	s3,104(sp)
    800054e8:	6ae6                	ld	s5,88(sp)
    800054ea:	6b46                	ld	s6,80(sp)
    800054ec:	6c06                	ld	s8,64(sp)
    800054ee:	7ce2                	ld	s9,56(sp)
    800054f0:	7d42                	ld	s10,48(sp)
    800054f2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800054f4:	0001e517          	auipc	a0,0x1e
    800054f8:	42450513          	addi	a0,a0,1060 # 80023918 <pr>
    800054fc:	3cc000ef          	jal	800058c8 <release>
    80005500:	bfd9                	j	800054d6 <printf+0x2a6>

0000000080005502 <panic>:

void
panic(char *s)
{
    80005502:	1101                	addi	sp,sp,-32
    80005504:	ec06                	sd	ra,24(sp)
    80005506:	e822                	sd	s0,16(sp)
    80005508:	e426                	sd	s1,8(sp)
    8000550a:	1000                	addi	s0,sp,32
    8000550c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000550e:	0001e797          	auipc	a5,0x1e
    80005512:	4207a123          	sw	zero,1058(a5) # 80023930 <pr+0x18>
  printf("panic: ");
    80005516:	00002517          	auipc	a0,0x2
    8000551a:	2ca50513          	addi	a0,a0,714 # 800077e0 <etext+0x7e0>
    8000551e:	d13ff0ef          	jal	80005230 <printf>
  printf("%s\n", s);
    80005522:	85a6                	mv	a1,s1
    80005524:	00002517          	auipc	a0,0x2
    80005528:	2c450513          	addi	a0,a0,708 # 800077e8 <etext+0x7e8>
    8000552c:	d05ff0ef          	jal	80005230 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005530:	4785                	li	a5,1
    80005532:	00005717          	auipc	a4,0x5
    80005536:	eef72d23          	sw	a5,-262(a4) # 8000a42c <panicked>
  for(;;)
    8000553a:	a001                	j	8000553a <panic+0x38>

000000008000553c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000553c:	1101                	addi	sp,sp,-32
    8000553e:	ec06                	sd	ra,24(sp)
    80005540:	e822                	sd	s0,16(sp)
    80005542:	e426                	sd	s1,8(sp)
    80005544:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005546:	0001e497          	auipc	s1,0x1e
    8000554a:	3d248493          	addi	s1,s1,978 # 80023918 <pr>
    8000554e:	00002597          	auipc	a1,0x2
    80005552:	2a258593          	addi	a1,a1,674 # 800077f0 <etext+0x7f0>
    80005556:	8526                	mv	a0,s1
    80005558:	258000ef          	jal	800057b0 <initlock>
  pr.locking = 1;
    8000555c:	4785                	li	a5,1
    8000555e:	cc9c                	sw	a5,24(s1)
}
    80005560:	60e2                	ld	ra,24(sp)
    80005562:	6442                	ld	s0,16(sp)
    80005564:	64a2                	ld	s1,8(sp)
    80005566:	6105                	addi	sp,sp,32
    80005568:	8082                	ret

000000008000556a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000556a:	1141                	addi	sp,sp,-16
    8000556c:	e406                	sd	ra,8(sp)
    8000556e:	e022                	sd	s0,0(sp)
    80005570:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005572:	100007b7          	lui	a5,0x10000
    80005576:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000557a:	10000737          	lui	a4,0x10000
    8000557e:	f8000693          	li	a3,-128
    80005582:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005586:	468d                	li	a3,3
    80005588:	10000637          	lui	a2,0x10000
    8000558c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005590:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005594:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005598:	10000737          	lui	a4,0x10000
    8000559c:	461d                	li	a2,7
    8000559e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800055a2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800055a6:	00002597          	auipc	a1,0x2
    800055aa:	25258593          	addi	a1,a1,594 # 800077f8 <etext+0x7f8>
    800055ae:	0001e517          	auipc	a0,0x1e
    800055b2:	38a50513          	addi	a0,a0,906 # 80023938 <uart_tx_lock>
    800055b6:	1fa000ef          	jal	800057b0 <initlock>
}
    800055ba:	60a2                	ld	ra,8(sp)
    800055bc:	6402                	ld	s0,0(sp)
    800055be:	0141                	addi	sp,sp,16
    800055c0:	8082                	ret

00000000800055c2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800055c2:	1101                	addi	sp,sp,-32
    800055c4:	ec06                	sd	ra,24(sp)
    800055c6:	e822                	sd	s0,16(sp)
    800055c8:	e426                	sd	s1,8(sp)
    800055ca:	1000                	addi	s0,sp,32
    800055cc:	84aa                	mv	s1,a0
  push_off();
    800055ce:	222000ef          	jal	800057f0 <push_off>

  if(panicked){
    800055d2:	00005797          	auipc	a5,0x5
    800055d6:	e5a7a783          	lw	a5,-422(a5) # 8000a42c <panicked>
    800055da:	e795                	bnez	a5,80005606 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800055dc:	10000737          	lui	a4,0x10000
    800055e0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800055e2:	00074783          	lbu	a5,0(a4)
    800055e6:	0207f793          	andi	a5,a5,32
    800055ea:	dfe5                	beqz	a5,800055e2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800055ec:	0ff4f513          	zext.b	a0,s1
    800055f0:	100007b7          	lui	a5,0x10000
    800055f4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800055f8:	27c000ef          	jal	80005874 <pop_off>
}
    800055fc:	60e2                	ld	ra,24(sp)
    800055fe:	6442                	ld	s0,16(sp)
    80005600:	64a2                	ld	s1,8(sp)
    80005602:	6105                	addi	sp,sp,32
    80005604:	8082                	ret
    for(;;)
    80005606:	a001                	j	80005606 <uartputc_sync+0x44>

0000000080005608 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005608:	00005797          	auipc	a5,0x5
    8000560c:	e287b783          	ld	a5,-472(a5) # 8000a430 <uart_tx_r>
    80005610:	00005717          	auipc	a4,0x5
    80005614:	e2873703          	ld	a4,-472(a4) # 8000a438 <uart_tx_w>
    80005618:	08f70263          	beq	a4,a5,8000569c <uartstart+0x94>
{
    8000561c:	7139                	addi	sp,sp,-64
    8000561e:	fc06                	sd	ra,56(sp)
    80005620:	f822                	sd	s0,48(sp)
    80005622:	f426                	sd	s1,40(sp)
    80005624:	f04a                	sd	s2,32(sp)
    80005626:	ec4e                	sd	s3,24(sp)
    80005628:	e852                	sd	s4,16(sp)
    8000562a:	e456                	sd	s5,8(sp)
    8000562c:	e05a                	sd	s6,0(sp)
    8000562e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005630:	10000937          	lui	s2,0x10000
    80005634:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005636:	0001ea97          	auipc	s5,0x1e
    8000563a:	302a8a93          	addi	s5,s5,770 # 80023938 <uart_tx_lock>
    uart_tx_r += 1;
    8000563e:	00005497          	auipc	s1,0x5
    80005642:	df248493          	addi	s1,s1,-526 # 8000a430 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005646:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000564a:	00005997          	auipc	s3,0x5
    8000564e:	dee98993          	addi	s3,s3,-530 # 8000a438 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005652:	00094703          	lbu	a4,0(s2)
    80005656:	02077713          	andi	a4,a4,32
    8000565a:	c71d                	beqz	a4,80005688 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000565c:	01f7f713          	andi	a4,a5,31
    80005660:	9756                	add	a4,a4,s5
    80005662:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005666:	0785                	addi	a5,a5,1
    80005668:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000566a:	8526                	mv	a0,s1
    8000566c:	d53fb0ef          	jal	800013be <wakeup>
    WriteReg(THR, c);
    80005670:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005674:	609c                	ld	a5,0(s1)
    80005676:	0009b703          	ld	a4,0(s3)
    8000567a:	fcf71ce3          	bne	a4,a5,80005652 <uartstart+0x4a>
      ReadReg(ISR);
    8000567e:	100007b7          	lui	a5,0x10000
    80005682:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005684:	0007c783          	lbu	a5,0(a5)
  }
}
    80005688:	70e2                	ld	ra,56(sp)
    8000568a:	7442                	ld	s0,48(sp)
    8000568c:	74a2                	ld	s1,40(sp)
    8000568e:	7902                	ld	s2,32(sp)
    80005690:	69e2                	ld	s3,24(sp)
    80005692:	6a42                	ld	s4,16(sp)
    80005694:	6aa2                	ld	s5,8(sp)
    80005696:	6b02                	ld	s6,0(sp)
    80005698:	6121                	addi	sp,sp,64
    8000569a:	8082                	ret
      ReadReg(ISR);
    8000569c:	100007b7          	lui	a5,0x10000
    800056a0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800056a2:	0007c783          	lbu	a5,0(a5)
      return;
    800056a6:	8082                	ret

00000000800056a8 <uartputc>:
{
    800056a8:	7179                	addi	sp,sp,-48
    800056aa:	f406                	sd	ra,40(sp)
    800056ac:	f022                	sd	s0,32(sp)
    800056ae:	ec26                	sd	s1,24(sp)
    800056b0:	e84a                	sd	s2,16(sp)
    800056b2:	e44e                	sd	s3,8(sp)
    800056b4:	e052                	sd	s4,0(sp)
    800056b6:	1800                	addi	s0,sp,48
    800056b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800056ba:	0001e517          	auipc	a0,0x1e
    800056be:	27e50513          	addi	a0,a0,638 # 80023938 <uart_tx_lock>
    800056c2:	16e000ef          	jal	80005830 <acquire>
  if(panicked){
    800056c6:	00005797          	auipc	a5,0x5
    800056ca:	d667a783          	lw	a5,-666(a5) # 8000a42c <panicked>
    800056ce:	efbd                	bnez	a5,8000574c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056d0:	00005717          	auipc	a4,0x5
    800056d4:	d6873703          	ld	a4,-664(a4) # 8000a438 <uart_tx_w>
    800056d8:	00005797          	auipc	a5,0x5
    800056dc:	d587b783          	ld	a5,-680(a5) # 8000a430 <uart_tx_r>
    800056e0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800056e4:	0001e997          	auipc	s3,0x1e
    800056e8:	25498993          	addi	s3,s3,596 # 80023938 <uart_tx_lock>
    800056ec:	00005497          	auipc	s1,0x5
    800056f0:	d4448493          	addi	s1,s1,-700 # 8000a430 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056f4:	00005917          	auipc	s2,0x5
    800056f8:	d4490913          	addi	s2,s2,-700 # 8000a438 <uart_tx_w>
    800056fc:	00e79d63          	bne	a5,a4,80005716 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005700:	85ce                	mv	a1,s3
    80005702:	8526                	mv	a0,s1
    80005704:	c6ffb0ef          	jal	80001372 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005708:	00093703          	ld	a4,0(s2)
    8000570c:	609c                	ld	a5,0(s1)
    8000570e:	02078793          	addi	a5,a5,32
    80005712:	fee787e3          	beq	a5,a4,80005700 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005716:	0001e497          	auipc	s1,0x1e
    8000571a:	22248493          	addi	s1,s1,546 # 80023938 <uart_tx_lock>
    8000571e:	01f77793          	andi	a5,a4,31
    80005722:	97a6                	add	a5,a5,s1
    80005724:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005728:	0705                	addi	a4,a4,1
    8000572a:	00005797          	auipc	a5,0x5
    8000572e:	d0e7b723          	sd	a4,-754(a5) # 8000a438 <uart_tx_w>
  uartstart();
    80005732:	ed7ff0ef          	jal	80005608 <uartstart>
  release(&uart_tx_lock);
    80005736:	8526                	mv	a0,s1
    80005738:	190000ef          	jal	800058c8 <release>
}
    8000573c:	70a2                	ld	ra,40(sp)
    8000573e:	7402                	ld	s0,32(sp)
    80005740:	64e2                	ld	s1,24(sp)
    80005742:	6942                	ld	s2,16(sp)
    80005744:	69a2                	ld	s3,8(sp)
    80005746:	6a02                	ld	s4,0(sp)
    80005748:	6145                	addi	sp,sp,48
    8000574a:	8082                	ret
    for(;;)
    8000574c:	a001                	j	8000574c <uartputc+0xa4>

000000008000574e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000574e:	1141                	addi	sp,sp,-16
    80005750:	e422                	sd	s0,8(sp)
    80005752:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005754:	100007b7          	lui	a5,0x10000
    80005758:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000575a:	0007c783          	lbu	a5,0(a5)
    8000575e:	8b85                	andi	a5,a5,1
    80005760:	cb81                	beqz	a5,80005770 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005762:	100007b7          	lui	a5,0x10000
    80005766:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000576a:	6422                	ld	s0,8(sp)
    8000576c:	0141                	addi	sp,sp,16
    8000576e:	8082                	ret
    return -1;
    80005770:	557d                	li	a0,-1
    80005772:	bfe5                	j	8000576a <uartgetc+0x1c>

0000000080005774 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005774:	1101                	addi	sp,sp,-32
    80005776:	ec06                	sd	ra,24(sp)
    80005778:	e822                	sd	s0,16(sp)
    8000577a:	e426                	sd	s1,8(sp)
    8000577c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000577e:	54fd                	li	s1,-1
    80005780:	a019                	j	80005786 <uartintr+0x12>
      break;
    consoleintr(c);
    80005782:	85fff0ef          	jal	80004fe0 <consoleintr>
    int c = uartgetc();
    80005786:	fc9ff0ef          	jal	8000574e <uartgetc>
    if(c == -1)
    8000578a:	fe951ce3          	bne	a0,s1,80005782 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000578e:	0001e497          	auipc	s1,0x1e
    80005792:	1aa48493          	addi	s1,s1,426 # 80023938 <uart_tx_lock>
    80005796:	8526                	mv	a0,s1
    80005798:	098000ef          	jal	80005830 <acquire>
  uartstart();
    8000579c:	e6dff0ef          	jal	80005608 <uartstart>
  release(&uart_tx_lock);
    800057a0:	8526                	mv	a0,s1
    800057a2:	126000ef          	jal	800058c8 <release>
}
    800057a6:	60e2                	ld	ra,24(sp)
    800057a8:	6442                	ld	s0,16(sp)
    800057aa:	64a2                	ld	s1,8(sp)
    800057ac:	6105                	addi	sp,sp,32
    800057ae:	8082                	ret

00000000800057b0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800057b0:	1141                	addi	sp,sp,-16
    800057b2:	e422                	sd	s0,8(sp)
    800057b4:	0800                	addi	s0,sp,16
  lk->name = name;
    800057b6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800057b8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800057bc:	00053823          	sd	zero,16(a0)
}
    800057c0:	6422                	ld	s0,8(sp)
    800057c2:	0141                	addi	sp,sp,16
    800057c4:	8082                	ret

00000000800057c6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800057c6:	411c                	lw	a5,0(a0)
    800057c8:	e399                	bnez	a5,800057ce <holding+0x8>
    800057ca:	4501                	li	a0,0
  return r;
}
    800057cc:	8082                	ret
{
    800057ce:	1101                	addi	sp,sp,-32
    800057d0:	ec06                	sd	ra,24(sp)
    800057d2:	e822                	sd	s0,16(sp)
    800057d4:	e426                	sd	s1,8(sp)
    800057d6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800057d8:	6904                	ld	s1,16(a0)
    800057da:	da2fb0ef          	jal	80000d7c <mycpu>
    800057de:	40a48533          	sub	a0,s1,a0
    800057e2:	00153513          	seqz	a0,a0
}
    800057e6:	60e2                	ld	ra,24(sp)
    800057e8:	6442                	ld	s0,16(sp)
    800057ea:	64a2                	ld	s1,8(sp)
    800057ec:	6105                	addi	sp,sp,32
    800057ee:	8082                	ret

00000000800057f0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800057f0:	1101                	addi	sp,sp,-32
    800057f2:	ec06                	sd	ra,24(sp)
    800057f4:	e822                	sd	s0,16(sp)
    800057f6:	e426                	sd	s1,8(sp)
    800057f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800057fa:	100024f3          	csrr	s1,sstatus
    800057fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005802:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005804:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005808:	d74fb0ef          	jal	80000d7c <mycpu>
    8000580c:	5d3c                	lw	a5,120(a0)
    8000580e:	cb99                	beqz	a5,80005824 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005810:	d6cfb0ef          	jal	80000d7c <mycpu>
    80005814:	5d3c                	lw	a5,120(a0)
    80005816:	2785                	addiw	a5,a5,1
    80005818:	dd3c                	sw	a5,120(a0)
}
    8000581a:	60e2                	ld	ra,24(sp)
    8000581c:	6442                	ld	s0,16(sp)
    8000581e:	64a2                	ld	s1,8(sp)
    80005820:	6105                	addi	sp,sp,32
    80005822:	8082                	ret
    mycpu()->intena = old;
    80005824:	d58fb0ef          	jal	80000d7c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005828:	8085                	srli	s1,s1,0x1
    8000582a:	8885                	andi	s1,s1,1
    8000582c:	dd64                	sw	s1,124(a0)
    8000582e:	b7cd                	j	80005810 <push_off+0x20>

0000000080005830 <acquire>:
{
    80005830:	1101                	addi	sp,sp,-32
    80005832:	ec06                	sd	ra,24(sp)
    80005834:	e822                	sd	s0,16(sp)
    80005836:	e426                	sd	s1,8(sp)
    80005838:	1000                	addi	s0,sp,32
    8000583a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000583c:	fb5ff0ef          	jal	800057f0 <push_off>
  if(holding(lk))
    80005840:	8526                	mv	a0,s1
    80005842:	f85ff0ef          	jal	800057c6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005846:	4705                	li	a4,1
  if(holding(lk))
    80005848:	e105                	bnez	a0,80005868 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000584a:	87ba                	mv	a5,a4
    8000584c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005850:	2781                	sext.w	a5,a5
    80005852:	ffe5                	bnez	a5,8000584a <acquire+0x1a>
  __sync_synchronize();
    80005854:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005858:	d24fb0ef          	jal	80000d7c <mycpu>
    8000585c:	e888                	sd	a0,16(s1)
}
    8000585e:	60e2                	ld	ra,24(sp)
    80005860:	6442                	ld	s0,16(sp)
    80005862:	64a2                	ld	s1,8(sp)
    80005864:	6105                	addi	sp,sp,32
    80005866:	8082                	ret
    panic("acquire");
    80005868:	00002517          	auipc	a0,0x2
    8000586c:	f9850513          	addi	a0,a0,-104 # 80007800 <etext+0x800>
    80005870:	c93ff0ef          	jal	80005502 <panic>

0000000080005874 <pop_off>:

void
pop_off(void)
{
    80005874:	1141                	addi	sp,sp,-16
    80005876:	e406                	sd	ra,8(sp)
    80005878:	e022                	sd	s0,0(sp)
    8000587a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000587c:	d00fb0ef          	jal	80000d7c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005880:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005884:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005886:	e78d                	bnez	a5,800058b0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005888:	5d3c                	lw	a5,120(a0)
    8000588a:	02f05963          	blez	a5,800058bc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000588e:	37fd                	addiw	a5,a5,-1
    80005890:	0007871b          	sext.w	a4,a5
    80005894:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005896:	eb09                	bnez	a4,800058a8 <pop_off+0x34>
    80005898:	5d7c                	lw	a5,124(a0)
    8000589a:	c799                	beqz	a5,800058a8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000589c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800058a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058a4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800058a8:	60a2                	ld	ra,8(sp)
    800058aa:	6402                	ld	s0,0(sp)
    800058ac:	0141                	addi	sp,sp,16
    800058ae:	8082                	ret
    panic("pop_off - interruptible");
    800058b0:	00002517          	auipc	a0,0x2
    800058b4:	f5850513          	addi	a0,a0,-168 # 80007808 <etext+0x808>
    800058b8:	c4bff0ef          	jal	80005502 <panic>
    panic("pop_off");
    800058bc:	00002517          	auipc	a0,0x2
    800058c0:	f6450513          	addi	a0,a0,-156 # 80007820 <etext+0x820>
    800058c4:	c3fff0ef          	jal	80005502 <panic>

00000000800058c8 <release>:
{
    800058c8:	1101                	addi	sp,sp,-32
    800058ca:	ec06                	sd	ra,24(sp)
    800058cc:	e822                	sd	s0,16(sp)
    800058ce:	e426                	sd	s1,8(sp)
    800058d0:	1000                	addi	s0,sp,32
    800058d2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800058d4:	ef3ff0ef          	jal	800057c6 <holding>
    800058d8:	c105                	beqz	a0,800058f8 <release+0x30>
  lk->cpu = 0;
    800058da:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800058de:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800058e2:	0310000f          	fence	rw,w
    800058e6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800058ea:	f8bff0ef          	jal	80005874 <pop_off>
}
    800058ee:	60e2                	ld	ra,24(sp)
    800058f0:	6442                	ld	s0,16(sp)
    800058f2:	64a2                	ld	s1,8(sp)
    800058f4:	6105                	addi	sp,sp,32
    800058f6:	8082                	ret
    panic("release");
    800058f8:	00002517          	auipc	a0,0x2
    800058fc:	f3050513          	addi	a0,a0,-208 # 80007828 <etext+0x828>
    80005900:	c03ff0ef          	jal	80005502 <panic>
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
