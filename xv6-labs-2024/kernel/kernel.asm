
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	3a813103          	ld	sp,936(sp) # 8000a3a8 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	559040ef          	jal	80004d6e <start>

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
    80000034:	6f078793          	addi	a5,a5,1776 # 80023720 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	3ac90913          	addi	s2,s2,940 # 8000a3f0 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	782050ef          	jal	800057d0 <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	00b050ef          	jal	80005868 <release>
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
    80000076:	42c050ef          	jal	800054a2 <panic>

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
    800000d6:	31e50513          	addi	a0,a0,798 # 8000a3f0 <kmem>
    800000da:	676050ef          	jal	80005750 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00023517          	auipc	a0,0x23
    800000e6:	63e50513          	addi	a0,a0,1598 # 80023720 <end>
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
    80000104:	2f048493          	addi	s1,s1,752 # 8000a3f0 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	6c6050ef          	jal	800057d0 <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	2ef73a23          	sd	a5,756(a4) # 8000a408 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	2d450513          	addi	a0,a0,724 # 8000a3f0 <kmem>
    80000124:	744050ef          	jal	80005868 <release>
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
    80000142:	2b248493          	addi	s1,s1,690 # 8000a3f0 <kmem>
    80000146:	8526                	mv	a0,s1
    80000148:	688050ef          	jal	800057d0 <acquire>
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
    8000015c:	29850513          	addi	a0,a0,664 # 8000a3f0 <kmem>
    80000160:	708050ef          	jal	80005868 <release>
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
    80000176:	1141                	addi	sp,sp,-16
    80000178:	e422                	sd	s0,8(sp)
    8000017a:	0800                	addi	s0,sp,16
    8000017c:	ca19                	beqz	a2,80000192 <memset+0x1c>
    8000017e:	87aa                	mv	a5,a0
    80000180:	1602                	slli	a2,a2,0x20
    80000182:	9201                	srli	a2,a2,0x20
    80000184:	00a60733          	add	a4,a2,a0
    80000188:	00b78023          	sb	a1,0(a5)
    8000018c:	0785                	addi	a5,a5,1
    8000018e:	fee79de3          	bne	a5,a4,80000188 <memset+0x12>
    80000192:	6422                	ld	s0,8(sp)
    80000194:	0141                	addi	sp,sp,16
    80000196:	8082                	ret

0000000080000198 <memcmp>:
    80000198:	1141                	addi	sp,sp,-16
    8000019a:	e422                	sd	s0,8(sp)
    8000019c:	0800                	addi	s0,sp,16
    8000019e:	ca05                	beqz	a2,800001ce <memcmp+0x36>
    800001a0:	fff6069b          	addiw	a3,a2,-1
    800001a4:	1682                	slli	a3,a3,0x20
    800001a6:	9281                	srli	a3,a3,0x20
    800001a8:	0685                	addi	a3,a3,1
    800001aa:	96aa                	add	a3,a3,a0
    800001ac:	00054783          	lbu	a5,0(a0)
    800001b0:	0005c703          	lbu	a4,0(a1)
    800001b4:	00e79863          	bne	a5,a4,800001c4 <memcmp+0x2c>
    800001b8:	0505                	addi	a0,a0,1
    800001ba:	0585                	addi	a1,a1,1
    800001bc:	fed518e3          	bne	a0,a3,800001ac <memcmp+0x14>
    800001c0:	4501                	li	a0,0
    800001c2:	a019                	j	800001c8 <memcmp+0x30>
    800001c4:	40e7853b          	subw	a0,a5,a4
    800001c8:	6422                	ld	s0,8(sp)
    800001ca:	0141                	addi	sp,sp,16
    800001cc:	8082                	ret
    800001ce:	4501                	li	a0,0
    800001d0:	bfe5                	j	800001c8 <memcmp+0x30>

00000000800001d2 <memmove>:
    800001d2:	1141                	addi	sp,sp,-16
    800001d4:	e422                	sd	s0,8(sp)
    800001d6:	0800                	addi	s0,sp,16
    800001d8:	c205                	beqz	a2,800001f8 <memmove+0x26>
    800001da:	02a5e263          	bltu	a1,a0,800001fe <memmove+0x2c>
    800001de:	1602                	slli	a2,a2,0x20
    800001e0:	9201                	srli	a2,a2,0x20
    800001e2:	00c587b3          	add	a5,a1,a2
    800001e6:	872a                	mv	a4,a0
    800001e8:	0585                	addi	a1,a1,1
    800001ea:	0705                	addi	a4,a4,1
    800001ec:	fff5c683          	lbu	a3,-1(a1)
    800001f0:	fed70fa3          	sb	a3,-1(a4)
    800001f4:	feb79ae3          	bne	a5,a1,800001e8 <memmove+0x16>
    800001f8:	6422                	ld	s0,8(sp)
    800001fa:	0141                	addi	sp,sp,16
    800001fc:	8082                	ret
    800001fe:	02061693          	slli	a3,a2,0x20
    80000202:	9281                	srli	a3,a3,0x20
    80000204:	00d58733          	add	a4,a1,a3
    80000208:	fce57be3          	bgeu	a0,a4,800001de <memmove+0xc>
    8000020c:	96aa                	add	a3,a3,a0
    8000020e:	fff6079b          	addiw	a5,a2,-1
    80000212:	1782                	slli	a5,a5,0x20
    80000214:	9381                	srli	a5,a5,0x20
    80000216:	fff7c793          	not	a5,a5
    8000021a:	97ba                	add	a5,a5,a4
    8000021c:	177d                	addi	a4,a4,-1
    8000021e:	16fd                	addi	a3,a3,-1
    80000220:	00074603          	lbu	a2,0(a4)
    80000224:	00c68023          	sb	a2,0(a3)
    80000228:	fef71ae3          	bne	a4,a5,8000021c <memmove+0x4a>
    8000022c:	b7f1                	j	800001f8 <memmove+0x26>

000000008000022e <memcpy>:
    8000022e:	1141                	addi	sp,sp,-16
    80000230:	e406                	sd	ra,8(sp)
    80000232:	e022                	sd	s0,0(sp)
    80000234:	0800                	addi	s0,sp,16
    80000236:	f9dff0ef          	jal	800001d2 <memmove>
    8000023a:	60a2                	ld	ra,8(sp)
    8000023c:	6402                	ld	s0,0(sp)
    8000023e:	0141                	addi	sp,sp,16
    80000240:	8082                	ret

0000000080000242 <strncmp>:
    80000242:	1141                	addi	sp,sp,-16
    80000244:	e422                	sd	s0,8(sp)
    80000246:	0800                	addi	s0,sp,16
    80000248:	ce11                	beqz	a2,80000264 <strncmp+0x22>
    8000024a:	00054783          	lbu	a5,0(a0)
    8000024e:	cf89                	beqz	a5,80000268 <strncmp+0x26>
    80000250:	0005c703          	lbu	a4,0(a1)
    80000254:	00f71a63          	bne	a4,a5,80000268 <strncmp+0x26>
    80000258:	367d                	addiw	a2,a2,-1
    8000025a:	0505                	addi	a0,a0,1
    8000025c:	0585                	addi	a1,a1,1
    8000025e:	f675                	bnez	a2,8000024a <strncmp+0x8>
    80000260:	4501                	li	a0,0
    80000262:	a801                	j	80000272 <strncmp+0x30>
    80000264:	4501                	li	a0,0
    80000266:	a031                	j	80000272 <strncmp+0x30>
    80000268:	00054503          	lbu	a0,0(a0)
    8000026c:	0005c783          	lbu	a5,0(a1)
    80000270:	9d1d                	subw	a0,a0,a5
    80000272:	6422                	ld	s0,8(sp)
    80000274:	0141                	addi	sp,sp,16
    80000276:	8082                	ret

0000000080000278 <strncpy>:
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e422                	sd	s0,8(sp)
    8000027c:	0800                	addi	s0,sp,16
    8000027e:	87aa                	mv	a5,a0
    80000280:	86b2                	mv	a3,a2
    80000282:	367d                	addiw	a2,a2,-1
    80000284:	02d05563          	blez	a3,800002ae <strncpy+0x36>
    80000288:	0785                	addi	a5,a5,1
    8000028a:	0005c703          	lbu	a4,0(a1)
    8000028e:	fee78fa3          	sb	a4,-1(a5)
    80000292:	0585                	addi	a1,a1,1
    80000294:	f775                	bnez	a4,80000280 <strncpy+0x8>
    80000296:	873e                	mv	a4,a5
    80000298:	9fb5                	addw	a5,a5,a3
    8000029a:	37fd                	addiw	a5,a5,-1
    8000029c:	00c05963          	blez	a2,800002ae <strncpy+0x36>
    800002a0:	0705                	addi	a4,a4,1
    800002a2:	fe070fa3          	sb	zero,-1(a4)
    800002a6:	40e786bb          	subw	a3,a5,a4
    800002aa:	fed04be3          	bgtz	a3,800002a0 <strncpy+0x28>
    800002ae:	6422                	ld	s0,8(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret

00000000800002b4 <safestrcpy>:
    800002b4:	1141                	addi	sp,sp,-16
    800002b6:	e422                	sd	s0,8(sp)
    800002b8:	0800                	addi	s0,sp,16
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2c>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x28>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x16>
    800002dc:	00078023          	sb	zero,0(a5)
    800002e0:	6422                	ld	s0,8(sp)
    800002e2:	0141                	addi	sp,sp,16
    800002e4:	8082                	ret

00000000800002e6 <strlen>:
    800002e6:	1141                	addi	sp,sp,-16
    800002e8:	e422                	sd	s0,8(sp)
    800002ea:	0800                	addi	s0,sp,16
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
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	addi	sp,sp,16
    8000030a:	8082                	ret
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
    80000320:	0a470713          	addi	a4,a4,164 # 8000a3c0 <started>
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
    8000033e:	693040ef          	jal	800051d0 <printf>
    kvminithart();    // turn on paging
    80000342:	080000ef          	jal	800003c2 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000346:	572010ef          	jal	800018b8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034a:	43e040ef          	jal	80004788 <plicinithart>
  }

  scheduler();        
    8000034e:	67f000ef          	jal	800011cc <scheduler>
    consoleinit();
    80000352:	5a9040ef          	jal	800050fa <consoleinit>
    printfinit();
    80000356:	186050ef          	jal	800054dc <printfinit>
    printf("\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cde50513          	addi	a0,a0,-802 # 80007038 <etext+0x38>
    80000362:	66f040ef          	jal	800051d0 <printf>
    printf("xv6 kernel is booting\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	caa50513          	addi	a0,a0,-854 # 80007010 <etext+0x10>
    8000036e:	663040ef          	jal	800051d0 <printf>
    printf("\n");
    80000372:	00007517          	auipc	a0,0x7
    80000376:	cc650513          	addi	a0,a0,-826 # 80007038 <etext+0x38>
    8000037a:	657040ef          	jal	800051d0 <printf>
    kinit();         // physical page allocator
    8000037e:	d45ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000382:	2ca000ef          	jal	8000064c <kvminit>
    kvminithart();   // turn on paging
    80000386:	03c000ef          	jal	800003c2 <kvminithart>
    procinit();      // process table
    8000038a:	12d000ef          	jal	80000cb6 <procinit>
    trapinit();      // trap vectors
    8000038e:	506010ef          	jal	80001894 <trapinit>
    trapinithart();  // install kernel trap vector
    80000392:	526010ef          	jal	800018b8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000396:	3d8040ef          	jal	8000476e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039a:	3ee040ef          	jal	80004788 <plicinithart>
    binit();         // buffer cache
    8000039e:	393010ef          	jal	80001f30 <binit>
    iinit();         // inode table
    800003a2:	184020ef          	jal	80002526 <iinit>
    fileinit();      // file table
    800003a6:	731020ef          	jal	800032d6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003aa:	4ce040ef          	jal	80004878 <virtio_disk_init>
    userinit();      // first user process
    800003ae:	453000ef          	jal	80001000 <userinit>
    __sync_synchronize();
    800003b2:	0330000f          	fence	rw,rw
    started = 1;
    800003b6:	4785                	li	a5,1
    800003b8:	0000a717          	auipc	a4,0xa
    800003bc:	00f72423          	sw	a5,8(a4) # 8000a3c0 <started>
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
    800003d0:	ffc7b783          	ld	a5,-4(a5) # 8000a3c8 <kernel_pagetable>
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
    80000418:	08a050ef          	jal	800054a2 <panic>
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
    8000043e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb8d7>
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
    8000052e:	775040ef          	jal	800054a2 <panic>
    panic("mappages: size not aligned");
    80000532:	00007517          	auipc	a0,0x7
    80000536:	b3650513          	addi	a0,a0,-1226 # 80007068 <etext+0x68>
    8000053a:	769040ef          	jal	800054a2 <panic>
    panic("mappages: size");
    8000053e:	00007517          	auipc	a0,0x7
    80000542:	b4a50513          	addi	a0,a0,-1206 # 80007088 <etext+0x88>
    80000546:	75d040ef          	jal	800054a2 <panic>
      panic("mappages: remap");
    8000054a:	00007517          	auipc	a0,0x7
    8000054e:	b4e50513          	addi	a0,a0,-1202 # 80007098 <etext+0x98>
    80000552:	751040ef          	jal	800054a2 <panic>
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
    80000596:	70d040ef          	jal	800054a2 <panic>

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
    8000065c:	d6a7b823          	sd	a0,-656(a5) # 8000a3c8 <kernel_pagetable>
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
    800006b0:	5f3040ef          	jal	800054a2 <panic>
      panic("uvmunmap: walk");
    800006b4:	00007517          	auipc	a0,0x7
    800006b8:	a1450513          	addi	a0,a0,-1516 # 800070c8 <etext+0xc8>
    800006bc:	5e7040ef          	jal	800054a2 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006c0:	85ca                	mv	a1,s2
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	a1650513          	addi	a0,a0,-1514 # 800070d8 <etext+0xd8>
    800006ca:	307040ef          	jal	800051d0 <printf>
      panic("uvmunmap: not mapped");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a1a50513          	addi	a0,a0,-1510 # 800070e8 <etext+0xe8>
    800006d6:	5cd040ef          	jal	800054a2 <panic>
      panic("uvmunmap: not a leaf");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a2650513          	addi	a0,a0,-1498 # 80007100 <etext+0x100>
    800006e2:	5c1040ef          	jal	800054a2 <panic>
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
    800007b4:	4ef040ef          	jal	800054a2 <panic>

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
    800008e0:	3c3040ef          	jal	800054a2 <panic>
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
    8000099e:	305040ef          	jal	800054a2 <panic>
      panic("uvmcopy: page not present");
    800009a2:	00006517          	auipc	a0,0x6
    800009a6:	7c650513          	addi	a0,a0,1990 # 80007168 <etext+0x168>
    800009aa:	2f9040ef          	jal	800054a2 <panic>
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
    80000a04:	29f040ef          	jal	800054a2 <panic>

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
    80000c38:	c0c48493          	addi	s1,s1,-1012 # 8000a840 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c3c:	8b26                	mv	s6,s1
    80000c3e:	04fa5937          	lui	s2,0x4fa5
    80000c42:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c46:	0932                	slli	s2,s2,0xc
    80000c48:	fa590913          	addi	s2,s2,-91
    80000c4c:	0932                	slli	s2,s2,0xc
    80000c4e:	fa590913          	addi	s2,s2,-91
    80000c52:	0932                	slli	s2,s2,0xc
    80000c54:	fa590913          	addi	s2,s2,-91
    80000c58:	040009b7          	lui	s3,0x4000
    80000c5c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c5e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c60:	0000fa97          	auipc	s5,0xf
    80000c64:	5e0a8a93          	addi	s5,s5,1504 # 80010240 <tickslock>
    char *pa = kalloc();
    80000c68:	c8eff0ef          	jal	800000f6 <kalloc>
    80000c6c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c6e:	cd15                	beqz	a0,80000caa <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c70:	416485b3          	sub	a1,s1,s6
    80000c74:	858d                	srai	a1,a1,0x3
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
    80000c8e:	16848493          	addi	s1,s1,360
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
    80000cb2:	7f0040ef          	jal	800054a2 <panic>

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
    80000cd6:	73e50513          	addi	a0,a0,1854 # 8000a410 <pid_lock>
    80000cda:	277040ef          	jal	80005750 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cde:	00006597          	auipc	a1,0x6
    80000ce2:	4ca58593          	addi	a1,a1,1226 # 800071a8 <etext+0x1a8>
    80000ce6:	00009517          	auipc	a0,0x9
    80000cea:	74250513          	addi	a0,a0,1858 # 8000a428 <wait_lock>
    80000cee:	263040ef          	jal	80005750 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	0000a497          	auipc	s1,0xa
    80000cf6:	b4e48493          	addi	s1,s1,-1202 # 8000a840 <proc>
      initlock(&p->lock, "proc");
    80000cfa:	00006b17          	auipc	s6,0x6
    80000cfe:	4beb0b13          	addi	s6,s6,1214 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d02:	8aa6                	mv	s5,s1
    80000d04:	04fa5937          	lui	s2,0x4fa5
    80000d08:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d0c:	0932                	slli	s2,s2,0xc
    80000d0e:	fa590913          	addi	s2,s2,-91
    80000d12:	0932                	slli	s2,s2,0xc
    80000d14:	fa590913          	addi	s2,s2,-91
    80000d18:	0932                	slli	s2,s2,0xc
    80000d1a:	fa590913          	addi	s2,s2,-91
    80000d1e:	040009b7          	lui	s3,0x4000
    80000d22:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d24:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	0000fa17          	auipc	s4,0xf
    80000d2a:	51aa0a13          	addi	s4,s4,1306 # 80010240 <tickslock>
      initlock(&p->lock, "proc");
    80000d2e:	85da                	mv	a1,s6
    80000d30:	8526                	mv	a0,s1
    80000d32:	21f040ef          	jal	80005750 <initlock>
      p->state = UNUSED;
    80000d36:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d3a:	415487b3          	sub	a5,s1,s5
    80000d3e:	878d                	srai	a5,a5,0x3
    80000d40:	032787b3          	mul	a5,a5,s2
    80000d44:	2785                	addiw	a5,a5,1
    80000d46:	00d7979b          	slliw	a5,a5,0xd
    80000d4a:	40f987b3          	sub	a5,s3,a5
    80000d4e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	16848493          	addi	s1,s1,360
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
    80000d8c:	6b850513          	addi	a0,a0,1720 # 8000a440 <cpus>
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
    80000da2:	1ef040ef          	jal	80005790 <push_off>
    80000da6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000da8:	2781                	sext.w	a5,a5
    80000daa:	079e                	slli	a5,a5,0x7
    80000dac:	00009717          	auipc	a4,0x9
    80000db0:	66470713          	addi	a4,a4,1636 # 8000a410 <pid_lock>
    80000db4:	97ba                	add	a5,a5,a4
    80000db6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000db8:	25d040ef          	jal	80005814 <pop_off>
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
    80000dd4:	295040ef          	jal	80005868 <release>

  if (first) {
    80000dd8:	00009797          	auipc	a5,0x9
    80000ddc:	4c87a783          	lw	a5,1224(a5) # 8000a2a0 <first.1>
    80000de0:	e799                	bnez	a5,80000dee <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000de2:	2ef000ef          	jal	800018d0 <usertrapret>
}
    80000de6:	60a2                	ld	ra,8(sp)
    80000de8:	6402                	ld	s0,0(sp)
    80000dea:	0141                	addi	sp,sp,16
    80000dec:	8082                	ret
    fsinit(ROOTDEV);
    80000dee:	4505                	li	a0,1
    80000df0:	6ca010ef          	jal	800024ba <fsinit>
    first = 0;
    80000df4:	00009797          	auipc	a5,0x9
    80000df8:	4a07a623          	sw	zero,1196(a5) # 8000a2a0 <first.1>
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
    80000e12:	60290913          	addi	s2,s2,1538 # 8000a410 <pid_lock>
    80000e16:	854a                	mv	a0,s2
    80000e18:	1b9040ef          	jal	800057d0 <acquire>
  pid = nextpid;
    80000e1c:	00009797          	auipc	a5,0x9
    80000e20:	48878793          	addi	a5,a5,1160 # 8000a2a4 <nextpid>
    80000e24:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e26:	0014871b          	addiw	a4,s1,1
    80000e2a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e2c:	854a                	mv	a0,s2
    80000e2e:	23b040ef          	jal	80005868 <release>
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
    80000f6a:	8da48493          	addi	s1,s1,-1830 # 8000a840 <proc>
    80000f6e:	0000f917          	auipc	s2,0xf
    80000f72:	2d290913          	addi	s2,s2,722 # 80010240 <tickslock>
    acquire(&p->lock);
    80000f76:	8526                	mv	a0,s1
    80000f78:	059040ef          	jal	800057d0 <acquire>
    if(p->state == UNUSED) {
    80000f7c:	4c9c                	lw	a5,24(s1)
    80000f7e:	cb91                	beqz	a5,80000f92 <allocproc+0x38>
      release(&p->lock);
    80000f80:	8526                	mv	a0,s1
    80000f82:	0e7040ef          	jal	80005868 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f86:	16848493          	addi	s1,s1,360
    80000f8a:	ff2496e3          	bne	s1,s2,80000f76 <allocproc+0x1c>
  return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	a089                	j	80000fd2 <allocproc+0x78>
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
    80000fa4:	cd15                	beqz	a0,80000fe0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	e99ff0ef          	jal	80000e40 <proc_pagetable>
    80000fac:	892a                	mv	s2,a0
    80000fae:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fb0:	c121                	beqz	a0,80000ff0 <allocproc+0x96>
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
}
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6902                	ld	s2,0(sp)
    80000fdc:	6105                	addi	sp,sp,32
    80000fde:	8082                	ret
    freeproc(p);
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	f29ff0ef          	jal	80000f0a <freeproc>
    release(&p->lock);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	081040ef          	jal	80005868 <release>
    return 0;
    80000fec:	84ca                	mv	s1,s2
    80000fee:	b7d5                	j	80000fd2 <allocproc+0x78>
    freeproc(p);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	f19ff0ef          	jal	80000f0a <freeproc>
    release(&p->lock);
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	071040ef          	jal	80005868 <release>
    return 0;
    80000ffc:	84ca                	mv	s1,s2
    80000ffe:	bfd1                	j	80000fd2 <allocproc+0x78>

0000000080001000 <userinit>:
{
    80001000:	1101                	addi	sp,sp,-32
    80001002:	ec06                	sd	ra,24(sp)
    80001004:	e822                	sd	s0,16(sp)
    80001006:	e426                	sd	s1,8(sp)
    80001008:	1000                	addi	s0,sp,32
  p = allocproc();
    8000100a:	f51ff0ef          	jal	80000f5a <allocproc>
    8000100e:	84aa                	mv	s1,a0
  initproc = p;
    80001010:	00009797          	auipc	a5,0x9
    80001014:	3ca7b023          	sd	a0,960(a5) # 8000a3d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001018:	03400613          	li	a2,52
    8000101c:	00009597          	auipc	a1,0x9
    80001020:	29458593          	addi	a1,a1,660 # 8000a2b0 <initcode>
    80001024:	6928                	ld	a0,80(a0)
    80001026:	f34ff0ef          	jal	8000075a <uvmfirst>
  p->sz = PGSIZE;
    8000102a:	6785                	lui	a5,0x1
    8000102c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000102e:	6cb8                	ld	a4,88(s1)
    80001030:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001034:	6cb8                	ld	a4,88(s1)
    80001036:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001038:	4641                	li	a2,16
    8000103a:	00006597          	auipc	a1,0x6
    8000103e:	18658593          	addi	a1,a1,390 # 800071c0 <etext+0x1c0>
    80001042:	15848513          	addi	a0,s1,344
    80001046:	a6eff0ef          	jal	800002b4 <safestrcpy>
  p->cwd = namei("/");
    8000104a:	00006517          	auipc	a0,0x6
    8000104e:	18650513          	addi	a0,a0,390 # 800071d0 <etext+0x1d0>
    80001052:	577010ef          	jal	80002dc8 <namei>
    80001056:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000105a:	478d                	li	a5,3
    8000105c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	009040ef          	jal	80005868 <release>
}
    80001064:	60e2                	ld	ra,24(sp)
    80001066:	6442                	ld	s0,16(sp)
    80001068:	64a2                	ld	s1,8(sp)
    8000106a:	6105                	addi	sp,sp,32
    8000106c:	8082                	ret

000000008000106e <growproc>:
{
    8000106e:	1101                	addi	sp,sp,-32
    80001070:	ec06                	sd	ra,24(sp)
    80001072:	e822                	sd	s0,16(sp)
    80001074:	e426                	sd	s1,8(sp)
    80001076:	e04a                	sd	s2,0(sp)
    80001078:	1000                	addi	s0,sp,32
    8000107a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000107c:	d1dff0ef          	jal	80000d98 <myproc>
    80001080:	84aa                	mv	s1,a0
  sz = p->sz;
    80001082:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001084:	01204c63          	bgtz	s2,8000109c <growproc+0x2e>
  } else if(n < 0){
    80001088:	02094463          	bltz	s2,800010b0 <growproc+0x42>
  p->sz = sz;
    8000108c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000108e:	4501                	li	a0,0
}
    80001090:	60e2                	ld	ra,24(sp)
    80001092:	6442                	ld	s0,16(sp)
    80001094:	64a2                	ld	s1,8(sp)
    80001096:	6902                	ld	s2,0(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000109c:	4691                	li	a3,4
    8000109e:	00b90633          	add	a2,s2,a1
    800010a2:	6928                	ld	a0,80(a0)
    800010a4:	f58ff0ef          	jal	800007fc <uvmalloc>
    800010a8:	85aa                	mv	a1,a0
    800010aa:	f16d                	bnez	a0,8000108c <growproc+0x1e>
      return -1;
    800010ac:	557d                	li	a0,-1
    800010ae:	b7cd                	j	80001090 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010b0:	00b90633          	add	a2,s2,a1
    800010b4:	6928                	ld	a0,80(a0)
    800010b6:	f02ff0ef          	jal	800007b8 <uvmdealloc>
    800010ba:	85aa                	mv	a1,a0
    800010bc:	bfc1                	j	8000108c <growproc+0x1e>

00000000800010be <fork>:
{
    800010be:	7139                	addi	sp,sp,-64
    800010c0:	fc06                	sd	ra,56(sp)
    800010c2:	f822                	sd	s0,48(sp)
    800010c4:	f04a                	sd	s2,32(sp)
    800010c6:	e456                	sd	s5,8(sp)
    800010c8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010ca:	ccfff0ef          	jal	80000d98 <myproc>
    800010ce:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010d0:	e8bff0ef          	jal	80000f5a <allocproc>
    800010d4:	0e050a63          	beqz	a0,800011c8 <fork+0x10a>
    800010d8:	e852                	sd	s4,16(sp)
    800010da:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010dc:	048ab603          	ld	a2,72(s5)
    800010e0:	692c                	ld	a1,80(a0)
    800010e2:	050ab503          	ld	a0,80(s5)
    800010e6:	847ff0ef          	jal	8000092c <uvmcopy>
    800010ea:	04054a63          	bltz	a0,8000113e <fork+0x80>
    800010ee:	f426                	sd	s1,40(sp)
    800010f0:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010f2:	048ab783          	ld	a5,72(s5)
    800010f6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010fa:	058ab683          	ld	a3,88(s5)
    800010fe:	87b6                	mv	a5,a3
    80001100:	058a3703          	ld	a4,88(s4)
    80001104:	12068693          	addi	a3,a3,288
    80001108:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000110c:	6788                	ld	a0,8(a5)
    8000110e:	6b8c                	ld	a1,16(a5)
    80001110:	6f90                	ld	a2,24(a5)
    80001112:	01073023          	sd	a6,0(a4)
    80001116:	e708                	sd	a0,8(a4)
    80001118:	eb0c                	sd	a1,16(a4)
    8000111a:	ef10                	sd	a2,24(a4)
    8000111c:	02078793          	addi	a5,a5,32
    80001120:	02070713          	addi	a4,a4,32
    80001124:	fed792e3          	bne	a5,a3,80001108 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001128:	058a3783          	ld	a5,88(s4)
    8000112c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001130:	0d0a8493          	addi	s1,s5,208
    80001134:	0d0a0913          	addi	s2,s4,208
    80001138:	150a8993          	addi	s3,s5,336
    8000113c:	a831                	j	80001158 <fork+0x9a>
    freeproc(np);
    8000113e:	8552                	mv	a0,s4
    80001140:	dcbff0ef          	jal	80000f0a <freeproc>
    release(&np->lock);
    80001144:	8552                	mv	a0,s4
    80001146:	722040ef          	jal	80005868 <release>
    return -1;
    8000114a:	597d                	li	s2,-1
    8000114c:	6a42                	ld	s4,16(sp)
    8000114e:	a0b5                	j	800011ba <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001150:	04a1                	addi	s1,s1,8
    80001152:	0921                	addi	s2,s2,8
    80001154:	01348963          	beq	s1,s3,80001166 <fork+0xa8>
    if(p->ofile[i])
    80001158:	6088                	ld	a0,0(s1)
    8000115a:	d97d                	beqz	a0,80001150 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000115c:	1fc020ef          	jal	80003358 <filedup>
    80001160:	00a93023          	sd	a0,0(s2)
    80001164:	b7f5                	j	80001150 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001166:	150ab503          	ld	a0,336(s5)
    8000116a:	54e010ef          	jal	800026b8 <idup>
    8000116e:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001172:	4641                	li	a2,16
    80001174:	158a8593          	addi	a1,s5,344
    80001178:	158a0513          	addi	a0,s4,344
    8000117c:	938ff0ef          	jal	800002b4 <safestrcpy>
  pid = np->pid;
    80001180:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001184:	8552                	mv	a0,s4
    80001186:	6e2040ef          	jal	80005868 <release>
  acquire(&wait_lock);
    8000118a:	00009497          	auipc	s1,0x9
    8000118e:	29e48493          	addi	s1,s1,670 # 8000a428 <wait_lock>
    80001192:	8526                	mv	a0,s1
    80001194:	63c040ef          	jal	800057d0 <acquire>
  np->parent = p;
    80001198:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000119c:	8526                	mv	a0,s1
    8000119e:	6ca040ef          	jal	80005868 <release>
  acquire(&np->lock);
    800011a2:	8552                	mv	a0,s4
    800011a4:	62c040ef          	jal	800057d0 <acquire>
  np->state = RUNNABLE;
    800011a8:	478d                	li	a5,3
    800011aa:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011ae:	8552                	mv	a0,s4
    800011b0:	6b8040ef          	jal	80005868 <release>
  return pid;
    800011b4:	74a2                	ld	s1,40(sp)
    800011b6:	69e2                	ld	s3,24(sp)
    800011b8:	6a42                	ld	s4,16(sp)
}
    800011ba:	854a                	mv	a0,s2
    800011bc:	70e2                	ld	ra,56(sp)
    800011be:	7442                	ld	s0,48(sp)
    800011c0:	7902                	ld	s2,32(sp)
    800011c2:	6aa2                	ld	s5,8(sp)
    800011c4:	6121                	addi	sp,sp,64
    800011c6:	8082                	ret
    return -1;
    800011c8:	597d                	li	s2,-1
    800011ca:	bfc5                	j	800011ba <fork+0xfc>

00000000800011cc <scheduler>:
{
    800011cc:	715d                	addi	sp,sp,-80
    800011ce:	e486                	sd	ra,72(sp)
    800011d0:	e0a2                	sd	s0,64(sp)
    800011d2:	fc26                	sd	s1,56(sp)
    800011d4:	f84a                	sd	s2,48(sp)
    800011d6:	f44e                	sd	s3,40(sp)
    800011d8:	f052                	sd	s4,32(sp)
    800011da:	ec56                	sd	s5,24(sp)
    800011dc:	e85a                	sd	s6,16(sp)
    800011de:	e45e                	sd	s7,8(sp)
    800011e0:	e062                	sd	s8,0(sp)
    800011e2:	0880                	addi	s0,sp,80
    800011e4:	8792                	mv	a5,tp
  int id = r_tp();
    800011e6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011e8:	00779b13          	slli	s6,a5,0x7
    800011ec:	00009717          	auipc	a4,0x9
    800011f0:	22470713          	addi	a4,a4,548 # 8000a410 <pid_lock>
    800011f4:	975a                	add	a4,a4,s6
    800011f6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011fa:	00009717          	auipc	a4,0x9
    800011fe:	24e70713          	addi	a4,a4,590 # 8000a448 <cpus+0x8>
    80001202:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001204:	4c11                	li	s8,4
        c->proc = p;
    80001206:	079e                	slli	a5,a5,0x7
    80001208:	00009a17          	auipc	s4,0x9
    8000120c:	208a0a13          	addi	s4,s4,520 # 8000a410 <pid_lock>
    80001210:	9a3e                	add	s4,s4,a5
        found = 1;
    80001212:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001214:	0000f997          	auipc	s3,0xf
    80001218:	02c98993          	addi	s3,s3,44 # 80010240 <tickslock>
    8000121c:	a0a9                	j	80001266 <scheduler+0x9a>
      release(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	648040ef          	jal	80005868 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001224:	16848493          	addi	s1,s1,360
    80001228:	03348563          	beq	s1,s3,80001252 <scheduler+0x86>
      acquire(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	5a2040ef          	jal	800057d0 <acquire>
      if(p->state == RUNNABLE) {
    80001232:	4c9c                	lw	a5,24(s1)
    80001234:	ff2795e3          	bne	a5,s2,8000121e <scheduler+0x52>
        p->state = RUNNING;
    80001238:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000123c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001240:	06048593          	addi	a1,s1,96
    80001244:	855a                	mv	a0,s6
    80001246:	5e4000ef          	jal	8000182a <swtch>
        c->proc = 0;
    8000124a:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000124e:	8ade                	mv	s5,s7
    80001250:	b7f9                	j	8000121e <scheduler+0x52>
    if(found == 0) {
    80001252:	000a9a63          	bnez	s5,80001266 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001256:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000125a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000125e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001262:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001266:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000126a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000126e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001272:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001274:	00009497          	auipc	s1,0x9
    80001278:	5cc48493          	addi	s1,s1,1484 # 8000a840 <proc>
      if(p->state == RUNNABLE) {
    8000127c:	490d                	li	s2,3
    8000127e:	b77d                	j	8000122c <scheduler+0x60>

0000000080001280 <sched>:
{
    80001280:	7179                	addi	sp,sp,-48
    80001282:	f406                	sd	ra,40(sp)
    80001284:	f022                	sd	s0,32(sp)
    80001286:	ec26                	sd	s1,24(sp)
    80001288:	e84a                	sd	s2,16(sp)
    8000128a:	e44e                	sd	s3,8(sp)
    8000128c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000128e:	b0bff0ef          	jal	80000d98 <myproc>
    80001292:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001294:	4d2040ef          	jal	80005766 <holding>
    80001298:	c92d                	beqz	a0,8000130a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000129a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000129c:	2781                	sext.w	a5,a5
    8000129e:	079e                	slli	a5,a5,0x7
    800012a0:	00009717          	auipc	a4,0x9
    800012a4:	17070713          	addi	a4,a4,368 # 8000a410 <pid_lock>
    800012a8:	97ba                	add	a5,a5,a4
    800012aa:	0a87a703          	lw	a4,168(a5)
    800012ae:	4785                	li	a5,1
    800012b0:	06f71363          	bne	a4,a5,80001316 <sched+0x96>
  if(p->state == RUNNING)
    800012b4:	4c98                	lw	a4,24(s1)
    800012b6:	4791                	li	a5,4
    800012b8:	06f70563          	beq	a4,a5,80001322 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012c0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012c2:	e7b5                	bnez	a5,8000132e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012c6:	00009917          	auipc	s2,0x9
    800012ca:	14a90913          	addi	s2,s2,330 # 8000a410 <pid_lock>
    800012ce:	2781                	sext.w	a5,a5
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	97ca                	add	a5,a5,s2
    800012d4:	0ac7a983          	lw	s3,172(a5)
    800012d8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	00009597          	auipc	a1,0x9
    800012e2:	16a58593          	addi	a1,a1,362 # 8000a448 <cpus+0x8>
    800012e6:	95be                	add	a1,a1,a5
    800012e8:	06048513          	addi	a0,s1,96
    800012ec:	53e000ef          	jal	8000182a <swtch>
    800012f0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012f2:	2781                	sext.w	a5,a5
    800012f4:	079e                	slli	a5,a5,0x7
    800012f6:	993e                	add	s2,s2,a5
    800012f8:	0b392623          	sw	s3,172(s2)
}
    800012fc:	70a2                	ld	ra,40(sp)
    800012fe:	7402                	ld	s0,32(sp)
    80001300:	64e2                	ld	s1,24(sp)
    80001302:	6942                	ld	s2,16(sp)
    80001304:	69a2                	ld	s3,8(sp)
    80001306:	6145                	addi	sp,sp,48
    80001308:	8082                	ret
    panic("sched p->lock");
    8000130a:	00006517          	auipc	a0,0x6
    8000130e:	ece50513          	addi	a0,a0,-306 # 800071d8 <etext+0x1d8>
    80001312:	190040ef          	jal	800054a2 <panic>
    panic("sched locks");
    80001316:	00006517          	auipc	a0,0x6
    8000131a:	ed250513          	addi	a0,a0,-302 # 800071e8 <etext+0x1e8>
    8000131e:	184040ef          	jal	800054a2 <panic>
    panic("sched running");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	ed650513          	addi	a0,a0,-298 # 800071f8 <etext+0x1f8>
    8000132a:	178040ef          	jal	800054a2 <panic>
    panic("sched interruptible");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eda50513          	addi	a0,a0,-294 # 80007208 <etext+0x208>
    80001336:	16c040ef          	jal	800054a2 <panic>

000000008000133a <yield>:
{
    8000133a:	1101                	addi	sp,sp,-32
    8000133c:	ec06                	sd	ra,24(sp)
    8000133e:	e822                	sd	s0,16(sp)
    80001340:	e426                	sd	s1,8(sp)
    80001342:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001344:	a55ff0ef          	jal	80000d98 <myproc>
    80001348:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000134a:	486040ef          	jal	800057d0 <acquire>
  p->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	cc9c                	sw	a5,24(s1)
  sched();
    80001352:	f2fff0ef          	jal	80001280 <sched>
  release(&p->lock);
    80001356:	8526                	mv	a0,s1
    80001358:	510040ef          	jal	80005868 <release>
}
    8000135c:	60e2                	ld	ra,24(sp)
    8000135e:	6442                	ld	s0,16(sp)
    80001360:	64a2                	ld	s1,8(sp)
    80001362:	6105                	addi	sp,sp,32
    80001364:	8082                	ret

0000000080001366 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001366:	7179                	addi	sp,sp,-48
    80001368:	f406                	sd	ra,40(sp)
    8000136a:	f022                	sd	s0,32(sp)
    8000136c:	ec26                	sd	s1,24(sp)
    8000136e:	e84a                	sd	s2,16(sp)
    80001370:	e44e                	sd	s3,8(sp)
    80001372:	1800                	addi	s0,sp,48
    80001374:	89aa                	mv	s3,a0
    80001376:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001378:	a21ff0ef          	jal	80000d98 <myproc>
    8000137c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000137e:	452040ef          	jal	800057d0 <acquire>
  release(lk);
    80001382:	854a                	mv	a0,s2
    80001384:	4e4040ef          	jal	80005868 <release>

  // Go to sleep.
  p->chan = chan;
    80001388:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000138c:	4789                	li	a5,2
    8000138e:	cc9c                	sw	a5,24(s1)

  sched();
    80001390:	ef1ff0ef          	jal	80001280 <sched>

  // Tidy up.
  p->chan = 0;
    80001394:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	4ce040ef          	jal	80005868 <release>
  acquire(lk);
    8000139e:	854a                	mv	a0,s2
    800013a0:	430040ef          	jal	800057d0 <acquire>
}
    800013a4:	70a2                	ld	ra,40(sp)
    800013a6:	7402                	ld	s0,32(sp)
    800013a8:	64e2                	ld	s1,24(sp)
    800013aa:	6942                	ld	s2,16(sp)
    800013ac:	69a2                	ld	s3,8(sp)
    800013ae:	6145                	addi	sp,sp,48
    800013b0:	8082                	ret

00000000800013b2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013b2:	7139                	addi	sp,sp,-64
    800013b4:	fc06                	sd	ra,56(sp)
    800013b6:	f822                	sd	s0,48(sp)
    800013b8:	f426                	sd	s1,40(sp)
    800013ba:	f04a                	sd	s2,32(sp)
    800013bc:	ec4e                	sd	s3,24(sp)
    800013be:	e852                	sd	s4,16(sp)
    800013c0:	e456                	sd	s5,8(sp)
    800013c2:	0080                	addi	s0,sp,64
    800013c4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013c6:	00009497          	auipc	s1,0x9
    800013ca:	47a48493          	addi	s1,s1,1146 # 8000a840 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013ce:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013d0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	0000f917          	auipc	s2,0xf
    800013d6:	e6e90913          	addi	s2,s2,-402 # 80010240 <tickslock>
    800013da:	a801                	j	800013ea <wakeup+0x38>
      }
      release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	48a040ef          	jal	80005868 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013e2:	16848493          	addi	s1,s1,360
    800013e6:	03248263          	beq	s1,s2,8000140a <wakeup+0x58>
    if(p != myproc()){
    800013ea:	9afff0ef          	jal	80000d98 <myproc>
    800013ee:	fea48ae3          	beq	s1,a0,800013e2 <wakeup+0x30>
      acquire(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	3dc040ef          	jal	800057d0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013f8:	4c9c                	lw	a5,24(s1)
    800013fa:	ff3791e3          	bne	a5,s3,800013dc <wakeup+0x2a>
    800013fe:	709c                	ld	a5,32(s1)
    80001400:	fd479ee3          	bne	a5,s4,800013dc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001404:	0154ac23          	sw	s5,24(s1)
    80001408:	bfd1                	j	800013dc <wakeup+0x2a>
    }
  }
}
    8000140a:	70e2                	ld	ra,56(sp)
    8000140c:	7442                	ld	s0,48(sp)
    8000140e:	74a2                	ld	s1,40(sp)
    80001410:	7902                	ld	s2,32(sp)
    80001412:	69e2                	ld	s3,24(sp)
    80001414:	6a42                	ld	s4,16(sp)
    80001416:	6aa2                	ld	s5,8(sp)
    80001418:	6121                	addi	sp,sp,64
    8000141a:	8082                	ret

000000008000141c <reparent>:
{
    8000141c:	7179                	addi	sp,sp,-48
    8000141e:	f406                	sd	ra,40(sp)
    80001420:	f022                	sd	s0,32(sp)
    80001422:	ec26                	sd	s1,24(sp)
    80001424:	e84a                	sd	s2,16(sp)
    80001426:	e44e                	sd	s3,8(sp)
    80001428:	e052                	sd	s4,0(sp)
    8000142a:	1800                	addi	s0,sp,48
    8000142c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000142e:	00009497          	auipc	s1,0x9
    80001432:	41248493          	addi	s1,s1,1042 # 8000a840 <proc>
      pp->parent = initproc;
    80001436:	00009a17          	auipc	s4,0x9
    8000143a:	f9aa0a13          	addi	s4,s4,-102 # 8000a3d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143e:	0000f997          	auipc	s3,0xf
    80001442:	e0298993          	addi	s3,s3,-510 # 80010240 <tickslock>
    80001446:	a029                	j	80001450 <reparent+0x34>
    80001448:	16848493          	addi	s1,s1,360
    8000144c:	01348b63          	beq	s1,s3,80001462 <reparent+0x46>
    if(pp->parent == p){
    80001450:	7c9c                	ld	a5,56(s1)
    80001452:	ff279be3          	bne	a5,s2,80001448 <reparent+0x2c>
      pp->parent = initproc;
    80001456:	000a3503          	ld	a0,0(s4)
    8000145a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000145c:	f57ff0ef          	jal	800013b2 <wakeup>
    80001460:	b7e5                	j	80001448 <reparent+0x2c>
}
    80001462:	70a2                	ld	ra,40(sp)
    80001464:	7402                	ld	s0,32(sp)
    80001466:	64e2                	ld	s1,24(sp)
    80001468:	6942                	ld	s2,16(sp)
    8000146a:	69a2                	ld	s3,8(sp)
    8000146c:	6a02                	ld	s4,0(sp)
    8000146e:	6145                	addi	sp,sp,48
    80001470:	8082                	ret

0000000080001472 <exit>:
{
    80001472:	7179                	addi	sp,sp,-48
    80001474:	f406                	sd	ra,40(sp)
    80001476:	f022                	sd	s0,32(sp)
    80001478:	ec26                	sd	s1,24(sp)
    8000147a:	e84a                	sd	s2,16(sp)
    8000147c:	e44e                	sd	s3,8(sp)
    8000147e:	e052                	sd	s4,0(sp)
    80001480:	1800                	addi	s0,sp,48
    80001482:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001484:	915ff0ef          	jal	80000d98 <myproc>
    80001488:	89aa                	mv	s3,a0
  if(p == initproc)
    8000148a:	00009797          	auipc	a5,0x9
    8000148e:	f467b783          	ld	a5,-186(a5) # 8000a3d0 <initproc>
    80001492:	0d050493          	addi	s1,a0,208
    80001496:	15050913          	addi	s2,a0,336
    8000149a:	00a79f63          	bne	a5,a0,800014b8 <exit+0x46>
    panic("init exiting");
    8000149e:	00006517          	auipc	a0,0x6
    800014a2:	d8250513          	addi	a0,a0,-638 # 80007220 <etext+0x220>
    800014a6:	7fd030ef          	jal	800054a2 <panic>
      fileclose(f);
    800014aa:	6f5010ef          	jal	8000339e <fileclose>
      p->ofile[fd] = 0;
    800014ae:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014b2:	04a1                	addi	s1,s1,8
    800014b4:	01248563          	beq	s1,s2,800014be <exit+0x4c>
    if(p->ofile[fd]){
    800014b8:	6088                	ld	a0,0(s1)
    800014ba:	f965                	bnez	a0,800014aa <exit+0x38>
    800014bc:	bfdd                	j	800014b2 <exit+0x40>
  begin_op();
    800014be:	2c7010ef          	jal	80002f84 <begin_op>
  iput(p->cwd);
    800014c2:	1509b503          	ld	a0,336(s3)
    800014c6:	3aa010ef          	jal	80002870 <iput>
  end_op();
    800014ca:	325010ef          	jal	80002fee <end_op>
  p->cwd = 0;
    800014ce:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014d2:	00009497          	auipc	s1,0x9
    800014d6:	f5648493          	addi	s1,s1,-170 # 8000a428 <wait_lock>
    800014da:	8526                	mv	a0,s1
    800014dc:	2f4040ef          	jal	800057d0 <acquire>
  reparent(p);
    800014e0:	854e                	mv	a0,s3
    800014e2:	f3bff0ef          	jal	8000141c <reparent>
  wakeup(p->parent);
    800014e6:	0389b503          	ld	a0,56(s3)
    800014ea:	ec9ff0ef          	jal	800013b2 <wakeup>
  acquire(&p->lock);
    800014ee:	854e                	mv	a0,s3
    800014f0:	2e0040ef          	jal	800057d0 <acquire>
  p->xstate = status;
    800014f4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014f8:	4795                	li	a5,5
    800014fa:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	368040ef          	jal	80005868 <release>
  sched();
    80001504:	d7dff0ef          	jal	80001280 <sched>
  panic("zombie exit");
    80001508:	00006517          	auipc	a0,0x6
    8000150c:	d2850513          	addi	a0,a0,-728 # 80007230 <etext+0x230>
    80001510:	793030ef          	jal	800054a2 <panic>

0000000080001514 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	1800                	addi	s0,sp,48
    80001522:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001524:	00009497          	auipc	s1,0x9
    80001528:	31c48493          	addi	s1,s1,796 # 8000a840 <proc>
    8000152c:	0000f997          	auipc	s3,0xf
    80001530:	d1498993          	addi	s3,s3,-748 # 80010240 <tickslock>
    acquire(&p->lock);
    80001534:	8526                	mv	a0,s1
    80001536:	29a040ef          	jal	800057d0 <acquire>
    if(p->pid == pid){
    8000153a:	589c                	lw	a5,48(s1)
    8000153c:	01278b63          	beq	a5,s2,80001552 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	326040ef          	jal	80005868 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001546:	16848493          	addi	s1,s1,360
    8000154a:	ff3495e3          	bne	s1,s3,80001534 <kill+0x20>
  }
  return -1;
    8000154e:	557d                	li	a0,-1
    80001550:	a819                	j	80001566 <kill+0x52>
      p->killed = 1;
    80001552:	4785                	li	a5,1
    80001554:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001556:	4c98                	lw	a4,24(s1)
    80001558:	4789                	li	a5,2
    8000155a:	00f70d63          	beq	a4,a5,80001574 <kill+0x60>
      release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	308040ef          	jal	80005868 <release>
      return 0;
    80001564:	4501                	li	a0,0
}
    80001566:	70a2                	ld	ra,40(sp)
    80001568:	7402                	ld	s0,32(sp)
    8000156a:	64e2                	ld	s1,24(sp)
    8000156c:	6942                	ld	s2,16(sp)
    8000156e:	69a2                	ld	s3,8(sp)
    80001570:	6145                	addi	sp,sp,48
    80001572:	8082                	ret
        p->state = RUNNABLE;
    80001574:	478d                	li	a5,3
    80001576:	cc9c                	sw	a5,24(s1)
    80001578:	b7dd                	j	8000155e <kill+0x4a>

000000008000157a <setkilled>:

void
setkilled(struct proc *p)
{
    8000157a:	1101                	addi	sp,sp,-32
    8000157c:	ec06                	sd	ra,24(sp)
    8000157e:	e822                	sd	s0,16(sp)
    80001580:	e426                	sd	s1,8(sp)
    80001582:	1000                	addi	s0,sp,32
    80001584:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001586:	24a040ef          	jal	800057d0 <acquire>
  p->killed = 1;
    8000158a:	4785                	li	a5,1
    8000158c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	2d8040ef          	jal	80005868 <release>
}
    80001594:	60e2                	ld	ra,24(sp)
    80001596:	6442                	ld	s0,16(sp)
    80001598:	64a2                	ld	s1,8(sp)
    8000159a:	6105                	addi	sp,sp,32
    8000159c:	8082                	ret

000000008000159e <killed>:

int
killed(struct proc *p)
{
    8000159e:	1101                	addi	sp,sp,-32
    800015a0:	ec06                	sd	ra,24(sp)
    800015a2:	e822                	sd	s0,16(sp)
    800015a4:	e426                	sd	s1,8(sp)
    800015a6:	e04a                	sd	s2,0(sp)
    800015a8:	1000                	addi	s0,sp,32
    800015aa:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015ac:	224040ef          	jal	800057d0 <acquire>
  k = p->killed;
    800015b0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015b4:	8526                	mv	a0,s1
    800015b6:	2b2040ef          	jal	80005868 <release>
  return k;
}
    800015ba:	854a                	mv	a0,s2
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6902                	ld	s2,0(sp)
    800015c4:	6105                	addi	sp,sp,32
    800015c6:	8082                	ret

00000000800015c8 <wait>:
{
    800015c8:	715d                	addi	sp,sp,-80
    800015ca:	e486                	sd	ra,72(sp)
    800015cc:	e0a2                	sd	s0,64(sp)
    800015ce:	fc26                	sd	s1,56(sp)
    800015d0:	f84a                	sd	s2,48(sp)
    800015d2:	f44e                	sd	s3,40(sp)
    800015d4:	f052                	sd	s4,32(sp)
    800015d6:	ec56                	sd	s5,24(sp)
    800015d8:	e85a                	sd	s6,16(sp)
    800015da:	e45e                	sd	s7,8(sp)
    800015dc:	e062                	sd	s8,0(sp)
    800015de:	0880                	addi	s0,sp,80
    800015e0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e2:	fb6ff0ef          	jal	80000d98 <myproc>
    800015e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e8:	00009517          	auipc	a0,0x9
    800015ec:	e4050513          	addi	a0,a0,-448 # 8000a428 <wait_lock>
    800015f0:	1e0040ef          	jal	800057d0 <acquire>
    havekids = 0;
    800015f4:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800015f6:	4a15                	li	s4,5
        havekids = 1;
    800015f8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015fa:	0000f997          	auipc	s3,0xf
    800015fe:	c4698993          	addi	s3,s3,-954 # 80010240 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001602:	00009c17          	auipc	s8,0x9
    80001606:	e26c0c13          	addi	s8,s8,-474 # 8000a428 <wait_lock>
    8000160a:	a871                	j	800016a6 <wait+0xde>
          pid = pp->pid;
    8000160c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001610:	000b0c63          	beqz	s6,80001628 <wait+0x60>
    80001614:	4691                	li	a3,4
    80001616:	02c48613          	addi	a2,s1,44
    8000161a:	85da                	mv	a1,s6
    8000161c:	05093503          	ld	a0,80(s2)
    80001620:	be8ff0ef          	jal	80000a08 <copyout>
    80001624:	02054b63          	bltz	a0,8000165a <wait+0x92>
          freeproc(pp);
    80001628:	8526                	mv	a0,s1
    8000162a:	8e1ff0ef          	jal	80000f0a <freeproc>
          release(&pp->lock);
    8000162e:	8526                	mv	a0,s1
    80001630:	238040ef          	jal	80005868 <release>
          release(&wait_lock);
    80001634:	00009517          	auipc	a0,0x9
    80001638:	df450513          	addi	a0,a0,-524 # 8000a428 <wait_lock>
    8000163c:	22c040ef          	jal	80005868 <release>
}
    80001640:	854e                	mv	a0,s3
    80001642:	60a6                	ld	ra,72(sp)
    80001644:	6406                	ld	s0,64(sp)
    80001646:	74e2                	ld	s1,56(sp)
    80001648:	7942                	ld	s2,48(sp)
    8000164a:	79a2                	ld	s3,40(sp)
    8000164c:	7a02                	ld	s4,32(sp)
    8000164e:	6ae2                	ld	s5,24(sp)
    80001650:	6b42                	ld	s6,16(sp)
    80001652:	6ba2                	ld	s7,8(sp)
    80001654:	6c02                	ld	s8,0(sp)
    80001656:	6161                	addi	sp,sp,80
    80001658:	8082                	ret
            release(&pp->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	20c040ef          	jal	80005868 <release>
            release(&wait_lock);
    80001660:	00009517          	auipc	a0,0x9
    80001664:	dc850513          	addi	a0,a0,-568 # 8000a428 <wait_lock>
    80001668:	200040ef          	jal	80005868 <release>
            return -1;
    8000166c:	59fd                	li	s3,-1
    8000166e:	bfc9                	j	80001640 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001670:	16848493          	addi	s1,s1,360
    80001674:	03348063          	beq	s1,s3,80001694 <wait+0xcc>
      if(pp->parent == p){
    80001678:	7c9c                	ld	a5,56(s1)
    8000167a:	ff279be3          	bne	a5,s2,80001670 <wait+0xa8>
        acquire(&pp->lock);
    8000167e:	8526                	mv	a0,s1
    80001680:	150040ef          	jal	800057d0 <acquire>
        if(pp->state == ZOMBIE){
    80001684:	4c9c                	lw	a5,24(s1)
    80001686:	f94783e3          	beq	a5,s4,8000160c <wait+0x44>
        release(&pp->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	1dc040ef          	jal	80005868 <release>
        havekids = 1;
    80001690:	8756                	mv	a4,s5
    80001692:	bff9                	j	80001670 <wait+0xa8>
    if(!havekids || killed(p)){
    80001694:	cf19                	beqz	a4,800016b2 <wait+0xea>
    80001696:	854a                	mv	a0,s2
    80001698:	f07ff0ef          	jal	8000159e <killed>
    8000169c:	e919                	bnez	a0,800016b2 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000169e:	85e2                	mv	a1,s8
    800016a0:	854a                	mv	a0,s2
    800016a2:	cc5ff0ef          	jal	80001366 <sleep>
    havekids = 0;
    800016a6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a8:	00009497          	auipc	s1,0x9
    800016ac:	19848493          	addi	s1,s1,408 # 8000a840 <proc>
    800016b0:	b7e1                	j	80001678 <wait+0xb0>
      release(&wait_lock);
    800016b2:	00009517          	auipc	a0,0x9
    800016b6:	d7650513          	addi	a0,a0,-650 # 8000a428 <wait_lock>
    800016ba:	1ae040ef          	jal	80005868 <release>
      return -1;
    800016be:	59fd                	li	s3,-1
    800016c0:	b741                	j	80001640 <wait+0x78>

00000000800016c2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016c2:	7179                	addi	sp,sp,-48
    800016c4:	f406                	sd	ra,40(sp)
    800016c6:	f022                	sd	s0,32(sp)
    800016c8:	ec26                	sd	s1,24(sp)
    800016ca:	e84a                	sd	s2,16(sp)
    800016cc:	e44e                	sd	s3,8(sp)
    800016ce:	e052                	sd	s4,0(sp)
    800016d0:	1800                	addi	s0,sp,48
    800016d2:	84aa                	mv	s1,a0
    800016d4:	892e                	mv	s2,a1
    800016d6:	89b2                	mv	s3,a2
    800016d8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016da:	ebeff0ef          	jal	80000d98 <myproc>
  if(user_dst){
    800016de:	cc99                	beqz	s1,800016fc <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016e0:	86d2                	mv	a3,s4
    800016e2:	864e                	mv	a2,s3
    800016e4:	85ca                	mv	a1,s2
    800016e6:	6928                	ld	a0,80(a0)
    800016e8:	b20ff0ef          	jal	80000a08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016ec:	70a2                	ld	ra,40(sp)
    800016ee:	7402                	ld	s0,32(sp)
    800016f0:	64e2                	ld	s1,24(sp)
    800016f2:	6942                	ld	s2,16(sp)
    800016f4:	69a2                	ld	s3,8(sp)
    800016f6:	6a02                	ld	s4,0(sp)
    800016f8:	6145                	addi	sp,sp,48
    800016fa:	8082                	ret
    memmove((char *)dst, src, len);
    800016fc:	000a061b          	sext.w	a2,s4
    80001700:	85ce                	mv	a1,s3
    80001702:	854a                	mv	a0,s2
    80001704:	acffe0ef          	jal	800001d2 <memmove>
    return 0;
    80001708:	8526                	mv	a0,s1
    8000170a:	b7cd                	j	800016ec <either_copyout+0x2a>

000000008000170c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000170c:	7179                	addi	sp,sp,-48
    8000170e:	f406                	sd	ra,40(sp)
    80001710:	f022                	sd	s0,32(sp)
    80001712:	ec26                	sd	s1,24(sp)
    80001714:	e84a                	sd	s2,16(sp)
    80001716:	e44e                	sd	s3,8(sp)
    80001718:	e052                	sd	s4,0(sp)
    8000171a:	1800                	addi	s0,sp,48
    8000171c:	892a                	mv	s2,a0
    8000171e:	84ae                	mv	s1,a1
    80001720:	89b2                	mv	s3,a2
    80001722:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001724:	e74ff0ef          	jal	80000d98 <myproc>
  if(user_src){
    80001728:	cc99                	beqz	s1,80001746 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000172a:	86d2                	mv	a3,s4
    8000172c:	864e                	mv	a2,s3
    8000172e:	85ca                	mv	a1,s2
    80001730:	6928                	ld	a0,80(a0)
    80001732:	baeff0ef          	jal	80000ae0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001736:	70a2                	ld	ra,40(sp)
    80001738:	7402                	ld	s0,32(sp)
    8000173a:	64e2                	ld	s1,24(sp)
    8000173c:	6942                	ld	s2,16(sp)
    8000173e:	69a2                	ld	s3,8(sp)
    80001740:	6a02                	ld	s4,0(sp)
    80001742:	6145                	addi	sp,sp,48
    80001744:	8082                	ret
    memmove(dst, (char*)src, len);
    80001746:	000a061b          	sext.w	a2,s4
    8000174a:	85ce                	mv	a1,s3
    8000174c:	854a                	mv	a0,s2
    8000174e:	a85fe0ef          	jal	800001d2 <memmove>
    return 0;
    80001752:	8526                	mv	a0,s1
    80001754:	b7cd                	j	80001736 <either_copyin+0x2a>

0000000080001756 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001756:	715d                	addi	sp,sp,-80
    80001758:	e486                	sd	ra,72(sp)
    8000175a:	e0a2                	sd	s0,64(sp)
    8000175c:	fc26                	sd	s1,56(sp)
    8000175e:	f84a                	sd	s2,48(sp)
    80001760:	f44e                	sd	s3,40(sp)
    80001762:	f052                	sd	s4,32(sp)
    80001764:	ec56                	sd	s5,24(sp)
    80001766:	e85a                	sd	s6,16(sp)
    80001768:	e45e                	sd	s7,8(sp)
    8000176a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000176c:	00006517          	auipc	a0,0x6
    80001770:	8cc50513          	addi	a0,a0,-1844 # 80007038 <etext+0x38>
    80001774:	25d030ef          	jal	800051d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001778:	00009497          	auipc	s1,0x9
    8000177c:	22048493          	addi	s1,s1,544 # 8000a998 <proc+0x158>
    80001780:	0000f917          	auipc	s2,0xf
    80001784:	c1890913          	addi	s2,s2,-1000 # 80010398 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001788:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000178a:	00006997          	auipc	s3,0x6
    8000178e:	ab698993          	addi	s3,s3,-1354 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001792:	00006a97          	auipc	s5,0x6
    80001796:	ab6a8a93          	addi	s5,s5,-1354 # 80007248 <etext+0x248>
    printf("\n");
    8000179a:	00006a17          	auipc	s4,0x6
    8000179e:	89ea0a13          	addi	s4,s4,-1890 # 80007038 <etext+0x38>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017a2:	00006b97          	auipc	s7,0x6
    800017a6:	06eb8b93          	addi	s7,s7,110 # 80007810 <states.0>
    800017aa:	a829                	j	800017c4 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017ac:	ed86a583          	lw	a1,-296(a3)
    800017b0:	8556                	mv	a0,s5
    800017b2:	21f030ef          	jal	800051d0 <printf>
    printf("\n");
    800017b6:	8552                	mv	a0,s4
    800017b8:	219030ef          	jal	800051d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017bc:	16848493          	addi	s1,s1,360
    800017c0:	03248263          	beq	s1,s2,800017e4 <procdump+0x8e>
    if(p->state == UNUSED)
    800017c4:	86a6                	mv	a3,s1
    800017c6:	ec04a783          	lw	a5,-320(s1)
    800017ca:	dbed                	beqz	a5,800017bc <procdump+0x66>
      state = "???";
    800017cc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ce:	fcfb6fe3          	bltu	s6,a5,800017ac <procdump+0x56>
    800017d2:	02079713          	slli	a4,a5,0x20
    800017d6:	01d75793          	srli	a5,a4,0x1d
    800017da:	97de                	add	a5,a5,s7
    800017dc:	6390                	ld	a2,0(a5)
    800017de:	f679                	bnez	a2,800017ac <procdump+0x56>
      state = "???";
    800017e0:	864e                	mv	a2,s3
    800017e2:	b7e9                	j	800017ac <procdump+0x56>
  }
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6161                	addi	sp,sp,80
    800017f8:	8082                	ret

00000000800017fa <nproc>:

uint64
nproc(void){
    800017fa:	1141                	addi	sp,sp,-16
    800017fc:	e422                	sd	s0,8(sp)
    800017fe:	0800                	addi	s0,sp,16
  int procCount = 0;
  struct proc* p;
  for (p=proc; p<&proc[NPROC]; p++){
    80001800:	00009797          	auipc	a5,0x9
    80001804:	04078793          	addi	a5,a5,64 # 8000a840 <proc>
  int procCount = 0;
    80001808:	4501                	li	a0,0
  for (p=proc; p<&proc[NPROC]; p++){
    8000180a:	0000f697          	auipc	a3,0xf
    8000180e:	a3668693          	addi	a3,a3,-1482 # 80010240 <tickslock>
    80001812:	a029                	j	8000181c <nproc+0x22>
    80001814:	16878793          	addi	a5,a5,360
    80001818:	00d78663          	beq	a5,a3,80001824 <nproc+0x2a>
    if (p->state != UNUSED){
    8000181c:	4f98                	lw	a4,24(a5)
    8000181e:	db7d                	beqz	a4,80001814 <nproc+0x1a>
      procCount++;
    80001820:	2505                	addiw	a0,a0,1
    80001822:	bfcd                	j	80001814 <nproc+0x1a>
    }
  }
  return procCount;
    80001824:	6422                	ld	s0,8(sp)
    80001826:	0141                	addi	sp,sp,16
    80001828:	8082                	ret

000000008000182a <swtch>:
    8000182a:	00153023          	sd	ra,0(a0)
    8000182e:	00253423          	sd	sp,8(a0)
    80001832:	e900                	sd	s0,16(a0)
    80001834:	ed04                	sd	s1,24(a0)
    80001836:	03253023          	sd	s2,32(a0)
    8000183a:	03353423          	sd	s3,40(a0)
    8000183e:	03453823          	sd	s4,48(a0)
    80001842:	03553c23          	sd	s5,56(a0)
    80001846:	05653023          	sd	s6,64(a0)
    8000184a:	05753423          	sd	s7,72(a0)
    8000184e:	05853823          	sd	s8,80(a0)
    80001852:	05953c23          	sd	s9,88(a0)
    80001856:	07a53023          	sd	s10,96(a0)
    8000185a:	07b53423          	sd	s11,104(a0)
    8000185e:	0005b083          	ld	ra,0(a1)
    80001862:	0085b103          	ld	sp,8(a1)
    80001866:	6980                	ld	s0,16(a1)
    80001868:	6d84                	ld	s1,24(a1)
    8000186a:	0205b903          	ld	s2,32(a1)
    8000186e:	0285b983          	ld	s3,40(a1)
    80001872:	0305ba03          	ld	s4,48(a1)
    80001876:	0385ba83          	ld	s5,56(a1)
    8000187a:	0405bb03          	ld	s6,64(a1)
    8000187e:	0485bb83          	ld	s7,72(a1)
    80001882:	0505bc03          	ld	s8,80(a1)
    80001886:	0585bc83          	ld	s9,88(a1)
    8000188a:	0605bd03          	ld	s10,96(a1)
    8000188e:	0685bd83          	ld	s11,104(a1)
    80001892:	8082                	ret

0000000080001894 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001894:	1141                	addi	sp,sp,-16
    80001896:	e406                	sd	ra,8(sp)
    80001898:	e022                	sd	s0,0(sp)
    8000189a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000189c:	00006597          	auipc	a1,0x6
    800018a0:	9ec58593          	addi	a1,a1,-1556 # 80007288 <etext+0x288>
    800018a4:	0000f517          	auipc	a0,0xf
    800018a8:	99c50513          	addi	a0,a0,-1636 # 80010240 <tickslock>
    800018ac:	6a5030ef          	jal	80005750 <initlock>
}
    800018b0:	60a2                	ld	ra,8(sp)
    800018b2:	6402                	ld	s0,0(sp)
    800018b4:	0141                	addi	sp,sp,16
    800018b6:	8082                	ret

00000000800018b8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018b8:	1141                	addi	sp,sp,-16
    800018ba:	e422                	sd	s0,8(sp)
    800018bc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018be:	00003797          	auipc	a5,0x3
    800018c2:	e5278793          	addi	a5,a5,-430 # 80004710 <kernelvec>
    800018c6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018ca:	6422                	ld	s0,8(sp)
    800018cc:	0141                	addi	sp,sp,16
    800018ce:	8082                	ret

00000000800018d0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800018d0:	1141                	addi	sp,sp,-16
    800018d2:	e406                	sd	ra,8(sp)
    800018d4:	e022                	sd	s0,0(sp)
    800018d6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018d8:	cc0ff0ef          	jal	80000d98 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018e0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018e2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018e6:	00004697          	auipc	a3,0x4
    800018ea:	71a68693          	addi	a3,a3,1818 # 80006000 <_trampoline>
    800018ee:	00004717          	auipc	a4,0x4
    800018f2:	71270713          	addi	a4,a4,1810 # 80006000 <_trampoline>
    800018f6:	8f15                	sub	a4,a4,a3
    800018f8:	040007b7          	lui	a5,0x4000
    800018fc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800018fe:	07b2                	slli	a5,a5,0xc
    80001900:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001902:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001906:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001908:	18002673          	csrr	a2,satp
    8000190c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000190e:	6d30                	ld	a2,88(a0)
    80001910:	6138                	ld	a4,64(a0)
    80001912:	6585                	lui	a1,0x1
    80001914:	972e                	add	a4,a4,a1
    80001916:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001918:	6d38                	ld	a4,88(a0)
    8000191a:	00000617          	auipc	a2,0x0
    8000191e:	11060613          	addi	a2,a2,272 # 80001a2a <usertrap>
    80001922:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001924:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001926:	8612                	mv	a2,tp
    80001928:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000192a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000192e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001932:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001936:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000193a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000193c:	6f18                	ld	a4,24(a4)
    8000193e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001942:	6928                	ld	a0,80(a0)
    80001944:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001946:	00004717          	auipc	a4,0x4
    8000194a:	75670713          	addi	a4,a4,1878 # 8000609c <userret>
    8000194e:	8f15                	sub	a4,a4,a3
    80001950:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001952:	577d                	li	a4,-1
    80001954:	177e                	slli	a4,a4,0x3f
    80001956:	8d59                	or	a0,a0,a4
    80001958:	9782                	jalr	a5
}
    8000195a:	60a2                	ld	ra,8(sp)
    8000195c:	6402                	ld	s0,0(sp)
    8000195e:	0141                	addi	sp,sp,16
    80001960:	8082                	ret

0000000080001962 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001962:	1101                	addi	sp,sp,-32
    80001964:	ec06                	sd	ra,24(sp)
    80001966:	e822                	sd	s0,16(sp)
    80001968:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000196a:	c02ff0ef          	jal	80000d6c <cpuid>
    8000196e:	cd11                	beqz	a0,8000198a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001970:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001974:	000f4737          	lui	a4,0xf4
    80001978:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000197c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000197e:	14d79073          	csrw	stimecmp,a5
}
    80001982:	60e2                	ld	ra,24(sp)
    80001984:	6442                	ld	s0,16(sp)
    80001986:	6105                	addi	sp,sp,32
    80001988:	8082                	ret
    8000198a:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000198c:	0000f497          	auipc	s1,0xf
    80001990:	8b448493          	addi	s1,s1,-1868 # 80010240 <tickslock>
    80001994:	8526                	mv	a0,s1
    80001996:	63b030ef          	jal	800057d0 <acquire>
    ticks++;
    8000199a:	00009517          	auipc	a0,0x9
    8000199e:	a3e50513          	addi	a0,a0,-1474 # 8000a3d8 <ticks>
    800019a2:	411c                	lw	a5,0(a0)
    800019a4:	2785                	addiw	a5,a5,1
    800019a6:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019a8:	a0bff0ef          	jal	800013b2 <wakeup>
    release(&tickslock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	6bb030ef          	jal	80005868 <release>
    800019b2:	64a2                	ld	s1,8(sp)
    800019b4:	bf75                	j	80001970 <clockintr+0xe>

00000000800019b6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019b6:	1101                	addi	sp,sp,-32
    800019b8:	ec06                	sd	ra,24(sp)
    800019ba:	e822                	sd	s0,16(sp)
    800019bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019be:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019c2:	57fd                	li	a5,-1
    800019c4:	17fe                	slli	a5,a5,0x3f
    800019c6:	07a5                	addi	a5,a5,9
    800019c8:	00f70c63          	beq	a4,a5,800019e0 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019cc:	57fd                	li	a5,-1
    800019ce:	17fe                	slli	a5,a5,0x3f
    800019d0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019d2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019d4:	04f70763          	beq	a4,a5,80001a22 <devintr+0x6c>
  }
}
    800019d8:	60e2                	ld	ra,24(sp)
    800019da:	6442                	ld	s0,16(sp)
    800019dc:	6105                	addi	sp,sp,32
    800019de:	8082                	ret
    800019e0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019e2:	5db020ef          	jal	800047bc <plic_claim>
    800019e6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019e8:	47a9                	li	a5,10
    800019ea:	00f50963          	beq	a0,a5,800019fc <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019ee:	4785                	li	a5,1
    800019f0:	00f50963          	beq	a0,a5,80001a02 <devintr+0x4c>
    return 1;
    800019f4:	4505                	li	a0,1
    } else if(irq){
    800019f6:	e889                	bnez	s1,80001a08 <devintr+0x52>
    800019f8:	64a2                	ld	s1,8(sp)
    800019fa:	bff9                	j	800019d8 <devintr+0x22>
      uartintr();
    800019fc:	519030ef          	jal	80005714 <uartintr>
    if(irq)
    80001a00:	a819                	j	80001a16 <devintr+0x60>
      virtio_disk_intr();
    80001a02:	280030ef          	jal	80004c82 <virtio_disk_intr>
    if(irq)
    80001a06:	a801                	j	80001a16 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a08:	85a6                	mv	a1,s1
    80001a0a:	00006517          	auipc	a0,0x6
    80001a0e:	88650513          	addi	a0,a0,-1914 # 80007290 <etext+0x290>
    80001a12:	7be030ef          	jal	800051d0 <printf>
      plic_complete(irq);
    80001a16:	8526                	mv	a0,s1
    80001a18:	5c5020ef          	jal	800047dc <plic_complete>
    return 1;
    80001a1c:	4505                	li	a0,1
    80001a1e:	64a2                	ld	s1,8(sp)
    80001a20:	bf65                	j	800019d8 <devintr+0x22>
    clockintr();
    80001a22:	f41ff0ef          	jal	80001962 <clockintr>
    return 2;
    80001a26:	4509                	li	a0,2
    80001a28:	bf45                	j	800019d8 <devintr+0x22>

0000000080001a2a <usertrap>:
{
    80001a2a:	1101                	addi	sp,sp,-32
    80001a2c:	ec06                	sd	ra,24(sp)
    80001a2e:	e822                	sd	s0,16(sp)
    80001a30:	e426                	sd	s1,8(sp)
    80001a32:	e04a                	sd	s2,0(sp)
    80001a34:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a36:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a3a:	1007f793          	andi	a5,a5,256
    80001a3e:	ef85                	bnez	a5,80001a76 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a40:	00003797          	auipc	a5,0x3
    80001a44:	cd078793          	addi	a5,a5,-816 # 80004710 <kernelvec>
    80001a48:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a4c:	b4cff0ef          	jal	80000d98 <myproc>
    80001a50:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a52:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a54:	14102773          	csrr	a4,sepc
    80001a58:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a5a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a5e:	47a1                	li	a5,8
    80001a60:	02f70163          	beq	a4,a5,80001a82 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a64:	f53ff0ef          	jal	800019b6 <devintr>
    80001a68:	892a                	mv	s2,a0
    80001a6a:	c135                	beqz	a0,80001ace <usertrap+0xa4>
  if(killed(p))
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	b31ff0ef          	jal	8000159e <killed>
    80001a72:	cd1d                	beqz	a0,80001ab0 <usertrap+0x86>
    80001a74:	a81d                	j	80001aaa <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001a76:	00006517          	auipc	a0,0x6
    80001a7a:	83a50513          	addi	a0,a0,-1990 # 800072b0 <etext+0x2b0>
    80001a7e:	225030ef          	jal	800054a2 <panic>
    if(killed(p))
    80001a82:	b1dff0ef          	jal	8000159e <killed>
    80001a86:	e121                	bnez	a0,80001ac6 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a88:	6cb8                	ld	a4,88(s1)
    80001a8a:	6f1c                	ld	a5,24(a4)
    80001a8c:	0791                	addi	a5,a5,4
    80001a8e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a98:	10079073          	csrw	sstatus,a5
    syscall();
    80001a9c:	248000ef          	jal	80001ce4 <syscall>
  if(killed(p))
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	afdff0ef          	jal	8000159e <killed>
    80001aa6:	c901                	beqz	a0,80001ab6 <usertrap+0x8c>
    80001aa8:	4901                	li	s2,0
    exit(-1);
    80001aaa:	557d                	li	a0,-1
    80001aac:	9c7ff0ef          	jal	80001472 <exit>
  if(which_dev == 2)
    80001ab0:	4789                	li	a5,2
    80001ab2:	04f90563          	beq	s2,a5,80001afc <usertrap+0xd2>
  usertrapret();
    80001ab6:	e1bff0ef          	jal	800018d0 <usertrapret>
}
    80001aba:	60e2                	ld	ra,24(sp)
    80001abc:	6442                	ld	s0,16(sp)
    80001abe:	64a2                	ld	s1,8(sp)
    80001ac0:	6902                	ld	s2,0(sp)
    80001ac2:	6105                	addi	sp,sp,32
    80001ac4:	8082                	ret
      exit(-1);
    80001ac6:	557d                	li	a0,-1
    80001ac8:	9abff0ef          	jal	80001472 <exit>
    80001acc:	bf75                	j	80001a88 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ace:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ad2:	5890                	lw	a2,48(s1)
    80001ad4:	00005517          	auipc	a0,0x5
    80001ad8:	7fc50513          	addi	a0,a0,2044 # 800072d0 <etext+0x2d0>
    80001adc:	6f4030ef          	jal	800051d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ae0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ae4:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001ae8:	00006517          	auipc	a0,0x6
    80001aec:	81850513          	addi	a0,a0,-2024 # 80007300 <etext+0x300>
    80001af0:	6e0030ef          	jal	800051d0 <printf>
    setkilled(p);
    80001af4:	8526                	mv	a0,s1
    80001af6:	a85ff0ef          	jal	8000157a <setkilled>
    80001afa:	b75d                	j	80001aa0 <usertrap+0x76>
    yield();
    80001afc:	83fff0ef          	jal	8000133a <yield>
    80001b00:	bf5d                	j	80001ab6 <usertrap+0x8c>

0000000080001b02 <kerneltrap>:
{
    80001b02:	7179                	addi	sp,sp,-48
    80001b04:	f406                	sd	ra,40(sp)
    80001b06:	f022                	sd	s0,32(sp)
    80001b08:	ec26                	sd	s1,24(sp)
    80001b0a:	e84a                	sd	s2,16(sp)
    80001b0c:	e44e                	sd	s3,8(sp)
    80001b0e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b10:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b14:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b18:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b1c:	1004f793          	andi	a5,s1,256
    80001b20:	c795                	beqz	a5,80001b4c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b26:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b28:	eb85                	bnez	a5,80001b58 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b2a:	e8dff0ef          	jal	800019b6 <devintr>
    80001b2e:	c91d                	beqz	a0,80001b64 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b30:	4789                	li	a5,2
    80001b32:	04f50a63          	beq	a0,a5,80001b86 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b36:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b3a:	10049073          	csrw	sstatus,s1
}
    80001b3e:	70a2                	ld	ra,40(sp)
    80001b40:	7402                	ld	s0,32(sp)
    80001b42:	64e2                	ld	s1,24(sp)
    80001b44:	6942                	ld	s2,16(sp)
    80001b46:	69a2                	ld	s3,8(sp)
    80001b48:	6145                	addi	sp,sp,48
    80001b4a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b4c:	00005517          	auipc	a0,0x5
    80001b50:	7dc50513          	addi	a0,a0,2012 # 80007328 <etext+0x328>
    80001b54:	14f030ef          	jal	800054a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b58:	00005517          	auipc	a0,0x5
    80001b5c:	7f850513          	addi	a0,a0,2040 # 80007350 <etext+0x350>
    80001b60:	143030ef          	jal	800054a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b64:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b68:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b6c:	85ce                	mv	a1,s3
    80001b6e:	00006517          	auipc	a0,0x6
    80001b72:	80250513          	addi	a0,a0,-2046 # 80007370 <etext+0x370>
    80001b76:	65a030ef          	jal	800051d0 <printf>
    panic("kerneltrap");
    80001b7a:	00006517          	auipc	a0,0x6
    80001b7e:	81e50513          	addi	a0,a0,-2018 # 80007398 <etext+0x398>
    80001b82:	121030ef          	jal	800054a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b86:	a12ff0ef          	jal	80000d98 <myproc>
    80001b8a:	d555                	beqz	a0,80001b36 <kerneltrap+0x34>
    yield();
    80001b8c:	faeff0ef          	jal	8000133a <yield>
    80001b90:	b75d                	j	80001b36 <kerneltrap+0x34>

0000000080001b92 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b92:	1101                	addi	sp,sp,-32
    80001b94:	ec06                	sd	ra,24(sp)
    80001b96:	e822                	sd	s0,16(sp)
    80001b98:	e426                	sd	s1,8(sp)
    80001b9a:	1000                	addi	s0,sp,32
    80001b9c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b9e:	9faff0ef          	jal	80000d98 <myproc>
  switch (n) {
    80001ba2:	4795                	li	a5,5
    80001ba4:	0497e163          	bltu	a5,s1,80001be6 <argraw+0x54>
    80001ba8:	048a                	slli	s1,s1,0x2
    80001baa:	00006717          	auipc	a4,0x6
    80001bae:	c9670713          	addi	a4,a4,-874 # 80007840 <states.0+0x30>
    80001bb2:	94ba                	add	s1,s1,a4
    80001bb4:	409c                	lw	a5,0(s1)
    80001bb6:	97ba                	add	a5,a5,a4
    80001bb8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bba:	6d3c                	ld	a5,88(a0)
    80001bbc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bbe:	60e2                	ld	ra,24(sp)
    80001bc0:	6442                	ld	s0,16(sp)
    80001bc2:	64a2                	ld	s1,8(sp)
    80001bc4:	6105                	addi	sp,sp,32
    80001bc6:	8082                	ret
    return p->trapframe->a1;
    80001bc8:	6d3c                	ld	a5,88(a0)
    80001bca:	7fa8                	ld	a0,120(a5)
    80001bcc:	bfcd                	j	80001bbe <argraw+0x2c>
    return p->trapframe->a2;
    80001bce:	6d3c                	ld	a5,88(a0)
    80001bd0:	63c8                	ld	a0,128(a5)
    80001bd2:	b7f5                	j	80001bbe <argraw+0x2c>
    return p->trapframe->a3;
    80001bd4:	6d3c                	ld	a5,88(a0)
    80001bd6:	67c8                	ld	a0,136(a5)
    80001bd8:	b7dd                	j	80001bbe <argraw+0x2c>
    return p->trapframe->a4;
    80001bda:	6d3c                	ld	a5,88(a0)
    80001bdc:	6bc8                	ld	a0,144(a5)
    80001bde:	b7c5                	j	80001bbe <argraw+0x2c>
    return p->trapframe->a5;
    80001be0:	6d3c                	ld	a5,88(a0)
    80001be2:	6fc8                	ld	a0,152(a5)
    80001be4:	bfe9                	j	80001bbe <argraw+0x2c>
  panic("argraw");
    80001be6:	00005517          	auipc	a0,0x5
    80001bea:	7c250513          	addi	a0,a0,1986 # 800073a8 <etext+0x3a8>
    80001bee:	0b5030ef          	jal	800054a2 <panic>

0000000080001bf2 <fetchaddr>:
{
    80001bf2:	1101                	addi	sp,sp,-32
    80001bf4:	ec06                	sd	ra,24(sp)
    80001bf6:	e822                	sd	s0,16(sp)
    80001bf8:	e426                	sd	s1,8(sp)
    80001bfa:	e04a                	sd	s2,0(sp)
    80001bfc:	1000                	addi	s0,sp,32
    80001bfe:	84aa                	mv	s1,a0
    80001c00:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c02:	996ff0ef          	jal	80000d98 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c06:	653c                	ld	a5,72(a0)
    80001c08:	02f4f663          	bgeu	s1,a5,80001c34 <fetchaddr+0x42>
    80001c0c:	00848713          	addi	a4,s1,8
    80001c10:	02e7e463          	bltu	a5,a4,80001c38 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c14:	46a1                	li	a3,8
    80001c16:	8626                	mv	a2,s1
    80001c18:	85ca                	mv	a1,s2
    80001c1a:	6928                	ld	a0,80(a0)
    80001c1c:	ec5fe0ef          	jal	80000ae0 <copyin>
    80001c20:	00a03533          	snez	a0,a0
    80001c24:	40a00533          	neg	a0,a0
}
    80001c28:	60e2                	ld	ra,24(sp)
    80001c2a:	6442                	ld	s0,16(sp)
    80001c2c:	64a2                	ld	s1,8(sp)
    80001c2e:	6902                	ld	s2,0(sp)
    80001c30:	6105                	addi	sp,sp,32
    80001c32:	8082                	ret
    return -1;
    80001c34:	557d                	li	a0,-1
    80001c36:	bfcd                	j	80001c28 <fetchaddr+0x36>
    80001c38:	557d                	li	a0,-1
    80001c3a:	b7fd                	j	80001c28 <fetchaddr+0x36>

0000000080001c3c <fetchstr>:
{
    80001c3c:	7179                	addi	sp,sp,-48
    80001c3e:	f406                	sd	ra,40(sp)
    80001c40:	f022                	sd	s0,32(sp)
    80001c42:	ec26                	sd	s1,24(sp)
    80001c44:	e84a                	sd	s2,16(sp)
    80001c46:	e44e                	sd	s3,8(sp)
    80001c48:	1800                	addi	s0,sp,48
    80001c4a:	892a                	mv	s2,a0
    80001c4c:	84ae                	mv	s1,a1
    80001c4e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c50:	948ff0ef          	jal	80000d98 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c54:	86ce                	mv	a3,s3
    80001c56:	864a                	mv	a2,s2
    80001c58:	85a6                	mv	a1,s1
    80001c5a:	6928                	ld	a0,80(a0)
    80001c5c:	f0bfe0ef          	jal	80000b66 <copyinstr>
    80001c60:	00054c63          	bltz	a0,80001c78 <fetchstr+0x3c>
  return strlen(buf);
    80001c64:	8526                	mv	a0,s1
    80001c66:	e80fe0ef          	jal	800002e6 <strlen>
}
    80001c6a:	70a2                	ld	ra,40(sp)
    80001c6c:	7402                	ld	s0,32(sp)
    80001c6e:	64e2                	ld	s1,24(sp)
    80001c70:	6942                	ld	s2,16(sp)
    80001c72:	69a2                	ld	s3,8(sp)
    80001c74:	6145                	addi	sp,sp,48
    80001c76:	8082                	ret
    return -1;
    80001c78:	557d                	li	a0,-1
    80001c7a:	bfc5                	j	80001c6a <fetchstr+0x2e>

0000000080001c7c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c7c:	1101                	addi	sp,sp,-32
    80001c7e:	ec06                	sd	ra,24(sp)
    80001c80:	e822                	sd	s0,16(sp)
    80001c82:	e426                	sd	s1,8(sp)
    80001c84:	1000                	addi	s0,sp,32
    80001c86:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c88:	f0bff0ef          	jal	80001b92 <argraw>
    80001c8c:	c088                	sw	a0,0(s1)
}
    80001c8e:	60e2                	ld	ra,24(sp)
    80001c90:	6442                	ld	s0,16(sp)
    80001c92:	64a2                	ld	s1,8(sp)
    80001c94:	6105                	addi	sp,sp,32
    80001c96:	8082                	ret

0000000080001c98 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c98:	1101                	addi	sp,sp,-32
    80001c9a:	ec06                	sd	ra,24(sp)
    80001c9c:	e822                	sd	s0,16(sp)
    80001c9e:	e426                	sd	s1,8(sp)
    80001ca0:	1000                	addi	s0,sp,32
    80001ca2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ca4:	eefff0ef          	jal	80001b92 <argraw>
    80001ca8:	e088                	sd	a0,0(s1)
}
    80001caa:	60e2                	ld	ra,24(sp)
    80001cac:	6442                	ld	s0,16(sp)
    80001cae:	64a2                	ld	s1,8(sp)
    80001cb0:	6105                	addi	sp,sp,32
    80001cb2:	8082                	ret

0000000080001cb4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cb4:	7179                	addi	sp,sp,-48
    80001cb6:	f406                	sd	ra,40(sp)
    80001cb8:	f022                	sd	s0,32(sp)
    80001cba:	ec26                	sd	s1,24(sp)
    80001cbc:	e84a                	sd	s2,16(sp)
    80001cbe:	1800                	addi	s0,sp,48
    80001cc0:	84ae                	mv	s1,a1
    80001cc2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cc4:	fd840593          	addi	a1,s0,-40
    80001cc8:	fd1ff0ef          	jal	80001c98 <argaddr>
  return fetchstr(addr, buf, max);
    80001ccc:	864a                	mv	a2,s2
    80001cce:	85a6                	mv	a1,s1
    80001cd0:	fd843503          	ld	a0,-40(s0)
    80001cd4:	f69ff0ef          	jal	80001c3c <fetchstr>
}
    80001cd8:	70a2                	ld	ra,40(sp)
    80001cda:	7402                	ld	s0,32(sp)
    80001cdc:	64e2                	ld	s1,24(sp)
    80001cde:	6942                	ld	s2,16(sp)
    80001ce0:	6145                	addi	sp,sp,48
    80001ce2:	8082                	ret

0000000080001ce4 <syscall>:
  "close","sysinfo",
};

void
syscall(void)
{
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	e426                	sd	s1,8(sp)
    80001cec:	e04a                	sd	s2,0(sp)
    80001cee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001cf0:	8a8ff0ef          	jal	80000d98 <myproc>
    80001cf4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001cf6:	05853903          	ld	s2,88(a0)
    80001cfa:	0a893783          	ld	a5,168(s2)
    80001cfe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d02:	37fd                	addiw	a5,a5,-1
    80001d04:	4759                	li	a4,22
    80001d06:	00f76f63          	bltu	a4,a5,80001d24 <syscall+0x40>
    80001d0a:	00369713          	slli	a4,a3,0x3
    80001d0e:	00006797          	auipc	a5,0x6
    80001d12:	b4a78793          	addi	a5,a5,-1206 # 80007858 <syscalls>
    80001d16:	97ba                	add	a5,a5,a4
    80001d18:	639c                	ld	a5,0(a5)
    80001d1a:	c789                	beqz	a5,80001d24 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d1c:	9782                	jalr	a5
    80001d1e:	06a93823          	sd	a0,112(s2)
    80001d22:	a829                	j	80001d3c <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d24:	15848613          	addi	a2,s1,344
    80001d28:	588c                	lw	a1,48(s1)
    80001d2a:	00005517          	auipc	a0,0x5
    80001d2e:	68650513          	addi	a0,a0,1670 # 800073b0 <etext+0x3b0>
    80001d32:	49e030ef          	jal	800051d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d36:	6cbc                	ld	a5,88(s1)
    80001d38:	577d                	li	a4,-1
    80001d3a:	fbb8                	sd	a4,112(a5)
  }
}
    80001d3c:	60e2                	ld	ra,24(sp)
    80001d3e:	6442                	ld	s0,16(sp)
    80001d40:	64a2                	ld	s1,8(sp)
    80001d42:	6902                	ld	s2,0(sp)
    80001d44:	6105                	addi	sp,sp,32
    80001d46:	8082                	ret

0000000080001d48 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d50:	fec40593          	addi	a1,s0,-20
    80001d54:	4501                	li	a0,0
    80001d56:	f27ff0ef          	jal	80001c7c <argint>
  exit(n);
    80001d5a:	fec42503          	lw	a0,-20(s0)
    80001d5e:	f14ff0ef          	jal	80001472 <exit>
  return 0;  // not reached
}
    80001d62:	4501                	li	a0,0
    80001d64:	60e2                	ld	ra,24(sp)
    80001d66:	6442                	ld	s0,16(sp)
    80001d68:	6105                	addi	sp,sp,32
    80001d6a:	8082                	ret

0000000080001d6c <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d6c:	1141                	addi	sp,sp,-16
    80001d6e:	e406                	sd	ra,8(sp)
    80001d70:	e022                	sd	s0,0(sp)
    80001d72:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d74:	824ff0ef          	jal	80000d98 <myproc>
}
    80001d78:	5908                	lw	a0,48(a0)
    80001d7a:	60a2                	ld	ra,8(sp)
    80001d7c:	6402                	ld	s0,0(sp)
    80001d7e:	0141                	addi	sp,sp,16
    80001d80:	8082                	ret

0000000080001d82 <sys_fork>:

uint64
sys_fork(void)
{
    80001d82:	1141                	addi	sp,sp,-16
    80001d84:	e406                	sd	ra,8(sp)
    80001d86:	e022                	sd	s0,0(sp)
    80001d88:	0800                	addi	s0,sp,16
  return fork();
    80001d8a:	b34ff0ef          	jal	800010be <fork>
}
    80001d8e:	60a2                	ld	ra,8(sp)
    80001d90:	6402                	ld	s0,0(sp)
    80001d92:	0141                	addi	sp,sp,16
    80001d94:	8082                	ret

0000000080001d96 <sys_wait>:

uint64
sys_wait(void)
{
    80001d96:	1101                	addi	sp,sp,-32
    80001d98:	ec06                	sd	ra,24(sp)
    80001d9a:	e822                	sd	s0,16(sp)
    80001d9c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d9e:	fe840593          	addi	a1,s0,-24
    80001da2:	4501                	li	a0,0
    80001da4:	ef5ff0ef          	jal	80001c98 <argaddr>
  return wait(p);
    80001da8:	fe843503          	ld	a0,-24(s0)
    80001dac:	81dff0ef          	jal	800015c8 <wait>
}
    80001db0:	60e2                	ld	ra,24(sp)
    80001db2:	6442                	ld	s0,16(sp)
    80001db4:	6105                	addi	sp,sp,32
    80001db6:	8082                	ret

0000000080001db8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001db8:	7179                	addi	sp,sp,-48
    80001dba:	f406                	sd	ra,40(sp)
    80001dbc:	f022                	sd	s0,32(sp)
    80001dbe:	ec26                	sd	s1,24(sp)
    80001dc0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001dc2:	fdc40593          	addi	a1,s0,-36
    80001dc6:	4501                	li	a0,0
    80001dc8:	eb5ff0ef          	jal	80001c7c <argint>
  addr = myproc()->sz;
    80001dcc:	fcdfe0ef          	jal	80000d98 <myproc>
    80001dd0:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001dd2:	fdc42503          	lw	a0,-36(s0)
    80001dd6:	a98ff0ef          	jal	8000106e <growproc>
    80001dda:	00054863          	bltz	a0,80001dea <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001dde:	8526                	mv	a0,s1
    80001de0:	70a2                	ld	ra,40(sp)
    80001de2:	7402                	ld	s0,32(sp)
    80001de4:	64e2                	ld	s1,24(sp)
    80001de6:	6145                	addi	sp,sp,48
    80001de8:	8082                	ret
    return -1;
    80001dea:	54fd                	li	s1,-1
    80001dec:	bfcd                	j	80001dde <sys_sbrk+0x26>

0000000080001dee <sys_sleep>:

uint64
sys_sleep(void)
{
    80001dee:	7139                	addi	sp,sp,-64
    80001df0:	fc06                	sd	ra,56(sp)
    80001df2:	f822                	sd	s0,48(sp)
    80001df4:	f04a                	sd	s2,32(sp)
    80001df6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001df8:	fcc40593          	addi	a1,s0,-52
    80001dfc:	4501                	li	a0,0
    80001dfe:	e7fff0ef          	jal	80001c7c <argint>
  if(n < 0)
    80001e02:	fcc42783          	lw	a5,-52(s0)
    80001e06:	0607c763          	bltz	a5,80001e74 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e0a:	0000e517          	auipc	a0,0xe
    80001e0e:	43650513          	addi	a0,a0,1078 # 80010240 <tickslock>
    80001e12:	1bf030ef          	jal	800057d0 <acquire>
  ticks0 = ticks;
    80001e16:	00008917          	auipc	s2,0x8
    80001e1a:	5c292903          	lw	s2,1474(s2) # 8000a3d8 <ticks>
  while(ticks - ticks0 < n){
    80001e1e:	fcc42783          	lw	a5,-52(s0)
    80001e22:	cf8d                	beqz	a5,80001e5c <sys_sleep+0x6e>
    80001e24:	f426                	sd	s1,40(sp)
    80001e26:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e28:	0000e997          	auipc	s3,0xe
    80001e2c:	41898993          	addi	s3,s3,1048 # 80010240 <tickslock>
    80001e30:	00008497          	auipc	s1,0x8
    80001e34:	5a848493          	addi	s1,s1,1448 # 8000a3d8 <ticks>
    if(killed(myproc())){
    80001e38:	f61fe0ef          	jal	80000d98 <myproc>
    80001e3c:	f62ff0ef          	jal	8000159e <killed>
    80001e40:	ed0d                	bnez	a0,80001e7a <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001e42:	85ce                	mv	a1,s3
    80001e44:	8526                	mv	a0,s1
    80001e46:	d20ff0ef          	jal	80001366 <sleep>
  while(ticks - ticks0 < n){
    80001e4a:	409c                	lw	a5,0(s1)
    80001e4c:	412787bb          	subw	a5,a5,s2
    80001e50:	fcc42703          	lw	a4,-52(s0)
    80001e54:	fee7e2e3          	bltu	a5,a4,80001e38 <sys_sleep+0x4a>
    80001e58:	74a2                	ld	s1,40(sp)
    80001e5a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e5c:	0000e517          	auipc	a0,0xe
    80001e60:	3e450513          	addi	a0,a0,996 # 80010240 <tickslock>
    80001e64:	205030ef          	jal	80005868 <release>
  return 0;
    80001e68:	4501                	li	a0,0
}
    80001e6a:	70e2                	ld	ra,56(sp)
    80001e6c:	7442                	ld	s0,48(sp)
    80001e6e:	7902                	ld	s2,32(sp)
    80001e70:	6121                	addi	sp,sp,64
    80001e72:	8082                	ret
    n = 0;
    80001e74:	fc042623          	sw	zero,-52(s0)
    80001e78:	bf49                	j	80001e0a <sys_sleep+0x1c>
      release(&tickslock);
    80001e7a:	0000e517          	auipc	a0,0xe
    80001e7e:	3c650513          	addi	a0,a0,966 # 80010240 <tickslock>
    80001e82:	1e7030ef          	jal	80005868 <release>
      return -1;
    80001e86:	557d                	li	a0,-1
    80001e88:	74a2                	ld	s1,40(sp)
    80001e8a:	69e2                	ld	s3,24(sp)
    80001e8c:	bff9                	j	80001e6a <sys_sleep+0x7c>

0000000080001e8e <sys_kill>:

uint64
sys_kill(void)
{
    80001e8e:	1101                	addi	sp,sp,-32
    80001e90:	ec06                	sd	ra,24(sp)
    80001e92:	e822                	sd	s0,16(sp)
    80001e94:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e96:	fec40593          	addi	a1,s0,-20
    80001e9a:	4501                	li	a0,0
    80001e9c:	de1ff0ef          	jal	80001c7c <argint>
  return kill(pid);
    80001ea0:	fec42503          	lw	a0,-20(s0)
    80001ea4:	e70ff0ef          	jal	80001514 <kill>
}
    80001ea8:	60e2                	ld	ra,24(sp)
    80001eaa:	6442                	ld	s0,16(sp)
    80001eac:	6105                	addi	sp,sp,32
    80001eae:	8082                	ret

0000000080001eb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001eb0:	1101                	addi	sp,sp,-32
    80001eb2:	ec06                	sd	ra,24(sp)
    80001eb4:	e822                	sd	s0,16(sp)
    80001eb6:	e426                	sd	s1,8(sp)
    80001eb8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001eba:	0000e517          	auipc	a0,0xe
    80001ebe:	38650513          	addi	a0,a0,902 # 80010240 <tickslock>
    80001ec2:	10f030ef          	jal	800057d0 <acquire>
  xticks = ticks;
    80001ec6:	00008497          	auipc	s1,0x8
    80001eca:	5124a483          	lw	s1,1298(s1) # 8000a3d8 <ticks>
  release(&tickslock);
    80001ece:	0000e517          	auipc	a0,0xe
    80001ed2:	37250513          	addi	a0,a0,882 # 80010240 <tickslock>
    80001ed6:	193030ef          	jal	80005868 <release>
  return xticks;
}
    80001eda:	02049513          	slli	a0,s1,0x20
    80001ede:	9101                	srli	a0,a0,0x20
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6105                	addi	sp,sp,32
    80001ee8:	8082                	ret

0000000080001eea <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80001eea:	7139                	addi	sp,sp,-64
    80001eec:	fc06                	sd	ra,56(sp)
    80001eee:	f822                	sd	s0,48(sp)
    80001ef0:	f426                	sd	s1,40(sp)
    80001ef2:	0080                	addi	s0,sp,64
  uint64 addr;
  struct sysinfo info;
  struct proc* p = myproc();
    80001ef4:	ea5fe0ef          	jal	80000d98 <myproc>
    80001ef8:	84aa                	mv	s1,a0
  argaddr(0, &addr);
    80001efa:	fd840593          	addi	a1,s0,-40
    80001efe:	4501                	li	a0,0
    80001f00:	d99ff0ef          	jal	80001c98 <argaddr>
  info.freemem = nfree();
    80001f04:	a30fe0ef          	jal	80000134 <nfree>
    80001f08:	fca43423          	sd	a0,-56(s0)
  info.nproc = nproc();
    80001f0c:	8efff0ef          	jal	800017fa <nproc>
    80001f10:	fca43823          	sd	a0,-48(s0)

  if(copyout(p->pagetable, addr, (char*)&info, sizeof(info)) < 0)
    80001f14:	46c1                	li	a3,16
    80001f16:	fc840613          	addi	a2,s0,-56
    80001f1a:	fd843583          	ld	a1,-40(s0)
    80001f1e:	68a8                	ld	a0,80(s1)
    80001f20:	ae9fe0ef          	jal	80000a08 <copyout>
    return -1;
  return 0;
}
    80001f24:	957d                	srai	a0,a0,0x3f
    80001f26:	70e2                	ld	ra,56(sp)
    80001f28:	7442                	ld	s0,48(sp)
    80001f2a:	74a2                	ld	s1,40(sp)
    80001f2c:	6121                	addi	sp,sp,64
    80001f2e:	8082                	ret

0000000080001f30 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f30:	7179                	addi	sp,sp,-48
    80001f32:	f406                	sd	ra,40(sp)
    80001f34:	f022                	sd	s0,32(sp)
    80001f36:	ec26                	sd	s1,24(sp)
    80001f38:	e84a                	sd	s2,16(sp)
    80001f3a:	e44e                	sd	s3,8(sp)
    80001f3c:	e052                	sd	s4,0(sp)
    80001f3e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f40:	00005597          	auipc	a1,0x5
    80001f44:	53858593          	addi	a1,a1,1336 # 80007478 <etext+0x478>
    80001f48:	0000e517          	auipc	a0,0xe
    80001f4c:	31050513          	addi	a0,a0,784 # 80010258 <bcache>
    80001f50:	001030ef          	jal	80005750 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f54:	00016797          	auipc	a5,0x16
    80001f58:	30478793          	addi	a5,a5,772 # 80018258 <bcache+0x8000>
    80001f5c:	00016717          	auipc	a4,0x16
    80001f60:	56470713          	addi	a4,a4,1380 # 800184c0 <bcache+0x8268>
    80001f64:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f68:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f6c:	0000e497          	auipc	s1,0xe
    80001f70:	30448493          	addi	s1,s1,772 # 80010270 <bcache+0x18>
    b->next = bcache.head.next;
    80001f74:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f76:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f78:	00005a17          	auipc	s4,0x5
    80001f7c:	508a0a13          	addi	s4,s4,1288 # 80007480 <etext+0x480>
    b->next = bcache.head.next;
    80001f80:	2b893783          	ld	a5,696(s2)
    80001f84:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f86:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f8a:	85d2                	mv	a1,s4
    80001f8c:	01048513          	addi	a0,s1,16
    80001f90:	248010ef          	jal	800031d8 <initsleeplock>
    bcache.head.next->prev = b;
    80001f94:	2b893783          	ld	a5,696(s2)
    80001f98:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001f9a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f9e:	45848493          	addi	s1,s1,1112
    80001fa2:	fd349fe3          	bne	s1,s3,80001f80 <binit+0x50>
  }
}
    80001fa6:	70a2                	ld	ra,40(sp)
    80001fa8:	7402                	ld	s0,32(sp)
    80001faa:	64e2                	ld	s1,24(sp)
    80001fac:	6942                	ld	s2,16(sp)
    80001fae:	69a2                	ld	s3,8(sp)
    80001fb0:	6a02                	ld	s4,0(sp)
    80001fb2:	6145                	addi	sp,sp,48
    80001fb4:	8082                	ret

0000000080001fb6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fb6:	7179                	addi	sp,sp,-48
    80001fb8:	f406                	sd	ra,40(sp)
    80001fba:	f022                	sd	s0,32(sp)
    80001fbc:	ec26                	sd	s1,24(sp)
    80001fbe:	e84a                	sd	s2,16(sp)
    80001fc0:	e44e                	sd	s3,8(sp)
    80001fc2:	1800                	addi	s0,sp,48
    80001fc4:	892a                	mv	s2,a0
    80001fc6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fc8:	0000e517          	auipc	a0,0xe
    80001fcc:	29050513          	addi	a0,a0,656 # 80010258 <bcache>
    80001fd0:	001030ef          	jal	800057d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fd4:	00016497          	auipc	s1,0x16
    80001fd8:	53c4b483          	ld	s1,1340(s1) # 80018510 <bcache+0x82b8>
    80001fdc:	00016797          	auipc	a5,0x16
    80001fe0:	4e478793          	addi	a5,a5,1252 # 800184c0 <bcache+0x8268>
    80001fe4:	02f48b63          	beq	s1,a5,8000201a <bread+0x64>
    80001fe8:	873e                	mv	a4,a5
    80001fea:	a021                	j	80001ff2 <bread+0x3c>
    80001fec:	68a4                	ld	s1,80(s1)
    80001fee:	02e48663          	beq	s1,a4,8000201a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001ff2:	449c                	lw	a5,8(s1)
    80001ff4:	ff279ce3          	bne	a5,s2,80001fec <bread+0x36>
    80001ff8:	44dc                	lw	a5,12(s1)
    80001ffa:	ff3799e3          	bne	a5,s3,80001fec <bread+0x36>
      b->refcnt++;
    80001ffe:	40bc                	lw	a5,64(s1)
    80002000:	2785                	addiw	a5,a5,1
    80002002:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002004:	0000e517          	auipc	a0,0xe
    80002008:	25450513          	addi	a0,a0,596 # 80010258 <bcache>
    8000200c:	05d030ef          	jal	80005868 <release>
      acquiresleep(&b->lock);
    80002010:	01048513          	addi	a0,s1,16
    80002014:	1fa010ef          	jal	8000320e <acquiresleep>
      return b;
    80002018:	a889                	j	8000206a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000201a:	00016497          	auipc	s1,0x16
    8000201e:	4ee4b483          	ld	s1,1262(s1) # 80018508 <bcache+0x82b0>
    80002022:	00016797          	auipc	a5,0x16
    80002026:	49e78793          	addi	a5,a5,1182 # 800184c0 <bcache+0x8268>
    8000202a:	00f48863          	beq	s1,a5,8000203a <bread+0x84>
    8000202e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002030:	40bc                	lw	a5,64(s1)
    80002032:	cb91                	beqz	a5,80002046 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002034:	64a4                	ld	s1,72(s1)
    80002036:	fee49de3          	bne	s1,a4,80002030 <bread+0x7a>
  panic("bget: no buffers");
    8000203a:	00005517          	auipc	a0,0x5
    8000203e:	44e50513          	addi	a0,a0,1102 # 80007488 <etext+0x488>
    80002042:	460030ef          	jal	800054a2 <panic>
      b->dev = dev;
    80002046:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000204a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000204e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002052:	4785                	li	a5,1
    80002054:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002056:	0000e517          	auipc	a0,0xe
    8000205a:	20250513          	addi	a0,a0,514 # 80010258 <bcache>
    8000205e:	00b030ef          	jal	80005868 <release>
      acquiresleep(&b->lock);
    80002062:	01048513          	addi	a0,s1,16
    80002066:	1a8010ef          	jal	8000320e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000206a:	409c                	lw	a5,0(s1)
    8000206c:	cb89                	beqz	a5,8000207e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000206e:	8526                	mv	a0,s1
    80002070:	70a2                	ld	ra,40(sp)
    80002072:	7402                	ld	s0,32(sp)
    80002074:	64e2                	ld	s1,24(sp)
    80002076:	6942                	ld	s2,16(sp)
    80002078:	69a2                	ld	s3,8(sp)
    8000207a:	6145                	addi	sp,sp,48
    8000207c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000207e:	4581                	li	a1,0
    80002080:	8526                	mv	a0,s1
    80002082:	1ef020ef          	jal	80004a70 <virtio_disk_rw>
    b->valid = 1;
    80002086:	4785                	li	a5,1
    80002088:	c09c                	sw	a5,0(s1)
  return b;
    8000208a:	b7d5                	j	8000206e <bread+0xb8>

000000008000208c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000208c:	1101                	addi	sp,sp,-32
    8000208e:	ec06                	sd	ra,24(sp)
    80002090:	e822                	sd	s0,16(sp)
    80002092:	e426                	sd	s1,8(sp)
    80002094:	1000                	addi	s0,sp,32
    80002096:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002098:	0541                	addi	a0,a0,16
    8000209a:	1f2010ef          	jal	8000328c <holdingsleep>
    8000209e:	c911                	beqz	a0,800020b2 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020a0:	4585                	li	a1,1
    800020a2:	8526                	mv	a0,s1
    800020a4:	1cd020ef          	jal	80004a70 <virtio_disk_rw>
}
    800020a8:	60e2                	ld	ra,24(sp)
    800020aa:	6442                	ld	s0,16(sp)
    800020ac:	64a2                	ld	s1,8(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret
    panic("bwrite");
    800020b2:	00005517          	auipc	a0,0x5
    800020b6:	3ee50513          	addi	a0,a0,1006 # 800074a0 <etext+0x4a0>
    800020ba:	3e8030ef          	jal	800054a2 <panic>

00000000800020be <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	e426                	sd	s1,8(sp)
    800020c6:	e04a                	sd	s2,0(sp)
    800020c8:	1000                	addi	s0,sp,32
    800020ca:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020cc:	01050913          	addi	s2,a0,16
    800020d0:	854a                	mv	a0,s2
    800020d2:	1ba010ef          	jal	8000328c <holdingsleep>
    800020d6:	c135                	beqz	a0,8000213a <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020d8:	854a                	mv	a0,s2
    800020da:	17a010ef          	jal	80003254 <releasesleep>

  acquire(&bcache.lock);
    800020de:	0000e517          	auipc	a0,0xe
    800020e2:	17a50513          	addi	a0,a0,378 # 80010258 <bcache>
    800020e6:	6ea030ef          	jal	800057d0 <acquire>
  b->refcnt--;
    800020ea:	40bc                	lw	a5,64(s1)
    800020ec:	37fd                	addiw	a5,a5,-1
    800020ee:	0007871b          	sext.w	a4,a5
    800020f2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800020f4:	e71d                	bnez	a4,80002122 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800020f6:	68b8                	ld	a4,80(s1)
    800020f8:	64bc                	ld	a5,72(s1)
    800020fa:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800020fc:	68b8                	ld	a4,80(s1)
    800020fe:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002100:	00016797          	auipc	a5,0x16
    80002104:	15878793          	addi	a5,a5,344 # 80018258 <bcache+0x8000>
    80002108:	2b87b703          	ld	a4,696(a5)
    8000210c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000210e:	00016717          	auipc	a4,0x16
    80002112:	3b270713          	addi	a4,a4,946 # 800184c0 <bcache+0x8268>
    80002116:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002118:	2b87b703          	ld	a4,696(a5)
    8000211c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000211e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002122:	0000e517          	auipc	a0,0xe
    80002126:	13650513          	addi	a0,a0,310 # 80010258 <bcache>
    8000212a:	73e030ef          	jal	80005868 <release>
}
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6902                	ld	s2,0(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret
    panic("brelse");
    8000213a:	00005517          	auipc	a0,0x5
    8000213e:	36e50513          	addi	a0,a0,878 # 800074a8 <etext+0x4a8>
    80002142:	360030ef          	jal	800054a2 <panic>

0000000080002146 <bpin>:

void
bpin(struct buf *b) {
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	1000                	addi	s0,sp,32
    80002150:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002152:	0000e517          	auipc	a0,0xe
    80002156:	10650513          	addi	a0,a0,262 # 80010258 <bcache>
    8000215a:	676030ef          	jal	800057d0 <acquire>
  b->refcnt++;
    8000215e:	40bc                	lw	a5,64(s1)
    80002160:	2785                	addiw	a5,a5,1
    80002162:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002164:	0000e517          	auipc	a0,0xe
    80002168:	0f450513          	addi	a0,a0,244 # 80010258 <bcache>
    8000216c:	6fc030ef          	jal	80005868 <release>
}
    80002170:	60e2                	ld	ra,24(sp)
    80002172:	6442                	ld	s0,16(sp)
    80002174:	64a2                	ld	s1,8(sp)
    80002176:	6105                	addi	sp,sp,32
    80002178:	8082                	ret

000000008000217a <bunpin>:

void
bunpin(struct buf *b) {
    8000217a:	1101                	addi	sp,sp,-32
    8000217c:	ec06                	sd	ra,24(sp)
    8000217e:	e822                	sd	s0,16(sp)
    80002180:	e426                	sd	s1,8(sp)
    80002182:	1000                	addi	s0,sp,32
    80002184:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002186:	0000e517          	auipc	a0,0xe
    8000218a:	0d250513          	addi	a0,a0,210 # 80010258 <bcache>
    8000218e:	642030ef          	jal	800057d0 <acquire>
  b->refcnt--;
    80002192:	40bc                	lw	a5,64(s1)
    80002194:	37fd                	addiw	a5,a5,-1
    80002196:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002198:	0000e517          	auipc	a0,0xe
    8000219c:	0c050513          	addi	a0,a0,192 # 80010258 <bcache>
    800021a0:	6c8030ef          	jal	80005868 <release>
}
    800021a4:	60e2                	ld	ra,24(sp)
    800021a6:	6442                	ld	s0,16(sp)
    800021a8:	64a2                	ld	s1,8(sp)
    800021aa:	6105                	addi	sp,sp,32
    800021ac:	8082                	ret

00000000800021ae <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021ae:	1101                	addi	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	e426                	sd	s1,8(sp)
    800021b6:	e04a                	sd	s2,0(sp)
    800021b8:	1000                	addi	s0,sp,32
    800021ba:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021bc:	00d5d59b          	srliw	a1,a1,0xd
    800021c0:	00016797          	auipc	a5,0x16
    800021c4:	7747a783          	lw	a5,1908(a5) # 80018934 <sb+0x1c>
    800021c8:	9dbd                	addw	a1,a1,a5
    800021ca:	dedff0ef          	jal	80001fb6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021ce:	0074f713          	andi	a4,s1,7
    800021d2:	4785                	li	a5,1
    800021d4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021d8:	14ce                	slli	s1,s1,0x33
    800021da:	90d9                	srli	s1,s1,0x36
    800021dc:	00950733          	add	a4,a0,s1
    800021e0:	05874703          	lbu	a4,88(a4)
    800021e4:	00e7f6b3          	and	a3,a5,a4
    800021e8:	c29d                	beqz	a3,8000220e <bfree+0x60>
    800021ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800021ec:	94aa                	add	s1,s1,a0
    800021ee:	fff7c793          	not	a5,a5
    800021f2:	8f7d                	and	a4,a4,a5
    800021f4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800021f8:	711000ef          	jal	80003108 <log_write>
  brelse(bp);
    800021fc:	854a                	mv	a0,s2
    800021fe:	ec1ff0ef          	jal	800020be <brelse>
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6902                	ld	s2,0(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret
    panic("freeing free block");
    8000220e:	00005517          	auipc	a0,0x5
    80002212:	2a250513          	addi	a0,a0,674 # 800074b0 <etext+0x4b0>
    80002216:	28c030ef          	jal	800054a2 <panic>

000000008000221a <balloc>:
{
    8000221a:	711d                	addi	sp,sp,-96
    8000221c:	ec86                	sd	ra,88(sp)
    8000221e:	e8a2                	sd	s0,80(sp)
    80002220:	e4a6                	sd	s1,72(sp)
    80002222:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002224:	00016797          	auipc	a5,0x16
    80002228:	6f87a783          	lw	a5,1784(a5) # 8001891c <sb+0x4>
    8000222c:	0e078f63          	beqz	a5,8000232a <balloc+0x110>
    80002230:	e0ca                	sd	s2,64(sp)
    80002232:	fc4e                	sd	s3,56(sp)
    80002234:	f852                	sd	s4,48(sp)
    80002236:	f456                	sd	s5,40(sp)
    80002238:	f05a                	sd	s6,32(sp)
    8000223a:	ec5e                	sd	s7,24(sp)
    8000223c:	e862                	sd	s8,16(sp)
    8000223e:	e466                	sd	s9,8(sp)
    80002240:	8baa                	mv	s7,a0
    80002242:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002244:	00016b17          	auipc	s6,0x16
    80002248:	6d4b0b13          	addi	s6,s6,1748 # 80018918 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000224c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000224e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002250:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002252:	6c89                	lui	s9,0x2
    80002254:	a0b5                	j	800022c0 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002256:	97ca                	add	a5,a5,s2
    80002258:	8e55                	or	a2,a2,a3
    8000225a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000225e:	854a                	mv	a0,s2
    80002260:	6a9000ef          	jal	80003108 <log_write>
        brelse(bp);
    80002264:	854a                	mv	a0,s2
    80002266:	e59ff0ef          	jal	800020be <brelse>
  bp = bread(dev, bno);
    8000226a:	85a6                	mv	a1,s1
    8000226c:	855e                	mv	a0,s7
    8000226e:	d49ff0ef          	jal	80001fb6 <bread>
    80002272:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002274:	40000613          	li	a2,1024
    80002278:	4581                	li	a1,0
    8000227a:	05850513          	addi	a0,a0,88
    8000227e:	ef9fd0ef          	jal	80000176 <memset>
  log_write(bp);
    80002282:	854a                	mv	a0,s2
    80002284:	685000ef          	jal	80003108 <log_write>
  brelse(bp);
    80002288:	854a                	mv	a0,s2
    8000228a:	e35ff0ef          	jal	800020be <brelse>
}
    8000228e:	6906                	ld	s2,64(sp)
    80002290:	79e2                	ld	s3,56(sp)
    80002292:	7a42                	ld	s4,48(sp)
    80002294:	7aa2                	ld	s5,40(sp)
    80002296:	7b02                	ld	s6,32(sp)
    80002298:	6be2                	ld	s7,24(sp)
    8000229a:	6c42                	ld	s8,16(sp)
    8000229c:	6ca2                	ld	s9,8(sp)
}
    8000229e:	8526                	mv	a0,s1
    800022a0:	60e6                	ld	ra,88(sp)
    800022a2:	6446                	ld	s0,80(sp)
    800022a4:	64a6                	ld	s1,72(sp)
    800022a6:	6125                	addi	sp,sp,96
    800022a8:	8082                	ret
    brelse(bp);
    800022aa:	854a                	mv	a0,s2
    800022ac:	e13ff0ef          	jal	800020be <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022b0:	015c87bb          	addw	a5,s9,s5
    800022b4:	00078a9b          	sext.w	s5,a5
    800022b8:	004b2703          	lw	a4,4(s6)
    800022bc:	04eaff63          	bgeu	s5,a4,8000231a <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022c0:	41fad79b          	sraiw	a5,s5,0x1f
    800022c4:	0137d79b          	srliw	a5,a5,0x13
    800022c8:	015787bb          	addw	a5,a5,s5
    800022cc:	40d7d79b          	sraiw	a5,a5,0xd
    800022d0:	01cb2583          	lw	a1,28(s6)
    800022d4:	9dbd                	addw	a1,a1,a5
    800022d6:	855e                	mv	a0,s7
    800022d8:	cdfff0ef          	jal	80001fb6 <bread>
    800022dc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022de:	004b2503          	lw	a0,4(s6)
    800022e2:	000a849b          	sext.w	s1,s5
    800022e6:	8762                	mv	a4,s8
    800022e8:	fca4f1e3          	bgeu	s1,a0,800022aa <balloc+0x90>
      m = 1 << (bi % 8);
    800022ec:	00777693          	andi	a3,a4,7
    800022f0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800022f4:	41f7579b          	sraiw	a5,a4,0x1f
    800022f8:	01d7d79b          	srliw	a5,a5,0x1d
    800022fc:	9fb9                	addw	a5,a5,a4
    800022fe:	4037d79b          	sraiw	a5,a5,0x3
    80002302:	00f90633          	add	a2,s2,a5
    80002306:	05864603          	lbu	a2,88(a2)
    8000230a:	00c6f5b3          	and	a1,a3,a2
    8000230e:	d5a1                	beqz	a1,80002256 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002310:	2705                	addiw	a4,a4,1
    80002312:	2485                	addiw	s1,s1,1
    80002314:	fd471ae3          	bne	a4,s4,800022e8 <balloc+0xce>
    80002318:	bf49                	j	800022aa <balloc+0x90>
    8000231a:	6906                	ld	s2,64(sp)
    8000231c:	79e2                	ld	s3,56(sp)
    8000231e:	7a42                	ld	s4,48(sp)
    80002320:	7aa2                	ld	s5,40(sp)
    80002322:	7b02                	ld	s6,32(sp)
    80002324:	6be2                	ld	s7,24(sp)
    80002326:	6c42                	ld	s8,16(sp)
    80002328:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000232a:	00005517          	auipc	a0,0x5
    8000232e:	19e50513          	addi	a0,a0,414 # 800074c8 <etext+0x4c8>
    80002332:	69f020ef          	jal	800051d0 <printf>
  return 0;
    80002336:	4481                	li	s1,0
    80002338:	b79d                	j	8000229e <balloc+0x84>

000000008000233a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000233a:	7179                	addi	sp,sp,-48
    8000233c:	f406                	sd	ra,40(sp)
    8000233e:	f022                	sd	s0,32(sp)
    80002340:	ec26                	sd	s1,24(sp)
    80002342:	e84a                	sd	s2,16(sp)
    80002344:	e44e                	sd	s3,8(sp)
    80002346:	1800                	addi	s0,sp,48
    80002348:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000234a:	47ad                	li	a5,11
    8000234c:	02b7e663          	bltu	a5,a1,80002378 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002350:	02059793          	slli	a5,a1,0x20
    80002354:	01e7d593          	srli	a1,a5,0x1e
    80002358:	00b504b3          	add	s1,a0,a1
    8000235c:	0504a903          	lw	s2,80(s1)
    80002360:	06091a63          	bnez	s2,800023d4 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002364:	4108                	lw	a0,0(a0)
    80002366:	eb5ff0ef          	jal	8000221a <balloc>
    8000236a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000236e:	06090363          	beqz	s2,800023d4 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002372:	0524a823          	sw	s2,80(s1)
    80002376:	a8b9                	j	800023d4 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002378:	ff45849b          	addiw	s1,a1,-12
    8000237c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002380:	0ff00793          	li	a5,255
    80002384:	06e7ee63          	bltu	a5,a4,80002400 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002388:	08052903          	lw	s2,128(a0)
    8000238c:	00091d63          	bnez	s2,800023a6 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002390:	4108                	lw	a0,0(a0)
    80002392:	e89ff0ef          	jal	8000221a <balloc>
    80002396:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000239a:	02090d63          	beqz	s2,800023d4 <bmap+0x9a>
    8000239e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023a0:	0929a023          	sw	s2,128(s3)
    800023a4:	a011                	j	800023a8 <bmap+0x6e>
    800023a6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023a8:	85ca                	mv	a1,s2
    800023aa:	0009a503          	lw	a0,0(s3)
    800023ae:	c09ff0ef          	jal	80001fb6 <bread>
    800023b2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023b4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023b8:	02049713          	slli	a4,s1,0x20
    800023bc:	01e75593          	srli	a1,a4,0x1e
    800023c0:	00b784b3          	add	s1,a5,a1
    800023c4:	0004a903          	lw	s2,0(s1)
    800023c8:	00090e63          	beqz	s2,800023e4 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023cc:	8552                	mv	a0,s4
    800023ce:	cf1ff0ef          	jal	800020be <brelse>
    return addr;
    800023d2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023d4:	854a                	mv	a0,s2
    800023d6:	70a2                	ld	ra,40(sp)
    800023d8:	7402                	ld	s0,32(sp)
    800023da:	64e2                	ld	s1,24(sp)
    800023dc:	6942                	ld	s2,16(sp)
    800023de:	69a2                	ld	s3,8(sp)
    800023e0:	6145                	addi	sp,sp,48
    800023e2:	8082                	ret
      addr = balloc(ip->dev);
    800023e4:	0009a503          	lw	a0,0(s3)
    800023e8:	e33ff0ef          	jal	8000221a <balloc>
    800023ec:	0005091b          	sext.w	s2,a0
      if(addr){
    800023f0:	fc090ee3          	beqz	s2,800023cc <bmap+0x92>
        a[bn] = addr;
    800023f4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800023f8:	8552                	mv	a0,s4
    800023fa:	50f000ef          	jal	80003108 <log_write>
    800023fe:	b7f9                	j	800023cc <bmap+0x92>
    80002400:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002402:	00005517          	auipc	a0,0x5
    80002406:	0de50513          	addi	a0,a0,222 # 800074e0 <etext+0x4e0>
    8000240a:	098030ef          	jal	800054a2 <panic>

000000008000240e <iget>:
{
    8000240e:	7179                	addi	sp,sp,-48
    80002410:	f406                	sd	ra,40(sp)
    80002412:	f022                	sd	s0,32(sp)
    80002414:	ec26                	sd	s1,24(sp)
    80002416:	e84a                	sd	s2,16(sp)
    80002418:	e44e                	sd	s3,8(sp)
    8000241a:	e052                	sd	s4,0(sp)
    8000241c:	1800                	addi	s0,sp,48
    8000241e:	89aa                	mv	s3,a0
    80002420:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002422:	00016517          	auipc	a0,0x16
    80002426:	51650513          	addi	a0,a0,1302 # 80018938 <itable>
    8000242a:	3a6030ef          	jal	800057d0 <acquire>
  empty = 0;
    8000242e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002430:	00016497          	auipc	s1,0x16
    80002434:	52048493          	addi	s1,s1,1312 # 80018950 <itable+0x18>
    80002438:	00018697          	auipc	a3,0x18
    8000243c:	fa868693          	addi	a3,a3,-88 # 8001a3e0 <log>
    80002440:	a039                	j	8000244e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002442:	02090963          	beqz	s2,80002474 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002446:	08848493          	addi	s1,s1,136
    8000244a:	02d48863          	beq	s1,a3,8000247a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000244e:	449c                	lw	a5,8(s1)
    80002450:	fef059e3          	blez	a5,80002442 <iget+0x34>
    80002454:	4098                	lw	a4,0(s1)
    80002456:	ff3716e3          	bne	a4,s3,80002442 <iget+0x34>
    8000245a:	40d8                	lw	a4,4(s1)
    8000245c:	ff4713e3          	bne	a4,s4,80002442 <iget+0x34>
      ip->ref++;
    80002460:	2785                	addiw	a5,a5,1
    80002462:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002464:	00016517          	auipc	a0,0x16
    80002468:	4d450513          	addi	a0,a0,1236 # 80018938 <itable>
    8000246c:	3fc030ef          	jal	80005868 <release>
      return ip;
    80002470:	8926                	mv	s2,s1
    80002472:	a02d                	j	8000249c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002474:	fbe9                	bnez	a5,80002446 <iget+0x38>
      empty = ip;
    80002476:	8926                	mv	s2,s1
    80002478:	b7f9                	j	80002446 <iget+0x38>
  if(empty == 0)
    8000247a:	02090a63          	beqz	s2,800024ae <iget+0xa0>
  ip->dev = dev;
    8000247e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002482:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002486:	4785                	li	a5,1
    80002488:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000248c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002490:	00016517          	auipc	a0,0x16
    80002494:	4a850513          	addi	a0,a0,1192 # 80018938 <itable>
    80002498:	3d0030ef          	jal	80005868 <release>
}
    8000249c:	854a                	mv	a0,s2
    8000249e:	70a2                	ld	ra,40(sp)
    800024a0:	7402                	ld	s0,32(sp)
    800024a2:	64e2                	ld	s1,24(sp)
    800024a4:	6942                	ld	s2,16(sp)
    800024a6:	69a2                	ld	s3,8(sp)
    800024a8:	6a02                	ld	s4,0(sp)
    800024aa:	6145                	addi	sp,sp,48
    800024ac:	8082                	ret
    panic("iget: no inodes");
    800024ae:	00005517          	auipc	a0,0x5
    800024b2:	04a50513          	addi	a0,a0,74 # 800074f8 <etext+0x4f8>
    800024b6:	7ed020ef          	jal	800054a2 <panic>

00000000800024ba <fsinit>:
fsinit(int dev) {
    800024ba:	7179                	addi	sp,sp,-48
    800024bc:	f406                	sd	ra,40(sp)
    800024be:	f022                	sd	s0,32(sp)
    800024c0:	ec26                	sd	s1,24(sp)
    800024c2:	e84a                	sd	s2,16(sp)
    800024c4:	e44e                	sd	s3,8(sp)
    800024c6:	1800                	addi	s0,sp,48
    800024c8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800024ca:	4585                	li	a1,1
    800024cc:	aebff0ef          	jal	80001fb6 <bread>
    800024d0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800024d2:	00016997          	auipc	s3,0x16
    800024d6:	44698993          	addi	s3,s3,1094 # 80018918 <sb>
    800024da:	02000613          	li	a2,32
    800024de:	05850593          	addi	a1,a0,88
    800024e2:	854e                	mv	a0,s3
    800024e4:	ceffd0ef          	jal	800001d2 <memmove>
  brelse(bp);
    800024e8:	8526                	mv	a0,s1
    800024ea:	bd5ff0ef          	jal	800020be <brelse>
  if(sb.magic != FSMAGIC)
    800024ee:	0009a703          	lw	a4,0(s3)
    800024f2:	102037b7          	lui	a5,0x10203
    800024f6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800024fa:	02f71063          	bne	a4,a5,8000251a <fsinit+0x60>
  initlog(dev, &sb);
    800024fe:	00016597          	auipc	a1,0x16
    80002502:	41a58593          	addi	a1,a1,1050 # 80018918 <sb>
    80002506:	854a                	mv	a0,s2
    80002508:	1f9000ef          	jal	80002f00 <initlog>
}
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6145                	addi	sp,sp,48
    80002518:	8082                	ret
    panic("invalid file system");
    8000251a:	00005517          	auipc	a0,0x5
    8000251e:	fee50513          	addi	a0,a0,-18 # 80007508 <etext+0x508>
    80002522:	781020ef          	jal	800054a2 <panic>

0000000080002526 <iinit>:
{
    80002526:	7179                	addi	sp,sp,-48
    80002528:	f406                	sd	ra,40(sp)
    8000252a:	f022                	sd	s0,32(sp)
    8000252c:	ec26                	sd	s1,24(sp)
    8000252e:	e84a                	sd	s2,16(sp)
    80002530:	e44e                	sd	s3,8(sp)
    80002532:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002534:	00005597          	auipc	a1,0x5
    80002538:	fec58593          	addi	a1,a1,-20 # 80007520 <etext+0x520>
    8000253c:	00016517          	auipc	a0,0x16
    80002540:	3fc50513          	addi	a0,a0,1020 # 80018938 <itable>
    80002544:	20c030ef          	jal	80005750 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002548:	00016497          	auipc	s1,0x16
    8000254c:	41848493          	addi	s1,s1,1048 # 80018960 <itable+0x28>
    80002550:	00018997          	auipc	s3,0x18
    80002554:	ea098993          	addi	s3,s3,-352 # 8001a3f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002558:	00005917          	auipc	s2,0x5
    8000255c:	fd090913          	addi	s2,s2,-48 # 80007528 <etext+0x528>
    80002560:	85ca                	mv	a1,s2
    80002562:	8526                	mv	a0,s1
    80002564:	475000ef          	jal	800031d8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002568:	08848493          	addi	s1,s1,136
    8000256c:	ff349ae3          	bne	s1,s3,80002560 <iinit+0x3a>
}
    80002570:	70a2                	ld	ra,40(sp)
    80002572:	7402                	ld	s0,32(sp)
    80002574:	64e2                	ld	s1,24(sp)
    80002576:	6942                	ld	s2,16(sp)
    80002578:	69a2                	ld	s3,8(sp)
    8000257a:	6145                	addi	sp,sp,48
    8000257c:	8082                	ret

000000008000257e <ialloc>:
{
    8000257e:	7139                	addi	sp,sp,-64
    80002580:	fc06                	sd	ra,56(sp)
    80002582:	f822                	sd	s0,48(sp)
    80002584:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002586:	00016717          	auipc	a4,0x16
    8000258a:	39e72703          	lw	a4,926(a4) # 80018924 <sb+0xc>
    8000258e:	4785                	li	a5,1
    80002590:	06e7f063          	bgeu	a5,a4,800025f0 <ialloc+0x72>
    80002594:	f426                	sd	s1,40(sp)
    80002596:	f04a                	sd	s2,32(sp)
    80002598:	ec4e                	sd	s3,24(sp)
    8000259a:	e852                	sd	s4,16(sp)
    8000259c:	e456                	sd	s5,8(sp)
    8000259e:	e05a                	sd	s6,0(sp)
    800025a0:	8aaa                	mv	s5,a0
    800025a2:	8b2e                	mv	s6,a1
    800025a4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800025a6:	00016a17          	auipc	s4,0x16
    800025aa:	372a0a13          	addi	s4,s4,882 # 80018918 <sb>
    800025ae:	00495593          	srli	a1,s2,0x4
    800025b2:	018a2783          	lw	a5,24(s4)
    800025b6:	9dbd                	addw	a1,a1,a5
    800025b8:	8556                	mv	a0,s5
    800025ba:	9fdff0ef          	jal	80001fb6 <bread>
    800025be:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025c0:	05850993          	addi	s3,a0,88
    800025c4:	00f97793          	andi	a5,s2,15
    800025c8:	079a                	slli	a5,a5,0x6
    800025ca:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025cc:	00099783          	lh	a5,0(s3)
    800025d0:	cb9d                	beqz	a5,80002606 <ialloc+0x88>
    brelse(bp);
    800025d2:	aedff0ef          	jal	800020be <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025d6:	0905                	addi	s2,s2,1
    800025d8:	00ca2703          	lw	a4,12(s4)
    800025dc:	0009079b          	sext.w	a5,s2
    800025e0:	fce7e7e3          	bltu	a5,a4,800025ae <ialloc+0x30>
    800025e4:	74a2                	ld	s1,40(sp)
    800025e6:	7902                	ld	s2,32(sp)
    800025e8:	69e2                	ld	s3,24(sp)
    800025ea:	6a42                	ld	s4,16(sp)
    800025ec:	6aa2                	ld	s5,8(sp)
    800025ee:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025f0:	00005517          	auipc	a0,0x5
    800025f4:	f4050513          	addi	a0,a0,-192 # 80007530 <etext+0x530>
    800025f8:	3d9020ef          	jal	800051d0 <printf>
  return 0;
    800025fc:	4501                	li	a0,0
}
    800025fe:	70e2                	ld	ra,56(sp)
    80002600:	7442                	ld	s0,48(sp)
    80002602:	6121                	addi	sp,sp,64
    80002604:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002606:	04000613          	li	a2,64
    8000260a:	4581                	li	a1,0
    8000260c:	854e                	mv	a0,s3
    8000260e:	b69fd0ef          	jal	80000176 <memset>
      dip->type = type;
    80002612:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002616:	8526                	mv	a0,s1
    80002618:	2f1000ef          	jal	80003108 <log_write>
      brelse(bp);
    8000261c:	8526                	mv	a0,s1
    8000261e:	aa1ff0ef          	jal	800020be <brelse>
      return iget(dev, inum);
    80002622:	0009059b          	sext.w	a1,s2
    80002626:	8556                	mv	a0,s5
    80002628:	de7ff0ef          	jal	8000240e <iget>
    8000262c:	74a2                	ld	s1,40(sp)
    8000262e:	7902                	ld	s2,32(sp)
    80002630:	69e2                	ld	s3,24(sp)
    80002632:	6a42                	ld	s4,16(sp)
    80002634:	6aa2                	ld	s5,8(sp)
    80002636:	6b02                	ld	s6,0(sp)
    80002638:	b7d9                	j	800025fe <ialloc+0x80>

000000008000263a <iupdate>:
{
    8000263a:	1101                	addi	sp,sp,-32
    8000263c:	ec06                	sd	ra,24(sp)
    8000263e:	e822                	sd	s0,16(sp)
    80002640:	e426                	sd	s1,8(sp)
    80002642:	e04a                	sd	s2,0(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002648:	415c                	lw	a5,4(a0)
    8000264a:	0047d79b          	srliw	a5,a5,0x4
    8000264e:	00016597          	auipc	a1,0x16
    80002652:	2e25a583          	lw	a1,738(a1) # 80018930 <sb+0x18>
    80002656:	9dbd                	addw	a1,a1,a5
    80002658:	4108                	lw	a0,0(a0)
    8000265a:	95dff0ef          	jal	80001fb6 <bread>
    8000265e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002660:	05850793          	addi	a5,a0,88
    80002664:	40d8                	lw	a4,4(s1)
    80002666:	8b3d                	andi	a4,a4,15
    80002668:	071a                	slli	a4,a4,0x6
    8000266a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000266c:	04449703          	lh	a4,68(s1)
    80002670:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002674:	04649703          	lh	a4,70(s1)
    80002678:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000267c:	04849703          	lh	a4,72(s1)
    80002680:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002684:	04a49703          	lh	a4,74(s1)
    80002688:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000268c:	44f8                	lw	a4,76(s1)
    8000268e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002690:	03400613          	li	a2,52
    80002694:	05048593          	addi	a1,s1,80
    80002698:	00c78513          	addi	a0,a5,12
    8000269c:	b37fd0ef          	jal	800001d2 <memmove>
  log_write(bp);
    800026a0:	854a                	mv	a0,s2
    800026a2:	267000ef          	jal	80003108 <log_write>
  brelse(bp);
    800026a6:	854a                	mv	a0,s2
    800026a8:	a17ff0ef          	jal	800020be <brelse>
}
    800026ac:	60e2                	ld	ra,24(sp)
    800026ae:	6442                	ld	s0,16(sp)
    800026b0:	64a2                	ld	s1,8(sp)
    800026b2:	6902                	ld	s2,0(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret

00000000800026b8 <idup>:
{
    800026b8:	1101                	addi	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	e426                	sd	s1,8(sp)
    800026c0:	1000                	addi	s0,sp,32
    800026c2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026c4:	00016517          	auipc	a0,0x16
    800026c8:	27450513          	addi	a0,a0,628 # 80018938 <itable>
    800026cc:	104030ef          	jal	800057d0 <acquire>
  ip->ref++;
    800026d0:	449c                	lw	a5,8(s1)
    800026d2:	2785                	addiw	a5,a5,1
    800026d4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026d6:	00016517          	auipc	a0,0x16
    800026da:	26250513          	addi	a0,a0,610 # 80018938 <itable>
    800026de:	18a030ef          	jal	80005868 <release>
}
    800026e2:	8526                	mv	a0,s1
    800026e4:	60e2                	ld	ra,24(sp)
    800026e6:	6442                	ld	s0,16(sp)
    800026e8:	64a2                	ld	s1,8(sp)
    800026ea:	6105                	addi	sp,sp,32
    800026ec:	8082                	ret

00000000800026ee <ilock>:
{
    800026ee:	1101                	addi	sp,sp,-32
    800026f0:	ec06                	sd	ra,24(sp)
    800026f2:	e822                	sd	s0,16(sp)
    800026f4:	e426                	sd	s1,8(sp)
    800026f6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026f8:	cd19                	beqz	a0,80002716 <ilock+0x28>
    800026fa:	84aa                	mv	s1,a0
    800026fc:	451c                	lw	a5,8(a0)
    800026fe:	00f05c63          	blez	a5,80002716 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002702:	0541                	addi	a0,a0,16
    80002704:	30b000ef          	jal	8000320e <acquiresleep>
  if(ip->valid == 0){
    80002708:	40bc                	lw	a5,64(s1)
    8000270a:	cf89                	beqz	a5,80002724 <ilock+0x36>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret
    80002716:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002718:	00005517          	auipc	a0,0x5
    8000271c:	e3050513          	addi	a0,a0,-464 # 80007548 <etext+0x548>
    80002720:	583020ef          	jal	800054a2 <panic>
    80002724:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002726:	40dc                	lw	a5,4(s1)
    80002728:	0047d79b          	srliw	a5,a5,0x4
    8000272c:	00016597          	auipc	a1,0x16
    80002730:	2045a583          	lw	a1,516(a1) # 80018930 <sb+0x18>
    80002734:	9dbd                	addw	a1,a1,a5
    80002736:	4088                	lw	a0,0(s1)
    80002738:	87fff0ef          	jal	80001fb6 <bread>
    8000273c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000273e:	05850593          	addi	a1,a0,88
    80002742:	40dc                	lw	a5,4(s1)
    80002744:	8bbd                	andi	a5,a5,15
    80002746:	079a                	slli	a5,a5,0x6
    80002748:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000274a:	00059783          	lh	a5,0(a1)
    8000274e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002752:	00259783          	lh	a5,2(a1)
    80002756:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000275a:	00459783          	lh	a5,4(a1)
    8000275e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002762:	00659783          	lh	a5,6(a1)
    80002766:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000276a:	459c                	lw	a5,8(a1)
    8000276c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000276e:	03400613          	li	a2,52
    80002772:	05b1                	addi	a1,a1,12
    80002774:	05048513          	addi	a0,s1,80
    80002778:	a5bfd0ef          	jal	800001d2 <memmove>
    brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	941ff0ef          	jal	800020be <brelse>
    ip->valid = 1;
    80002782:	4785                	li	a5,1
    80002784:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002786:	04449783          	lh	a5,68(s1)
    8000278a:	c399                	beqz	a5,80002790 <ilock+0xa2>
    8000278c:	6902                	ld	s2,0(sp)
    8000278e:	bfbd                	j	8000270c <ilock+0x1e>
      panic("ilock: no type");
    80002790:	00005517          	auipc	a0,0x5
    80002794:	dc050513          	addi	a0,a0,-576 # 80007550 <etext+0x550>
    80002798:	50b020ef          	jal	800054a2 <panic>

000000008000279c <iunlock>:
{
    8000279c:	1101                	addi	sp,sp,-32
    8000279e:	ec06                	sd	ra,24(sp)
    800027a0:	e822                	sd	s0,16(sp)
    800027a2:	e426                	sd	s1,8(sp)
    800027a4:	e04a                	sd	s2,0(sp)
    800027a6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027a8:	c505                	beqz	a0,800027d0 <iunlock+0x34>
    800027aa:	84aa                	mv	s1,a0
    800027ac:	01050913          	addi	s2,a0,16
    800027b0:	854a                	mv	a0,s2
    800027b2:	2db000ef          	jal	8000328c <holdingsleep>
    800027b6:	cd09                	beqz	a0,800027d0 <iunlock+0x34>
    800027b8:	449c                	lw	a5,8(s1)
    800027ba:	00f05b63          	blez	a5,800027d0 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027be:	854a                	mv	a0,s2
    800027c0:	295000ef          	jal	80003254 <releasesleep>
}
    800027c4:	60e2                	ld	ra,24(sp)
    800027c6:	6442                	ld	s0,16(sp)
    800027c8:	64a2                	ld	s1,8(sp)
    800027ca:	6902                	ld	s2,0(sp)
    800027cc:	6105                	addi	sp,sp,32
    800027ce:	8082                	ret
    panic("iunlock");
    800027d0:	00005517          	auipc	a0,0x5
    800027d4:	d9050513          	addi	a0,a0,-624 # 80007560 <etext+0x560>
    800027d8:	4cb020ef          	jal	800054a2 <panic>

00000000800027dc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027dc:	7179                	addi	sp,sp,-48
    800027de:	f406                	sd	ra,40(sp)
    800027e0:	f022                	sd	s0,32(sp)
    800027e2:	ec26                	sd	s1,24(sp)
    800027e4:	e84a                	sd	s2,16(sp)
    800027e6:	e44e                	sd	s3,8(sp)
    800027e8:	1800                	addi	s0,sp,48
    800027ea:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027ec:	05050493          	addi	s1,a0,80
    800027f0:	08050913          	addi	s2,a0,128
    800027f4:	a021                	j	800027fc <itrunc+0x20>
    800027f6:	0491                	addi	s1,s1,4
    800027f8:	01248b63          	beq	s1,s2,8000280e <itrunc+0x32>
    if(ip->addrs[i]){
    800027fc:	408c                	lw	a1,0(s1)
    800027fe:	dde5                	beqz	a1,800027f6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002800:	0009a503          	lw	a0,0(s3)
    80002804:	9abff0ef          	jal	800021ae <bfree>
      ip->addrs[i] = 0;
    80002808:	0004a023          	sw	zero,0(s1)
    8000280c:	b7ed                	j	800027f6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000280e:	0809a583          	lw	a1,128(s3)
    80002812:	ed89                	bnez	a1,8000282c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002814:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002818:	854e                	mv	a0,s3
    8000281a:	e21ff0ef          	jal	8000263a <iupdate>
}
    8000281e:	70a2                	ld	ra,40(sp)
    80002820:	7402                	ld	s0,32(sp)
    80002822:	64e2                	ld	s1,24(sp)
    80002824:	6942                	ld	s2,16(sp)
    80002826:	69a2                	ld	s3,8(sp)
    80002828:	6145                	addi	sp,sp,48
    8000282a:	8082                	ret
    8000282c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000282e:	0009a503          	lw	a0,0(s3)
    80002832:	f84ff0ef          	jal	80001fb6 <bread>
    80002836:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002838:	05850493          	addi	s1,a0,88
    8000283c:	45850913          	addi	s2,a0,1112
    80002840:	a021                	j	80002848 <itrunc+0x6c>
    80002842:	0491                	addi	s1,s1,4
    80002844:	01248963          	beq	s1,s2,80002856 <itrunc+0x7a>
      if(a[j])
    80002848:	408c                	lw	a1,0(s1)
    8000284a:	dde5                	beqz	a1,80002842 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000284c:	0009a503          	lw	a0,0(s3)
    80002850:	95fff0ef          	jal	800021ae <bfree>
    80002854:	b7fd                	j	80002842 <itrunc+0x66>
    brelse(bp);
    80002856:	8552                	mv	a0,s4
    80002858:	867ff0ef          	jal	800020be <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000285c:	0809a583          	lw	a1,128(s3)
    80002860:	0009a503          	lw	a0,0(s3)
    80002864:	94bff0ef          	jal	800021ae <bfree>
    ip->addrs[NDIRECT] = 0;
    80002868:	0809a023          	sw	zero,128(s3)
    8000286c:	6a02                	ld	s4,0(sp)
    8000286e:	b75d                	j	80002814 <itrunc+0x38>

0000000080002870 <iput>:
{
    80002870:	1101                	addi	sp,sp,-32
    80002872:	ec06                	sd	ra,24(sp)
    80002874:	e822                	sd	s0,16(sp)
    80002876:	e426                	sd	s1,8(sp)
    80002878:	1000                	addi	s0,sp,32
    8000287a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000287c:	00016517          	auipc	a0,0x16
    80002880:	0bc50513          	addi	a0,a0,188 # 80018938 <itable>
    80002884:	74d020ef          	jal	800057d0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002888:	4498                	lw	a4,8(s1)
    8000288a:	4785                	li	a5,1
    8000288c:	02f70063          	beq	a4,a5,800028ac <iput+0x3c>
  ip->ref--;
    80002890:	449c                	lw	a5,8(s1)
    80002892:	37fd                	addiw	a5,a5,-1
    80002894:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002896:	00016517          	auipc	a0,0x16
    8000289a:	0a250513          	addi	a0,a0,162 # 80018938 <itable>
    8000289e:	7cb020ef          	jal	80005868 <release>
}
    800028a2:	60e2                	ld	ra,24(sp)
    800028a4:	6442                	ld	s0,16(sp)
    800028a6:	64a2                	ld	s1,8(sp)
    800028a8:	6105                	addi	sp,sp,32
    800028aa:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028ac:	40bc                	lw	a5,64(s1)
    800028ae:	d3ed                	beqz	a5,80002890 <iput+0x20>
    800028b0:	04a49783          	lh	a5,74(s1)
    800028b4:	fff1                	bnez	a5,80002890 <iput+0x20>
    800028b6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028b8:	01048913          	addi	s2,s1,16
    800028bc:	854a                	mv	a0,s2
    800028be:	151000ef          	jal	8000320e <acquiresleep>
    release(&itable.lock);
    800028c2:	00016517          	auipc	a0,0x16
    800028c6:	07650513          	addi	a0,a0,118 # 80018938 <itable>
    800028ca:	79f020ef          	jal	80005868 <release>
    itrunc(ip);
    800028ce:	8526                	mv	a0,s1
    800028d0:	f0dff0ef          	jal	800027dc <itrunc>
    ip->type = 0;
    800028d4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028d8:	8526                	mv	a0,s1
    800028da:	d61ff0ef          	jal	8000263a <iupdate>
    ip->valid = 0;
    800028de:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028e2:	854a                	mv	a0,s2
    800028e4:	171000ef          	jal	80003254 <releasesleep>
    acquire(&itable.lock);
    800028e8:	00016517          	auipc	a0,0x16
    800028ec:	05050513          	addi	a0,a0,80 # 80018938 <itable>
    800028f0:	6e1020ef          	jal	800057d0 <acquire>
    800028f4:	6902                	ld	s2,0(sp)
    800028f6:	bf69                	j	80002890 <iput+0x20>

00000000800028f8 <iunlockput>:
{
    800028f8:	1101                	addi	sp,sp,-32
    800028fa:	ec06                	sd	ra,24(sp)
    800028fc:	e822                	sd	s0,16(sp)
    800028fe:	e426                	sd	s1,8(sp)
    80002900:	1000                	addi	s0,sp,32
    80002902:	84aa                	mv	s1,a0
  iunlock(ip);
    80002904:	e99ff0ef          	jal	8000279c <iunlock>
  iput(ip);
    80002908:	8526                	mv	a0,s1
    8000290a:	f67ff0ef          	jal	80002870 <iput>
}
    8000290e:	60e2                	ld	ra,24(sp)
    80002910:	6442                	ld	s0,16(sp)
    80002912:	64a2                	ld	s1,8(sp)
    80002914:	6105                	addi	sp,sp,32
    80002916:	8082                	ret

0000000080002918 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002918:	1141                	addi	sp,sp,-16
    8000291a:	e422                	sd	s0,8(sp)
    8000291c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000291e:	411c                	lw	a5,0(a0)
    80002920:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002922:	415c                	lw	a5,4(a0)
    80002924:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002926:	04451783          	lh	a5,68(a0)
    8000292a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000292e:	04a51783          	lh	a5,74(a0)
    80002932:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002936:	04c56783          	lwu	a5,76(a0)
    8000293a:	e99c                	sd	a5,16(a1)
}
    8000293c:	6422                	ld	s0,8(sp)
    8000293e:	0141                	addi	sp,sp,16
    80002940:	8082                	ret

0000000080002942 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002942:	457c                	lw	a5,76(a0)
    80002944:	0ed7eb63          	bltu	a5,a3,80002a3a <readi+0xf8>
{
    80002948:	7159                	addi	sp,sp,-112
    8000294a:	f486                	sd	ra,104(sp)
    8000294c:	f0a2                	sd	s0,96(sp)
    8000294e:	eca6                	sd	s1,88(sp)
    80002950:	e0d2                	sd	s4,64(sp)
    80002952:	fc56                	sd	s5,56(sp)
    80002954:	f85a                	sd	s6,48(sp)
    80002956:	f45e                	sd	s7,40(sp)
    80002958:	1880                	addi	s0,sp,112
    8000295a:	8b2a                	mv	s6,a0
    8000295c:	8bae                	mv	s7,a1
    8000295e:	8a32                	mv	s4,a2
    80002960:	84b6                	mv	s1,a3
    80002962:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002964:	9f35                	addw	a4,a4,a3
    return 0;
    80002966:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002968:	0cd76063          	bltu	a4,a3,80002a28 <readi+0xe6>
    8000296c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000296e:	00e7f463          	bgeu	a5,a4,80002976 <readi+0x34>
    n = ip->size - off;
    80002972:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002976:	080a8f63          	beqz	s5,80002a14 <readi+0xd2>
    8000297a:	e8ca                	sd	s2,80(sp)
    8000297c:	f062                	sd	s8,32(sp)
    8000297e:	ec66                	sd	s9,24(sp)
    80002980:	e86a                	sd	s10,16(sp)
    80002982:	e46e                	sd	s11,8(sp)
    80002984:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002986:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000298a:	5c7d                	li	s8,-1
    8000298c:	a80d                	j	800029be <readi+0x7c>
    8000298e:	020d1d93          	slli	s11,s10,0x20
    80002992:	020ddd93          	srli	s11,s11,0x20
    80002996:	05890613          	addi	a2,s2,88
    8000299a:	86ee                	mv	a3,s11
    8000299c:	963a                	add	a2,a2,a4
    8000299e:	85d2                	mv	a1,s4
    800029a0:	855e                	mv	a0,s7
    800029a2:	d21fe0ef          	jal	800016c2 <either_copyout>
    800029a6:	05850763          	beq	a0,s8,800029f4 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029aa:	854a                	mv	a0,s2
    800029ac:	f12ff0ef          	jal	800020be <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029b0:	013d09bb          	addw	s3,s10,s3
    800029b4:	009d04bb          	addw	s1,s10,s1
    800029b8:	9a6e                	add	s4,s4,s11
    800029ba:	0559f763          	bgeu	s3,s5,80002a08 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800029be:	00a4d59b          	srliw	a1,s1,0xa
    800029c2:	855a                	mv	a0,s6
    800029c4:	977ff0ef          	jal	8000233a <bmap>
    800029c8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800029cc:	c5b1                	beqz	a1,80002a18 <readi+0xd6>
    bp = bread(ip->dev, addr);
    800029ce:	000b2503          	lw	a0,0(s6)
    800029d2:	de4ff0ef          	jal	80001fb6 <bread>
    800029d6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800029d8:	3ff4f713          	andi	a4,s1,1023
    800029dc:	40ec87bb          	subw	a5,s9,a4
    800029e0:	413a86bb          	subw	a3,s5,s3
    800029e4:	8d3e                	mv	s10,a5
    800029e6:	2781                	sext.w	a5,a5
    800029e8:	0006861b          	sext.w	a2,a3
    800029ec:	faf671e3          	bgeu	a2,a5,8000298e <readi+0x4c>
    800029f0:	8d36                	mv	s10,a3
    800029f2:	bf71                	j	8000298e <readi+0x4c>
      brelse(bp);
    800029f4:	854a                	mv	a0,s2
    800029f6:	ec8ff0ef          	jal	800020be <brelse>
      tot = -1;
    800029fa:	59fd                	li	s3,-1
      break;
    800029fc:	6946                	ld	s2,80(sp)
    800029fe:	7c02                	ld	s8,32(sp)
    80002a00:	6ce2                	ld	s9,24(sp)
    80002a02:	6d42                	ld	s10,16(sp)
    80002a04:	6da2                	ld	s11,8(sp)
    80002a06:	a831                	j	80002a22 <readi+0xe0>
    80002a08:	6946                	ld	s2,80(sp)
    80002a0a:	7c02                	ld	s8,32(sp)
    80002a0c:	6ce2                	ld	s9,24(sp)
    80002a0e:	6d42                	ld	s10,16(sp)
    80002a10:	6da2                	ld	s11,8(sp)
    80002a12:	a801                	j	80002a22 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a14:	89d6                	mv	s3,s5
    80002a16:	a031                	j	80002a22 <readi+0xe0>
    80002a18:	6946                	ld	s2,80(sp)
    80002a1a:	7c02                	ld	s8,32(sp)
    80002a1c:	6ce2                	ld	s9,24(sp)
    80002a1e:	6d42                	ld	s10,16(sp)
    80002a20:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a22:	0009851b          	sext.w	a0,s3
    80002a26:	69a6                	ld	s3,72(sp)
}
    80002a28:	70a6                	ld	ra,104(sp)
    80002a2a:	7406                	ld	s0,96(sp)
    80002a2c:	64e6                	ld	s1,88(sp)
    80002a2e:	6a06                	ld	s4,64(sp)
    80002a30:	7ae2                	ld	s5,56(sp)
    80002a32:	7b42                	ld	s6,48(sp)
    80002a34:	7ba2                	ld	s7,40(sp)
    80002a36:	6165                	addi	sp,sp,112
    80002a38:	8082                	ret
    return 0;
    80002a3a:	4501                	li	a0,0
}
    80002a3c:	8082                	ret

0000000080002a3e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a3e:	457c                	lw	a5,76(a0)
    80002a40:	10d7e063          	bltu	a5,a3,80002b40 <writei+0x102>
{
    80002a44:	7159                	addi	sp,sp,-112
    80002a46:	f486                	sd	ra,104(sp)
    80002a48:	f0a2                	sd	s0,96(sp)
    80002a4a:	e8ca                	sd	s2,80(sp)
    80002a4c:	e0d2                	sd	s4,64(sp)
    80002a4e:	fc56                	sd	s5,56(sp)
    80002a50:	f85a                	sd	s6,48(sp)
    80002a52:	f45e                	sd	s7,40(sp)
    80002a54:	1880                	addi	s0,sp,112
    80002a56:	8aaa                	mv	s5,a0
    80002a58:	8bae                	mv	s7,a1
    80002a5a:	8a32                	mv	s4,a2
    80002a5c:	8936                	mv	s2,a3
    80002a5e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002a60:	00e687bb          	addw	a5,a3,a4
    80002a64:	0ed7e063          	bltu	a5,a3,80002b44 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002a68:	00043737          	lui	a4,0x43
    80002a6c:	0cf76e63          	bltu	a4,a5,80002b48 <writei+0x10a>
    80002a70:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a72:	0a0b0f63          	beqz	s6,80002b30 <writei+0xf2>
    80002a76:	eca6                	sd	s1,88(sp)
    80002a78:	f062                	sd	s8,32(sp)
    80002a7a:	ec66                	sd	s9,24(sp)
    80002a7c:	e86a                	sd	s10,16(sp)
    80002a7e:	e46e                	sd	s11,8(sp)
    80002a80:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a82:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002a86:	5c7d                	li	s8,-1
    80002a88:	a825                	j	80002ac0 <writei+0x82>
    80002a8a:	020d1d93          	slli	s11,s10,0x20
    80002a8e:	020ddd93          	srli	s11,s11,0x20
    80002a92:	05848513          	addi	a0,s1,88
    80002a96:	86ee                	mv	a3,s11
    80002a98:	8652                	mv	a2,s4
    80002a9a:	85de                	mv	a1,s7
    80002a9c:	953a                	add	a0,a0,a4
    80002a9e:	c6ffe0ef          	jal	8000170c <either_copyin>
    80002aa2:	05850a63          	beq	a0,s8,80002af6 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	660000ef          	jal	80003108 <log_write>
    brelse(bp);
    80002aac:	8526                	mv	a0,s1
    80002aae:	e10ff0ef          	jal	800020be <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ab2:	013d09bb          	addw	s3,s10,s3
    80002ab6:	012d093b          	addw	s2,s10,s2
    80002aba:	9a6e                	add	s4,s4,s11
    80002abc:	0569f063          	bgeu	s3,s6,80002afc <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ac0:	00a9559b          	srliw	a1,s2,0xa
    80002ac4:	8556                	mv	a0,s5
    80002ac6:	875ff0ef          	jal	8000233a <bmap>
    80002aca:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ace:	c59d                	beqz	a1,80002afc <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002ad0:	000aa503          	lw	a0,0(s5)
    80002ad4:	ce2ff0ef          	jal	80001fb6 <bread>
    80002ad8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ada:	3ff97713          	andi	a4,s2,1023
    80002ade:	40ec87bb          	subw	a5,s9,a4
    80002ae2:	413b06bb          	subw	a3,s6,s3
    80002ae6:	8d3e                	mv	s10,a5
    80002ae8:	2781                	sext.w	a5,a5
    80002aea:	0006861b          	sext.w	a2,a3
    80002aee:	f8f67ee3          	bgeu	a2,a5,80002a8a <writei+0x4c>
    80002af2:	8d36                	mv	s10,a3
    80002af4:	bf59                	j	80002a8a <writei+0x4c>
      brelse(bp);
    80002af6:	8526                	mv	a0,s1
    80002af8:	dc6ff0ef          	jal	800020be <brelse>
  }

  if(off > ip->size)
    80002afc:	04caa783          	lw	a5,76(s5)
    80002b00:	0327fa63          	bgeu	a5,s2,80002b34 <writei+0xf6>
    ip->size = off;
    80002b04:	052aa623          	sw	s2,76(s5)
    80002b08:	64e6                	ld	s1,88(sp)
    80002b0a:	7c02                	ld	s8,32(sp)
    80002b0c:	6ce2                	ld	s9,24(sp)
    80002b0e:	6d42                	ld	s10,16(sp)
    80002b10:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b12:	8556                	mv	a0,s5
    80002b14:	b27ff0ef          	jal	8000263a <iupdate>

  return tot;
    80002b18:	0009851b          	sext.w	a0,s3
    80002b1c:	69a6                	ld	s3,72(sp)
}
    80002b1e:	70a6                	ld	ra,104(sp)
    80002b20:	7406                	ld	s0,96(sp)
    80002b22:	6946                	ld	s2,80(sp)
    80002b24:	6a06                	ld	s4,64(sp)
    80002b26:	7ae2                	ld	s5,56(sp)
    80002b28:	7b42                	ld	s6,48(sp)
    80002b2a:	7ba2                	ld	s7,40(sp)
    80002b2c:	6165                	addi	sp,sp,112
    80002b2e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b30:	89da                	mv	s3,s6
    80002b32:	b7c5                	j	80002b12 <writei+0xd4>
    80002b34:	64e6                	ld	s1,88(sp)
    80002b36:	7c02                	ld	s8,32(sp)
    80002b38:	6ce2                	ld	s9,24(sp)
    80002b3a:	6d42                	ld	s10,16(sp)
    80002b3c:	6da2                	ld	s11,8(sp)
    80002b3e:	bfd1                	j	80002b12 <writei+0xd4>
    return -1;
    80002b40:	557d                	li	a0,-1
}
    80002b42:	8082                	ret
    return -1;
    80002b44:	557d                	li	a0,-1
    80002b46:	bfe1                	j	80002b1e <writei+0xe0>
    return -1;
    80002b48:	557d                	li	a0,-1
    80002b4a:	bfd1                	j	80002b1e <writei+0xe0>

0000000080002b4c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b4c:	1141                	addi	sp,sp,-16
    80002b4e:	e406                	sd	ra,8(sp)
    80002b50:	e022                	sd	s0,0(sp)
    80002b52:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b54:	4639                	li	a2,14
    80002b56:	eecfd0ef          	jal	80000242 <strncmp>
}
    80002b5a:	60a2                	ld	ra,8(sp)
    80002b5c:	6402                	ld	s0,0(sp)
    80002b5e:	0141                	addi	sp,sp,16
    80002b60:	8082                	ret

0000000080002b62 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002b62:	7139                	addi	sp,sp,-64
    80002b64:	fc06                	sd	ra,56(sp)
    80002b66:	f822                	sd	s0,48(sp)
    80002b68:	f426                	sd	s1,40(sp)
    80002b6a:	f04a                	sd	s2,32(sp)
    80002b6c:	ec4e                	sd	s3,24(sp)
    80002b6e:	e852                	sd	s4,16(sp)
    80002b70:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002b72:	04451703          	lh	a4,68(a0)
    80002b76:	4785                	li	a5,1
    80002b78:	00f71a63          	bne	a4,a5,80002b8c <dirlookup+0x2a>
    80002b7c:	892a                	mv	s2,a0
    80002b7e:	89ae                	mv	s3,a1
    80002b80:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b82:	457c                	lw	a5,76(a0)
    80002b84:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002b86:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002b88:	e39d                	bnez	a5,80002bae <dirlookup+0x4c>
    80002b8a:	a095                	j	80002bee <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002b8c:	00005517          	auipc	a0,0x5
    80002b90:	9dc50513          	addi	a0,a0,-1572 # 80007568 <etext+0x568>
    80002b94:	10f020ef          	jal	800054a2 <panic>
      panic("dirlookup read");
    80002b98:	00005517          	auipc	a0,0x5
    80002b9c:	9e850513          	addi	a0,a0,-1560 # 80007580 <etext+0x580>
    80002ba0:	103020ef          	jal	800054a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ba4:	24c1                	addiw	s1,s1,16
    80002ba6:	04c92783          	lw	a5,76(s2)
    80002baa:	04f4f163          	bgeu	s1,a5,80002bec <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bae:	4741                	li	a4,16
    80002bb0:	86a6                	mv	a3,s1
    80002bb2:	fc040613          	addi	a2,s0,-64
    80002bb6:	4581                	li	a1,0
    80002bb8:	854a                	mv	a0,s2
    80002bba:	d89ff0ef          	jal	80002942 <readi>
    80002bbe:	47c1                	li	a5,16
    80002bc0:	fcf51ce3          	bne	a0,a5,80002b98 <dirlookup+0x36>
    if(de.inum == 0)
    80002bc4:	fc045783          	lhu	a5,-64(s0)
    80002bc8:	dff1                	beqz	a5,80002ba4 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002bca:	fc240593          	addi	a1,s0,-62
    80002bce:	854e                	mv	a0,s3
    80002bd0:	f7dff0ef          	jal	80002b4c <namecmp>
    80002bd4:	f961                	bnez	a0,80002ba4 <dirlookup+0x42>
      if(poff)
    80002bd6:	000a0463          	beqz	s4,80002bde <dirlookup+0x7c>
        *poff = off;
    80002bda:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002bde:	fc045583          	lhu	a1,-64(s0)
    80002be2:	00092503          	lw	a0,0(s2)
    80002be6:	829ff0ef          	jal	8000240e <iget>
    80002bea:	a011                	j	80002bee <dirlookup+0x8c>
  return 0;
    80002bec:	4501                	li	a0,0
}
    80002bee:	70e2                	ld	ra,56(sp)
    80002bf0:	7442                	ld	s0,48(sp)
    80002bf2:	74a2                	ld	s1,40(sp)
    80002bf4:	7902                	ld	s2,32(sp)
    80002bf6:	69e2                	ld	s3,24(sp)
    80002bf8:	6a42                	ld	s4,16(sp)
    80002bfa:	6121                	addi	sp,sp,64
    80002bfc:	8082                	ret

0000000080002bfe <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002bfe:	711d                	addi	sp,sp,-96
    80002c00:	ec86                	sd	ra,88(sp)
    80002c02:	e8a2                	sd	s0,80(sp)
    80002c04:	e4a6                	sd	s1,72(sp)
    80002c06:	e0ca                	sd	s2,64(sp)
    80002c08:	fc4e                	sd	s3,56(sp)
    80002c0a:	f852                	sd	s4,48(sp)
    80002c0c:	f456                	sd	s5,40(sp)
    80002c0e:	f05a                	sd	s6,32(sp)
    80002c10:	ec5e                	sd	s7,24(sp)
    80002c12:	e862                	sd	s8,16(sp)
    80002c14:	e466                	sd	s9,8(sp)
    80002c16:	1080                	addi	s0,sp,96
    80002c18:	84aa                	mv	s1,a0
    80002c1a:	8b2e                	mv	s6,a1
    80002c1c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c1e:	00054703          	lbu	a4,0(a0)
    80002c22:	02f00793          	li	a5,47
    80002c26:	00f70e63          	beq	a4,a5,80002c42 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c2a:	96efe0ef          	jal	80000d98 <myproc>
    80002c2e:	15053503          	ld	a0,336(a0)
    80002c32:	a87ff0ef          	jal	800026b8 <idup>
    80002c36:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c38:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c3c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c3e:	4b85                	li	s7,1
    80002c40:	a871                	j	80002cdc <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002c42:	4585                	li	a1,1
    80002c44:	4505                	li	a0,1
    80002c46:	fc8ff0ef          	jal	8000240e <iget>
    80002c4a:	8a2a                	mv	s4,a0
    80002c4c:	b7f5                	j	80002c38 <namex+0x3a>
      iunlockput(ip);
    80002c4e:	8552                	mv	a0,s4
    80002c50:	ca9ff0ef          	jal	800028f8 <iunlockput>
      return 0;
    80002c54:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002c56:	8552                	mv	a0,s4
    80002c58:	60e6                	ld	ra,88(sp)
    80002c5a:	6446                	ld	s0,80(sp)
    80002c5c:	64a6                	ld	s1,72(sp)
    80002c5e:	6906                	ld	s2,64(sp)
    80002c60:	79e2                	ld	s3,56(sp)
    80002c62:	7a42                	ld	s4,48(sp)
    80002c64:	7aa2                	ld	s5,40(sp)
    80002c66:	7b02                	ld	s6,32(sp)
    80002c68:	6be2                	ld	s7,24(sp)
    80002c6a:	6c42                	ld	s8,16(sp)
    80002c6c:	6ca2                	ld	s9,8(sp)
    80002c6e:	6125                	addi	sp,sp,96
    80002c70:	8082                	ret
      iunlock(ip);
    80002c72:	8552                	mv	a0,s4
    80002c74:	b29ff0ef          	jal	8000279c <iunlock>
      return ip;
    80002c78:	bff9                	j	80002c56 <namex+0x58>
      iunlockput(ip);
    80002c7a:	8552                	mv	a0,s4
    80002c7c:	c7dff0ef          	jal	800028f8 <iunlockput>
      return 0;
    80002c80:	8a4e                	mv	s4,s3
    80002c82:	bfd1                	j	80002c56 <namex+0x58>
  len = path - s;
    80002c84:	40998633          	sub	a2,s3,s1
    80002c88:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002c8c:	099c5063          	bge	s8,s9,80002d0c <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002c90:	4639                	li	a2,14
    80002c92:	85a6                	mv	a1,s1
    80002c94:	8556                	mv	a0,s5
    80002c96:	d3cfd0ef          	jal	800001d2 <memmove>
    80002c9a:	84ce                	mv	s1,s3
  while(*path == '/')
    80002c9c:	0004c783          	lbu	a5,0(s1)
    80002ca0:	01279763          	bne	a5,s2,80002cae <namex+0xb0>
    path++;
    80002ca4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ca6:	0004c783          	lbu	a5,0(s1)
    80002caa:	ff278de3          	beq	a5,s2,80002ca4 <namex+0xa6>
    ilock(ip);
    80002cae:	8552                	mv	a0,s4
    80002cb0:	a3fff0ef          	jal	800026ee <ilock>
    if(ip->type != T_DIR){
    80002cb4:	044a1783          	lh	a5,68(s4)
    80002cb8:	f9779be3          	bne	a5,s7,80002c4e <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002cbc:	000b0563          	beqz	s6,80002cc6 <namex+0xc8>
    80002cc0:	0004c783          	lbu	a5,0(s1)
    80002cc4:	d7dd                	beqz	a5,80002c72 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002cc6:	4601                	li	a2,0
    80002cc8:	85d6                	mv	a1,s5
    80002cca:	8552                	mv	a0,s4
    80002ccc:	e97ff0ef          	jal	80002b62 <dirlookup>
    80002cd0:	89aa                	mv	s3,a0
    80002cd2:	d545                	beqz	a0,80002c7a <namex+0x7c>
    iunlockput(ip);
    80002cd4:	8552                	mv	a0,s4
    80002cd6:	c23ff0ef          	jal	800028f8 <iunlockput>
    ip = next;
    80002cda:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002cdc:	0004c783          	lbu	a5,0(s1)
    80002ce0:	01279763          	bne	a5,s2,80002cee <namex+0xf0>
    path++;
    80002ce4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ce6:	0004c783          	lbu	a5,0(s1)
    80002cea:	ff278de3          	beq	a5,s2,80002ce4 <namex+0xe6>
  if(*path == 0)
    80002cee:	cb8d                	beqz	a5,80002d20 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002cf0:	0004c783          	lbu	a5,0(s1)
    80002cf4:	89a6                	mv	s3,s1
  len = path - s;
    80002cf6:	4c81                	li	s9,0
    80002cf8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002cfa:	01278963          	beq	a5,s2,80002d0c <namex+0x10e>
    80002cfe:	d3d9                	beqz	a5,80002c84 <namex+0x86>
    path++;
    80002d00:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d02:	0009c783          	lbu	a5,0(s3)
    80002d06:	ff279ce3          	bne	a5,s2,80002cfe <namex+0x100>
    80002d0a:	bfad                	j	80002c84 <namex+0x86>
    memmove(name, s, len);
    80002d0c:	2601                	sext.w	a2,a2
    80002d0e:	85a6                	mv	a1,s1
    80002d10:	8556                	mv	a0,s5
    80002d12:	cc0fd0ef          	jal	800001d2 <memmove>
    name[len] = 0;
    80002d16:	9cd6                	add	s9,s9,s5
    80002d18:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d1c:	84ce                	mv	s1,s3
    80002d1e:	bfbd                	j	80002c9c <namex+0x9e>
  if(nameiparent){
    80002d20:	f20b0be3          	beqz	s6,80002c56 <namex+0x58>
    iput(ip);
    80002d24:	8552                	mv	a0,s4
    80002d26:	b4bff0ef          	jal	80002870 <iput>
    return 0;
    80002d2a:	4a01                	li	s4,0
    80002d2c:	b72d                	j	80002c56 <namex+0x58>

0000000080002d2e <dirlink>:
{
    80002d2e:	7139                	addi	sp,sp,-64
    80002d30:	fc06                	sd	ra,56(sp)
    80002d32:	f822                	sd	s0,48(sp)
    80002d34:	f04a                	sd	s2,32(sp)
    80002d36:	ec4e                	sd	s3,24(sp)
    80002d38:	e852                	sd	s4,16(sp)
    80002d3a:	0080                	addi	s0,sp,64
    80002d3c:	892a                	mv	s2,a0
    80002d3e:	8a2e                	mv	s4,a1
    80002d40:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d42:	4601                	li	a2,0
    80002d44:	e1fff0ef          	jal	80002b62 <dirlookup>
    80002d48:	e535                	bnez	a0,80002db4 <dirlink+0x86>
    80002d4a:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d4c:	04c92483          	lw	s1,76(s2)
    80002d50:	c48d                	beqz	s1,80002d7a <dirlink+0x4c>
    80002d52:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d54:	4741                	li	a4,16
    80002d56:	86a6                	mv	a3,s1
    80002d58:	fc040613          	addi	a2,s0,-64
    80002d5c:	4581                	li	a1,0
    80002d5e:	854a                	mv	a0,s2
    80002d60:	be3ff0ef          	jal	80002942 <readi>
    80002d64:	47c1                	li	a5,16
    80002d66:	04f51b63          	bne	a0,a5,80002dbc <dirlink+0x8e>
    if(de.inum == 0)
    80002d6a:	fc045783          	lhu	a5,-64(s0)
    80002d6e:	c791                	beqz	a5,80002d7a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d70:	24c1                	addiw	s1,s1,16
    80002d72:	04c92783          	lw	a5,76(s2)
    80002d76:	fcf4efe3          	bltu	s1,a5,80002d54 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002d7a:	4639                	li	a2,14
    80002d7c:	85d2                	mv	a1,s4
    80002d7e:	fc240513          	addi	a0,s0,-62
    80002d82:	cf6fd0ef          	jal	80000278 <strncpy>
  de.inum = inum;
    80002d86:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d8a:	4741                	li	a4,16
    80002d8c:	86a6                	mv	a3,s1
    80002d8e:	fc040613          	addi	a2,s0,-64
    80002d92:	4581                	li	a1,0
    80002d94:	854a                	mv	a0,s2
    80002d96:	ca9ff0ef          	jal	80002a3e <writei>
    80002d9a:	1541                	addi	a0,a0,-16
    80002d9c:	00a03533          	snez	a0,a0
    80002da0:	40a00533          	neg	a0,a0
    80002da4:	74a2                	ld	s1,40(sp)
}
    80002da6:	70e2                	ld	ra,56(sp)
    80002da8:	7442                	ld	s0,48(sp)
    80002daa:	7902                	ld	s2,32(sp)
    80002dac:	69e2                	ld	s3,24(sp)
    80002dae:	6a42                	ld	s4,16(sp)
    80002db0:	6121                	addi	sp,sp,64
    80002db2:	8082                	ret
    iput(ip);
    80002db4:	abdff0ef          	jal	80002870 <iput>
    return -1;
    80002db8:	557d                	li	a0,-1
    80002dba:	b7f5                	j	80002da6 <dirlink+0x78>
      panic("dirlink read");
    80002dbc:	00004517          	auipc	a0,0x4
    80002dc0:	7d450513          	addi	a0,a0,2004 # 80007590 <etext+0x590>
    80002dc4:	6de020ef          	jal	800054a2 <panic>

0000000080002dc8 <namei>:

struct inode*
namei(char *path)
{
    80002dc8:	1101                	addi	sp,sp,-32
    80002dca:	ec06                	sd	ra,24(sp)
    80002dcc:	e822                	sd	s0,16(sp)
    80002dce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002dd0:	fe040613          	addi	a2,s0,-32
    80002dd4:	4581                	li	a1,0
    80002dd6:	e29ff0ef          	jal	80002bfe <namex>
}
    80002dda:	60e2                	ld	ra,24(sp)
    80002ddc:	6442                	ld	s0,16(sp)
    80002dde:	6105                	addi	sp,sp,32
    80002de0:	8082                	ret

0000000080002de2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002de2:	1141                	addi	sp,sp,-16
    80002de4:	e406                	sd	ra,8(sp)
    80002de6:	e022                	sd	s0,0(sp)
    80002de8:	0800                	addi	s0,sp,16
    80002dea:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002dec:	4585                	li	a1,1
    80002dee:	e11ff0ef          	jal	80002bfe <namex>
}
    80002df2:	60a2                	ld	ra,8(sp)
    80002df4:	6402                	ld	s0,0(sp)
    80002df6:	0141                	addi	sp,sp,16
    80002df8:	8082                	ret

0000000080002dfa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002dfa:	1101                	addi	sp,sp,-32
    80002dfc:	ec06                	sd	ra,24(sp)
    80002dfe:	e822                	sd	s0,16(sp)
    80002e00:	e426                	sd	s1,8(sp)
    80002e02:	e04a                	sd	s2,0(sp)
    80002e04:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e06:	00017917          	auipc	s2,0x17
    80002e0a:	5da90913          	addi	s2,s2,1498 # 8001a3e0 <log>
    80002e0e:	01892583          	lw	a1,24(s2)
    80002e12:	02892503          	lw	a0,40(s2)
    80002e16:	9a0ff0ef          	jal	80001fb6 <bread>
    80002e1a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e1c:	02c92603          	lw	a2,44(s2)
    80002e20:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e22:	00c05f63          	blez	a2,80002e40 <write_head+0x46>
    80002e26:	00017717          	auipc	a4,0x17
    80002e2a:	5ea70713          	addi	a4,a4,1514 # 8001a410 <log+0x30>
    80002e2e:	87aa                	mv	a5,a0
    80002e30:	060a                	slli	a2,a2,0x2
    80002e32:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e34:	4314                	lw	a3,0(a4)
    80002e36:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e38:	0711                	addi	a4,a4,4
    80002e3a:	0791                	addi	a5,a5,4
    80002e3c:	fec79ce3          	bne	a5,a2,80002e34 <write_head+0x3a>
  }
  bwrite(buf);
    80002e40:	8526                	mv	a0,s1
    80002e42:	a4aff0ef          	jal	8000208c <bwrite>
  brelse(buf);
    80002e46:	8526                	mv	a0,s1
    80002e48:	a76ff0ef          	jal	800020be <brelse>
}
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	64a2                	ld	s1,8(sp)
    80002e52:	6902                	ld	s2,0(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret

0000000080002e58 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e58:	00017797          	auipc	a5,0x17
    80002e5c:	5b47a783          	lw	a5,1460(a5) # 8001a40c <log+0x2c>
    80002e60:	08f05f63          	blez	a5,80002efe <install_trans+0xa6>
{
    80002e64:	7139                	addi	sp,sp,-64
    80002e66:	fc06                	sd	ra,56(sp)
    80002e68:	f822                	sd	s0,48(sp)
    80002e6a:	f426                	sd	s1,40(sp)
    80002e6c:	f04a                	sd	s2,32(sp)
    80002e6e:	ec4e                	sd	s3,24(sp)
    80002e70:	e852                	sd	s4,16(sp)
    80002e72:	e456                	sd	s5,8(sp)
    80002e74:	e05a                	sd	s6,0(sp)
    80002e76:	0080                	addi	s0,sp,64
    80002e78:	8b2a                	mv	s6,a0
    80002e7a:	00017a97          	auipc	s5,0x17
    80002e7e:	596a8a93          	addi	s5,s5,1430 # 8001a410 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e82:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002e84:	00017997          	auipc	s3,0x17
    80002e88:	55c98993          	addi	s3,s3,1372 # 8001a3e0 <log>
    80002e8c:	a829                	j	80002ea6 <install_trans+0x4e>
    brelse(lbuf);
    80002e8e:	854a                	mv	a0,s2
    80002e90:	a2eff0ef          	jal	800020be <brelse>
    brelse(dbuf);
    80002e94:	8526                	mv	a0,s1
    80002e96:	a28ff0ef          	jal	800020be <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002e9a:	2a05                	addiw	s4,s4,1
    80002e9c:	0a91                	addi	s5,s5,4
    80002e9e:	02c9a783          	lw	a5,44(s3)
    80002ea2:	04fa5463          	bge	s4,a5,80002eea <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ea6:	0189a583          	lw	a1,24(s3)
    80002eaa:	014585bb          	addw	a1,a1,s4
    80002eae:	2585                	addiw	a1,a1,1
    80002eb0:	0289a503          	lw	a0,40(s3)
    80002eb4:	902ff0ef          	jal	80001fb6 <bread>
    80002eb8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002eba:	000aa583          	lw	a1,0(s5)
    80002ebe:	0289a503          	lw	a0,40(s3)
    80002ec2:	8f4ff0ef          	jal	80001fb6 <bread>
    80002ec6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002ec8:	40000613          	li	a2,1024
    80002ecc:	05890593          	addi	a1,s2,88
    80002ed0:	05850513          	addi	a0,a0,88
    80002ed4:	afefd0ef          	jal	800001d2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002ed8:	8526                	mv	a0,s1
    80002eda:	9b2ff0ef          	jal	8000208c <bwrite>
    if(recovering == 0)
    80002ede:	fa0b18e3          	bnez	s6,80002e8e <install_trans+0x36>
      bunpin(dbuf);
    80002ee2:	8526                	mv	a0,s1
    80002ee4:	a96ff0ef          	jal	8000217a <bunpin>
    80002ee8:	b75d                	j	80002e8e <install_trans+0x36>
}
    80002eea:	70e2                	ld	ra,56(sp)
    80002eec:	7442                	ld	s0,48(sp)
    80002eee:	74a2                	ld	s1,40(sp)
    80002ef0:	7902                	ld	s2,32(sp)
    80002ef2:	69e2                	ld	s3,24(sp)
    80002ef4:	6a42                	ld	s4,16(sp)
    80002ef6:	6aa2                	ld	s5,8(sp)
    80002ef8:	6b02                	ld	s6,0(sp)
    80002efa:	6121                	addi	sp,sp,64
    80002efc:	8082                	ret
    80002efe:	8082                	ret

0000000080002f00 <initlog>:
{
    80002f00:	7179                	addi	sp,sp,-48
    80002f02:	f406                	sd	ra,40(sp)
    80002f04:	f022                	sd	s0,32(sp)
    80002f06:	ec26                	sd	s1,24(sp)
    80002f08:	e84a                	sd	s2,16(sp)
    80002f0a:	e44e                	sd	s3,8(sp)
    80002f0c:	1800                	addi	s0,sp,48
    80002f0e:	892a                	mv	s2,a0
    80002f10:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f12:	00017497          	auipc	s1,0x17
    80002f16:	4ce48493          	addi	s1,s1,1230 # 8001a3e0 <log>
    80002f1a:	00004597          	auipc	a1,0x4
    80002f1e:	68658593          	addi	a1,a1,1670 # 800075a0 <etext+0x5a0>
    80002f22:	8526                	mv	a0,s1
    80002f24:	02d020ef          	jal	80005750 <initlock>
  log.start = sb->logstart;
    80002f28:	0149a583          	lw	a1,20(s3)
    80002f2c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f2e:	0109a783          	lw	a5,16(s3)
    80002f32:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002f34:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	87cff0ef          	jal	80001fb6 <bread>
  log.lh.n = lh->n;
    80002f3e:	4d30                	lw	a2,88(a0)
    80002f40:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002f42:	00c05f63          	blez	a2,80002f60 <initlog+0x60>
    80002f46:	87aa                	mv	a5,a0
    80002f48:	00017717          	auipc	a4,0x17
    80002f4c:	4c870713          	addi	a4,a4,1224 # 8001a410 <log+0x30>
    80002f50:	060a                	slli	a2,a2,0x2
    80002f52:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002f54:	4ff4                	lw	a3,92(a5)
    80002f56:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002f58:	0791                	addi	a5,a5,4
    80002f5a:	0711                	addi	a4,a4,4
    80002f5c:	fec79ce3          	bne	a5,a2,80002f54 <initlog+0x54>
  brelse(buf);
    80002f60:	95eff0ef          	jal	800020be <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002f64:	4505                	li	a0,1
    80002f66:	ef3ff0ef          	jal	80002e58 <install_trans>
  log.lh.n = 0;
    80002f6a:	00017797          	auipc	a5,0x17
    80002f6e:	4a07a123          	sw	zero,1186(a5) # 8001a40c <log+0x2c>
  write_head(); // clear the log
    80002f72:	e89ff0ef          	jal	80002dfa <write_head>
}
    80002f76:	70a2                	ld	ra,40(sp)
    80002f78:	7402                	ld	s0,32(sp)
    80002f7a:	64e2                	ld	s1,24(sp)
    80002f7c:	6942                	ld	s2,16(sp)
    80002f7e:	69a2                	ld	s3,8(sp)
    80002f80:	6145                	addi	sp,sp,48
    80002f82:	8082                	ret

0000000080002f84 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002f84:	1101                	addi	sp,sp,-32
    80002f86:	ec06                	sd	ra,24(sp)
    80002f88:	e822                	sd	s0,16(sp)
    80002f8a:	e426                	sd	s1,8(sp)
    80002f8c:	e04a                	sd	s2,0(sp)
    80002f8e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002f90:	00017517          	auipc	a0,0x17
    80002f94:	45050513          	addi	a0,a0,1104 # 8001a3e0 <log>
    80002f98:	039020ef          	jal	800057d0 <acquire>
  while(1){
    if(log.committing){
    80002f9c:	00017497          	auipc	s1,0x17
    80002fa0:	44448493          	addi	s1,s1,1092 # 8001a3e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fa4:	4979                	li	s2,30
    80002fa6:	a029                	j	80002fb0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002fa8:	85a6                	mv	a1,s1
    80002faa:	8526                	mv	a0,s1
    80002fac:	bbafe0ef          	jal	80001366 <sleep>
    if(log.committing){
    80002fb0:	50dc                	lw	a5,36(s1)
    80002fb2:	fbfd                	bnez	a5,80002fa8 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002fb4:	5098                	lw	a4,32(s1)
    80002fb6:	2705                	addiw	a4,a4,1
    80002fb8:	0027179b          	slliw	a5,a4,0x2
    80002fbc:	9fb9                	addw	a5,a5,a4
    80002fbe:	0017979b          	slliw	a5,a5,0x1
    80002fc2:	54d4                	lw	a3,44(s1)
    80002fc4:	9fb5                	addw	a5,a5,a3
    80002fc6:	00f95763          	bge	s2,a5,80002fd4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002fca:	85a6                	mv	a1,s1
    80002fcc:	8526                	mv	a0,s1
    80002fce:	b98fe0ef          	jal	80001366 <sleep>
    80002fd2:	bff9                	j	80002fb0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002fd4:	00017517          	auipc	a0,0x17
    80002fd8:	40c50513          	addi	a0,a0,1036 # 8001a3e0 <log>
    80002fdc:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80002fde:	08b020ef          	jal	80005868 <release>
      break;
    }
  }
}
    80002fe2:	60e2                	ld	ra,24(sp)
    80002fe4:	6442                	ld	s0,16(sp)
    80002fe6:	64a2                	ld	s1,8(sp)
    80002fe8:	6902                	ld	s2,0(sp)
    80002fea:	6105                	addi	sp,sp,32
    80002fec:	8082                	ret

0000000080002fee <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002fee:	7139                	addi	sp,sp,-64
    80002ff0:	fc06                	sd	ra,56(sp)
    80002ff2:	f822                	sd	s0,48(sp)
    80002ff4:	f426                	sd	s1,40(sp)
    80002ff6:	f04a                	sd	s2,32(sp)
    80002ff8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002ffa:	00017497          	auipc	s1,0x17
    80002ffe:	3e648493          	addi	s1,s1,998 # 8001a3e0 <log>
    80003002:	8526                	mv	a0,s1
    80003004:	7cc020ef          	jal	800057d0 <acquire>
  log.outstanding -= 1;
    80003008:	509c                	lw	a5,32(s1)
    8000300a:	37fd                	addiw	a5,a5,-1
    8000300c:	0007891b          	sext.w	s2,a5
    80003010:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003012:	50dc                	lw	a5,36(s1)
    80003014:	ef9d                	bnez	a5,80003052 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003016:	04091763          	bnez	s2,80003064 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000301a:	00017497          	auipc	s1,0x17
    8000301e:	3c648493          	addi	s1,s1,966 # 8001a3e0 <log>
    80003022:	4785                	li	a5,1
    80003024:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003026:	8526                	mv	a0,s1
    80003028:	041020ef          	jal	80005868 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000302c:	54dc                	lw	a5,44(s1)
    8000302e:	04f04b63          	bgtz	a5,80003084 <end_op+0x96>
    acquire(&log.lock);
    80003032:	00017497          	auipc	s1,0x17
    80003036:	3ae48493          	addi	s1,s1,942 # 8001a3e0 <log>
    8000303a:	8526                	mv	a0,s1
    8000303c:	794020ef          	jal	800057d0 <acquire>
    log.committing = 0;
    80003040:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003044:	8526                	mv	a0,s1
    80003046:	b6cfe0ef          	jal	800013b2 <wakeup>
    release(&log.lock);
    8000304a:	8526                	mv	a0,s1
    8000304c:	01d020ef          	jal	80005868 <release>
}
    80003050:	a025                	j	80003078 <end_op+0x8a>
    80003052:	ec4e                	sd	s3,24(sp)
    80003054:	e852                	sd	s4,16(sp)
    80003056:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003058:	00004517          	auipc	a0,0x4
    8000305c:	55050513          	addi	a0,a0,1360 # 800075a8 <etext+0x5a8>
    80003060:	442020ef          	jal	800054a2 <panic>
    wakeup(&log);
    80003064:	00017497          	auipc	s1,0x17
    80003068:	37c48493          	addi	s1,s1,892 # 8001a3e0 <log>
    8000306c:	8526                	mv	a0,s1
    8000306e:	b44fe0ef          	jal	800013b2 <wakeup>
  release(&log.lock);
    80003072:	8526                	mv	a0,s1
    80003074:	7f4020ef          	jal	80005868 <release>
}
    80003078:	70e2                	ld	ra,56(sp)
    8000307a:	7442                	ld	s0,48(sp)
    8000307c:	74a2                	ld	s1,40(sp)
    8000307e:	7902                	ld	s2,32(sp)
    80003080:	6121                	addi	sp,sp,64
    80003082:	8082                	ret
    80003084:	ec4e                	sd	s3,24(sp)
    80003086:	e852                	sd	s4,16(sp)
    80003088:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000308a:	00017a97          	auipc	s5,0x17
    8000308e:	386a8a93          	addi	s5,s5,902 # 8001a410 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003092:	00017a17          	auipc	s4,0x17
    80003096:	34ea0a13          	addi	s4,s4,846 # 8001a3e0 <log>
    8000309a:	018a2583          	lw	a1,24(s4)
    8000309e:	012585bb          	addw	a1,a1,s2
    800030a2:	2585                	addiw	a1,a1,1
    800030a4:	028a2503          	lw	a0,40(s4)
    800030a8:	f0ffe0ef          	jal	80001fb6 <bread>
    800030ac:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800030ae:	000aa583          	lw	a1,0(s5)
    800030b2:	028a2503          	lw	a0,40(s4)
    800030b6:	f01fe0ef          	jal	80001fb6 <bread>
    800030ba:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800030bc:	40000613          	li	a2,1024
    800030c0:	05850593          	addi	a1,a0,88
    800030c4:	05848513          	addi	a0,s1,88
    800030c8:	90afd0ef          	jal	800001d2 <memmove>
    bwrite(to);  // write the log
    800030cc:	8526                	mv	a0,s1
    800030ce:	fbffe0ef          	jal	8000208c <bwrite>
    brelse(from);
    800030d2:	854e                	mv	a0,s3
    800030d4:	febfe0ef          	jal	800020be <brelse>
    brelse(to);
    800030d8:	8526                	mv	a0,s1
    800030da:	fe5fe0ef          	jal	800020be <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030de:	2905                	addiw	s2,s2,1
    800030e0:	0a91                	addi	s5,s5,4
    800030e2:	02ca2783          	lw	a5,44(s4)
    800030e6:	faf94ae3          	blt	s2,a5,8000309a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800030ea:	d11ff0ef          	jal	80002dfa <write_head>
    install_trans(0); // Now install writes to home locations
    800030ee:	4501                	li	a0,0
    800030f0:	d69ff0ef          	jal	80002e58 <install_trans>
    log.lh.n = 0;
    800030f4:	00017797          	auipc	a5,0x17
    800030f8:	3007ac23          	sw	zero,792(a5) # 8001a40c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800030fc:	cffff0ef          	jal	80002dfa <write_head>
    80003100:	69e2                	ld	s3,24(sp)
    80003102:	6a42                	ld	s4,16(sp)
    80003104:	6aa2                	ld	s5,8(sp)
    80003106:	b735                	j	80003032 <end_op+0x44>

0000000080003108 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003108:	1101                	addi	sp,sp,-32
    8000310a:	ec06                	sd	ra,24(sp)
    8000310c:	e822                	sd	s0,16(sp)
    8000310e:	e426                	sd	s1,8(sp)
    80003110:	e04a                	sd	s2,0(sp)
    80003112:	1000                	addi	s0,sp,32
    80003114:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003116:	00017917          	auipc	s2,0x17
    8000311a:	2ca90913          	addi	s2,s2,714 # 8001a3e0 <log>
    8000311e:	854a                	mv	a0,s2
    80003120:	6b0020ef          	jal	800057d0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003124:	02c92603          	lw	a2,44(s2)
    80003128:	47f5                	li	a5,29
    8000312a:	06c7c363          	blt	a5,a2,80003190 <log_write+0x88>
    8000312e:	00017797          	auipc	a5,0x17
    80003132:	2ce7a783          	lw	a5,718(a5) # 8001a3fc <log+0x1c>
    80003136:	37fd                	addiw	a5,a5,-1
    80003138:	04f65c63          	bge	a2,a5,80003190 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000313c:	00017797          	auipc	a5,0x17
    80003140:	2c47a783          	lw	a5,708(a5) # 8001a400 <log+0x20>
    80003144:	04f05c63          	blez	a5,8000319c <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003148:	4781                	li	a5,0
    8000314a:	04c05f63          	blez	a2,800031a8 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000314e:	44cc                	lw	a1,12(s1)
    80003150:	00017717          	auipc	a4,0x17
    80003154:	2c070713          	addi	a4,a4,704 # 8001a410 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003158:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000315a:	4314                	lw	a3,0(a4)
    8000315c:	04b68663          	beq	a3,a1,800031a8 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003160:	2785                	addiw	a5,a5,1
    80003162:	0711                	addi	a4,a4,4
    80003164:	fef61be3          	bne	a2,a5,8000315a <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003168:	0621                	addi	a2,a2,8
    8000316a:	060a                	slli	a2,a2,0x2
    8000316c:	00017797          	auipc	a5,0x17
    80003170:	27478793          	addi	a5,a5,628 # 8001a3e0 <log>
    80003174:	97b2                	add	a5,a5,a2
    80003176:	44d8                	lw	a4,12(s1)
    80003178:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000317a:	8526                	mv	a0,s1
    8000317c:	fcbfe0ef          	jal	80002146 <bpin>
    log.lh.n++;
    80003180:	00017717          	auipc	a4,0x17
    80003184:	26070713          	addi	a4,a4,608 # 8001a3e0 <log>
    80003188:	575c                	lw	a5,44(a4)
    8000318a:	2785                	addiw	a5,a5,1
    8000318c:	d75c                	sw	a5,44(a4)
    8000318e:	a80d                	j	800031c0 <log_write+0xb8>
    panic("too big a transaction");
    80003190:	00004517          	auipc	a0,0x4
    80003194:	42850513          	addi	a0,a0,1064 # 800075b8 <etext+0x5b8>
    80003198:	30a020ef          	jal	800054a2 <panic>
    panic("log_write outside of trans");
    8000319c:	00004517          	auipc	a0,0x4
    800031a0:	43450513          	addi	a0,a0,1076 # 800075d0 <etext+0x5d0>
    800031a4:	2fe020ef          	jal	800054a2 <panic>
  log.lh.block[i] = b->blockno;
    800031a8:	00878693          	addi	a3,a5,8
    800031ac:	068a                	slli	a3,a3,0x2
    800031ae:	00017717          	auipc	a4,0x17
    800031b2:	23270713          	addi	a4,a4,562 # 8001a3e0 <log>
    800031b6:	9736                	add	a4,a4,a3
    800031b8:	44d4                	lw	a3,12(s1)
    800031ba:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800031bc:	faf60fe3          	beq	a2,a5,8000317a <log_write+0x72>
  }
  release(&log.lock);
    800031c0:	00017517          	auipc	a0,0x17
    800031c4:	22050513          	addi	a0,a0,544 # 8001a3e0 <log>
    800031c8:	6a0020ef          	jal	80005868 <release>
}
    800031cc:	60e2                	ld	ra,24(sp)
    800031ce:	6442                	ld	s0,16(sp)
    800031d0:	64a2                	ld	s1,8(sp)
    800031d2:	6902                	ld	s2,0(sp)
    800031d4:	6105                	addi	sp,sp,32
    800031d6:	8082                	ret

00000000800031d8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800031d8:	1101                	addi	sp,sp,-32
    800031da:	ec06                	sd	ra,24(sp)
    800031dc:	e822                	sd	s0,16(sp)
    800031de:	e426                	sd	s1,8(sp)
    800031e0:	e04a                	sd	s2,0(sp)
    800031e2:	1000                	addi	s0,sp,32
    800031e4:	84aa                	mv	s1,a0
    800031e6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800031e8:	00004597          	auipc	a1,0x4
    800031ec:	40858593          	addi	a1,a1,1032 # 800075f0 <etext+0x5f0>
    800031f0:	0521                	addi	a0,a0,8
    800031f2:	55e020ef          	jal	80005750 <initlock>
  lk->name = name;
    800031f6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800031fa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031fe:	0204a423          	sw	zero,40(s1)
}
    80003202:	60e2                	ld	ra,24(sp)
    80003204:	6442                	ld	s0,16(sp)
    80003206:	64a2                	ld	s1,8(sp)
    80003208:	6902                	ld	s2,0(sp)
    8000320a:	6105                	addi	sp,sp,32
    8000320c:	8082                	ret

000000008000320e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000320e:	1101                	addi	sp,sp,-32
    80003210:	ec06                	sd	ra,24(sp)
    80003212:	e822                	sd	s0,16(sp)
    80003214:	e426                	sd	s1,8(sp)
    80003216:	e04a                	sd	s2,0(sp)
    80003218:	1000                	addi	s0,sp,32
    8000321a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000321c:	00850913          	addi	s2,a0,8
    80003220:	854a                	mv	a0,s2
    80003222:	5ae020ef          	jal	800057d0 <acquire>
  while (lk->locked) {
    80003226:	409c                	lw	a5,0(s1)
    80003228:	c799                	beqz	a5,80003236 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000322a:	85ca                	mv	a1,s2
    8000322c:	8526                	mv	a0,s1
    8000322e:	938fe0ef          	jal	80001366 <sleep>
  while (lk->locked) {
    80003232:	409c                	lw	a5,0(s1)
    80003234:	fbfd                	bnez	a5,8000322a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003236:	4785                	li	a5,1
    80003238:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000323a:	b5ffd0ef          	jal	80000d98 <myproc>
    8000323e:	591c                	lw	a5,48(a0)
    80003240:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003242:	854a                	mv	a0,s2
    80003244:	624020ef          	jal	80005868 <release>
}
    80003248:	60e2                	ld	ra,24(sp)
    8000324a:	6442                	ld	s0,16(sp)
    8000324c:	64a2                	ld	s1,8(sp)
    8000324e:	6902                	ld	s2,0(sp)
    80003250:	6105                	addi	sp,sp,32
    80003252:	8082                	ret

0000000080003254 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003254:	1101                	addi	sp,sp,-32
    80003256:	ec06                	sd	ra,24(sp)
    80003258:	e822                	sd	s0,16(sp)
    8000325a:	e426                	sd	s1,8(sp)
    8000325c:	e04a                	sd	s2,0(sp)
    8000325e:	1000                	addi	s0,sp,32
    80003260:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003262:	00850913          	addi	s2,a0,8
    80003266:	854a                	mv	a0,s2
    80003268:	568020ef          	jal	800057d0 <acquire>
  lk->locked = 0;
    8000326c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003270:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003274:	8526                	mv	a0,s1
    80003276:	93cfe0ef          	jal	800013b2 <wakeup>
  release(&lk->lk);
    8000327a:	854a                	mv	a0,s2
    8000327c:	5ec020ef          	jal	80005868 <release>
}
    80003280:	60e2                	ld	ra,24(sp)
    80003282:	6442                	ld	s0,16(sp)
    80003284:	64a2                	ld	s1,8(sp)
    80003286:	6902                	ld	s2,0(sp)
    80003288:	6105                	addi	sp,sp,32
    8000328a:	8082                	ret

000000008000328c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000328c:	7179                	addi	sp,sp,-48
    8000328e:	f406                	sd	ra,40(sp)
    80003290:	f022                	sd	s0,32(sp)
    80003292:	ec26                	sd	s1,24(sp)
    80003294:	e84a                	sd	s2,16(sp)
    80003296:	1800                	addi	s0,sp,48
    80003298:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000329a:	00850913          	addi	s2,a0,8
    8000329e:	854a                	mv	a0,s2
    800032a0:	530020ef          	jal	800057d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800032a4:	409c                	lw	a5,0(s1)
    800032a6:	ef81                	bnez	a5,800032be <holdingsleep+0x32>
    800032a8:	4481                	li	s1,0
  release(&lk->lk);
    800032aa:	854a                	mv	a0,s2
    800032ac:	5bc020ef          	jal	80005868 <release>
  return r;
}
    800032b0:	8526                	mv	a0,s1
    800032b2:	70a2                	ld	ra,40(sp)
    800032b4:	7402                	ld	s0,32(sp)
    800032b6:	64e2                	ld	s1,24(sp)
    800032b8:	6942                	ld	s2,16(sp)
    800032ba:	6145                	addi	sp,sp,48
    800032bc:	8082                	ret
    800032be:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800032c0:	0284a983          	lw	s3,40(s1)
    800032c4:	ad5fd0ef          	jal	80000d98 <myproc>
    800032c8:	5904                	lw	s1,48(a0)
    800032ca:	413484b3          	sub	s1,s1,s3
    800032ce:	0014b493          	seqz	s1,s1
    800032d2:	69a2                	ld	s3,8(sp)
    800032d4:	bfd9                	j	800032aa <holdingsleep+0x1e>

00000000800032d6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800032d6:	1141                	addi	sp,sp,-16
    800032d8:	e406                	sd	ra,8(sp)
    800032da:	e022                	sd	s0,0(sp)
    800032dc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800032de:	00004597          	auipc	a1,0x4
    800032e2:	32258593          	addi	a1,a1,802 # 80007600 <etext+0x600>
    800032e6:	00017517          	auipc	a0,0x17
    800032ea:	24250513          	addi	a0,a0,578 # 8001a528 <ftable>
    800032ee:	462020ef          	jal	80005750 <initlock>
}
    800032f2:	60a2                	ld	ra,8(sp)
    800032f4:	6402                	ld	s0,0(sp)
    800032f6:	0141                	addi	sp,sp,16
    800032f8:	8082                	ret

00000000800032fa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800032fa:	1101                	addi	sp,sp,-32
    800032fc:	ec06                	sd	ra,24(sp)
    800032fe:	e822                	sd	s0,16(sp)
    80003300:	e426                	sd	s1,8(sp)
    80003302:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003304:	00017517          	auipc	a0,0x17
    80003308:	22450513          	addi	a0,a0,548 # 8001a528 <ftable>
    8000330c:	4c4020ef          	jal	800057d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003310:	00017497          	auipc	s1,0x17
    80003314:	23048493          	addi	s1,s1,560 # 8001a540 <ftable+0x18>
    80003318:	00018717          	auipc	a4,0x18
    8000331c:	1c870713          	addi	a4,a4,456 # 8001b4e0 <disk>
    if(f->ref == 0){
    80003320:	40dc                	lw	a5,4(s1)
    80003322:	cf89                	beqz	a5,8000333c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003324:	02848493          	addi	s1,s1,40
    80003328:	fee49ce3          	bne	s1,a4,80003320 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000332c:	00017517          	auipc	a0,0x17
    80003330:	1fc50513          	addi	a0,a0,508 # 8001a528 <ftable>
    80003334:	534020ef          	jal	80005868 <release>
  return 0;
    80003338:	4481                	li	s1,0
    8000333a:	a809                	j	8000334c <filealloc+0x52>
      f->ref = 1;
    8000333c:	4785                	li	a5,1
    8000333e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003340:	00017517          	auipc	a0,0x17
    80003344:	1e850513          	addi	a0,a0,488 # 8001a528 <ftable>
    80003348:	520020ef          	jal	80005868 <release>
}
    8000334c:	8526                	mv	a0,s1
    8000334e:	60e2                	ld	ra,24(sp)
    80003350:	6442                	ld	s0,16(sp)
    80003352:	64a2                	ld	s1,8(sp)
    80003354:	6105                	addi	sp,sp,32
    80003356:	8082                	ret

0000000080003358 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003358:	1101                	addi	sp,sp,-32
    8000335a:	ec06                	sd	ra,24(sp)
    8000335c:	e822                	sd	s0,16(sp)
    8000335e:	e426                	sd	s1,8(sp)
    80003360:	1000                	addi	s0,sp,32
    80003362:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003364:	00017517          	auipc	a0,0x17
    80003368:	1c450513          	addi	a0,a0,452 # 8001a528 <ftable>
    8000336c:	464020ef          	jal	800057d0 <acquire>
  if(f->ref < 1)
    80003370:	40dc                	lw	a5,4(s1)
    80003372:	02f05063          	blez	a5,80003392 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003376:	2785                	addiw	a5,a5,1
    80003378:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000337a:	00017517          	auipc	a0,0x17
    8000337e:	1ae50513          	addi	a0,a0,430 # 8001a528 <ftable>
    80003382:	4e6020ef          	jal	80005868 <release>
  return f;
}
    80003386:	8526                	mv	a0,s1
    80003388:	60e2                	ld	ra,24(sp)
    8000338a:	6442                	ld	s0,16(sp)
    8000338c:	64a2                	ld	s1,8(sp)
    8000338e:	6105                	addi	sp,sp,32
    80003390:	8082                	ret
    panic("filedup");
    80003392:	00004517          	auipc	a0,0x4
    80003396:	27650513          	addi	a0,a0,630 # 80007608 <etext+0x608>
    8000339a:	108020ef          	jal	800054a2 <panic>

000000008000339e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000339e:	7139                	addi	sp,sp,-64
    800033a0:	fc06                	sd	ra,56(sp)
    800033a2:	f822                	sd	s0,48(sp)
    800033a4:	f426                	sd	s1,40(sp)
    800033a6:	0080                	addi	s0,sp,64
    800033a8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800033aa:	00017517          	auipc	a0,0x17
    800033ae:	17e50513          	addi	a0,a0,382 # 8001a528 <ftable>
    800033b2:	41e020ef          	jal	800057d0 <acquire>
  if(f->ref < 1)
    800033b6:	40dc                	lw	a5,4(s1)
    800033b8:	04f05a63          	blez	a5,8000340c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800033bc:	37fd                	addiw	a5,a5,-1
    800033be:	0007871b          	sext.w	a4,a5
    800033c2:	c0dc                	sw	a5,4(s1)
    800033c4:	04e04e63          	bgtz	a4,80003420 <fileclose+0x82>
    800033c8:	f04a                	sd	s2,32(sp)
    800033ca:	ec4e                	sd	s3,24(sp)
    800033cc:	e852                	sd	s4,16(sp)
    800033ce:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800033d0:	0004a903          	lw	s2,0(s1)
    800033d4:	0094ca83          	lbu	s5,9(s1)
    800033d8:	0104ba03          	ld	s4,16(s1)
    800033dc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800033e0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800033e4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800033e8:	00017517          	auipc	a0,0x17
    800033ec:	14050513          	addi	a0,a0,320 # 8001a528 <ftable>
    800033f0:	478020ef          	jal	80005868 <release>

  if(ff.type == FD_PIPE){
    800033f4:	4785                	li	a5,1
    800033f6:	04f90063          	beq	s2,a5,80003436 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800033fa:	3979                	addiw	s2,s2,-2
    800033fc:	4785                	li	a5,1
    800033fe:	0527f563          	bgeu	a5,s2,80003448 <fileclose+0xaa>
    80003402:	7902                	ld	s2,32(sp)
    80003404:	69e2                	ld	s3,24(sp)
    80003406:	6a42                	ld	s4,16(sp)
    80003408:	6aa2                	ld	s5,8(sp)
    8000340a:	a00d                	j	8000342c <fileclose+0x8e>
    8000340c:	f04a                	sd	s2,32(sp)
    8000340e:	ec4e                	sd	s3,24(sp)
    80003410:	e852                	sd	s4,16(sp)
    80003412:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003414:	00004517          	auipc	a0,0x4
    80003418:	1fc50513          	addi	a0,a0,508 # 80007610 <etext+0x610>
    8000341c:	086020ef          	jal	800054a2 <panic>
    release(&ftable.lock);
    80003420:	00017517          	auipc	a0,0x17
    80003424:	10850513          	addi	a0,a0,264 # 8001a528 <ftable>
    80003428:	440020ef          	jal	80005868 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000342c:	70e2                	ld	ra,56(sp)
    8000342e:	7442                	ld	s0,48(sp)
    80003430:	74a2                	ld	s1,40(sp)
    80003432:	6121                	addi	sp,sp,64
    80003434:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003436:	85d6                	mv	a1,s5
    80003438:	8552                	mv	a0,s4
    8000343a:	336000ef          	jal	80003770 <pipeclose>
    8000343e:	7902                	ld	s2,32(sp)
    80003440:	69e2                	ld	s3,24(sp)
    80003442:	6a42                	ld	s4,16(sp)
    80003444:	6aa2                	ld	s5,8(sp)
    80003446:	b7dd                	j	8000342c <fileclose+0x8e>
    begin_op();
    80003448:	b3dff0ef          	jal	80002f84 <begin_op>
    iput(ff.ip);
    8000344c:	854e                	mv	a0,s3
    8000344e:	c22ff0ef          	jal	80002870 <iput>
    end_op();
    80003452:	b9dff0ef          	jal	80002fee <end_op>
    80003456:	7902                	ld	s2,32(sp)
    80003458:	69e2                	ld	s3,24(sp)
    8000345a:	6a42                	ld	s4,16(sp)
    8000345c:	6aa2                	ld	s5,8(sp)
    8000345e:	b7f9                	j	8000342c <fileclose+0x8e>

0000000080003460 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003460:	715d                	addi	sp,sp,-80
    80003462:	e486                	sd	ra,72(sp)
    80003464:	e0a2                	sd	s0,64(sp)
    80003466:	fc26                	sd	s1,56(sp)
    80003468:	f44e                	sd	s3,40(sp)
    8000346a:	0880                	addi	s0,sp,80
    8000346c:	84aa                	mv	s1,a0
    8000346e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003470:	929fd0ef          	jal	80000d98 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003474:	409c                	lw	a5,0(s1)
    80003476:	37f9                	addiw	a5,a5,-2
    80003478:	4705                	li	a4,1
    8000347a:	04f76063          	bltu	a4,a5,800034ba <filestat+0x5a>
    8000347e:	f84a                	sd	s2,48(sp)
    80003480:	892a                	mv	s2,a0
    ilock(f->ip);
    80003482:	6c88                	ld	a0,24(s1)
    80003484:	a6aff0ef          	jal	800026ee <ilock>
    stati(f->ip, &st);
    80003488:	fb840593          	addi	a1,s0,-72
    8000348c:	6c88                	ld	a0,24(s1)
    8000348e:	c8aff0ef          	jal	80002918 <stati>
    iunlock(f->ip);
    80003492:	6c88                	ld	a0,24(s1)
    80003494:	b08ff0ef          	jal	8000279c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003498:	46e1                	li	a3,24
    8000349a:	fb840613          	addi	a2,s0,-72
    8000349e:	85ce                	mv	a1,s3
    800034a0:	05093503          	ld	a0,80(s2)
    800034a4:	d64fd0ef          	jal	80000a08 <copyout>
    800034a8:	41f5551b          	sraiw	a0,a0,0x1f
    800034ac:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800034ae:	60a6                	ld	ra,72(sp)
    800034b0:	6406                	ld	s0,64(sp)
    800034b2:	74e2                	ld	s1,56(sp)
    800034b4:	79a2                	ld	s3,40(sp)
    800034b6:	6161                	addi	sp,sp,80
    800034b8:	8082                	ret
  return -1;
    800034ba:	557d                	li	a0,-1
    800034bc:	bfcd                	j	800034ae <filestat+0x4e>

00000000800034be <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800034be:	7179                	addi	sp,sp,-48
    800034c0:	f406                	sd	ra,40(sp)
    800034c2:	f022                	sd	s0,32(sp)
    800034c4:	e84a                	sd	s2,16(sp)
    800034c6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800034c8:	00854783          	lbu	a5,8(a0)
    800034cc:	cfd1                	beqz	a5,80003568 <fileread+0xaa>
    800034ce:	ec26                	sd	s1,24(sp)
    800034d0:	e44e                	sd	s3,8(sp)
    800034d2:	84aa                	mv	s1,a0
    800034d4:	89ae                	mv	s3,a1
    800034d6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800034d8:	411c                	lw	a5,0(a0)
    800034da:	4705                	li	a4,1
    800034dc:	04e78363          	beq	a5,a4,80003522 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034e0:	470d                	li	a4,3
    800034e2:	04e78763          	beq	a5,a4,80003530 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800034e6:	4709                	li	a4,2
    800034e8:	06e79a63          	bne	a5,a4,8000355c <fileread+0x9e>
    ilock(f->ip);
    800034ec:	6d08                	ld	a0,24(a0)
    800034ee:	a00ff0ef          	jal	800026ee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800034f2:	874a                	mv	a4,s2
    800034f4:	5094                	lw	a3,32(s1)
    800034f6:	864e                	mv	a2,s3
    800034f8:	4585                	li	a1,1
    800034fa:	6c88                	ld	a0,24(s1)
    800034fc:	c46ff0ef          	jal	80002942 <readi>
    80003500:	892a                	mv	s2,a0
    80003502:	00a05563          	blez	a0,8000350c <fileread+0x4e>
      f->off += r;
    80003506:	509c                	lw	a5,32(s1)
    80003508:	9fa9                	addw	a5,a5,a0
    8000350a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000350c:	6c88                	ld	a0,24(s1)
    8000350e:	a8eff0ef          	jal	8000279c <iunlock>
    80003512:	64e2                	ld	s1,24(sp)
    80003514:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003516:	854a                	mv	a0,s2
    80003518:	70a2                	ld	ra,40(sp)
    8000351a:	7402                	ld	s0,32(sp)
    8000351c:	6942                	ld	s2,16(sp)
    8000351e:	6145                	addi	sp,sp,48
    80003520:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003522:	6908                	ld	a0,16(a0)
    80003524:	388000ef          	jal	800038ac <piperead>
    80003528:	892a                	mv	s2,a0
    8000352a:	64e2                	ld	s1,24(sp)
    8000352c:	69a2                	ld	s3,8(sp)
    8000352e:	b7e5                	j	80003516 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003530:	02451783          	lh	a5,36(a0)
    80003534:	03079693          	slli	a3,a5,0x30
    80003538:	92c1                	srli	a3,a3,0x30
    8000353a:	4725                	li	a4,9
    8000353c:	02d76863          	bltu	a4,a3,8000356c <fileread+0xae>
    80003540:	0792                	slli	a5,a5,0x4
    80003542:	00017717          	auipc	a4,0x17
    80003546:	f4670713          	addi	a4,a4,-186 # 8001a488 <devsw>
    8000354a:	97ba                	add	a5,a5,a4
    8000354c:	639c                	ld	a5,0(a5)
    8000354e:	c39d                	beqz	a5,80003574 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003550:	4505                	li	a0,1
    80003552:	9782                	jalr	a5
    80003554:	892a                	mv	s2,a0
    80003556:	64e2                	ld	s1,24(sp)
    80003558:	69a2                	ld	s3,8(sp)
    8000355a:	bf75                	j	80003516 <fileread+0x58>
    panic("fileread");
    8000355c:	00004517          	auipc	a0,0x4
    80003560:	0c450513          	addi	a0,a0,196 # 80007620 <etext+0x620>
    80003564:	73f010ef          	jal	800054a2 <panic>
    return -1;
    80003568:	597d                	li	s2,-1
    8000356a:	b775                	j	80003516 <fileread+0x58>
      return -1;
    8000356c:	597d                	li	s2,-1
    8000356e:	64e2                	ld	s1,24(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	b755                	j	80003516 <fileread+0x58>
    80003574:	597d                	li	s2,-1
    80003576:	64e2                	ld	s1,24(sp)
    80003578:	69a2                	ld	s3,8(sp)
    8000357a:	bf71                	j	80003516 <fileread+0x58>

000000008000357c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000357c:	00954783          	lbu	a5,9(a0)
    80003580:	10078b63          	beqz	a5,80003696 <filewrite+0x11a>
{
    80003584:	715d                	addi	sp,sp,-80
    80003586:	e486                	sd	ra,72(sp)
    80003588:	e0a2                	sd	s0,64(sp)
    8000358a:	f84a                	sd	s2,48(sp)
    8000358c:	f052                	sd	s4,32(sp)
    8000358e:	e85a                	sd	s6,16(sp)
    80003590:	0880                	addi	s0,sp,80
    80003592:	892a                	mv	s2,a0
    80003594:	8b2e                	mv	s6,a1
    80003596:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003598:	411c                	lw	a5,0(a0)
    8000359a:	4705                	li	a4,1
    8000359c:	02e78763          	beq	a5,a4,800035ca <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035a0:	470d                	li	a4,3
    800035a2:	02e78863          	beq	a5,a4,800035d2 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800035a6:	4709                	li	a4,2
    800035a8:	0ce79c63          	bne	a5,a4,80003680 <filewrite+0x104>
    800035ac:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800035ae:	0ac05863          	blez	a2,8000365e <filewrite+0xe2>
    800035b2:	fc26                	sd	s1,56(sp)
    800035b4:	ec56                	sd	s5,24(sp)
    800035b6:	e45e                	sd	s7,8(sp)
    800035b8:	e062                	sd	s8,0(sp)
    int i = 0;
    800035ba:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800035bc:	6b85                	lui	s7,0x1
    800035be:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800035c2:	6c05                	lui	s8,0x1
    800035c4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800035c8:	a8b5                	j	80003644 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800035ca:	6908                	ld	a0,16(a0)
    800035cc:	1fc000ef          	jal	800037c8 <pipewrite>
    800035d0:	a04d                	j	80003672 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800035d2:	02451783          	lh	a5,36(a0)
    800035d6:	03079693          	slli	a3,a5,0x30
    800035da:	92c1                	srli	a3,a3,0x30
    800035dc:	4725                	li	a4,9
    800035de:	0ad76e63          	bltu	a4,a3,8000369a <filewrite+0x11e>
    800035e2:	0792                	slli	a5,a5,0x4
    800035e4:	00017717          	auipc	a4,0x17
    800035e8:	ea470713          	addi	a4,a4,-348 # 8001a488 <devsw>
    800035ec:	97ba                	add	a5,a5,a4
    800035ee:	679c                	ld	a5,8(a5)
    800035f0:	c7dd                	beqz	a5,8000369e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800035f2:	4505                	li	a0,1
    800035f4:	9782                	jalr	a5
    800035f6:	a8b5                	j	80003672 <filewrite+0xf6>
      if(n1 > max)
    800035f8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800035fc:	989ff0ef          	jal	80002f84 <begin_op>
      ilock(f->ip);
    80003600:	01893503          	ld	a0,24(s2)
    80003604:	8eaff0ef          	jal	800026ee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003608:	8756                	mv	a4,s5
    8000360a:	02092683          	lw	a3,32(s2)
    8000360e:	01698633          	add	a2,s3,s6
    80003612:	4585                	li	a1,1
    80003614:	01893503          	ld	a0,24(s2)
    80003618:	c26ff0ef          	jal	80002a3e <writei>
    8000361c:	84aa                	mv	s1,a0
    8000361e:	00a05763          	blez	a0,8000362c <filewrite+0xb0>
        f->off += r;
    80003622:	02092783          	lw	a5,32(s2)
    80003626:	9fa9                	addw	a5,a5,a0
    80003628:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000362c:	01893503          	ld	a0,24(s2)
    80003630:	96cff0ef          	jal	8000279c <iunlock>
      end_op();
    80003634:	9bbff0ef          	jal	80002fee <end_op>

      if(r != n1){
    80003638:	029a9563          	bne	s5,s1,80003662 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000363c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003640:	0149da63          	bge	s3,s4,80003654 <filewrite+0xd8>
      int n1 = n - i;
    80003644:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003648:	0004879b          	sext.w	a5,s1
    8000364c:	fafbd6e3          	bge	s7,a5,800035f8 <filewrite+0x7c>
    80003650:	84e2                	mv	s1,s8
    80003652:	b75d                	j	800035f8 <filewrite+0x7c>
    80003654:	74e2                	ld	s1,56(sp)
    80003656:	6ae2                	ld	s5,24(sp)
    80003658:	6ba2                	ld	s7,8(sp)
    8000365a:	6c02                	ld	s8,0(sp)
    8000365c:	a039                	j	8000366a <filewrite+0xee>
    int i = 0;
    8000365e:	4981                	li	s3,0
    80003660:	a029                	j	8000366a <filewrite+0xee>
    80003662:	74e2                	ld	s1,56(sp)
    80003664:	6ae2                	ld	s5,24(sp)
    80003666:	6ba2                	ld	s7,8(sp)
    80003668:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000366a:	033a1c63          	bne	s4,s3,800036a2 <filewrite+0x126>
    8000366e:	8552                	mv	a0,s4
    80003670:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003672:	60a6                	ld	ra,72(sp)
    80003674:	6406                	ld	s0,64(sp)
    80003676:	7942                	ld	s2,48(sp)
    80003678:	7a02                	ld	s4,32(sp)
    8000367a:	6b42                	ld	s6,16(sp)
    8000367c:	6161                	addi	sp,sp,80
    8000367e:	8082                	ret
    80003680:	fc26                	sd	s1,56(sp)
    80003682:	f44e                	sd	s3,40(sp)
    80003684:	ec56                	sd	s5,24(sp)
    80003686:	e45e                	sd	s7,8(sp)
    80003688:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000368a:	00004517          	auipc	a0,0x4
    8000368e:	fa650513          	addi	a0,a0,-90 # 80007630 <etext+0x630>
    80003692:	611010ef          	jal	800054a2 <panic>
    return -1;
    80003696:	557d                	li	a0,-1
}
    80003698:	8082                	ret
      return -1;
    8000369a:	557d                	li	a0,-1
    8000369c:	bfd9                	j	80003672 <filewrite+0xf6>
    8000369e:	557d                	li	a0,-1
    800036a0:	bfc9                	j	80003672 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800036a2:	557d                	li	a0,-1
    800036a4:	79a2                	ld	s3,40(sp)
    800036a6:	b7f1                	j	80003672 <filewrite+0xf6>

00000000800036a8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800036a8:	7179                	addi	sp,sp,-48
    800036aa:	f406                	sd	ra,40(sp)
    800036ac:	f022                	sd	s0,32(sp)
    800036ae:	ec26                	sd	s1,24(sp)
    800036b0:	e052                	sd	s4,0(sp)
    800036b2:	1800                	addi	s0,sp,48
    800036b4:	84aa                	mv	s1,a0
    800036b6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800036b8:	0005b023          	sd	zero,0(a1)
    800036bc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800036c0:	c3bff0ef          	jal	800032fa <filealloc>
    800036c4:	e088                	sd	a0,0(s1)
    800036c6:	c549                	beqz	a0,80003750 <pipealloc+0xa8>
    800036c8:	c33ff0ef          	jal	800032fa <filealloc>
    800036cc:	00aa3023          	sd	a0,0(s4)
    800036d0:	cd25                	beqz	a0,80003748 <pipealloc+0xa0>
    800036d2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800036d4:	a23fc0ef          	jal	800000f6 <kalloc>
    800036d8:	892a                	mv	s2,a0
    800036da:	c12d                	beqz	a0,8000373c <pipealloc+0x94>
    800036dc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800036de:	4985                	li	s3,1
    800036e0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800036e4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800036e8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800036ec:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800036f0:	00004597          	auipc	a1,0x4
    800036f4:	cf858593          	addi	a1,a1,-776 # 800073e8 <etext+0x3e8>
    800036f8:	058020ef          	jal	80005750 <initlock>
  (*f0)->type = FD_PIPE;
    800036fc:	609c                	ld	a5,0(s1)
    800036fe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003702:	609c                	ld	a5,0(s1)
    80003704:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003708:	609c                	ld	a5,0(s1)
    8000370a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000370e:	609c                	ld	a5,0(s1)
    80003710:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003714:	000a3783          	ld	a5,0(s4)
    80003718:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000371c:	000a3783          	ld	a5,0(s4)
    80003720:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003724:	000a3783          	ld	a5,0(s4)
    80003728:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000372c:	000a3783          	ld	a5,0(s4)
    80003730:	0127b823          	sd	s2,16(a5)
  return 0;
    80003734:	4501                	li	a0,0
    80003736:	6942                	ld	s2,16(sp)
    80003738:	69a2                	ld	s3,8(sp)
    8000373a:	a01d                	j	80003760 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000373c:	6088                	ld	a0,0(s1)
    8000373e:	c119                	beqz	a0,80003744 <pipealloc+0x9c>
    80003740:	6942                	ld	s2,16(sp)
    80003742:	a029                	j	8000374c <pipealloc+0xa4>
    80003744:	6942                	ld	s2,16(sp)
    80003746:	a029                	j	80003750 <pipealloc+0xa8>
    80003748:	6088                	ld	a0,0(s1)
    8000374a:	c10d                	beqz	a0,8000376c <pipealloc+0xc4>
    fileclose(*f0);
    8000374c:	c53ff0ef          	jal	8000339e <fileclose>
  if(*f1)
    80003750:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003754:	557d                	li	a0,-1
  if(*f1)
    80003756:	c789                	beqz	a5,80003760 <pipealloc+0xb8>
    fileclose(*f1);
    80003758:	853e                	mv	a0,a5
    8000375a:	c45ff0ef          	jal	8000339e <fileclose>
  return -1;
    8000375e:	557d                	li	a0,-1
}
    80003760:	70a2                	ld	ra,40(sp)
    80003762:	7402                	ld	s0,32(sp)
    80003764:	64e2                	ld	s1,24(sp)
    80003766:	6a02                	ld	s4,0(sp)
    80003768:	6145                	addi	sp,sp,48
    8000376a:	8082                	ret
  return -1;
    8000376c:	557d                	li	a0,-1
    8000376e:	bfcd                	j	80003760 <pipealloc+0xb8>

0000000080003770 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003770:	1101                	addi	sp,sp,-32
    80003772:	ec06                	sd	ra,24(sp)
    80003774:	e822                	sd	s0,16(sp)
    80003776:	e426                	sd	s1,8(sp)
    80003778:	e04a                	sd	s2,0(sp)
    8000377a:	1000                	addi	s0,sp,32
    8000377c:	84aa                	mv	s1,a0
    8000377e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003780:	050020ef          	jal	800057d0 <acquire>
  if(writable){
    80003784:	02090763          	beqz	s2,800037b2 <pipeclose+0x42>
    pi->writeopen = 0;
    80003788:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000378c:	21848513          	addi	a0,s1,536
    80003790:	c23fd0ef          	jal	800013b2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003794:	2204b783          	ld	a5,544(s1)
    80003798:	e785                	bnez	a5,800037c0 <pipeclose+0x50>
    release(&pi->lock);
    8000379a:	8526                	mv	a0,s1
    8000379c:	0cc020ef          	jal	80005868 <release>
    kfree((char*)pi);
    800037a0:	8526                	mv	a0,s1
    800037a2:	87bfc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800037a6:	60e2                	ld	ra,24(sp)
    800037a8:	6442                	ld	s0,16(sp)
    800037aa:	64a2                	ld	s1,8(sp)
    800037ac:	6902                	ld	s2,0(sp)
    800037ae:	6105                	addi	sp,sp,32
    800037b0:	8082                	ret
    pi->readopen = 0;
    800037b2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800037b6:	21c48513          	addi	a0,s1,540
    800037ba:	bf9fd0ef          	jal	800013b2 <wakeup>
    800037be:	bfd9                	j	80003794 <pipeclose+0x24>
    release(&pi->lock);
    800037c0:	8526                	mv	a0,s1
    800037c2:	0a6020ef          	jal	80005868 <release>
}
    800037c6:	b7c5                	j	800037a6 <pipeclose+0x36>

00000000800037c8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800037c8:	711d                	addi	sp,sp,-96
    800037ca:	ec86                	sd	ra,88(sp)
    800037cc:	e8a2                	sd	s0,80(sp)
    800037ce:	e4a6                	sd	s1,72(sp)
    800037d0:	e0ca                	sd	s2,64(sp)
    800037d2:	fc4e                	sd	s3,56(sp)
    800037d4:	f852                	sd	s4,48(sp)
    800037d6:	f456                	sd	s5,40(sp)
    800037d8:	1080                	addi	s0,sp,96
    800037da:	84aa                	mv	s1,a0
    800037dc:	8aae                	mv	s5,a1
    800037de:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800037e0:	db8fd0ef          	jal	80000d98 <myproc>
    800037e4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800037e6:	8526                	mv	a0,s1
    800037e8:	7e9010ef          	jal	800057d0 <acquire>
  while(i < n){
    800037ec:	0b405a63          	blez	s4,800038a0 <pipewrite+0xd8>
    800037f0:	f05a                	sd	s6,32(sp)
    800037f2:	ec5e                	sd	s7,24(sp)
    800037f4:	e862                	sd	s8,16(sp)
  int i = 0;
    800037f6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800037f8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800037fa:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800037fe:	21c48b93          	addi	s7,s1,540
    80003802:	a81d                	j	80003838 <pipewrite+0x70>
      release(&pi->lock);
    80003804:	8526                	mv	a0,s1
    80003806:	062020ef          	jal	80005868 <release>
      return -1;
    8000380a:	597d                	li	s2,-1
    8000380c:	7b02                	ld	s6,32(sp)
    8000380e:	6be2                	ld	s7,24(sp)
    80003810:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003812:	854a                	mv	a0,s2
    80003814:	60e6                	ld	ra,88(sp)
    80003816:	6446                	ld	s0,80(sp)
    80003818:	64a6                	ld	s1,72(sp)
    8000381a:	6906                	ld	s2,64(sp)
    8000381c:	79e2                	ld	s3,56(sp)
    8000381e:	7a42                	ld	s4,48(sp)
    80003820:	7aa2                	ld	s5,40(sp)
    80003822:	6125                	addi	sp,sp,96
    80003824:	8082                	ret
      wakeup(&pi->nread);
    80003826:	8562                	mv	a0,s8
    80003828:	b8bfd0ef          	jal	800013b2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000382c:	85a6                	mv	a1,s1
    8000382e:	855e                	mv	a0,s7
    80003830:	b37fd0ef          	jal	80001366 <sleep>
  while(i < n){
    80003834:	05495b63          	bge	s2,s4,8000388a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003838:	2204a783          	lw	a5,544(s1)
    8000383c:	d7e1                	beqz	a5,80003804 <pipewrite+0x3c>
    8000383e:	854e                	mv	a0,s3
    80003840:	d5ffd0ef          	jal	8000159e <killed>
    80003844:	f161                	bnez	a0,80003804 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003846:	2184a783          	lw	a5,536(s1)
    8000384a:	21c4a703          	lw	a4,540(s1)
    8000384e:	2007879b          	addiw	a5,a5,512
    80003852:	fcf70ae3          	beq	a4,a5,80003826 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003856:	4685                	li	a3,1
    80003858:	01590633          	add	a2,s2,s5
    8000385c:	faf40593          	addi	a1,s0,-81
    80003860:	0509b503          	ld	a0,80(s3)
    80003864:	a7cfd0ef          	jal	80000ae0 <copyin>
    80003868:	03650e63          	beq	a0,s6,800038a4 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000386c:	21c4a783          	lw	a5,540(s1)
    80003870:	0017871b          	addiw	a4,a5,1
    80003874:	20e4ae23          	sw	a4,540(s1)
    80003878:	1ff7f793          	andi	a5,a5,511
    8000387c:	97a6                	add	a5,a5,s1
    8000387e:	faf44703          	lbu	a4,-81(s0)
    80003882:	00e78c23          	sb	a4,24(a5)
      i++;
    80003886:	2905                	addiw	s2,s2,1
    80003888:	b775                	j	80003834 <pipewrite+0x6c>
    8000388a:	7b02                	ld	s6,32(sp)
    8000388c:	6be2                	ld	s7,24(sp)
    8000388e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003890:	21848513          	addi	a0,s1,536
    80003894:	b1ffd0ef          	jal	800013b2 <wakeup>
  release(&pi->lock);
    80003898:	8526                	mv	a0,s1
    8000389a:	7cf010ef          	jal	80005868 <release>
  return i;
    8000389e:	bf95                	j	80003812 <pipewrite+0x4a>
  int i = 0;
    800038a0:	4901                	li	s2,0
    800038a2:	b7fd                	j	80003890 <pipewrite+0xc8>
    800038a4:	7b02                	ld	s6,32(sp)
    800038a6:	6be2                	ld	s7,24(sp)
    800038a8:	6c42                	ld	s8,16(sp)
    800038aa:	b7dd                	j	80003890 <pipewrite+0xc8>

00000000800038ac <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800038ac:	715d                	addi	sp,sp,-80
    800038ae:	e486                	sd	ra,72(sp)
    800038b0:	e0a2                	sd	s0,64(sp)
    800038b2:	fc26                	sd	s1,56(sp)
    800038b4:	f84a                	sd	s2,48(sp)
    800038b6:	f44e                	sd	s3,40(sp)
    800038b8:	f052                	sd	s4,32(sp)
    800038ba:	ec56                	sd	s5,24(sp)
    800038bc:	0880                	addi	s0,sp,80
    800038be:	84aa                	mv	s1,a0
    800038c0:	892e                	mv	s2,a1
    800038c2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800038c4:	cd4fd0ef          	jal	80000d98 <myproc>
    800038c8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800038ca:	8526                	mv	a0,s1
    800038cc:	705010ef          	jal	800057d0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038d0:	2184a703          	lw	a4,536(s1)
    800038d4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038d8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038dc:	02f71563          	bne	a4,a5,80003906 <piperead+0x5a>
    800038e0:	2244a783          	lw	a5,548(s1)
    800038e4:	cb85                	beqz	a5,80003914 <piperead+0x68>
    if(killed(pr)){
    800038e6:	8552                	mv	a0,s4
    800038e8:	cb7fd0ef          	jal	8000159e <killed>
    800038ec:	ed19                	bnez	a0,8000390a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800038ee:	85a6                	mv	a1,s1
    800038f0:	854e                	mv	a0,s3
    800038f2:	a75fd0ef          	jal	80001366 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800038f6:	2184a703          	lw	a4,536(s1)
    800038fa:	21c4a783          	lw	a5,540(s1)
    800038fe:	fef701e3          	beq	a4,a5,800038e0 <piperead+0x34>
    80003902:	e85a                	sd	s6,16(sp)
    80003904:	a809                	j	80003916 <piperead+0x6a>
    80003906:	e85a                	sd	s6,16(sp)
    80003908:	a039                	j	80003916 <piperead+0x6a>
      release(&pi->lock);
    8000390a:	8526                	mv	a0,s1
    8000390c:	75d010ef          	jal	80005868 <release>
      return -1;
    80003910:	59fd                	li	s3,-1
    80003912:	a8b1                	j	8000396e <piperead+0xc2>
    80003914:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003916:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003918:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000391a:	05505263          	blez	s5,8000395e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000391e:	2184a783          	lw	a5,536(s1)
    80003922:	21c4a703          	lw	a4,540(s1)
    80003926:	02f70c63          	beq	a4,a5,8000395e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000392a:	0017871b          	addiw	a4,a5,1
    8000392e:	20e4ac23          	sw	a4,536(s1)
    80003932:	1ff7f793          	andi	a5,a5,511
    80003936:	97a6                	add	a5,a5,s1
    80003938:	0187c783          	lbu	a5,24(a5)
    8000393c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003940:	4685                	li	a3,1
    80003942:	fbf40613          	addi	a2,s0,-65
    80003946:	85ca                	mv	a1,s2
    80003948:	050a3503          	ld	a0,80(s4)
    8000394c:	8bcfd0ef          	jal	80000a08 <copyout>
    80003950:	01650763          	beq	a0,s6,8000395e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003954:	2985                	addiw	s3,s3,1
    80003956:	0905                	addi	s2,s2,1
    80003958:	fd3a93e3          	bne	s5,s3,8000391e <piperead+0x72>
    8000395c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000395e:	21c48513          	addi	a0,s1,540
    80003962:	a51fd0ef          	jal	800013b2 <wakeup>
  release(&pi->lock);
    80003966:	8526                	mv	a0,s1
    80003968:	701010ef          	jal	80005868 <release>
    8000396c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000396e:	854e                	mv	a0,s3
    80003970:	60a6                	ld	ra,72(sp)
    80003972:	6406                	ld	s0,64(sp)
    80003974:	74e2                	ld	s1,56(sp)
    80003976:	7942                	ld	s2,48(sp)
    80003978:	79a2                	ld	s3,40(sp)
    8000397a:	7a02                	ld	s4,32(sp)
    8000397c:	6ae2                	ld	s5,24(sp)
    8000397e:	6161                	addi	sp,sp,80
    80003980:	8082                	ret

0000000080003982 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003982:	1141                	addi	sp,sp,-16
    80003984:	e422                	sd	s0,8(sp)
    80003986:	0800                	addi	s0,sp,16
    80003988:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000398a:	8905                	andi	a0,a0,1
    8000398c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000398e:	8b89                	andi	a5,a5,2
    80003990:	c399                	beqz	a5,80003996 <flags2perm+0x14>
      perm |= PTE_W;
    80003992:	00456513          	ori	a0,a0,4
    return perm;
}
    80003996:	6422                	ld	s0,8(sp)
    80003998:	0141                	addi	sp,sp,16
    8000399a:	8082                	ret

000000008000399c <exec>:

int
exec(char *path, char **argv)
{
    8000399c:	df010113          	addi	sp,sp,-528
    800039a0:	20113423          	sd	ra,520(sp)
    800039a4:	20813023          	sd	s0,512(sp)
    800039a8:	ffa6                	sd	s1,504(sp)
    800039aa:	fbca                	sd	s2,496(sp)
    800039ac:	0c00                	addi	s0,sp,528
    800039ae:	892a                	mv	s2,a0
    800039b0:	dea43c23          	sd	a0,-520(s0)
    800039b4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800039b8:	be0fd0ef          	jal	80000d98 <myproc>
    800039bc:	84aa                	mv	s1,a0

  begin_op();
    800039be:	dc6ff0ef          	jal	80002f84 <begin_op>

  if((ip = namei(path)) == 0){
    800039c2:	854a                	mv	a0,s2
    800039c4:	c04ff0ef          	jal	80002dc8 <namei>
    800039c8:	c931                	beqz	a0,80003a1c <exec+0x80>
    800039ca:	f3d2                	sd	s4,480(sp)
    800039cc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800039ce:	d21fe0ef          	jal	800026ee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800039d2:	04000713          	li	a4,64
    800039d6:	4681                	li	a3,0
    800039d8:	e5040613          	addi	a2,s0,-432
    800039dc:	4581                	li	a1,0
    800039de:	8552                	mv	a0,s4
    800039e0:	f63fe0ef          	jal	80002942 <readi>
    800039e4:	04000793          	li	a5,64
    800039e8:	00f51a63          	bne	a0,a5,800039fc <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800039ec:	e5042703          	lw	a4,-432(s0)
    800039f0:	464c47b7          	lui	a5,0x464c4
    800039f4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800039f8:	02f70663          	beq	a4,a5,80003a24 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800039fc:	8552                	mv	a0,s4
    800039fe:	efbfe0ef          	jal	800028f8 <iunlockput>
    end_op();
    80003a02:	decff0ef          	jal	80002fee <end_op>
  }
  return -1;
    80003a06:	557d                	li	a0,-1
    80003a08:	7a1e                	ld	s4,480(sp)
}
    80003a0a:	20813083          	ld	ra,520(sp)
    80003a0e:	20013403          	ld	s0,512(sp)
    80003a12:	74fe                	ld	s1,504(sp)
    80003a14:	795e                	ld	s2,496(sp)
    80003a16:	21010113          	addi	sp,sp,528
    80003a1a:	8082                	ret
    end_op();
    80003a1c:	dd2ff0ef          	jal	80002fee <end_op>
    return -1;
    80003a20:	557d                	li	a0,-1
    80003a22:	b7e5                	j	80003a0a <exec+0x6e>
    80003a24:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a26:	8526                	mv	a0,s1
    80003a28:	c18fd0ef          	jal	80000e40 <proc_pagetable>
    80003a2c:	8b2a                	mv	s6,a0
    80003a2e:	2c050b63          	beqz	a0,80003d04 <exec+0x368>
    80003a32:	f7ce                	sd	s3,488(sp)
    80003a34:	efd6                	sd	s5,472(sp)
    80003a36:	e7de                	sd	s7,456(sp)
    80003a38:	e3e2                	sd	s8,448(sp)
    80003a3a:	ff66                	sd	s9,440(sp)
    80003a3c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a3e:	e7042d03          	lw	s10,-400(s0)
    80003a42:	e8845783          	lhu	a5,-376(s0)
    80003a46:	12078963          	beqz	a5,80003b78 <exec+0x1dc>
    80003a4a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003a4c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003a4e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003a50:	6c85                	lui	s9,0x1
    80003a52:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003a56:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003a5a:	6a85                	lui	s5,0x1
    80003a5c:	a085                	j	80003abc <exec+0x120>
      panic("loadseg: address should exist");
    80003a5e:	00004517          	auipc	a0,0x4
    80003a62:	be250513          	addi	a0,a0,-1054 # 80007640 <etext+0x640>
    80003a66:	23d010ef          	jal	800054a2 <panic>
    if(sz - i < PGSIZE)
    80003a6a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003a6c:	8726                	mv	a4,s1
    80003a6e:	012c06bb          	addw	a3,s8,s2
    80003a72:	4581                	li	a1,0
    80003a74:	8552                	mv	a0,s4
    80003a76:	ecdfe0ef          	jal	80002942 <readi>
    80003a7a:	2501                	sext.w	a0,a0
    80003a7c:	24a49a63          	bne	s1,a0,80003cd0 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003a80:	012a893b          	addw	s2,s5,s2
    80003a84:	03397363          	bgeu	s2,s3,80003aaa <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003a88:	02091593          	slli	a1,s2,0x20
    80003a8c:	9181                	srli	a1,a1,0x20
    80003a8e:	95de                	add	a1,a1,s7
    80003a90:	855a                	mv	a0,s6
    80003a92:	9f3fc0ef          	jal	80000484 <walkaddr>
    80003a96:	862a                	mv	a2,a0
    if(pa == 0)
    80003a98:	d179                	beqz	a0,80003a5e <exec+0xc2>
    if(sz - i < PGSIZE)
    80003a9a:	412984bb          	subw	s1,s3,s2
    80003a9e:	0004879b          	sext.w	a5,s1
    80003aa2:	fcfcf4e3          	bgeu	s9,a5,80003a6a <exec+0xce>
    80003aa6:	84d6                	mv	s1,s5
    80003aa8:	b7c9                	j	80003a6a <exec+0xce>
    sz = sz1;
    80003aaa:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aae:	2d85                	addiw	s11,s11,1
    80003ab0:	038d0d1b          	addiw	s10,s10,56
    80003ab4:	e8845783          	lhu	a5,-376(s0)
    80003ab8:	08fdd063          	bge	s11,a5,80003b38 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003abc:	2d01                	sext.w	s10,s10
    80003abe:	03800713          	li	a4,56
    80003ac2:	86ea                	mv	a3,s10
    80003ac4:	e1840613          	addi	a2,s0,-488
    80003ac8:	4581                	li	a1,0
    80003aca:	8552                	mv	a0,s4
    80003acc:	e77fe0ef          	jal	80002942 <readi>
    80003ad0:	03800793          	li	a5,56
    80003ad4:	1cf51663          	bne	a0,a5,80003ca0 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003ad8:	e1842783          	lw	a5,-488(s0)
    80003adc:	4705                	li	a4,1
    80003ade:	fce798e3          	bne	a5,a4,80003aae <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003ae2:	e4043483          	ld	s1,-448(s0)
    80003ae6:	e3843783          	ld	a5,-456(s0)
    80003aea:	1af4ef63          	bltu	s1,a5,80003ca8 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003aee:	e2843783          	ld	a5,-472(s0)
    80003af2:	94be                	add	s1,s1,a5
    80003af4:	1af4ee63          	bltu	s1,a5,80003cb0 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003af8:	df043703          	ld	a4,-528(s0)
    80003afc:	8ff9                	and	a5,a5,a4
    80003afe:	1a079d63          	bnez	a5,80003cb8 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b02:	e1c42503          	lw	a0,-484(s0)
    80003b06:	e7dff0ef          	jal	80003982 <flags2perm>
    80003b0a:	86aa                	mv	a3,a0
    80003b0c:	8626                	mv	a2,s1
    80003b0e:	85ca                	mv	a1,s2
    80003b10:	855a                	mv	a0,s6
    80003b12:	cebfc0ef          	jal	800007fc <uvmalloc>
    80003b16:	e0a43423          	sd	a0,-504(s0)
    80003b1a:	1a050363          	beqz	a0,80003cc0 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b1e:	e2843b83          	ld	s7,-472(s0)
    80003b22:	e2042c03          	lw	s8,-480(s0)
    80003b26:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b2a:	00098463          	beqz	s3,80003b32 <exec+0x196>
    80003b2e:	4901                	li	s2,0
    80003b30:	bfa1                	j	80003a88 <exec+0xec>
    sz = sz1;
    80003b32:	e0843903          	ld	s2,-504(s0)
    80003b36:	bfa5                	j	80003aae <exec+0x112>
    80003b38:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003b3a:	8552                	mv	a0,s4
    80003b3c:	dbdfe0ef          	jal	800028f8 <iunlockput>
  end_op();
    80003b40:	caeff0ef          	jal	80002fee <end_op>
  p = myproc();
    80003b44:	a54fd0ef          	jal	80000d98 <myproc>
    80003b48:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003b4a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003b4e:	6985                	lui	s3,0x1
    80003b50:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003b52:	99ca                	add	s3,s3,s2
    80003b54:	77fd                	lui	a5,0xfffff
    80003b56:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003b5a:	4691                	li	a3,4
    80003b5c:	6609                	lui	a2,0x2
    80003b5e:	964e                	add	a2,a2,s3
    80003b60:	85ce                	mv	a1,s3
    80003b62:	855a                	mv	a0,s6
    80003b64:	c99fc0ef          	jal	800007fc <uvmalloc>
    80003b68:	892a                	mv	s2,a0
    80003b6a:	e0a43423          	sd	a0,-504(s0)
    80003b6e:	e519                	bnez	a0,80003b7c <exec+0x1e0>
  if(pagetable)
    80003b70:	e1343423          	sd	s3,-504(s0)
    80003b74:	4a01                	li	s4,0
    80003b76:	aab1                	j	80003cd2 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b78:	4901                	li	s2,0
    80003b7a:	b7c1                	j	80003b3a <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003b7c:	75f9                	lui	a1,0xffffe
    80003b7e:	95aa                	add	a1,a1,a0
    80003b80:	855a                	mv	a0,s6
    80003b82:	e5dfc0ef          	jal	800009de <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003b86:	7bfd                	lui	s7,0xfffff
    80003b88:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003b8a:	e0043783          	ld	a5,-512(s0)
    80003b8e:	6388                	ld	a0,0(a5)
    80003b90:	cd39                	beqz	a0,80003bee <exec+0x252>
    80003b92:	e9040993          	addi	s3,s0,-368
    80003b96:	f9040c13          	addi	s8,s0,-112
    80003b9a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003b9c:	f4afc0ef          	jal	800002e6 <strlen>
    80003ba0:	0015079b          	addiw	a5,a0,1
    80003ba4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003ba8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003bac:	11796e63          	bltu	s2,s7,80003cc8 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003bb0:	e0043d03          	ld	s10,-512(s0)
    80003bb4:	000d3a03          	ld	s4,0(s10)
    80003bb8:	8552                	mv	a0,s4
    80003bba:	f2cfc0ef          	jal	800002e6 <strlen>
    80003bbe:	0015069b          	addiw	a3,a0,1
    80003bc2:	8652                	mv	a2,s4
    80003bc4:	85ca                	mv	a1,s2
    80003bc6:	855a                	mv	a0,s6
    80003bc8:	e41fc0ef          	jal	80000a08 <copyout>
    80003bcc:	10054063          	bltz	a0,80003ccc <exec+0x330>
    ustack[argc] = sp;
    80003bd0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003bd4:	0485                	addi	s1,s1,1
    80003bd6:	008d0793          	addi	a5,s10,8
    80003bda:	e0f43023          	sd	a5,-512(s0)
    80003bde:	008d3503          	ld	a0,8(s10)
    80003be2:	c909                	beqz	a0,80003bf4 <exec+0x258>
    if(argc >= MAXARG)
    80003be4:	09a1                	addi	s3,s3,8
    80003be6:	fb899be3          	bne	s3,s8,80003b9c <exec+0x200>
  ip = 0;
    80003bea:	4a01                	li	s4,0
    80003bec:	a0dd                	j	80003cd2 <exec+0x336>
  sp = sz;
    80003bee:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003bf2:	4481                	li	s1,0
  ustack[argc] = 0;
    80003bf4:	00349793          	slli	a5,s1,0x3
    80003bf8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb870>
    80003bfc:	97a2                	add	a5,a5,s0
    80003bfe:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c02:	00148693          	addi	a3,s1,1
    80003c06:	068e                	slli	a3,a3,0x3
    80003c08:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c0c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c10:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c14:	f5796ee3          	bltu	s2,s7,80003b70 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c18:	e9040613          	addi	a2,s0,-368
    80003c1c:	85ca                	mv	a1,s2
    80003c1e:	855a                	mv	a0,s6
    80003c20:	de9fc0ef          	jal	80000a08 <copyout>
    80003c24:	0e054263          	bltz	a0,80003d08 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003c28:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c2c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c30:	df843783          	ld	a5,-520(s0)
    80003c34:	0007c703          	lbu	a4,0(a5)
    80003c38:	cf11                	beqz	a4,80003c54 <exec+0x2b8>
    80003c3a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003c3c:	02f00693          	li	a3,47
    80003c40:	a039                	j	80003c4e <exec+0x2b2>
      last = s+1;
    80003c42:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003c46:	0785                	addi	a5,a5,1
    80003c48:	fff7c703          	lbu	a4,-1(a5)
    80003c4c:	c701                	beqz	a4,80003c54 <exec+0x2b8>
    if(*s == '/')
    80003c4e:	fed71ce3          	bne	a4,a3,80003c46 <exec+0x2aa>
    80003c52:	bfc5                	j	80003c42 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003c54:	4641                	li	a2,16
    80003c56:	df843583          	ld	a1,-520(s0)
    80003c5a:	158a8513          	addi	a0,s5,344
    80003c5e:	e56fc0ef          	jal	800002b4 <safestrcpy>
  oldpagetable = p->pagetable;
    80003c62:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003c66:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003c6a:	e0843783          	ld	a5,-504(s0)
    80003c6e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003c72:	058ab783          	ld	a5,88(s5)
    80003c76:	e6843703          	ld	a4,-408(s0)
    80003c7a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003c7c:	058ab783          	ld	a5,88(s5)
    80003c80:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003c84:	85e6                	mv	a1,s9
    80003c86:	a3efd0ef          	jal	80000ec4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003c8a:	0004851b          	sext.w	a0,s1
    80003c8e:	79be                	ld	s3,488(sp)
    80003c90:	7a1e                	ld	s4,480(sp)
    80003c92:	6afe                	ld	s5,472(sp)
    80003c94:	6b5e                	ld	s6,464(sp)
    80003c96:	6bbe                	ld	s7,456(sp)
    80003c98:	6c1e                	ld	s8,448(sp)
    80003c9a:	7cfa                	ld	s9,440(sp)
    80003c9c:	7d5a                	ld	s10,432(sp)
    80003c9e:	b3b5                	j	80003a0a <exec+0x6e>
    80003ca0:	e1243423          	sd	s2,-504(s0)
    80003ca4:	7dba                	ld	s11,424(sp)
    80003ca6:	a035                	j	80003cd2 <exec+0x336>
    80003ca8:	e1243423          	sd	s2,-504(s0)
    80003cac:	7dba                	ld	s11,424(sp)
    80003cae:	a015                	j	80003cd2 <exec+0x336>
    80003cb0:	e1243423          	sd	s2,-504(s0)
    80003cb4:	7dba                	ld	s11,424(sp)
    80003cb6:	a831                	j	80003cd2 <exec+0x336>
    80003cb8:	e1243423          	sd	s2,-504(s0)
    80003cbc:	7dba                	ld	s11,424(sp)
    80003cbe:	a811                	j	80003cd2 <exec+0x336>
    80003cc0:	e1243423          	sd	s2,-504(s0)
    80003cc4:	7dba                	ld	s11,424(sp)
    80003cc6:	a031                	j	80003cd2 <exec+0x336>
  ip = 0;
    80003cc8:	4a01                	li	s4,0
    80003cca:	a021                	j	80003cd2 <exec+0x336>
    80003ccc:	4a01                	li	s4,0
  if(pagetable)
    80003cce:	a011                	j	80003cd2 <exec+0x336>
    80003cd0:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003cd2:	e0843583          	ld	a1,-504(s0)
    80003cd6:	855a                	mv	a0,s6
    80003cd8:	9ecfd0ef          	jal	80000ec4 <proc_freepagetable>
  return -1;
    80003cdc:	557d                	li	a0,-1
  if(ip){
    80003cde:	000a1b63          	bnez	s4,80003cf4 <exec+0x358>
    80003ce2:	79be                	ld	s3,488(sp)
    80003ce4:	7a1e                	ld	s4,480(sp)
    80003ce6:	6afe                	ld	s5,472(sp)
    80003ce8:	6b5e                	ld	s6,464(sp)
    80003cea:	6bbe                	ld	s7,456(sp)
    80003cec:	6c1e                	ld	s8,448(sp)
    80003cee:	7cfa                	ld	s9,440(sp)
    80003cf0:	7d5a                	ld	s10,432(sp)
    80003cf2:	bb21                	j	80003a0a <exec+0x6e>
    80003cf4:	79be                	ld	s3,488(sp)
    80003cf6:	6afe                	ld	s5,472(sp)
    80003cf8:	6b5e                	ld	s6,464(sp)
    80003cfa:	6bbe                	ld	s7,456(sp)
    80003cfc:	6c1e                	ld	s8,448(sp)
    80003cfe:	7cfa                	ld	s9,440(sp)
    80003d00:	7d5a                	ld	s10,432(sp)
    80003d02:	b9ed                	j	800039fc <exec+0x60>
    80003d04:	6b5e                	ld	s6,464(sp)
    80003d06:	b9dd                	j	800039fc <exec+0x60>
  sz = sz1;
    80003d08:	e0843983          	ld	s3,-504(s0)
    80003d0c:	b595                	j	80003b70 <exec+0x1d4>

0000000080003d0e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d0e:	7179                	addi	sp,sp,-48
    80003d10:	f406                	sd	ra,40(sp)
    80003d12:	f022                	sd	s0,32(sp)
    80003d14:	ec26                	sd	s1,24(sp)
    80003d16:	e84a                	sd	s2,16(sp)
    80003d18:	1800                	addi	s0,sp,48
    80003d1a:	892e                	mv	s2,a1
    80003d1c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d1e:	fdc40593          	addi	a1,s0,-36
    80003d22:	f5bfd0ef          	jal	80001c7c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d26:	fdc42703          	lw	a4,-36(s0)
    80003d2a:	47bd                	li	a5,15
    80003d2c:	02e7e963          	bltu	a5,a4,80003d5e <argfd+0x50>
    80003d30:	868fd0ef          	jal	80000d98 <myproc>
    80003d34:	fdc42703          	lw	a4,-36(s0)
    80003d38:	01a70793          	addi	a5,a4,26
    80003d3c:	078e                	slli	a5,a5,0x3
    80003d3e:	953e                	add	a0,a0,a5
    80003d40:	611c                	ld	a5,0(a0)
    80003d42:	c385                	beqz	a5,80003d62 <argfd+0x54>
    return -1;
  if(pfd)
    80003d44:	00090463          	beqz	s2,80003d4c <argfd+0x3e>
    *pfd = fd;
    80003d48:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003d4c:	4501                	li	a0,0
  if(pf)
    80003d4e:	c091                	beqz	s1,80003d52 <argfd+0x44>
    *pf = f;
    80003d50:	e09c                	sd	a5,0(s1)
}
    80003d52:	70a2                	ld	ra,40(sp)
    80003d54:	7402                	ld	s0,32(sp)
    80003d56:	64e2                	ld	s1,24(sp)
    80003d58:	6942                	ld	s2,16(sp)
    80003d5a:	6145                	addi	sp,sp,48
    80003d5c:	8082                	ret
    return -1;
    80003d5e:	557d                	li	a0,-1
    80003d60:	bfcd                	j	80003d52 <argfd+0x44>
    80003d62:	557d                	li	a0,-1
    80003d64:	b7fd                	j	80003d52 <argfd+0x44>

0000000080003d66 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003d66:	1101                	addi	sp,sp,-32
    80003d68:	ec06                	sd	ra,24(sp)
    80003d6a:	e822                	sd	s0,16(sp)
    80003d6c:	e426                	sd	s1,8(sp)
    80003d6e:	1000                	addi	s0,sp,32
    80003d70:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003d72:	826fd0ef          	jal	80000d98 <myproc>
    80003d76:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003d78:	0d050793          	addi	a5,a0,208
    80003d7c:	4501                	li	a0,0
    80003d7e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003d80:	6398                	ld	a4,0(a5)
    80003d82:	cb19                	beqz	a4,80003d98 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003d84:	2505                	addiw	a0,a0,1
    80003d86:	07a1                	addi	a5,a5,8
    80003d88:	fed51ce3          	bne	a0,a3,80003d80 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003d8c:	557d                	li	a0,-1
}
    80003d8e:	60e2                	ld	ra,24(sp)
    80003d90:	6442                	ld	s0,16(sp)
    80003d92:	64a2                	ld	s1,8(sp)
    80003d94:	6105                	addi	sp,sp,32
    80003d96:	8082                	ret
      p->ofile[fd] = f;
    80003d98:	01a50793          	addi	a5,a0,26
    80003d9c:	078e                	slli	a5,a5,0x3
    80003d9e:	963e                	add	a2,a2,a5
    80003da0:	e204                	sd	s1,0(a2)
      return fd;
    80003da2:	b7f5                	j	80003d8e <fdalloc+0x28>

0000000080003da4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003da4:	715d                	addi	sp,sp,-80
    80003da6:	e486                	sd	ra,72(sp)
    80003da8:	e0a2                	sd	s0,64(sp)
    80003daa:	fc26                	sd	s1,56(sp)
    80003dac:	f84a                	sd	s2,48(sp)
    80003dae:	f44e                	sd	s3,40(sp)
    80003db0:	ec56                	sd	s5,24(sp)
    80003db2:	e85a                	sd	s6,16(sp)
    80003db4:	0880                	addi	s0,sp,80
    80003db6:	8b2e                	mv	s6,a1
    80003db8:	89b2                	mv	s3,a2
    80003dba:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003dbc:	fb040593          	addi	a1,s0,-80
    80003dc0:	822ff0ef          	jal	80002de2 <nameiparent>
    80003dc4:	84aa                	mv	s1,a0
    80003dc6:	10050a63          	beqz	a0,80003eda <create+0x136>
    return 0;

  ilock(dp);
    80003dca:	925fe0ef          	jal	800026ee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003dce:	4601                	li	a2,0
    80003dd0:	fb040593          	addi	a1,s0,-80
    80003dd4:	8526                	mv	a0,s1
    80003dd6:	d8dfe0ef          	jal	80002b62 <dirlookup>
    80003dda:	8aaa                	mv	s5,a0
    80003ddc:	c129                	beqz	a0,80003e1e <create+0x7a>
    iunlockput(dp);
    80003dde:	8526                	mv	a0,s1
    80003de0:	b19fe0ef          	jal	800028f8 <iunlockput>
    ilock(ip);
    80003de4:	8556                	mv	a0,s5
    80003de6:	909fe0ef          	jal	800026ee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003dea:	4789                	li	a5,2
    80003dec:	02fb1463          	bne	s6,a5,80003e14 <create+0x70>
    80003df0:	044ad783          	lhu	a5,68(s5)
    80003df4:	37f9                	addiw	a5,a5,-2
    80003df6:	17c2                	slli	a5,a5,0x30
    80003df8:	93c1                	srli	a5,a5,0x30
    80003dfa:	4705                	li	a4,1
    80003dfc:	00f76c63          	bltu	a4,a5,80003e14 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e00:	8556                	mv	a0,s5
    80003e02:	60a6                	ld	ra,72(sp)
    80003e04:	6406                	ld	s0,64(sp)
    80003e06:	74e2                	ld	s1,56(sp)
    80003e08:	7942                	ld	s2,48(sp)
    80003e0a:	79a2                	ld	s3,40(sp)
    80003e0c:	6ae2                	ld	s5,24(sp)
    80003e0e:	6b42                	ld	s6,16(sp)
    80003e10:	6161                	addi	sp,sp,80
    80003e12:	8082                	ret
    iunlockput(ip);
    80003e14:	8556                	mv	a0,s5
    80003e16:	ae3fe0ef          	jal	800028f8 <iunlockput>
    return 0;
    80003e1a:	4a81                	li	s5,0
    80003e1c:	b7d5                	j	80003e00 <create+0x5c>
    80003e1e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e20:	85da                	mv	a1,s6
    80003e22:	4088                	lw	a0,0(s1)
    80003e24:	f5afe0ef          	jal	8000257e <ialloc>
    80003e28:	8a2a                	mv	s4,a0
    80003e2a:	cd15                	beqz	a0,80003e66 <create+0xc2>
  ilock(ip);
    80003e2c:	8c3fe0ef          	jal	800026ee <ilock>
  ip->major = major;
    80003e30:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003e34:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003e38:	4905                	li	s2,1
    80003e3a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003e3e:	8552                	mv	a0,s4
    80003e40:	ffafe0ef          	jal	8000263a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003e44:	032b0763          	beq	s6,s2,80003e72 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e48:	004a2603          	lw	a2,4(s4)
    80003e4c:	fb040593          	addi	a1,s0,-80
    80003e50:	8526                	mv	a0,s1
    80003e52:	eddfe0ef          	jal	80002d2e <dirlink>
    80003e56:	06054563          	bltz	a0,80003ec0 <create+0x11c>
  iunlockput(dp);
    80003e5a:	8526                	mv	a0,s1
    80003e5c:	a9dfe0ef          	jal	800028f8 <iunlockput>
  return ip;
    80003e60:	8ad2                	mv	s5,s4
    80003e62:	7a02                	ld	s4,32(sp)
    80003e64:	bf71                	j	80003e00 <create+0x5c>
    iunlockput(dp);
    80003e66:	8526                	mv	a0,s1
    80003e68:	a91fe0ef          	jal	800028f8 <iunlockput>
    return 0;
    80003e6c:	8ad2                	mv	s5,s4
    80003e6e:	7a02                	ld	s4,32(sp)
    80003e70:	bf41                	j	80003e00 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003e72:	004a2603          	lw	a2,4(s4)
    80003e76:	00003597          	auipc	a1,0x3
    80003e7a:	7ea58593          	addi	a1,a1,2026 # 80007660 <etext+0x660>
    80003e7e:	8552                	mv	a0,s4
    80003e80:	eaffe0ef          	jal	80002d2e <dirlink>
    80003e84:	02054e63          	bltz	a0,80003ec0 <create+0x11c>
    80003e88:	40d0                	lw	a2,4(s1)
    80003e8a:	00003597          	auipc	a1,0x3
    80003e8e:	7de58593          	addi	a1,a1,2014 # 80007668 <etext+0x668>
    80003e92:	8552                	mv	a0,s4
    80003e94:	e9bfe0ef          	jal	80002d2e <dirlink>
    80003e98:	02054463          	bltz	a0,80003ec0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003e9c:	004a2603          	lw	a2,4(s4)
    80003ea0:	fb040593          	addi	a1,s0,-80
    80003ea4:	8526                	mv	a0,s1
    80003ea6:	e89fe0ef          	jal	80002d2e <dirlink>
    80003eaa:	00054b63          	bltz	a0,80003ec0 <create+0x11c>
    dp->nlink++;  // for ".."
    80003eae:	04a4d783          	lhu	a5,74(s1)
    80003eb2:	2785                	addiw	a5,a5,1
    80003eb4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	f80fe0ef          	jal	8000263a <iupdate>
    80003ebe:	bf71                	j	80003e5a <create+0xb6>
  ip->nlink = 0;
    80003ec0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003ec4:	8552                	mv	a0,s4
    80003ec6:	f74fe0ef          	jal	8000263a <iupdate>
  iunlockput(ip);
    80003eca:	8552                	mv	a0,s4
    80003ecc:	a2dfe0ef          	jal	800028f8 <iunlockput>
  iunlockput(dp);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	a27fe0ef          	jal	800028f8 <iunlockput>
  return 0;
    80003ed6:	7a02                	ld	s4,32(sp)
    80003ed8:	b725                	j	80003e00 <create+0x5c>
    return 0;
    80003eda:	8aaa                	mv	s5,a0
    80003edc:	b715                	j	80003e00 <create+0x5c>

0000000080003ede <sys_dup>:
{
    80003ede:	7179                	addi	sp,sp,-48
    80003ee0:	f406                	sd	ra,40(sp)
    80003ee2:	f022                	sd	s0,32(sp)
    80003ee4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003ee6:	fd840613          	addi	a2,s0,-40
    80003eea:	4581                	li	a1,0
    80003eec:	4501                	li	a0,0
    80003eee:	e21ff0ef          	jal	80003d0e <argfd>
    return -1;
    80003ef2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003ef4:	02054363          	bltz	a0,80003f1a <sys_dup+0x3c>
    80003ef8:	ec26                	sd	s1,24(sp)
    80003efa:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003efc:	fd843903          	ld	s2,-40(s0)
    80003f00:	854a                	mv	a0,s2
    80003f02:	e65ff0ef          	jal	80003d66 <fdalloc>
    80003f06:	84aa                	mv	s1,a0
    return -1;
    80003f08:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f0a:	00054d63          	bltz	a0,80003f24 <sys_dup+0x46>
  filedup(f);
    80003f0e:	854a                	mv	a0,s2
    80003f10:	c48ff0ef          	jal	80003358 <filedup>
  return fd;
    80003f14:	87a6                	mv	a5,s1
    80003f16:	64e2                	ld	s1,24(sp)
    80003f18:	6942                	ld	s2,16(sp)
}
    80003f1a:	853e                	mv	a0,a5
    80003f1c:	70a2                	ld	ra,40(sp)
    80003f1e:	7402                	ld	s0,32(sp)
    80003f20:	6145                	addi	sp,sp,48
    80003f22:	8082                	ret
    80003f24:	64e2                	ld	s1,24(sp)
    80003f26:	6942                	ld	s2,16(sp)
    80003f28:	bfcd                	j	80003f1a <sys_dup+0x3c>

0000000080003f2a <sys_read>:
{
    80003f2a:	7179                	addi	sp,sp,-48
    80003f2c:	f406                	sd	ra,40(sp)
    80003f2e:	f022                	sd	s0,32(sp)
    80003f30:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f32:	fd840593          	addi	a1,s0,-40
    80003f36:	4505                	li	a0,1
    80003f38:	d61fd0ef          	jal	80001c98 <argaddr>
  argint(2, &n);
    80003f3c:	fe440593          	addi	a1,s0,-28
    80003f40:	4509                	li	a0,2
    80003f42:	d3bfd0ef          	jal	80001c7c <argint>
  if(argfd(0, 0, &f) < 0)
    80003f46:	fe840613          	addi	a2,s0,-24
    80003f4a:	4581                	li	a1,0
    80003f4c:	4501                	li	a0,0
    80003f4e:	dc1ff0ef          	jal	80003d0e <argfd>
    80003f52:	87aa                	mv	a5,a0
    return -1;
    80003f54:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f56:	0007ca63          	bltz	a5,80003f6a <sys_read+0x40>
  return fileread(f, p, n);
    80003f5a:	fe442603          	lw	a2,-28(s0)
    80003f5e:	fd843583          	ld	a1,-40(s0)
    80003f62:	fe843503          	ld	a0,-24(s0)
    80003f66:	d58ff0ef          	jal	800034be <fileread>
}
    80003f6a:	70a2                	ld	ra,40(sp)
    80003f6c:	7402                	ld	s0,32(sp)
    80003f6e:	6145                	addi	sp,sp,48
    80003f70:	8082                	ret

0000000080003f72 <sys_write>:
{
    80003f72:	7179                	addi	sp,sp,-48
    80003f74:	f406                	sd	ra,40(sp)
    80003f76:	f022                	sd	s0,32(sp)
    80003f78:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003f7a:	fd840593          	addi	a1,s0,-40
    80003f7e:	4505                	li	a0,1
    80003f80:	d19fd0ef          	jal	80001c98 <argaddr>
  argint(2, &n);
    80003f84:	fe440593          	addi	a1,s0,-28
    80003f88:	4509                	li	a0,2
    80003f8a:	cf3fd0ef          	jal	80001c7c <argint>
  if(argfd(0, 0, &f) < 0)
    80003f8e:	fe840613          	addi	a2,s0,-24
    80003f92:	4581                	li	a1,0
    80003f94:	4501                	li	a0,0
    80003f96:	d79ff0ef          	jal	80003d0e <argfd>
    80003f9a:	87aa                	mv	a5,a0
    return -1;
    80003f9c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f9e:	0007ca63          	bltz	a5,80003fb2 <sys_write+0x40>
  return filewrite(f, p, n);
    80003fa2:	fe442603          	lw	a2,-28(s0)
    80003fa6:	fd843583          	ld	a1,-40(s0)
    80003faa:	fe843503          	ld	a0,-24(s0)
    80003fae:	dceff0ef          	jal	8000357c <filewrite>
}
    80003fb2:	70a2                	ld	ra,40(sp)
    80003fb4:	7402                	ld	s0,32(sp)
    80003fb6:	6145                	addi	sp,sp,48
    80003fb8:	8082                	ret

0000000080003fba <sys_close>:
{
    80003fba:	1101                	addi	sp,sp,-32
    80003fbc:	ec06                	sd	ra,24(sp)
    80003fbe:	e822                	sd	s0,16(sp)
    80003fc0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003fc2:	fe040613          	addi	a2,s0,-32
    80003fc6:	fec40593          	addi	a1,s0,-20
    80003fca:	4501                	li	a0,0
    80003fcc:	d43ff0ef          	jal	80003d0e <argfd>
    return -1;
    80003fd0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003fd2:	02054063          	bltz	a0,80003ff2 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003fd6:	dc3fc0ef          	jal	80000d98 <myproc>
    80003fda:	fec42783          	lw	a5,-20(s0)
    80003fde:	07e9                	addi	a5,a5,26
    80003fe0:	078e                	slli	a5,a5,0x3
    80003fe2:	953e                	add	a0,a0,a5
    80003fe4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003fe8:	fe043503          	ld	a0,-32(s0)
    80003fec:	bb2ff0ef          	jal	8000339e <fileclose>
  return 0;
    80003ff0:	4781                	li	a5,0
}
    80003ff2:	853e                	mv	a0,a5
    80003ff4:	60e2                	ld	ra,24(sp)
    80003ff6:	6442                	ld	s0,16(sp)
    80003ff8:	6105                	addi	sp,sp,32
    80003ffa:	8082                	ret

0000000080003ffc <sys_fstat>:
{
    80003ffc:	1101                	addi	sp,sp,-32
    80003ffe:	ec06                	sd	ra,24(sp)
    80004000:	e822                	sd	s0,16(sp)
    80004002:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004004:	fe040593          	addi	a1,s0,-32
    80004008:	4505                	li	a0,1
    8000400a:	c8ffd0ef          	jal	80001c98 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000400e:	fe840613          	addi	a2,s0,-24
    80004012:	4581                	li	a1,0
    80004014:	4501                	li	a0,0
    80004016:	cf9ff0ef          	jal	80003d0e <argfd>
    8000401a:	87aa                	mv	a5,a0
    return -1;
    8000401c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000401e:	0007c863          	bltz	a5,8000402e <sys_fstat+0x32>
  return filestat(f, st);
    80004022:	fe043583          	ld	a1,-32(s0)
    80004026:	fe843503          	ld	a0,-24(s0)
    8000402a:	c36ff0ef          	jal	80003460 <filestat>
}
    8000402e:	60e2                	ld	ra,24(sp)
    80004030:	6442                	ld	s0,16(sp)
    80004032:	6105                	addi	sp,sp,32
    80004034:	8082                	ret

0000000080004036 <sys_link>:
{
    80004036:	7169                	addi	sp,sp,-304
    80004038:	f606                	sd	ra,296(sp)
    8000403a:	f222                	sd	s0,288(sp)
    8000403c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000403e:	08000613          	li	a2,128
    80004042:	ed040593          	addi	a1,s0,-304
    80004046:	4501                	li	a0,0
    80004048:	c6dfd0ef          	jal	80001cb4 <argstr>
    return -1;
    8000404c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000404e:	0c054e63          	bltz	a0,8000412a <sys_link+0xf4>
    80004052:	08000613          	li	a2,128
    80004056:	f5040593          	addi	a1,s0,-176
    8000405a:	4505                	li	a0,1
    8000405c:	c59fd0ef          	jal	80001cb4 <argstr>
    return -1;
    80004060:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004062:	0c054463          	bltz	a0,8000412a <sys_link+0xf4>
    80004066:	ee26                	sd	s1,280(sp)
  begin_op();
    80004068:	f1dfe0ef          	jal	80002f84 <begin_op>
  if((ip = namei(old)) == 0){
    8000406c:	ed040513          	addi	a0,s0,-304
    80004070:	d59fe0ef          	jal	80002dc8 <namei>
    80004074:	84aa                	mv	s1,a0
    80004076:	c53d                	beqz	a0,800040e4 <sys_link+0xae>
  ilock(ip);
    80004078:	e76fe0ef          	jal	800026ee <ilock>
  if(ip->type == T_DIR){
    8000407c:	04449703          	lh	a4,68(s1)
    80004080:	4785                	li	a5,1
    80004082:	06f70663          	beq	a4,a5,800040ee <sys_link+0xb8>
    80004086:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004088:	04a4d783          	lhu	a5,74(s1)
    8000408c:	2785                	addiw	a5,a5,1
    8000408e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004092:	8526                	mv	a0,s1
    80004094:	da6fe0ef          	jal	8000263a <iupdate>
  iunlock(ip);
    80004098:	8526                	mv	a0,s1
    8000409a:	f02fe0ef          	jal	8000279c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000409e:	fd040593          	addi	a1,s0,-48
    800040a2:	f5040513          	addi	a0,s0,-176
    800040a6:	d3dfe0ef          	jal	80002de2 <nameiparent>
    800040aa:	892a                	mv	s2,a0
    800040ac:	cd21                	beqz	a0,80004104 <sys_link+0xce>
  ilock(dp);
    800040ae:	e40fe0ef          	jal	800026ee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800040b2:	00092703          	lw	a4,0(s2)
    800040b6:	409c                	lw	a5,0(s1)
    800040b8:	04f71363          	bne	a4,a5,800040fe <sys_link+0xc8>
    800040bc:	40d0                	lw	a2,4(s1)
    800040be:	fd040593          	addi	a1,s0,-48
    800040c2:	854a                	mv	a0,s2
    800040c4:	c6bfe0ef          	jal	80002d2e <dirlink>
    800040c8:	02054b63          	bltz	a0,800040fe <sys_link+0xc8>
  iunlockput(dp);
    800040cc:	854a                	mv	a0,s2
    800040ce:	82bfe0ef          	jal	800028f8 <iunlockput>
  iput(ip);
    800040d2:	8526                	mv	a0,s1
    800040d4:	f9cfe0ef          	jal	80002870 <iput>
  end_op();
    800040d8:	f17fe0ef          	jal	80002fee <end_op>
  return 0;
    800040dc:	4781                	li	a5,0
    800040de:	64f2                	ld	s1,280(sp)
    800040e0:	6952                	ld	s2,272(sp)
    800040e2:	a0a1                	j	8000412a <sys_link+0xf4>
    end_op();
    800040e4:	f0bfe0ef          	jal	80002fee <end_op>
    return -1;
    800040e8:	57fd                	li	a5,-1
    800040ea:	64f2                	ld	s1,280(sp)
    800040ec:	a83d                	j	8000412a <sys_link+0xf4>
    iunlockput(ip);
    800040ee:	8526                	mv	a0,s1
    800040f0:	809fe0ef          	jal	800028f8 <iunlockput>
    end_op();
    800040f4:	efbfe0ef          	jal	80002fee <end_op>
    return -1;
    800040f8:	57fd                	li	a5,-1
    800040fa:	64f2                	ld	s1,280(sp)
    800040fc:	a03d                	j	8000412a <sys_link+0xf4>
    iunlockput(dp);
    800040fe:	854a                	mv	a0,s2
    80004100:	ff8fe0ef          	jal	800028f8 <iunlockput>
  ilock(ip);
    80004104:	8526                	mv	a0,s1
    80004106:	de8fe0ef          	jal	800026ee <ilock>
  ip->nlink--;
    8000410a:	04a4d783          	lhu	a5,74(s1)
    8000410e:	37fd                	addiw	a5,a5,-1
    80004110:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004114:	8526                	mv	a0,s1
    80004116:	d24fe0ef          	jal	8000263a <iupdate>
  iunlockput(ip);
    8000411a:	8526                	mv	a0,s1
    8000411c:	fdcfe0ef          	jal	800028f8 <iunlockput>
  end_op();
    80004120:	ecffe0ef          	jal	80002fee <end_op>
  return -1;
    80004124:	57fd                	li	a5,-1
    80004126:	64f2                	ld	s1,280(sp)
    80004128:	6952                	ld	s2,272(sp)
}
    8000412a:	853e                	mv	a0,a5
    8000412c:	70b2                	ld	ra,296(sp)
    8000412e:	7412                	ld	s0,288(sp)
    80004130:	6155                	addi	sp,sp,304
    80004132:	8082                	ret

0000000080004134 <sys_unlink>:
{
    80004134:	7151                	addi	sp,sp,-240
    80004136:	f586                	sd	ra,232(sp)
    80004138:	f1a2                	sd	s0,224(sp)
    8000413a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000413c:	08000613          	li	a2,128
    80004140:	f3040593          	addi	a1,s0,-208
    80004144:	4501                	li	a0,0
    80004146:	b6ffd0ef          	jal	80001cb4 <argstr>
    8000414a:	16054063          	bltz	a0,800042aa <sys_unlink+0x176>
    8000414e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004150:	e35fe0ef          	jal	80002f84 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004154:	fb040593          	addi	a1,s0,-80
    80004158:	f3040513          	addi	a0,s0,-208
    8000415c:	c87fe0ef          	jal	80002de2 <nameiparent>
    80004160:	84aa                	mv	s1,a0
    80004162:	c945                	beqz	a0,80004212 <sys_unlink+0xde>
  ilock(dp);
    80004164:	d8afe0ef          	jal	800026ee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004168:	00003597          	auipc	a1,0x3
    8000416c:	4f858593          	addi	a1,a1,1272 # 80007660 <etext+0x660>
    80004170:	fb040513          	addi	a0,s0,-80
    80004174:	9d9fe0ef          	jal	80002b4c <namecmp>
    80004178:	10050e63          	beqz	a0,80004294 <sys_unlink+0x160>
    8000417c:	00003597          	auipc	a1,0x3
    80004180:	4ec58593          	addi	a1,a1,1260 # 80007668 <etext+0x668>
    80004184:	fb040513          	addi	a0,s0,-80
    80004188:	9c5fe0ef          	jal	80002b4c <namecmp>
    8000418c:	10050463          	beqz	a0,80004294 <sys_unlink+0x160>
    80004190:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004192:	f2c40613          	addi	a2,s0,-212
    80004196:	fb040593          	addi	a1,s0,-80
    8000419a:	8526                	mv	a0,s1
    8000419c:	9c7fe0ef          	jal	80002b62 <dirlookup>
    800041a0:	892a                	mv	s2,a0
    800041a2:	0e050863          	beqz	a0,80004292 <sys_unlink+0x15e>
  ilock(ip);
    800041a6:	d48fe0ef          	jal	800026ee <ilock>
  if(ip->nlink < 1)
    800041aa:	04a91783          	lh	a5,74(s2)
    800041ae:	06f05763          	blez	a5,8000421c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800041b2:	04491703          	lh	a4,68(s2)
    800041b6:	4785                	li	a5,1
    800041b8:	06f70963          	beq	a4,a5,8000422a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800041bc:	4641                	li	a2,16
    800041be:	4581                	li	a1,0
    800041c0:	fc040513          	addi	a0,s0,-64
    800041c4:	fb3fb0ef          	jal	80000176 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041c8:	4741                	li	a4,16
    800041ca:	f2c42683          	lw	a3,-212(s0)
    800041ce:	fc040613          	addi	a2,s0,-64
    800041d2:	4581                	li	a1,0
    800041d4:	8526                	mv	a0,s1
    800041d6:	869fe0ef          	jal	80002a3e <writei>
    800041da:	47c1                	li	a5,16
    800041dc:	08f51b63          	bne	a0,a5,80004272 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800041e0:	04491703          	lh	a4,68(s2)
    800041e4:	4785                	li	a5,1
    800041e6:	08f70d63          	beq	a4,a5,80004280 <sys_unlink+0x14c>
  iunlockput(dp);
    800041ea:	8526                	mv	a0,s1
    800041ec:	f0cfe0ef          	jal	800028f8 <iunlockput>
  ip->nlink--;
    800041f0:	04a95783          	lhu	a5,74(s2)
    800041f4:	37fd                	addiw	a5,a5,-1
    800041f6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800041fa:	854a                	mv	a0,s2
    800041fc:	c3efe0ef          	jal	8000263a <iupdate>
  iunlockput(ip);
    80004200:	854a                	mv	a0,s2
    80004202:	ef6fe0ef          	jal	800028f8 <iunlockput>
  end_op();
    80004206:	de9fe0ef          	jal	80002fee <end_op>
  return 0;
    8000420a:	4501                	li	a0,0
    8000420c:	64ee                	ld	s1,216(sp)
    8000420e:	694e                	ld	s2,208(sp)
    80004210:	a849                	j	800042a2 <sys_unlink+0x16e>
    end_op();
    80004212:	dddfe0ef          	jal	80002fee <end_op>
    return -1;
    80004216:	557d                	li	a0,-1
    80004218:	64ee                	ld	s1,216(sp)
    8000421a:	a061                	j	800042a2 <sys_unlink+0x16e>
    8000421c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000421e:	00003517          	auipc	a0,0x3
    80004222:	45250513          	addi	a0,a0,1106 # 80007670 <etext+0x670>
    80004226:	27c010ef          	jal	800054a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000422a:	04c92703          	lw	a4,76(s2)
    8000422e:	02000793          	li	a5,32
    80004232:	f8e7f5e3          	bgeu	a5,a4,800041bc <sys_unlink+0x88>
    80004236:	e5ce                	sd	s3,200(sp)
    80004238:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000423c:	4741                	li	a4,16
    8000423e:	86ce                	mv	a3,s3
    80004240:	f1840613          	addi	a2,s0,-232
    80004244:	4581                	li	a1,0
    80004246:	854a                	mv	a0,s2
    80004248:	efafe0ef          	jal	80002942 <readi>
    8000424c:	47c1                	li	a5,16
    8000424e:	00f51c63          	bne	a0,a5,80004266 <sys_unlink+0x132>
    if(de.inum != 0)
    80004252:	f1845783          	lhu	a5,-232(s0)
    80004256:	efa1                	bnez	a5,800042ae <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004258:	29c1                	addiw	s3,s3,16
    8000425a:	04c92783          	lw	a5,76(s2)
    8000425e:	fcf9efe3          	bltu	s3,a5,8000423c <sys_unlink+0x108>
    80004262:	69ae                	ld	s3,200(sp)
    80004264:	bfa1                	j	800041bc <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004266:	00003517          	auipc	a0,0x3
    8000426a:	42250513          	addi	a0,a0,1058 # 80007688 <etext+0x688>
    8000426e:	234010ef          	jal	800054a2 <panic>
    80004272:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004274:	00003517          	auipc	a0,0x3
    80004278:	42c50513          	addi	a0,a0,1068 # 800076a0 <etext+0x6a0>
    8000427c:	226010ef          	jal	800054a2 <panic>
    dp->nlink--;
    80004280:	04a4d783          	lhu	a5,74(s1)
    80004284:	37fd                	addiw	a5,a5,-1
    80004286:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000428a:	8526                	mv	a0,s1
    8000428c:	baefe0ef          	jal	8000263a <iupdate>
    80004290:	bfa9                	j	800041ea <sys_unlink+0xb6>
    80004292:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004294:	8526                	mv	a0,s1
    80004296:	e62fe0ef          	jal	800028f8 <iunlockput>
  end_op();
    8000429a:	d55fe0ef          	jal	80002fee <end_op>
  return -1;
    8000429e:	557d                	li	a0,-1
    800042a0:	64ee                	ld	s1,216(sp)
}
    800042a2:	70ae                	ld	ra,232(sp)
    800042a4:	740e                	ld	s0,224(sp)
    800042a6:	616d                	addi	sp,sp,240
    800042a8:	8082                	ret
    return -1;
    800042aa:	557d                	li	a0,-1
    800042ac:	bfdd                	j	800042a2 <sys_unlink+0x16e>
    iunlockput(ip);
    800042ae:	854a                	mv	a0,s2
    800042b0:	e48fe0ef          	jal	800028f8 <iunlockput>
    goto bad;
    800042b4:	694e                	ld	s2,208(sp)
    800042b6:	69ae                	ld	s3,200(sp)
    800042b8:	bff1                	j	80004294 <sys_unlink+0x160>

00000000800042ba <sys_open>:

uint64
sys_open(void)
{
    800042ba:	7131                	addi	sp,sp,-192
    800042bc:	fd06                	sd	ra,184(sp)
    800042be:	f922                	sd	s0,176(sp)
    800042c0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800042c2:	f4c40593          	addi	a1,s0,-180
    800042c6:	4505                	li	a0,1
    800042c8:	9b5fd0ef          	jal	80001c7c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042cc:	08000613          	li	a2,128
    800042d0:	f5040593          	addi	a1,s0,-176
    800042d4:	4501                	li	a0,0
    800042d6:	9dffd0ef          	jal	80001cb4 <argstr>
    800042da:	87aa                	mv	a5,a0
    return -1;
    800042dc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800042de:	0a07c263          	bltz	a5,80004382 <sys_open+0xc8>
    800042e2:	f526                	sd	s1,168(sp)

  begin_op();
    800042e4:	ca1fe0ef          	jal	80002f84 <begin_op>

  if(omode & O_CREATE){
    800042e8:	f4c42783          	lw	a5,-180(s0)
    800042ec:	2007f793          	andi	a5,a5,512
    800042f0:	c3d5                	beqz	a5,80004394 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800042f2:	4681                	li	a3,0
    800042f4:	4601                	li	a2,0
    800042f6:	4589                	li	a1,2
    800042f8:	f5040513          	addi	a0,s0,-176
    800042fc:	aa9ff0ef          	jal	80003da4 <create>
    80004300:	84aa                	mv	s1,a0
    if(ip == 0){
    80004302:	c541                	beqz	a0,8000438a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004304:	04449703          	lh	a4,68(s1)
    80004308:	478d                	li	a5,3
    8000430a:	00f71763          	bne	a4,a5,80004318 <sys_open+0x5e>
    8000430e:	0464d703          	lhu	a4,70(s1)
    80004312:	47a5                	li	a5,9
    80004314:	0ae7ed63          	bltu	a5,a4,800043ce <sys_open+0x114>
    80004318:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000431a:	fe1fe0ef          	jal	800032fa <filealloc>
    8000431e:	892a                	mv	s2,a0
    80004320:	c179                	beqz	a0,800043e6 <sys_open+0x12c>
    80004322:	ed4e                	sd	s3,152(sp)
    80004324:	a43ff0ef          	jal	80003d66 <fdalloc>
    80004328:	89aa                	mv	s3,a0
    8000432a:	0a054a63          	bltz	a0,800043de <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000432e:	04449703          	lh	a4,68(s1)
    80004332:	478d                	li	a5,3
    80004334:	0cf70263          	beq	a4,a5,800043f8 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004338:	4789                	li	a5,2
    8000433a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000433e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004342:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004346:	f4c42783          	lw	a5,-180(s0)
    8000434a:	0017c713          	xori	a4,a5,1
    8000434e:	8b05                	andi	a4,a4,1
    80004350:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004354:	0037f713          	andi	a4,a5,3
    80004358:	00e03733          	snez	a4,a4
    8000435c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004360:	4007f793          	andi	a5,a5,1024
    80004364:	c791                	beqz	a5,80004370 <sys_open+0xb6>
    80004366:	04449703          	lh	a4,68(s1)
    8000436a:	4789                	li	a5,2
    8000436c:	08f70d63          	beq	a4,a5,80004406 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004370:	8526                	mv	a0,s1
    80004372:	c2afe0ef          	jal	8000279c <iunlock>
  end_op();
    80004376:	c79fe0ef          	jal	80002fee <end_op>

  return fd;
    8000437a:	854e                	mv	a0,s3
    8000437c:	74aa                	ld	s1,168(sp)
    8000437e:	790a                	ld	s2,160(sp)
    80004380:	69ea                	ld	s3,152(sp)
}
    80004382:	70ea                	ld	ra,184(sp)
    80004384:	744a                	ld	s0,176(sp)
    80004386:	6129                	addi	sp,sp,192
    80004388:	8082                	ret
      end_op();
    8000438a:	c65fe0ef          	jal	80002fee <end_op>
      return -1;
    8000438e:	557d                	li	a0,-1
    80004390:	74aa                	ld	s1,168(sp)
    80004392:	bfc5                	j	80004382 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004394:	f5040513          	addi	a0,s0,-176
    80004398:	a31fe0ef          	jal	80002dc8 <namei>
    8000439c:	84aa                	mv	s1,a0
    8000439e:	c11d                	beqz	a0,800043c4 <sys_open+0x10a>
    ilock(ip);
    800043a0:	b4efe0ef          	jal	800026ee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800043a4:	04449703          	lh	a4,68(s1)
    800043a8:	4785                	li	a5,1
    800043aa:	f4f71de3          	bne	a4,a5,80004304 <sys_open+0x4a>
    800043ae:	f4c42783          	lw	a5,-180(s0)
    800043b2:	d3bd                	beqz	a5,80004318 <sys_open+0x5e>
      iunlockput(ip);
    800043b4:	8526                	mv	a0,s1
    800043b6:	d42fe0ef          	jal	800028f8 <iunlockput>
      end_op();
    800043ba:	c35fe0ef          	jal	80002fee <end_op>
      return -1;
    800043be:	557d                	li	a0,-1
    800043c0:	74aa                	ld	s1,168(sp)
    800043c2:	b7c1                	j	80004382 <sys_open+0xc8>
      end_op();
    800043c4:	c2bfe0ef          	jal	80002fee <end_op>
      return -1;
    800043c8:	557d                	li	a0,-1
    800043ca:	74aa                	ld	s1,168(sp)
    800043cc:	bf5d                	j	80004382 <sys_open+0xc8>
    iunlockput(ip);
    800043ce:	8526                	mv	a0,s1
    800043d0:	d28fe0ef          	jal	800028f8 <iunlockput>
    end_op();
    800043d4:	c1bfe0ef          	jal	80002fee <end_op>
    return -1;
    800043d8:	557d                	li	a0,-1
    800043da:	74aa                	ld	s1,168(sp)
    800043dc:	b75d                	j	80004382 <sys_open+0xc8>
      fileclose(f);
    800043de:	854a                	mv	a0,s2
    800043e0:	fbffe0ef          	jal	8000339e <fileclose>
    800043e4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800043e6:	8526                	mv	a0,s1
    800043e8:	d10fe0ef          	jal	800028f8 <iunlockput>
    end_op();
    800043ec:	c03fe0ef          	jal	80002fee <end_op>
    return -1;
    800043f0:	557d                	li	a0,-1
    800043f2:	74aa                	ld	s1,168(sp)
    800043f4:	790a                	ld	s2,160(sp)
    800043f6:	b771                	j	80004382 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800043f8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800043fc:	04649783          	lh	a5,70(s1)
    80004400:	02f91223          	sh	a5,36(s2)
    80004404:	bf3d                	j	80004342 <sys_open+0x88>
    itrunc(ip);
    80004406:	8526                	mv	a0,s1
    80004408:	bd4fe0ef          	jal	800027dc <itrunc>
    8000440c:	b795                	j	80004370 <sys_open+0xb6>

000000008000440e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000440e:	7175                	addi	sp,sp,-144
    80004410:	e506                	sd	ra,136(sp)
    80004412:	e122                	sd	s0,128(sp)
    80004414:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004416:	b6ffe0ef          	jal	80002f84 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000441a:	08000613          	li	a2,128
    8000441e:	f7040593          	addi	a1,s0,-144
    80004422:	4501                	li	a0,0
    80004424:	891fd0ef          	jal	80001cb4 <argstr>
    80004428:	02054363          	bltz	a0,8000444e <sys_mkdir+0x40>
    8000442c:	4681                	li	a3,0
    8000442e:	4601                	li	a2,0
    80004430:	4585                	li	a1,1
    80004432:	f7040513          	addi	a0,s0,-144
    80004436:	96fff0ef          	jal	80003da4 <create>
    8000443a:	c911                	beqz	a0,8000444e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000443c:	cbcfe0ef          	jal	800028f8 <iunlockput>
  end_op();
    80004440:	baffe0ef          	jal	80002fee <end_op>
  return 0;
    80004444:	4501                	li	a0,0
}
    80004446:	60aa                	ld	ra,136(sp)
    80004448:	640a                	ld	s0,128(sp)
    8000444a:	6149                	addi	sp,sp,144
    8000444c:	8082                	ret
    end_op();
    8000444e:	ba1fe0ef          	jal	80002fee <end_op>
    return -1;
    80004452:	557d                	li	a0,-1
    80004454:	bfcd                	j	80004446 <sys_mkdir+0x38>

0000000080004456 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004456:	7135                	addi	sp,sp,-160
    80004458:	ed06                	sd	ra,152(sp)
    8000445a:	e922                	sd	s0,144(sp)
    8000445c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000445e:	b27fe0ef          	jal	80002f84 <begin_op>
  argint(1, &major);
    80004462:	f6c40593          	addi	a1,s0,-148
    80004466:	4505                	li	a0,1
    80004468:	815fd0ef          	jal	80001c7c <argint>
  argint(2, &minor);
    8000446c:	f6840593          	addi	a1,s0,-152
    80004470:	4509                	li	a0,2
    80004472:	80bfd0ef          	jal	80001c7c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004476:	08000613          	li	a2,128
    8000447a:	f7040593          	addi	a1,s0,-144
    8000447e:	4501                	li	a0,0
    80004480:	835fd0ef          	jal	80001cb4 <argstr>
    80004484:	02054563          	bltz	a0,800044ae <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004488:	f6841683          	lh	a3,-152(s0)
    8000448c:	f6c41603          	lh	a2,-148(s0)
    80004490:	458d                	li	a1,3
    80004492:	f7040513          	addi	a0,s0,-144
    80004496:	90fff0ef          	jal	80003da4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000449a:	c911                	beqz	a0,800044ae <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000449c:	c5cfe0ef          	jal	800028f8 <iunlockput>
  end_op();
    800044a0:	b4ffe0ef          	jal	80002fee <end_op>
  return 0;
    800044a4:	4501                	li	a0,0
}
    800044a6:	60ea                	ld	ra,152(sp)
    800044a8:	644a                	ld	s0,144(sp)
    800044aa:	610d                	addi	sp,sp,160
    800044ac:	8082                	ret
    end_op();
    800044ae:	b41fe0ef          	jal	80002fee <end_op>
    return -1;
    800044b2:	557d                	li	a0,-1
    800044b4:	bfcd                	j	800044a6 <sys_mknod+0x50>

00000000800044b6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800044b6:	7135                	addi	sp,sp,-160
    800044b8:	ed06                	sd	ra,152(sp)
    800044ba:	e922                	sd	s0,144(sp)
    800044bc:	e14a                	sd	s2,128(sp)
    800044be:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800044c0:	8d9fc0ef          	jal	80000d98 <myproc>
    800044c4:	892a                	mv	s2,a0
  
  begin_op();
    800044c6:	abffe0ef          	jal	80002f84 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800044ca:	08000613          	li	a2,128
    800044ce:	f6040593          	addi	a1,s0,-160
    800044d2:	4501                	li	a0,0
    800044d4:	fe0fd0ef          	jal	80001cb4 <argstr>
    800044d8:	04054363          	bltz	a0,8000451e <sys_chdir+0x68>
    800044dc:	e526                	sd	s1,136(sp)
    800044de:	f6040513          	addi	a0,s0,-160
    800044e2:	8e7fe0ef          	jal	80002dc8 <namei>
    800044e6:	84aa                	mv	s1,a0
    800044e8:	c915                	beqz	a0,8000451c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800044ea:	a04fe0ef          	jal	800026ee <ilock>
  if(ip->type != T_DIR){
    800044ee:	04449703          	lh	a4,68(s1)
    800044f2:	4785                	li	a5,1
    800044f4:	02f71963          	bne	a4,a5,80004526 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800044f8:	8526                	mv	a0,s1
    800044fa:	aa2fe0ef          	jal	8000279c <iunlock>
  iput(p->cwd);
    800044fe:	15093503          	ld	a0,336(s2)
    80004502:	b6efe0ef          	jal	80002870 <iput>
  end_op();
    80004506:	ae9fe0ef          	jal	80002fee <end_op>
  p->cwd = ip;
    8000450a:	14993823          	sd	s1,336(s2)
  return 0;
    8000450e:	4501                	li	a0,0
    80004510:	64aa                	ld	s1,136(sp)
}
    80004512:	60ea                	ld	ra,152(sp)
    80004514:	644a                	ld	s0,144(sp)
    80004516:	690a                	ld	s2,128(sp)
    80004518:	610d                	addi	sp,sp,160
    8000451a:	8082                	ret
    8000451c:	64aa                	ld	s1,136(sp)
    end_op();
    8000451e:	ad1fe0ef          	jal	80002fee <end_op>
    return -1;
    80004522:	557d                	li	a0,-1
    80004524:	b7fd                	j	80004512 <sys_chdir+0x5c>
    iunlockput(ip);
    80004526:	8526                	mv	a0,s1
    80004528:	bd0fe0ef          	jal	800028f8 <iunlockput>
    end_op();
    8000452c:	ac3fe0ef          	jal	80002fee <end_op>
    return -1;
    80004530:	557d                	li	a0,-1
    80004532:	64aa                	ld	s1,136(sp)
    80004534:	bff9                	j	80004512 <sys_chdir+0x5c>

0000000080004536 <sys_exec>:

uint64
sys_exec(void)
{
    80004536:	7121                	addi	sp,sp,-448
    80004538:	ff06                	sd	ra,440(sp)
    8000453a:	fb22                	sd	s0,432(sp)
    8000453c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000453e:	e4840593          	addi	a1,s0,-440
    80004542:	4505                	li	a0,1
    80004544:	f54fd0ef          	jal	80001c98 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004548:	08000613          	li	a2,128
    8000454c:	f5040593          	addi	a1,s0,-176
    80004550:	4501                	li	a0,0
    80004552:	f62fd0ef          	jal	80001cb4 <argstr>
    80004556:	87aa                	mv	a5,a0
    return -1;
    80004558:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000455a:	0c07c463          	bltz	a5,80004622 <sys_exec+0xec>
    8000455e:	f726                	sd	s1,424(sp)
    80004560:	f34a                	sd	s2,416(sp)
    80004562:	ef4e                	sd	s3,408(sp)
    80004564:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004566:	10000613          	li	a2,256
    8000456a:	4581                	li	a1,0
    8000456c:	e5040513          	addi	a0,s0,-432
    80004570:	c07fb0ef          	jal	80000176 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004574:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004578:	89a6                	mv	s3,s1
    8000457a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000457c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004580:	00391513          	slli	a0,s2,0x3
    80004584:	e4040593          	addi	a1,s0,-448
    80004588:	e4843783          	ld	a5,-440(s0)
    8000458c:	953e                	add	a0,a0,a5
    8000458e:	e64fd0ef          	jal	80001bf2 <fetchaddr>
    80004592:	02054663          	bltz	a0,800045be <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004596:	e4043783          	ld	a5,-448(s0)
    8000459a:	c3a9                	beqz	a5,800045dc <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000459c:	b5bfb0ef          	jal	800000f6 <kalloc>
    800045a0:	85aa                	mv	a1,a0
    800045a2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800045a6:	cd01                	beqz	a0,800045be <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800045a8:	6605                	lui	a2,0x1
    800045aa:	e4043503          	ld	a0,-448(s0)
    800045ae:	e8efd0ef          	jal	80001c3c <fetchstr>
    800045b2:	00054663          	bltz	a0,800045be <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800045b6:	0905                	addi	s2,s2,1
    800045b8:	09a1                	addi	s3,s3,8
    800045ba:	fd4913e3          	bne	s2,s4,80004580 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045be:	f5040913          	addi	s2,s0,-176
    800045c2:	6088                	ld	a0,0(s1)
    800045c4:	c931                	beqz	a0,80004618 <sys_exec+0xe2>
    kfree(argv[i]);
    800045c6:	a57fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045ca:	04a1                	addi	s1,s1,8
    800045cc:	ff249be3          	bne	s1,s2,800045c2 <sys_exec+0x8c>
  return -1;
    800045d0:	557d                	li	a0,-1
    800045d2:	74ba                	ld	s1,424(sp)
    800045d4:	791a                	ld	s2,416(sp)
    800045d6:	69fa                	ld	s3,408(sp)
    800045d8:	6a5a                	ld	s4,400(sp)
    800045da:	a0a1                	j	80004622 <sys_exec+0xec>
      argv[i] = 0;
    800045dc:	0009079b          	sext.w	a5,s2
    800045e0:	078e                	slli	a5,a5,0x3
    800045e2:	fd078793          	addi	a5,a5,-48
    800045e6:	97a2                	add	a5,a5,s0
    800045e8:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800045ec:	e5040593          	addi	a1,s0,-432
    800045f0:	f5040513          	addi	a0,s0,-176
    800045f4:	ba8ff0ef          	jal	8000399c <exec>
    800045f8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800045fa:	f5040993          	addi	s3,s0,-176
    800045fe:	6088                	ld	a0,0(s1)
    80004600:	c511                	beqz	a0,8000460c <sys_exec+0xd6>
    kfree(argv[i]);
    80004602:	a1bfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004606:	04a1                	addi	s1,s1,8
    80004608:	ff349be3          	bne	s1,s3,800045fe <sys_exec+0xc8>
  return ret;
    8000460c:	854a                	mv	a0,s2
    8000460e:	74ba                	ld	s1,424(sp)
    80004610:	791a                	ld	s2,416(sp)
    80004612:	69fa                	ld	s3,408(sp)
    80004614:	6a5a                	ld	s4,400(sp)
    80004616:	a031                	j	80004622 <sys_exec+0xec>
  return -1;
    80004618:	557d                	li	a0,-1
    8000461a:	74ba                	ld	s1,424(sp)
    8000461c:	791a                	ld	s2,416(sp)
    8000461e:	69fa                	ld	s3,408(sp)
    80004620:	6a5a                	ld	s4,400(sp)
}
    80004622:	70fa                	ld	ra,440(sp)
    80004624:	745a                	ld	s0,432(sp)
    80004626:	6139                	addi	sp,sp,448
    80004628:	8082                	ret

000000008000462a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000462a:	7139                	addi	sp,sp,-64
    8000462c:	fc06                	sd	ra,56(sp)
    8000462e:	f822                	sd	s0,48(sp)
    80004630:	f426                	sd	s1,40(sp)
    80004632:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004634:	f64fc0ef          	jal	80000d98 <myproc>
    80004638:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000463a:	fd840593          	addi	a1,s0,-40
    8000463e:	4501                	li	a0,0
    80004640:	e58fd0ef          	jal	80001c98 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004644:	fc840593          	addi	a1,s0,-56
    80004648:	fd040513          	addi	a0,s0,-48
    8000464c:	85cff0ef          	jal	800036a8 <pipealloc>
    return -1;
    80004650:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004652:	0a054463          	bltz	a0,800046fa <sys_pipe+0xd0>
  fd0 = -1;
    80004656:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000465a:	fd043503          	ld	a0,-48(s0)
    8000465e:	f08ff0ef          	jal	80003d66 <fdalloc>
    80004662:	fca42223          	sw	a0,-60(s0)
    80004666:	08054163          	bltz	a0,800046e8 <sys_pipe+0xbe>
    8000466a:	fc843503          	ld	a0,-56(s0)
    8000466e:	ef8ff0ef          	jal	80003d66 <fdalloc>
    80004672:	fca42023          	sw	a0,-64(s0)
    80004676:	06054063          	bltz	a0,800046d6 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000467a:	4691                	li	a3,4
    8000467c:	fc440613          	addi	a2,s0,-60
    80004680:	fd843583          	ld	a1,-40(s0)
    80004684:	68a8                	ld	a0,80(s1)
    80004686:	b82fc0ef          	jal	80000a08 <copyout>
    8000468a:	00054e63          	bltz	a0,800046a6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000468e:	4691                	li	a3,4
    80004690:	fc040613          	addi	a2,s0,-64
    80004694:	fd843583          	ld	a1,-40(s0)
    80004698:	0591                	addi	a1,a1,4
    8000469a:	68a8                	ld	a0,80(s1)
    8000469c:	b6cfc0ef          	jal	80000a08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800046a0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046a2:	04055c63          	bgez	a0,800046fa <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800046a6:	fc442783          	lw	a5,-60(s0)
    800046aa:	07e9                	addi	a5,a5,26
    800046ac:	078e                	slli	a5,a5,0x3
    800046ae:	97a6                	add	a5,a5,s1
    800046b0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800046b4:	fc042783          	lw	a5,-64(s0)
    800046b8:	07e9                	addi	a5,a5,26
    800046ba:	078e                	slli	a5,a5,0x3
    800046bc:	94be                	add	s1,s1,a5
    800046be:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800046c2:	fd043503          	ld	a0,-48(s0)
    800046c6:	cd9fe0ef          	jal	8000339e <fileclose>
    fileclose(wf);
    800046ca:	fc843503          	ld	a0,-56(s0)
    800046ce:	cd1fe0ef          	jal	8000339e <fileclose>
    return -1;
    800046d2:	57fd                	li	a5,-1
    800046d4:	a01d                	j	800046fa <sys_pipe+0xd0>
    if(fd0 >= 0)
    800046d6:	fc442783          	lw	a5,-60(s0)
    800046da:	0007c763          	bltz	a5,800046e8 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800046de:	07e9                	addi	a5,a5,26
    800046e0:	078e                	slli	a5,a5,0x3
    800046e2:	97a6                	add	a5,a5,s1
    800046e4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800046e8:	fd043503          	ld	a0,-48(s0)
    800046ec:	cb3fe0ef          	jal	8000339e <fileclose>
    fileclose(wf);
    800046f0:	fc843503          	ld	a0,-56(s0)
    800046f4:	cabfe0ef          	jal	8000339e <fileclose>
    return -1;
    800046f8:	57fd                	li	a5,-1
}
    800046fa:	853e                	mv	a0,a5
    800046fc:	70e2                	ld	ra,56(sp)
    800046fe:	7442                	ld	s0,48(sp)
    80004700:	74a2                	ld	s1,40(sp)
    80004702:	6121                	addi	sp,sp,64
    80004704:	8082                	ret
	...

0000000080004710 <kernelvec>:
    80004710:	7111                	addi	sp,sp,-256
    80004712:	e006                	sd	ra,0(sp)
    80004714:	e40a                	sd	sp,8(sp)
    80004716:	e80e                	sd	gp,16(sp)
    80004718:	ec12                	sd	tp,24(sp)
    8000471a:	f016                	sd	t0,32(sp)
    8000471c:	f41a                	sd	t1,40(sp)
    8000471e:	f81e                	sd	t2,48(sp)
    80004720:	e4aa                	sd	a0,72(sp)
    80004722:	e8ae                	sd	a1,80(sp)
    80004724:	ecb2                	sd	a2,88(sp)
    80004726:	f0b6                	sd	a3,96(sp)
    80004728:	f4ba                	sd	a4,104(sp)
    8000472a:	f8be                	sd	a5,112(sp)
    8000472c:	fcc2                	sd	a6,120(sp)
    8000472e:	e146                	sd	a7,128(sp)
    80004730:	edf2                	sd	t3,216(sp)
    80004732:	f1f6                	sd	t4,224(sp)
    80004734:	f5fa                	sd	t5,232(sp)
    80004736:	f9fe                	sd	t6,240(sp)
    80004738:	bcafd0ef          	jal	80001b02 <kerneltrap>
    8000473c:	6082                	ld	ra,0(sp)
    8000473e:	6122                	ld	sp,8(sp)
    80004740:	61c2                	ld	gp,16(sp)
    80004742:	7282                	ld	t0,32(sp)
    80004744:	7322                	ld	t1,40(sp)
    80004746:	73c2                	ld	t2,48(sp)
    80004748:	6526                	ld	a0,72(sp)
    8000474a:	65c6                	ld	a1,80(sp)
    8000474c:	6666                	ld	a2,88(sp)
    8000474e:	7686                	ld	a3,96(sp)
    80004750:	7726                	ld	a4,104(sp)
    80004752:	77c6                	ld	a5,112(sp)
    80004754:	7866                	ld	a6,120(sp)
    80004756:	688a                	ld	a7,128(sp)
    80004758:	6e6e                	ld	t3,216(sp)
    8000475a:	7e8e                	ld	t4,224(sp)
    8000475c:	7f2e                	ld	t5,232(sp)
    8000475e:	7fce                	ld	t6,240(sp)
    80004760:	6111                	addi	sp,sp,256
    80004762:	10200073          	sret
	...

000000008000476e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000476e:	1141                	addi	sp,sp,-16
    80004770:	e422                	sd	s0,8(sp)
    80004772:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004774:	0c0007b7          	lui	a5,0xc000
    80004778:	4705                	li	a4,1
    8000477a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000477c:	0c0007b7          	lui	a5,0xc000
    80004780:	c3d8                	sw	a4,4(a5)
}
    80004782:	6422                	ld	s0,8(sp)
    80004784:	0141                	addi	sp,sp,16
    80004786:	8082                	ret

0000000080004788 <plicinithart>:

void
plicinithart(void)
{
    80004788:	1141                	addi	sp,sp,-16
    8000478a:	e406                	sd	ra,8(sp)
    8000478c:	e022                	sd	s0,0(sp)
    8000478e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004790:	ddcfc0ef          	jal	80000d6c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004794:	0085171b          	slliw	a4,a0,0x8
    80004798:	0c0027b7          	lui	a5,0xc002
    8000479c:	97ba                	add	a5,a5,a4
    8000479e:	40200713          	li	a4,1026
    800047a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800047a6:	00d5151b          	slliw	a0,a0,0xd
    800047aa:	0c2017b7          	lui	a5,0xc201
    800047ae:	97aa                	add	a5,a5,a0
    800047b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800047b4:	60a2                	ld	ra,8(sp)
    800047b6:	6402                	ld	s0,0(sp)
    800047b8:	0141                	addi	sp,sp,16
    800047ba:	8082                	ret

00000000800047bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800047bc:	1141                	addi	sp,sp,-16
    800047be:	e406                	sd	ra,8(sp)
    800047c0:	e022                	sd	s0,0(sp)
    800047c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047c4:	da8fc0ef          	jal	80000d6c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800047c8:	00d5151b          	slliw	a0,a0,0xd
    800047cc:	0c2017b7          	lui	a5,0xc201
    800047d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800047d2:	43c8                	lw	a0,4(a5)
    800047d4:	60a2                	ld	ra,8(sp)
    800047d6:	6402                	ld	s0,0(sp)
    800047d8:	0141                	addi	sp,sp,16
    800047da:	8082                	ret

00000000800047dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800047dc:	1101                	addi	sp,sp,-32
    800047de:	ec06                	sd	ra,24(sp)
    800047e0:	e822                	sd	s0,16(sp)
    800047e2:	e426                	sd	s1,8(sp)
    800047e4:	1000                	addi	s0,sp,32
    800047e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800047e8:	d84fc0ef          	jal	80000d6c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800047ec:	00d5151b          	slliw	a0,a0,0xd
    800047f0:	0c2017b7          	lui	a5,0xc201
    800047f4:	97aa                	add	a5,a5,a0
    800047f6:	c3c4                	sw	s1,4(a5)
}
    800047f8:	60e2                	ld	ra,24(sp)
    800047fa:	6442                	ld	s0,16(sp)
    800047fc:	64a2                	ld	s1,8(sp)
    800047fe:	6105                	addi	sp,sp,32
    80004800:	8082                	ret

0000000080004802 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004802:	1141                	addi	sp,sp,-16
    80004804:	e406                	sd	ra,8(sp)
    80004806:	e022                	sd	s0,0(sp)
    80004808:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000480a:	479d                	li	a5,7
    8000480c:	04a7ca63          	blt	a5,a0,80004860 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004810:	00017797          	auipc	a5,0x17
    80004814:	cd078793          	addi	a5,a5,-816 # 8001b4e0 <disk>
    80004818:	97aa                	add	a5,a5,a0
    8000481a:	0187c783          	lbu	a5,24(a5)
    8000481e:	e7b9                	bnez	a5,8000486c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004820:	00451693          	slli	a3,a0,0x4
    80004824:	00017797          	auipc	a5,0x17
    80004828:	cbc78793          	addi	a5,a5,-836 # 8001b4e0 <disk>
    8000482c:	6398                	ld	a4,0(a5)
    8000482e:	9736                	add	a4,a4,a3
    80004830:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004834:	6398                	ld	a4,0(a5)
    80004836:	9736                	add	a4,a4,a3
    80004838:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000483c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004840:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004844:	97aa                	add	a5,a5,a0
    80004846:	4705                	li	a4,1
    80004848:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000484c:	00017517          	auipc	a0,0x17
    80004850:	cac50513          	addi	a0,a0,-852 # 8001b4f8 <disk+0x18>
    80004854:	b5ffc0ef          	jal	800013b2 <wakeup>
}
    80004858:	60a2                	ld	ra,8(sp)
    8000485a:	6402                	ld	s0,0(sp)
    8000485c:	0141                	addi	sp,sp,16
    8000485e:	8082                	ret
    panic("free_desc 1");
    80004860:	00003517          	auipc	a0,0x3
    80004864:	e5050513          	addi	a0,a0,-432 # 800076b0 <etext+0x6b0>
    80004868:	43b000ef          	jal	800054a2 <panic>
    panic("free_desc 2");
    8000486c:	00003517          	auipc	a0,0x3
    80004870:	e5450513          	addi	a0,a0,-428 # 800076c0 <etext+0x6c0>
    80004874:	42f000ef          	jal	800054a2 <panic>

0000000080004878 <virtio_disk_init>:
{
    80004878:	1101                	addi	sp,sp,-32
    8000487a:	ec06                	sd	ra,24(sp)
    8000487c:	e822                	sd	s0,16(sp)
    8000487e:	e426                	sd	s1,8(sp)
    80004880:	e04a                	sd	s2,0(sp)
    80004882:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004884:	00003597          	auipc	a1,0x3
    80004888:	e4c58593          	addi	a1,a1,-436 # 800076d0 <etext+0x6d0>
    8000488c:	00017517          	auipc	a0,0x17
    80004890:	d7c50513          	addi	a0,a0,-644 # 8001b608 <disk+0x128>
    80004894:	6bd000ef          	jal	80005750 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004898:	100017b7          	lui	a5,0x10001
    8000489c:	4398                	lw	a4,0(a5)
    8000489e:	2701                	sext.w	a4,a4
    800048a0:	747277b7          	lui	a5,0x74727
    800048a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800048a8:	18f71063          	bne	a4,a5,80004a28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048ac:	100017b7          	lui	a5,0x10001
    800048b0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800048b2:	439c                	lw	a5,0(a5)
    800048b4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800048b6:	4709                	li	a4,2
    800048b8:	16e79863          	bne	a5,a4,80004a28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048bc:	100017b7          	lui	a5,0x10001
    800048c0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800048c2:	439c                	lw	a5,0(a5)
    800048c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800048c6:	16e79163          	bne	a5,a4,80004a28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800048ca:	100017b7          	lui	a5,0x10001
    800048ce:	47d8                	lw	a4,12(a5)
    800048d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048d2:	554d47b7          	lui	a5,0x554d4
    800048d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800048da:	14f71763          	bne	a4,a5,80004a28 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048de:	100017b7          	lui	a5,0x10001
    800048e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048e6:	4705                	li	a4,1
    800048e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048ea:	470d                	li	a4,3
    800048ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800048ee:	10001737          	lui	a4,0x10001
    800048f2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800048f4:	c7ffe737          	lui	a4,0xc7ffe
    800048f8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb03f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800048fc:	8ef9                	and	a3,a3,a4
    800048fe:	10001737          	lui	a4,0x10001
    80004902:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004904:	472d                	li	a4,11
    80004906:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004908:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000490c:	439c                	lw	a5,0(a5)
    8000490e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004912:	8ba1                	andi	a5,a5,8
    80004914:	12078063          	beqz	a5,80004a34 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004918:	100017b7          	lui	a5,0x10001
    8000491c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004920:	100017b7          	lui	a5,0x10001
    80004924:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004928:	439c                	lw	a5,0(a5)
    8000492a:	2781                	sext.w	a5,a5
    8000492c:	10079a63          	bnez	a5,80004a40 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004930:	100017b7          	lui	a5,0x10001
    80004934:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004938:	439c                	lw	a5,0(a5)
    8000493a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000493c:	10078863          	beqz	a5,80004a4c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004940:	471d                	li	a4,7
    80004942:	10f77b63          	bgeu	a4,a5,80004a58 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004946:	fb0fb0ef          	jal	800000f6 <kalloc>
    8000494a:	00017497          	auipc	s1,0x17
    8000494e:	b9648493          	addi	s1,s1,-1130 # 8001b4e0 <disk>
    80004952:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004954:	fa2fb0ef          	jal	800000f6 <kalloc>
    80004958:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000495a:	f9cfb0ef          	jal	800000f6 <kalloc>
    8000495e:	87aa                	mv	a5,a0
    80004960:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004962:	6088                	ld	a0,0(s1)
    80004964:	10050063          	beqz	a0,80004a64 <virtio_disk_init+0x1ec>
    80004968:	00017717          	auipc	a4,0x17
    8000496c:	b8073703          	ld	a4,-1152(a4) # 8001b4e8 <disk+0x8>
    80004970:	0e070a63          	beqz	a4,80004a64 <virtio_disk_init+0x1ec>
    80004974:	0e078863          	beqz	a5,80004a64 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004978:	6605                	lui	a2,0x1
    8000497a:	4581                	li	a1,0
    8000497c:	ffafb0ef          	jal	80000176 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004980:	00017497          	auipc	s1,0x17
    80004984:	b6048493          	addi	s1,s1,-1184 # 8001b4e0 <disk>
    80004988:	6605                	lui	a2,0x1
    8000498a:	4581                	li	a1,0
    8000498c:	6488                	ld	a0,8(s1)
    8000498e:	fe8fb0ef          	jal	80000176 <memset>
  memset(disk.used, 0, PGSIZE);
    80004992:	6605                	lui	a2,0x1
    80004994:	4581                	li	a1,0
    80004996:	6888                	ld	a0,16(s1)
    80004998:	fdefb0ef          	jal	80000176 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000499c:	100017b7          	lui	a5,0x10001
    800049a0:	4721                	li	a4,8
    800049a2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800049a4:	4098                	lw	a4,0(s1)
    800049a6:	100017b7          	lui	a5,0x10001
    800049aa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800049ae:	40d8                	lw	a4,4(s1)
    800049b0:	100017b7          	lui	a5,0x10001
    800049b4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800049b8:	649c                	ld	a5,8(s1)
    800049ba:	0007869b          	sext.w	a3,a5
    800049be:	10001737          	lui	a4,0x10001
    800049c2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800049c6:	9781                	srai	a5,a5,0x20
    800049c8:	10001737          	lui	a4,0x10001
    800049cc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800049d0:	689c                	ld	a5,16(s1)
    800049d2:	0007869b          	sext.w	a3,a5
    800049d6:	10001737          	lui	a4,0x10001
    800049da:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800049de:	9781                	srai	a5,a5,0x20
    800049e0:	10001737          	lui	a4,0x10001
    800049e4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800049e8:	10001737          	lui	a4,0x10001
    800049ec:	4785                	li	a5,1
    800049ee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800049f0:	00f48c23          	sb	a5,24(s1)
    800049f4:	00f48ca3          	sb	a5,25(s1)
    800049f8:	00f48d23          	sb	a5,26(s1)
    800049fc:	00f48da3          	sb	a5,27(s1)
    80004a00:	00f48e23          	sb	a5,28(s1)
    80004a04:	00f48ea3          	sb	a5,29(s1)
    80004a08:	00f48f23          	sb	a5,30(s1)
    80004a0c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a10:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a14:	100017b7          	lui	a5,0x10001
    80004a18:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004a1c:	60e2                	ld	ra,24(sp)
    80004a1e:	6442                	ld	s0,16(sp)
    80004a20:	64a2                	ld	s1,8(sp)
    80004a22:	6902                	ld	s2,0(sp)
    80004a24:	6105                	addi	sp,sp,32
    80004a26:	8082                	ret
    panic("could not find virtio disk");
    80004a28:	00003517          	auipc	a0,0x3
    80004a2c:	cb850513          	addi	a0,a0,-840 # 800076e0 <etext+0x6e0>
    80004a30:	273000ef          	jal	800054a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004a34:	00003517          	auipc	a0,0x3
    80004a38:	ccc50513          	addi	a0,a0,-820 # 80007700 <etext+0x700>
    80004a3c:	267000ef          	jal	800054a2 <panic>
    panic("virtio disk should not be ready");
    80004a40:	00003517          	auipc	a0,0x3
    80004a44:	ce050513          	addi	a0,a0,-800 # 80007720 <etext+0x720>
    80004a48:	25b000ef          	jal	800054a2 <panic>
    panic("virtio disk has no queue 0");
    80004a4c:	00003517          	auipc	a0,0x3
    80004a50:	cf450513          	addi	a0,a0,-780 # 80007740 <etext+0x740>
    80004a54:	24f000ef          	jal	800054a2 <panic>
    panic("virtio disk max queue too short");
    80004a58:	00003517          	auipc	a0,0x3
    80004a5c:	d0850513          	addi	a0,a0,-760 # 80007760 <etext+0x760>
    80004a60:	243000ef          	jal	800054a2 <panic>
    panic("virtio disk kalloc");
    80004a64:	00003517          	auipc	a0,0x3
    80004a68:	d1c50513          	addi	a0,a0,-740 # 80007780 <etext+0x780>
    80004a6c:	237000ef          	jal	800054a2 <panic>

0000000080004a70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004a70:	7159                	addi	sp,sp,-112
    80004a72:	f486                	sd	ra,104(sp)
    80004a74:	f0a2                	sd	s0,96(sp)
    80004a76:	eca6                	sd	s1,88(sp)
    80004a78:	e8ca                	sd	s2,80(sp)
    80004a7a:	e4ce                	sd	s3,72(sp)
    80004a7c:	e0d2                	sd	s4,64(sp)
    80004a7e:	fc56                	sd	s5,56(sp)
    80004a80:	f85a                	sd	s6,48(sp)
    80004a82:	f45e                	sd	s7,40(sp)
    80004a84:	f062                	sd	s8,32(sp)
    80004a86:	ec66                	sd	s9,24(sp)
    80004a88:	1880                	addi	s0,sp,112
    80004a8a:	8a2a                	mv	s4,a0
    80004a8c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004a8e:	00c52c83          	lw	s9,12(a0)
    80004a92:	001c9c9b          	slliw	s9,s9,0x1
    80004a96:	1c82                	slli	s9,s9,0x20
    80004a98:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004a9c:	00017517          	auipc	a0,0x17
    80004aa0:	b6c50513          	addi	a0,a0,-1172 # 8001b608 <disk+0x128>
    80004aa4:	52d000ef          	jal	800057d0 <acquire>
  for(int i = 0; i < 3; i++){
    80004aa8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004aaa:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004aac:	00017b17          	auipc	s6,0x17
    80004ab0:	a34b0b13          	addi	s6,s6,-1484 # 8001b4e0 <disk>
  for(int i = 0; i < 3; i++){
    80004ab4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ab6:	00017c17          	auipc	s8,0x17
    80004aba:	b52c0c13          	addi	s8,s8,-1198 # 8001b608 <disk+0x128>
    80004abe:	a8b9                	j	80004b1c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004ac0:	00fb0733          	add	a4,s6,a5
    80004ac4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004ac8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004aca:	0207c563          	bltz	a5,80004af4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004ace:	2905                	addiw	s2,s2,1
    80004ad0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004ad2:	05590963          	beq	s2,s5,80004b24 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004ad6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004ad8:	00017717          	auipc	a4,0x17
    80004adc:	a0870713          	addi	a4,a4,-1528 # 8001b4e0 <disk>
    80004ae0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004ae2:	01874683          	lbu	a3,24(a4)
    80004ae6:	fee9                	bnez	a3,80004ac0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004ae8:	2785                	addiw	a5,a5,1
    80004aea:	0705                	addi	a4,a4,1
    80004aec:	fe979be3          	bne	a5,s1,80004ae2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004af0:	57fd                	li	a5,-1
    80004af2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004af4:	01205d63          	blez	s2,80004b0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004af8:	f9042503          	lw	a0,-112(s0)
    80004afc:	d07ff0ef          	jal	80004802 <free_desc>
      for(int j = 0; j < i; j++)
    80004b00:	4785                	li	a5,1
    80004b02:	0127d663          	bge	a5,s2,80004b0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b06:	f9442503          	lw	a0,-108(s0)
    80004b0a:	cf9ff0ef          	jal	80004802 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b0e:	85e2                	mv	a1,s8
    80004b10:	00017517          	auipc	a0,0x17
    80004b14:	9e850513          	addi	a0,a0,-1560 # 8001b4f8 <disk+0x18>
    80004b18:	84ffc0ef          	jal	80001366 <sleep>
  for(int i = 0; i < 3; i++){
    80004b1c:	f9040613          	addi	a2,s0,-112
    80004b20:	894e                	mv	s2,s3
    80004b22:	bf55                	j	80004ad6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b24:	f9042503          	lw	a0,-112(s0)
    80004b28:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b2c:	00017797          	auipc	a5,0x17
    80004b30:	9b478793          	addi	a5,a5,-1612 # 8001b4e0 <disk>
    80004b34:	00a50713          	addi	a4,a0,10
    80004b38:	0712                	slli	a4,a4,0x4
    80004b3a:	973e                	add	a4,a4,a5
    80004b3c:	01703633          	snez	a2,s7
    80004b40:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004b42:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004b46:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b4a:	6398                	ld	a4,0(a5)
    80004b4c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b4e:	0a868613          	addi	a2,a3,168
    80004b52:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004b54:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004b56:	6390                	ld	a2,0(a5)
    80004b58:	00d605b3          	add	a1,a2,a3
    80004b5c:	4741                	li	a4,16
    80004b5e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004b60:	4805                	li	a6,1
    80004b62:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004b66:	f9442703          	lw	a4,-108(s0)
    80004b6a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004b6e:	0712                	slli	a4,a4,0x4
    80004b70:	963a                	add	a2,a2,a4
    80004b72:	058a0593          	addi	a1,s4,88
    80004b76:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004b78:	0007b883          	ld	a7,0(a5)
    80004b7c:	9746                	add	a4,a4,a7
    80004b7e:	40000613          	li	a2,1024
    80004b82:	c710                	sw	a2,8(a4)
  if(write)
    80004b84:	001bb613          	seqz	a2,s7
    80004b88:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004b8c:	00166613          	ori	a2,a2,1
    80004b90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004b94:	f9842583          	lw	a1,-104(s0)
    80004b98:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004b9c:	00250613          	addi	a2,a0,2
    80004ba0:	0612                	slli	a2,a2,0x4
    80004ba2:	963e                	add	a2,a2,a5
    80004ba4:	577d                	li	a4,-1
    80004ba6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004baa:	0592                	slli	a1,a1,0x4
    80004bac:	98ae                	add	a7,a7,a1
    80004bae:	03068713          	addi	a4,a3,48
    80004bb2:	973e                	add	a4,a4,a5
    80004bb4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004bb8:	6398                	ld	a4,0(a5)
    80004bba:	972e                	add	a4,a4,a1
    80004bbc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004bc0:	4689                	li	a3,2
    80004bc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004bc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004bca:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004bce:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004bd2:	6794                	ld	a3,8(a5)
    80004bd4:	0026d703          	lhu	a4,2(a3)
    80004bd8:	8b1d                	andi	a4,a4,7
    80004bda:	0706                	slli	a4,a4,0x1
    80004bdc:	96ba                	add	a3,a3,a4
    80004bde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004be2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004be6:	6798                	ld	a4,8(a5)
    80004be8:	00275783          	lhu	a5,2(a4)
    80004bec:	2785                	addiw	a5,a5,1
    80004bee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004bf2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004bf6:	100017b7          	lui	a5,0x10001
    80004bfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004bfe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004c02:	00017917          	auipc	s2,0x17
    80004c06:	a0690913          	addi	s2,s2,-1530 # 8001b608 <disk+0x128>
  while(b->disk == 1) {
    80004c0a:	4485                	li	s1,1
    80004c0c:	01079a63          	bne	a5,a6,80004c20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004c10:	85ca                	mv	a1,s2
    80004c12:	8552                	mv	a0,s4
    80004c14:	f52fc0ef          	jal	80001366 <sleep>
  while(b->disk == 1) {
    80004c18:	004a2783          	lw	a5,4(s4)
    80004c1c:	fe978ae3          	beq	a5,s1,80004c10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004c20:	f9042903          	lw	s2,-112(s0)
    80004c24:	00290713          	addi	a4,s2,2
    80004c28:	0712                	slli	a4,a4,0x4
    80004c2a:	00017797          	auipc	a5,0x17
    80004c2e:	8b678793          	addi	a5,a5,-1866 # 8001b4e0 <disk>
    80004c32:	97ba                	add	a5,a5,a4
    80004c34:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004c38:	00017997          	auipc	s3,0x17
    80004c3c:	8a898993          	addi	s3,s3,-1880 # 8001b4e0 <disk>
    80004c40:	00491713          	slli	a4,s2,0x4
    80004c44:	0009b783          	ld	a5,0(s3)
    80004c48:	97ba                	add	a5,a5,a4
    80004c4a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004c4e:	854a                	mv	a0,s2
    80004c50:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004c54:	bafff0ef          	jal	80004802 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004c58:	8885                	andi	s1,s1,1
    80004c5a:	f0fd                	bnez	s1,80004c40 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004c5c:	00017517          	auipc	a0,0x17
    80004c60:	9ac50513          	addi	a0,a0,-1620 # 8001b608 <disk+0x128>
    80004c64:	405000ef          	jal	80005868 <release>
}
    80004c68:	70a6                	ld	ra,104(sp)
    80004c6a:	7406                	ld	s0,96(sp)
    80004c6c:	64e6                	ld	s1,88(sp)
    80004c6e:	6946                	ld	s2,80(sp)
    80004c70:	69a6                	ld	s3,72(sp)
    80004c72:	6a06                	ld	s4,64(sp)
    80004c74:	7ae2                	ld	s5,56(sp)
    80004c76:	7b42                	ld	s6,48(sp)
    80004c78:	7ba2                	ld	s7,40(sp)
    80004c7a:	7c02                	ld	s8,32(sp)
    80004c7c:	6ce2                	ld	s9,24(sp)
    80004c7e:	6165                	addi	sp,sp,112
    80004c80:	8082                	ret

0000000080004c82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004c82:	1101                	addi	sp,sp,-32
    80004c84:	ec06                	sd	ra,24(sp)
    80004c86:	e822                	sd	s0,16(sp)
    80004c88:	e426                	sd	s1,8(sp)
    80004c8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c8c:	00017497          	auipc	s1,0x17
    80004c90:	85448493          	addi	s1,s1,-1964 # 8001b4e0 <disk>
    80004c94:	00017517          	auipc	a0,0x17
    80004c98:	97450513          	addi	a0,a0,-1676 # 8001b608 <disk+0x128>
    80004c9c:	335000ef          	jal	800057d0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004ca0:	100017b7          	lui	a5,0x10001
    80004ca4:	53b8                	lw	a4,96(a5)
    80004ca6:	8b0d                	andi	a4,a4,3
    80004ca8:	100017b7          	lui	a5,0x10001
    80004cac:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004cae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004cb2:	689c                	ld	a5,16(s1)
    80004cb4:	0204d703          	lhu	a4,32(s1)
    80004cb8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004cbc:	04f70663          	beq	a4,a5,80004d08 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004cc0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004cc4:	6898                	ld	a4,16(s1)
    80004cc6:	0204d783          	lhu	a5,32(s1)
    80004cca:	8b9d                	andi	a5,a5,7
    80004ccc:	078e                	slli	a5,a5,0x3
    80004cce:	97ba                	add	a5,a5,a4
    80004cd0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004cd2:	00278713          	addi	a4,a5,2
    80004cd6:	0712                	slli	a4,a4,0x4
    80004cd8:	9726                	add	a4,a4,s1
    80004cda:	01074703          	lbu	a4,16(a4)
    80004cde:	e321                	bnez	a4,80004d1e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004ce0:	0789                	addi	a5,a5,2
    80004ce2:	0792                	slli	a5,a5,0x4
    80004ce4:	97a6                	add	a5,a5,s1
    80004ce6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004ce8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004cec:	ec6fc0ef          	jal	800013b2 <wakeup>

    disk.used_idx += 1;
    80004cf0:	0204d783          	lhu	a5,32(s1)
    80004cf4:	2785                	addiw	a5,a5,1
    80004cf6:	17c2                	slli	a5,a5,0x30
    80004cf8:	93c1                	srli	a5,a5,0x30
    80004cfa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004cfe:	6898                	ld	a4,16(s1)
    80004d00:	00275703          	lhu	a4,2(a4)
    80004d04:	faf71ee3          	bne	a4,a5,80004cc0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d08:	00017517          	auipc	a0,0x17
    80004d0c:	90050513          	addi	a0,a0,-1792 # 8001b608 <disk+0x128>
    80004d10:	359000ef          	jal	80005868 <release>
}
    80004d14:	60e2                	ld	ra,24(sp)
    80004d16:	6442                	ld	s0,16(sp)
    80004d18:	64a2                	ld	s1,8(sp)
    80004d1a:	6105                	addi	sp,sp,32
    80004d1c:	8082                	ret
      panic("virtio_disk_intr status");
    80004d1e:	00003517          	auipc	a0,0x3
    80004d22:	a7a50513          	addi	a0,a0,-1414 # 80007798 <etext+0x798>
    80004d26:	77c000ef          	jal	800054a2 <panic>

0000000080004d2a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d2a:	1141                	addi	sp,sp,-16
    80004d2c:	e422                	sd	s0,8(sp)
    80004d2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004d30:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004d34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004d38:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004d3c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004d40:	577d                	li	a4,-1
    80004d42:	177e                	slli	a4,a4,0x3f
    80004d44:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004d46:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004d4a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004d4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004d52:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004d56:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004d5a:	000f4737          	lui	a4,0xf4
    80004d5e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004d62:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004d64:	14d79073          	csrw	stimecmp,a5
}
    80004d68:	6422                	ld	s0,8(sp)
    80004d6a:	0141                	addi	sp,sp,16
    80004d6c:	8082                	ret

0000000080004d6e <start>:
{
    80004d6e:	1141                	addi	sp,sp,-16
    80004d70:	e406                	sd	ra,8(sp)
    80004d72:	e022                	sd	s0,0(sp)
    80004d74:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004d76:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004d7a:	7779                	lui	a4,0xffffe
    80004d7c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb0df>
    80004d80:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004d82:	6705                	lui	a4,0x1
    80004d84:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004d88:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004d8a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d8e:	ffffb797          	auipc	a5,0xffffb
    80004d92:	58278793          	addi	a5,a5,1410 # 80000310 <main>
    80004d96:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d9a:	4781                	li	a5,0
    80004d9c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004da0:	67c1                	lui	a5,0x10
    80004da2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004da4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004da8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004dac:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004db0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004db4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004db8:	57fd                	li	a5,-1
    80004dba:	83a9                	srli	a5,a5,0xa
    80004dbc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004dc0:	47bd                	li	a5,15
    80004dc2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004dc6:	f65ff0ef          	jal	80004d2a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004dca:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004dce:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004dd0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004dd2:	30200073          	mret
}
    80004dd6:	60a2                	ld	ra,8(sp)
    80004dd8:	6402                	ld	s0,0(sp)
    80004dda:	0141                	addi	sp,sp,16
    80004ddc:	8082                	ret

0000000080004dde <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004dde:	715d                	addi	sp,sp,-80
    80004de0:	e486                	sd	ra,72(sp)
    80004de2:	e0a2                	sd	s0,64(sp)
    80004de4:	f84a                	sd	s2,48(sp)
    80004de6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004de8:	04c05263          	blez	a2,80004e2c <consolewrite+0x4e>
    80004dec:	fc26                	sd	s1,56(sp)
    80004dee:	f44e                	sd	s3,40(sp)
    80004df0:	f052                	sd	s4,32(sp)
    80004df2:	ec56                	sd	s5,24(sp)
    80004df4:	8a2a                	mv	s4,a0
    80004df6:	84ae                	mv	s1,a1
    80004df8:	89b2                	mv	s3,a2
    80004dfa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004dfc:	5afd                	li	s5,-1
    80004dfe:	4685                	li	a3,1
    80004e00:	8626                	mv	a2,s1
    80004e02:	85d2                	mv	a1,s4
    80004e04:	fbf40513          	addi	a0,s0,-65
    80004e08:	905fc0ef          	jal	8000170c <either_copyin>
    80004e0c:	03550263          	beq	a0,s5,80004e30 <consolewrite+0x52>
      break;
    uartputc(c);
    80004e10:	fbf44503          	lbu	a0,-65(s0)
    80004e14:	035000ef          	jal	80005648 <uartputc>
  for(i = 0; i < n; i++){
    80004e18:	2905                	addiw	s2,s2,1
    80004e1a:	0485                	addi	s1,s1,1
    80004e1c:	ff2991e3          	bne	s3,s2,80004dfe <consolewrite+0x20>
    80004e20:	894e                	mv	s2,s3
    80004e22:	74e2                	ld	s1,56(sp)
    80004e24:	79a2                	ld	s3,40(sp)
    80004e26:	7a02                	ld	s4,32(sp)
    80004e28:	6ae2                	ld	s5,24(sp)
    80004e2a:	a039                	j	80004e38 <consolewrite+0x5a>
    80004e2c:	4901                	li	s2,0
    80004e2e:	a029                	j	80004e38 <consolewrite+0x5a>
    80004e30:	74e2                	ld	s1,56(sp)
    80004e32:	79a2                	ld	s3,40(sp)
    80004e34:	7a02                	ld	s4,32(sp)
    80004e36:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004e38:	854a                	mv	a0,s2
    80004e3a:	60a6                	ld	ra,72(sp)
    80004e3c:	6406                	ld	s0,64(sp)
    80004e3e:	7942                	ld	s2,48(sp)
    80004e40:	6161                	addi	sp,sp,80
    80004e42:	8082                	ret

0000000080004e44 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004e44:	711d                	addi	sp,sp,-96
    80004e46:	ec86                	sd	ra,88(sp)
    80004e48:	e8a2                	sd	s0,80(sp)
    80004e4a:	e4a6                	sd	s1,72(sp)
    80004e4c:	e0ca                	sd	s2,64(sp)
    80004e4e:	fc4e                	sd	s3,56(sp)
    80004e50:	f852                	sd	s4,48(sp)
    80004e52:	f456                	sd	s5,40(sp)
    80004e54:	f05a                	sd	s6,32(sp)
    80004e56:	1080                	addi	s0,sp,96
    80004e58:	8aaa                	mv	s5,a0
    80004e5a:	8a2e                	mv	s4,a1
    80004e5c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004e5e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004e62:	0001e517          	auipc	a0,0x1e
    80004e66:	7be50513          	addi	a0,a0,1982 # 80023620 <cons>
    80004e6a:	167000ef          	jal	800057d0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e6e:	0001e497          	auipc	s1,0x1e
    80004e72:	7b248493          	addi	s1,s1,1970 # 80023620 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e76:	0001f917          	auipc	s2,0x1f
    80004e7a:	84290913          	addi	s2,s2,-1982 # 800236b8 <cons+0x98>
  while(n > 0){
    80004e7e:	0b305d63          	blez	s3,80004f38 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004e82:	0984a783          	lw	a5,152(s1)
    80004e86:	09c4a703          	lw	a4,156(s1)
    80004e8a:	0af71263          	bne	a4,a5,80004f2e <consoleread+0xea>
      if(killed(myproc())){
    80004e8e:	f0bfb0ef          	jal	80000d98 <myproc>
    80004e92:	f0cfc0ef          	jal	8000159e <killed>
    80004e96:	e12d                	bnez	a0,80004ef8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004e98:	85a6                	mv	a1,s1
    80004e9a:	854a                	mv	a0,s2
    80004e9c:	ccafc0ef          	jal	80001366 <sleep>
    while(cons.r == cons.w){
    80004ea0:	0984a783          	lw	a5,152(s1)
    80004ea4:	09c4a703          	lw	a4,156(s1)
    80004ea8:	fef703e3          	beq	a4,a5,80004e8e <consoleread+0x4a>
    80004eac:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004eae:	0001e717          	auipc	a4,0x1e
    80004eb2:	77270713          	addi	a4,a4,1906 # 80023620 <cons>
    80004eb6:	0017869b          	addiw	a3,a5,1
    80004eba:	08d72c23          	sw	a3,152(a4)
    80004ebe:	07f7f693          	andi	a3,a5,127
    80004ec2:	9736                	add	a4,a4,a3
    80004ec4:	01874703          	lbu	a4,24(a4)
    80004ec8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004ecc:	4691                	li	a3,4
    80004ece:	04db8663          	beq	s7,a3,80004f1a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004ed2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004ed6:	4685                	li	a3,1
    80004ed8:	faf40613          	addi	a2,s0,-81
    80004edc:	85d2                	mv	a1,s4
    80004ede:	8556                	mv	a0,s5
    80004ee0:	fe2fc0ef          	jal	800016c2 <either_copyout>
    80004ee4:	57fd                	li	a5,-1
    80004ee6:	04f50863          	beq	a0,a5,80004f36 <consoleread+0xf2>
      break;

    dst++;
    80004eea:	0a05                	addi	s4,s4,1
    --n;
    80004eec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004eee:	47a9                	li	a5,10
    80004ef0:	04fb8d63          	beq	s7,a5,80004f4a <consoleread+0x106>
    80004ef4:	6be2                	ld	s7,24(sp)
    80004ef6:	b761                	j	80004e7e <consoleread+0x3a>
        release(&cons.lock);
    80004ef8:	0001e517          	auipc	a0,0x1e
    80004efc:	72850513          	addi	a0,a0,1832 # 80023620 <cons>
    80004f00:	169000ef          	jal	80005868 <release>
        return -1;
    80004f04:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f06:	60e6                	ld	ra,88(sp)
    80004f08:	6446                	ld	s0,80(sp)
    80004f0a:	64a6                	ld	s1,72(sp)
    80004f0c:	6906                	ld	s2,64(sp)
    80004f0e:	79e2                	ld	s3,56(sp)
    80004f10:	7a42                	ld	s4,48(sp)
    80004f12:	7aa2                	ld	s5,40(sp)
    80004f14:	7b02                	ld	s6,32(sp)
    80004f16:	6125                	addi	sp,sp,96
    80004f18:	8082                	ret
      if(n < target){
    80004f1a:	0009871b          	sext.w	a4,s3
    80004f1e:	01677a63          	bgeu	a4,s6,80004f32 <consoleread+0xee>
        cons.r--;
    80004f22:	0001e717          	auipc	a4,0x1e
    80004f26:	78f72b23          	sw	a5,1942(a4) # 800236b8 <cons+0x98>
    80004f2a:	6be2                	ld	s7,24(sp)
    80004f2c:	a031                	j	80004f38 <consoleread+0xf4>
    80004f2e:	ec5e                	sd	s7,24(sp)
    80004f30:	bfbd                	j	80004eae <consoleread+0x6a>
    80004f32:	6be2                	ld	s7,24(sp)
    80004f34:	a011                	j	80004f38 <consoleread+0xf4>
    80004f36:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004f38:	0001e517          	auipc	a0,0x1e
    80004f3c:	6e850513          	addi	a0,a0,1768 # 80023620 <cons>
    80004f40:	129000ef          	jal	80005868 <release>
  return target - n;
    80004f44:	413b053b          	subw	a0,s6,s3
    80004f48:	bf7d                	j	80004f06 <consoleread+0xc2>
    80004f4a:	6be2                	ld	s7,24(sp)
    80004f4c:	b7f5                	j	80004f38 <consoleread+0xf4>

0000000080004f4e <consputc>:
{
    80004f4e:	1141                	addi	sp,sp,-16
    80004f50:	e406                	sd	ra,8(sp)
    80004f52:	e022                	sd	s0,0(sp)
    80004f54:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004f56:	10000793          	li	a5,256
    80004f5a:	00f50863          	beq	a0,a5,80004f6a <consputc+0x1c>
    uartputc_sync(c);
    80004f5e:	604000ef          	jal	80005562 <uartputc_sync>
}
    80004f62:	60a2                	ld	ra,8(sp)
    80004f64:	6402                	ld	s0,0(sp)
    80004f66:	0141                	addi	sp,sp,16
    80004f68:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004f6a:	4521                	li	a0,8
    80004f6c:	5f6000ef          	jal	80005562 <uartputc_sync>
    80004f70:	02000513          	li	a0,32
    80004f74:	5ee000ef          	jal	80005562 <uartputc_sync>
    80004f78:	4521                	li	a0,8
    80004f7a:	5e8000ef          	jal	80005562 <uartputc_sync>
    80004f7e:	b7d5                	j	80004f62 <consputc+0x14>

0000000080004f80 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004f80:	1101                	addi	sp,sp,-32
    80004f82:	ec06                	sd	ra,24(sp)
    80004f84:	e822                	sd	s0,16(sp)
    80004f86:	e426                	sd	s1,8(sp)
    80004f88:	1000                	addi	s0,sp,32
    80004f8a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004f8c:	0001e517          	auipc	a0,0x1e
    80004f90:	69450513          	addi	a0,a0,1684 # 80023620 <cons>
    80004f94:	03d000ef          	jal	800057d0 <acquire>

  switch(c){
    80004f98:	47d5                	li	a5,21
    80004f9a:	08f48f63          	beq	s1,a5,80005038 <consoleintr+0xb8>
    80004f9e:	0297c563          	blt	a5,s1,80004fc8 <consoleintr+0x48>
    80004fa2:	47a1                	li	a5,8
    80004fa4:	0ef48463          	beq	s1,a5,8000508c <consoleintr+0x10c>
    80004fa8:	47c1                	li	a5,16
    80004faa:	10f49563          	bne	s1,a5,800050b4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80004fae:	fa8fc0ef          	jal	80001756 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004fb2:	0001e517          	auipc	a0,0x1e
    80004fb6:	66e50513          	addi	a0,a0,1646 # 80023620 <cons>
    80004fba:	0af000ef          	jal	80005868 <release>
}
    80004fbe:	60e2                	ld	ra,24(sp)
    80004fc0:	6442                	ld	s0,16(sp)
    80004fc2:	64a2                	ld	s1,8(sp)
    80004fc4:	6105                	addi	sp,sp,32
    80004fc6:	8082                	ret
  switch(c){
    80004fc8:	07f00793          	li	a5,127
    80004fcc:	0cf48063          	beq	s1,a5,8000508c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004fd0:	0001e717          	auipc	a4,0x1e
    80004fd4:	65070713          	addi	a4,a4,1616 # 80023620 <cons>
    80004fd8:	0a072783          	lw	a5,160(a4)
    80004fdc:	09872703          	lw	a4,152(a4)
    80004fe0:	9f99                	subw	a5,a5,a4
    80004fe2:	07f00713          	li	a4,127
    80004fe6:	fcf766e3          	bltu	a4,a5,80004fb2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80004fea:	47b5                	li	a5,13
    80004fec:	0cf48763          	beq	s1,a5,800050ba <consoleintr+0x13a>
      consputc(c);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	f5dff0ef          	jal	80004f4e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004ff6:	0001e797          	auipc	a5,0x1e
    80004ffa:	62a78793          	addi	a5,a5,1578 # 80023620 <cons>
    80004ffe:	0a07a683          	lw	a3,160(a5)
    80005002:	0016871b          	addiw	a4,a3,1
    80005006:	0007061b          	sext.w	a2,a4
    8000500a:	0ae7a023          	sw	a4,160(a5)
    8000500e:	07f6f693          	andi	a3,a3,127
    80005012:	97b6                	add	a5,a5,a3
    80005014:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005018:	47a9                	li	a5,10
    8000501a:	0cf48563          	beq	s1,a5,800050e4 <consoleintr+0x164>
    8000501e:	4791                	li	a5,4
    80005020:	0cf48263          	beq	s1,a5,800050e4 <consoleintr+0x164>
    80005024:	0001e797          	auipc	a5,0x1e
    80005028:	6947a783          	lw	a5,1684(a5) # 800236b8 <cons+0x98>
    8000502c:	9f1d                	subw	a4,a4,a5
    8000502e:	08000793          	li	a5,128
    80005032:	f8f710e3          	bne	a4,a5,80004fb2 <consoleintr+0x32>
    80005036:	a07d                	j	800050e4 <consoleintr+0x164>
    80005038:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000503a:	0001e717          	auipc	a4,0x1e
    8000503e:	5e670713          	addi	a4,a4,1510 # 80023620 <cons>
    80005042:	0a072783          	lw	a5,160(a4)
    80005046:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000504a:	0001e497          	auipc	s1,0x1e
    8000504e:	5d648493          	addi	s1,s1,1494 # 80023620 <cons>
    while(cons.e != cons.w &&
    80005052:	4929                	li	s2,10
    80005054:	02f70863          	beq	a4,a5,80005084 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005058:	37fd                	addiw	a5,a5,-1
    8000505a:	07f7f713          	andi	a4,a5,127
    8000505e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005060:	01874703          	lbu	a4,24(a4)
    80005064:	03270263          	beq	a4,s2,80005088 <consoleintr+0x108>
      cons.e--;
    80005068:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000506c:	10000513          	li	a0,256
    80005070:	edfff0ef          	jal	80004f4e <consputc>
    while(cons.e != cons.w &&
    80005074:	0a04a783          	lw	a5,160(s1)
    80005078:	09c4a703          	lw	a4,156(s1)
    8000507c:	fcf71ee3          	bne	a4,a5,80005058 <consoleintr+0xd8>
    80005080:	6902                	ld	s2,0(sp)
    80005082:	bf05                	j	80004fb2 <consoleintr+0x32>
    80005084:	6902                	ld	s2,0(sp)
    80005086:	b735                	j	80004fb2 <consoleintr+0x32>
    80005088:	6902                	ld	s2,0(sp)
    8000508a:	b725                	j	80004fb2 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000508c:	0001e717          	auipc	a4,0x1e
    80005090:	59470713          	addi	a4,a4,1428 # 80023620 <cons>
    80005094:	0a072783          	lw	a5,160(a4)
    80005098:	09c72703          	lw	a4,156(a4)
    8000509c:	f0f70be3          	beq	a4,a5,80004fb2 <consoleintr+0x32>
      cons.e--;
    800050a0:	37fd                	addiw	a5,a5,-1
    800050a2:	0001e717          	auipc	a4,0x1e
    800050a6:	60f72f23          	sw	a5,1566(a4) # 800236c0 <cons+0xa0>
      consputc(BACKSPACE);
    800050aa:	10000513          	li	a0,256
    800050ae:	ea1ff0ef          	jal	80004f4e <consputc>
    800050b2:	b701                	j	80004fb2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050b4:	ee048fe3          	beqz	s1,80004fb2 <consoleintr+0x32>
    800050b8:	bf21                	j	80004fd0 <consoleintr+0x50>
      consputc(c);
    800050ba:	4529                	li	a0,10
    800050bc:	e93ff0ef          	jal	80004f4e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050c0:	0001e797          	auipc	a5,0x1e
    800050c4:	56078793          	addi	a5,a5,1376 # 80023620 <cons>
    800050c8:	0a07a703          	lw	a4,160(a5)
    800050cc:	0017069b          	addiw	a3,a4,1
    800050d0:	0006861b          	sext.w	a2,a3
    800050d4:	0ad7a023          	sw	a3,160(a5)
    800050d8:	07f77713          	andi	a4,a4,127
    800050dc:	97ba                	add	a5,a5,a4
    800050de:	4729                	li	a4,10
    800050e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800050e4:	0001e797          	auipc	a5,0x1e
    800050e8:	5cc7ac23          	sw	a2,1496(a5) # 800236bc <cons+0x9c>
        wakeup(&cons.r);
    800050ec:	0001e517          	auipc	a0,0x1e
    800050f0:	5cc50513          	addi	a0,a0,1484 # 800236b8 <cons+0x98>
    800050f4:	abefc0ef          	jal	800013b2 <wakeup>
    800050f8:	bd6d                	j	80004fb2 <consoleintr+0x32>

00000000800050fa <consoleinit>:

void
consoleinit(void)
{
    800050fa:	1141                	addi	sp,sp,-16
    800050fc:	e406                	sd	ra,8(sp)
    800050fe:	e022                	sd	s0,0(sp)
    80005100:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005102:	00002597          	auipc	a1,0x2
    80005106:	6ae58593          	addi	a1,a1,1710 # 800077b0 <etext+0x7b0>
    8000510a:	0001e517          	auipc	a0,0x1e
    8000510e:	51650513          	addi	a0,a0,1302 # 80023620 <cons>
    80005112:	63e000ef          	jal	80005750 <initlock>

  uartinit();
    80005116:	3f4000ef          	jal	8000550a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000511a:	00015797          	auipc	a5,0x15
    8000511e:	36e78793          	addi	a5,a5,878 # 8001a488 <devsw>
    80005122:	00000717          	auipc	a4,0x0
    80005126:	d2270713          	addi	a4,a4,-734 # 80004e44 <consoleread>
    8000512a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000512c:	00000717          	auipc	a4,0x0
    80005130:	cb270713          	addi	a4,a4,-846 # 80004dde <consolewrite>
    80005134:	ef98                	sd	a4,24(a5)
}
    80005136:	60a2                	ld	ra,8(sp)
    80005138:	6402                	ld	s0,0(sp)
    8000513a:	0141                	addi	sp,sp,16
    8000513c:	8082                	ret

000000008000513e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000513e:	7179                	addi	sp,sp,-48
    80005140:	f406                	sd	ra,40(sp)
    80005142:	f022                	sd	s0,32(sp)
    80005144:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005146:	c219                	beqz	a2,8000514c <printint+0xe>
    80005148:	08054063          	bltz	a0,800051c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000514c:	4881                	li	a7,0
    8000514e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005152:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005154:	00002617          	auipc	a2,0x2
    80005158:	7c460613          	addi	a2,a2,1988 # 80007918 <digits>
    8000515c:	883e                	mv	a6,a5
    8000515e:	2785                	addiw	a5,a5,1
    80005160:	02b57733          	remu	a4,a0,a1
    80005164:	9732                	add	a4,a4,a2
    80005166:	00074703          	lbu	a4,0(a4)
    8000516a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000516e:	872a                	mv	a4,a0
    80005170:	02b55533          	divu	a0,a0,a1
    80005174:	0685                	addi	a3,a3,1
    80005176:	feb773e3          	bgeu	a4,a1,8000515c <printint+0x1e>

  if(sign)
    8000517a:	00088a63          	beqz	a7,8000518e <printint+0x50>
    buf[i++] = '-';
    8000517e:	1781                	addi	a5,a5,-32
    80005180:	97a2                	add	a5,a5,s0
    80005182:	02d00713          	li	a4,45
    80005186:	fee78823          	sb	a4,-16(a5)
    8000518a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000518e:	02f05963          	blez	a5,800051c0 <printint+0x82>
    80005192:	ec26                	sd	s1,24(sp)
    80005194:	e84a                	sd	s2,16(sp)
    80005196:	fd040713          	addi	a4,s0,-48
    8000519a:	00f704b3          	add	s1,a4,a5
    8000519e:	fff70913          	addi	s2,a4,-1
    800051a2:	993e                	add	s2,s2,a5
    800051a4:	37fd                	addiw	a5,a5,-1
    800051a6:	1782                	slli	a5,a5,0x20
    800051a8:	9381                	srli	a5,a5,0x20
    800051aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800051ae:	fff4c503          	lbu	a0,-1(s1)
    800051b2:	d9dff0ef          	jal	80004f4e <consputc>
  while(--i >= 0)
    800051b6:	14fd                	addi	s1,s1,-1
    800051b8:	ff249be3          	bne	s1,s2,800051ae <printint+0x70>
    800051bc:	64e2                	ld	s1,24(sp)
    800051be:	6942                	ld	s2,16(sp)
}
    800051c0:	70a2                	ld	ra,40(sp)
    800051c2:	7402                	ld	s0,32(sp)
    800051c4:	6145                	addi	sp,sp,48
    800051c6:	8082                	ret
    x = -xx;
    800051c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800051cc:	4885                	li	a7,1
    x = -xx;
    800051ce:	b741                	j	8000514e <printint+0x10>

00000000800051d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800051d0:	7155                	addi	sp,sp,-208
    800051d2:	e506                	sd	ra,136(sp)
    800051d4:	e122                	sd	s0,128(sp)
    800051d6:	f0d2                	sd	s4,96(sp)
    800051d8:	0900                	addi	s0,sp,144
    800051da:	8a2a                	mv	s4,a0
    800051dc:	e40c                	sd	a1,8(s0)
    800051de:	e810                	sd	a2,16(s0)
    800051e0:	ec14                	sd	a3,24(s0)
    800051e2:	f018                	sd	a4,32(s0)
    800051e4:	f41c                	sd	a5,40(s0)
    800051e6:	03043823          	sd	a6,48(s0)
    800051ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800051ee:	0001e797          	auipc	a5,0x1e
    800051f2:	4f27a783          	lw	a5,1266(a5) # 800236e0 <pr+0x18>
    800051f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800051fa:	e3a1                	bnez	a5,8000523a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800051fc:	00840793          	addi	a5,s0,8
    80005200:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005204:	00054503          	lbu	a0,0(a0)
    80005208:	26050763          	beqz	a0,80005476 <printf+0x2a6>
    8000520c:	fca6                	sd	s1,120(sp)
    8000520e:	f8ca                	sd	s2,112(sp)
    80005210:	f4ce                	sd	s3,104(sp)
    80005212:	ecd6                	sd	s5,88(sp)
    80005214:	e8da                	sd	s6,80(sp)
    80005216:	e0e2                	sd	s8,64(sp)
    80005218:	fc66                	sd	s9,56(sp)
    8000521a:	f86a                	sd	s10,48(sp)
    8000521c:	f46e                	sd	s11,40(sp)
    8000521e:	4981                	li	s3,0
    if(cx != '%'){
    80005220:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005224:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005228:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000522c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005230:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005234:	07000d93          	li	s11,112
    80005238:	a815                	j	8000526c <printf+0x9c>
    acquire(&pr.lock);
    8000523a:	0001e517          	auipc	a0,0x1e
    8000523e:	48e50513          	addi	a0,a0,1166 # 800236c8 <pr>
    80005242:	58e000ef          	jal	800057d0 <acquire>
  va_start(ap, fmt);
    80005246:	00840793          	addi	a5,s0,8
    8000524a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000524e:	000a4503          	lbu	a0,0(s4)
    80005252:	fd4d                	bnez	a0,8000520c <printf+0x3c>
    80005254:	a481                	j	80005494 <printf+0x2c4>
      consputc(cx);
    80005256:	cf9ff0ef          	jal	80004f4e <consputc>
      continue;
    8000525a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000525c:	0014899b          	addiw	s3,s1,1
    80005260:	013a07b3          	add	a5,s4,s3
    80005264:	0007c503          	lbu	a0,0(a5)
    80005268:	1e050b63          	beqz	a0,8000545e <printf+0x28e>
    if(cx != '%'){
    8000526c:	ff5515e3          	bne	a0,s5,80005256 <printf+0x86>
    i++;
    80005270:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005274:	009a07b3          	add	a5,s4,s1
    80005278:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000527c:	1e090163          	beqz	s2,8000545e <printf+0x28e>
    80005280:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005284:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005286:	c789                	beqz	a5,80005290 <printf+0xc0>
    80005288:	009a0733          	add	a4,s4,s1
    8000528c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005290:	03690763          	beq	s2,s6,800052be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005294:	05890163          	beq	s2,s8,800052d6 <printf+0x106>
    } else if(c0 == 'u'){
    80005298:	0d990b63          	beq	s2,s9,8000536e <printf+0x19e>
    } else if(c0 == 'x'){
    8000529c:	13a90163          	beq	s2,s10,800053be <printf+0x1ee>
    } else if(c0 == 'p'){
    800052a0:	13b90b63          	beq	s2,s11,800053d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800052a4:	07300793          	li	a5,115
    800052a8:	16f90a63          	beq	s2,a5,8000541c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800052ac:	1b590463          	beq	s2,s5,80005454 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800052b0:	8556                	mv	a0,s5
    800052b2:	c9dff0ef          	jal	80004f4e <consputc>
      consputc(c0);
    800052b6:	854a                	mv	a0,s2
    800052b8:	c97ff0ef          	jal	80004f4e <consputc>
    800052bc:	b745                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800052be:	f8843783          	ld	a5,-120(s0)
    800052c2:	00878713          	addi	a4,a5,8
    800052c6:	f8e43423          	sd	a4,-120(s0)
    800052ca:	4605                	li	a2,1
    800052cc:	45a9                	li	a1,10
    800052ce:	4388                	lw	a0,0(a5)
    800052d0:	e6fff0ef          	jal	8000513e <printint>
    800052d4:	b761                	j	8000525c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800052d6:	03678663          	beq	a5,s6,80005302 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052da:	05878263          	beq	a5,s8,8000531e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800052de:	0b978463          	beq	a5,s9,80005386 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800052e2:	fda797e3          	bne	a5,s10,800052b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800052e6:	f8843783          	ld	a5,-120(s0)
    800052ea:	00878713          	addi	a4,a5,8
    800052ee:	f8e43423          	sd	a4,-120(s0)
    800052f2:	4601                	li	a2,0
    800052f4:	45c1                	li	a1,16
    800052f6:	6388                	ld	a0,0(a5)
    800052f8:	e47ff0ef          	jal	8000513e <printint>
      i += 1;
    800052fc:	0029849b          	addiw	s1,s3,2
    80005300:	bfb1                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005302:	f8843783          	ld	a5,-120(s0)
    80005306:	00878713          	addi	a4,a5,8
    8000530a:	f8e43423          	sd	a4,-120(s0)
    8000530e:	4605                	li	a2,1
    80005310:	45a9                	li	a1,10
    80005312:	6388                	ld	a0,0(a5)
    80005314:	e2bff0ef          	jal	8000513e <printint>
      i += 1;
    80005318:	0029849b          	addiw	s1,s3,2
    8000531c:	b781                	j	8000525c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000531e:	06400793          	li	a5,100
    80005322:	02f68863          	beq	a3,a5,80005352 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005326:	07500793          	li	a5,117
    8000532a:	06f68c63          	beq	a3,a5,800053a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000532e:	07800793          	li	a5,120
    80005332:	f6f69fe3          	bne	a3,a5,800052b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005336:	f8843783          	ld	a5,-120(s0)
    8000533a:	00878713          	addi	a4,a5,8
    8000533e:	f8e43423          	sd	a4,-120(s0)
    80005342:	4601                	li	a2,0
    80005344:	45c1                	li	a1,16
    80005346:	6388                	ld	a0,0(a5)
    80005348:	df7ff0ef          	jal	8000513e <printint>
      i += 2;
    8000534c:	0039849b          	addiw	s1,s3,3
    80005350:	b731                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005352:	f8843783          	ld	a5,-120(s0)
    80005356:	00878713          	addi	a4,a5,8
    8000535a:	f8e43423          	sd	a4,-120(s0)
    8000535e:	4605                	li	a2,1
    80005360:	45a9                	li	a1,10
    80005362:	6388                	ld	a0,0(a5)
    80005364:	ddbff0ef          	jal	8000513e <printint>
      i += 2;
    80005368:	0039849b          	addiw	s1,s3,3
    8000536c:	bdc5                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000536e:	f8843783          	ld	a5,-120(s0)
    80005372:	00878713          	addi	a4,a5,8
    80005376:	f8e43423          	sd	a4,-120(s0)
    8000537a:	4601                	li	a2,0
    8000537c:	45a9                	li	a1,10
    8000537e:	4388                	lw	a0,0(a5)
    80005380:	dbfff0ef          	jal	8000513e <printint>
    80005384:	bde1                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005386:	f8843783          	ld	a5,-120(s0)
    8000538a:	00878713          	addi	a4,a5,8
    8000538e:	f8e43423          	sd	a4,-120(s0)
    80005392:	4601                	li	a2,0
    80005394:	45a9                	li	a1,10
    80005396:	6388                	ld	a0,0(a5)
    80005398:	da7ff0ef          	jal	8000513e <printint>
      i += 1;
    8000539c:	0029849b          	addiw	s1,s3,2
    800053a0:	bd75                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053a2:	f8843783          	ld	a5,-120(s0)
    800053a6:	00878713          	addi	a4,a5,8
    800053aa:	f8e43423          	sd	a4,-120(s0)
    800053ae:	4601                	li	a2,0
    800053b0:	45a9                	li	a1,10
    800053b2:	6388                	ld	a0,0(a5)
    800053b4:	d8bff0ef          	jal	8000513e <printint>
      i += 2;
    800053b8:	0039849b          	addiw	s1,s3,3
    800053bc:	b545                	j	8000525c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800053be:	f8843783          	ld	a5,-120(s0)
    800053c2:	00878713          	addi	a4,a5,8
    800053c6:	f8e43423          	sd	a4,-120(s0)
    800053ca:	4601                	li	a2,0
    800053cc:	45c1                	li	a1,16
    800053ce:	4388                	lw	a0,0(a5)
    800053d0:	d6fff0ef          	jal	8000513e <printint>
    800053d4:	b561                	j	8000525c <printf+0x8c>
    800053d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800053d8:	f8843783          	ld	a5,-120(s0)
    800053dc:	00878713          	addi	a4,a5,8
    800053e0:	f8e43423          	sd	a4,-120(s0)
    800053e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800053e8:	03000513          	li	a0,48
    800053ec:	b63ff0ef          	jal	80004f4e <consputc>
  consputc('x');
    800053f0:	07800513          	li	a0,120
    800053f4:	b5bff0ef          	jal	80004f4e <consputc>
    800053f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800053fa:	00002b97          	auipc	s7,0x2
    800053fe:	51eb8b93          	addi	s7,s7,1310 # 80007918 <digits>
    80005402:	03c9d793          	srli	a5,s3,0x3c
    80005406:	97de                	add	a5,a5,s7
    80005408:	0007c503          	lbu	a0,0(a5)
    8000540c:	b43ff0ef          	jal	80004f4e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005410:	0992                	slli	s3,s3,0x4
    80005412:	397d                	addiw	s2,s2,-1
    80005414:	fe0917e3          	bnez	s2,80005402 <printf+0x232>
    80005418:	6ba6                	ld	s7,72(sp)
    8000541a:	b589                	j	8000525c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000541c:	f8843783          	ld	a5,-120(s0)
    80005420:	00878713          	addi	a4,a5,8
    80005424:	f8e43423          	sd	a4,-120(s0)
    80005428:	0007b903          	ld	s2,0(a5)
    8000542c:	00090d63          	beqz	s2,80005446 <printf+0x276>
      for(; *s; s++)
    80005430:	00094503          	lbu	a0,0(s2)
    80005434:	e20504e3          	beqz	a0,8000525c <printf+0x8c>
        consputc(*s);
    80005438:	b17ff0ef          	jal	80004f4e <consputc>
      for(; *s; s++)
    8000543c:	0905                	addi	s2,s2,1
    8000543e:	00094503          	lbu	a0,0(s2)
    80005442:	f97d                	bnez	a0,80005438 <printf+0x268>
    80005444:	bd21                	j	8000525c <printf+0x8c>
        s = "(null)";
    80005446:	00002917          	auipc	s2,0x2
    8000544a:	37290913          	addi	s2,s2,882 # 800077b8 <etext+0x7b8>
      for(; *s; s++)
    8000544e:	02800513          	li	a0,40
    80005452:	b7dd                	j	80005438 <printf+0x268>
      consputc('%');
    80005454:	02500513          	li	a0,37
    80005458:	af7ff0ef          	jal	80004f4e <consputc>
    8000545c:	b501                	j	8000525c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000545e:	f7843783          	ld	a5,-136(s0)
    80005462:	e385                	bnez	a5,80005482 <printf+0x2b2>
    80005464:	74e6                	ld	s1,120(sp)
    80005466:	7946                	ld	s2,112(sp)
    80005468:	79a6                	ld	s3,104(sp)
    8000546a:	6ae6                	ld	s5,88(sp)
    8000546c:	6b46                	ld	s6,80(sp)
    8000546e:	6c06                	ld	s8,64(sp)
    80005470:	7ce2                	ld	s9,56(sp)
    80005472:	7d42                	ld	s10,48(sp)
    80005474:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005476:	4501                	li	a0,0
    80005478:	60aa                	ld	ra,136(sp)
    8000547a:	640a                	ld	s0,128(sp)
    8000547c:	7a06                	ld	s4,96(sp)
    8000547e:	6169                	addi	sp,sp,208
    80005480:	8082                	ret
    80005482:	74e6                	ld	s1,120(sp)
    80005484:	7946                	ld	s2,112(sp)
    80005486:	79a6                	ld	s3,104(sp)
    80005488:	6ae6                	ld	s5,88(sp)
    8000548a:	6b46                	ld	s6,80(sp)
    8000548c:	6c06                	ld	s8,64(sp)
    8000548e:	7ce2                	ld	s9,56(sp)
    80005490:	7d42                	ld	s10,48(sp)
    80005492:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005494:	0001e517          	auipc	a0,0x1e
    80005498:	23450513          	addi	a0,a0,564 # 800236c8 <pr>
    8000549c:	3cc000ef          	jal	80005868 <release>
    800054a0:	bfd9                	j	80005476 <printf+0x2a6>

00000000800054a2 <panic>:

void
panic(char *s)
{
    800054a2:	1101                	addi	sp,sp,-32
    800054a4:	ec06                	sd	ra,24(sp)
    800054a6:	e822                	sd	s0,16(sp)
    800054a8:	e426                	sd	s1,8(sp)
    800054aa:	1000                	addi	s0,sp,32
    800054ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800054ae:	0001e797          	auipc	a5,0x1e
    800054b2:	2207a923          	sw	zero,562(a5) # 800236e0 <pr+0x18>
  printf("panic: ");
    800054b6:	00002517          	auipc	a0,0x2
    800054ba:	30a50513          	addi	a0,a0,778 # 800077c0 <etext+0x7c0>
    800054be:	d13ff0ef          	jal	800051d0 <printf>
  printf("%s\n", s);
    800054c2:	85a6                	mv	a1,s1
    800054c4:	00002517          	auipc	a0,0x2
    800054c8:	30450513          	addi	a0,a0,772 # 800077c8 <etext+0x7c8>
    800054cc:	d05ff0ef          	jal	800051d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800054d0:	4785                	li	a5,1
    800054d2:	00005717          	auipc	a4,0x5
    800054d6:	f0f72523          	sw	a5,-246(a4) # 8000a3dc <panicked>
  for(;;)
    800054da:	a001                	j	800054da <panic+0x38>

00000000800054dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800054dc:	1101                	addi	sp,sp,-32
    800054de:	ec06                	sd	ra,24(sp)
    800054e0:	e822                	sd	s0,16(sp)
    800054e2:	e426                	sd	s1,8(sp)
    800054e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800054e6:	0001e497          	auipc	s1,0x1e
    800054ea:	1e248493          	addi	s1,s1,482 # 800236c8 <pr>
    800054ee:	00002597          	auipc	a1,0x2
    800054f2:	2e258593          	addi	a1,a1,738 # 800077d0 <etext+0x7d0>
    800054f6:	8526                	mv	a0,s1
    800054f8:	258000ef          	jal	80005750 <initlock>
  pr.locking = 1;
    800054fc:	4785                	li	a5,1
    800054fe:	cc9c                	sw	a5,24(s1)
}
    80005500:	60e2                	ld	ra,24(sp)
    80005502:	6442                	ld	s0,16(sp)
    80005504:	64a2                	ld	s1,8(sp)
    80005506:	6105                	addi	sp,sp,32
    80005508:	8082                	ret

000000008000550a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000550a:	1141                	addi	sp,sp,-16
    8000550c:	e406                	sd	ra,8(sp)
    8000550e:	e022                	sd	s0,0(sp)
    80005510:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005512:	100007b7          	lui	a5,0x10000
    80005516:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000551a:	10000737          	lui	a4,0x10000
    8000551e:	f8000693          	li	a3,-128
    80005522:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005526:	468d                	li	a3,3
    80005528:	10000637          	lui	a2,0x10000
    8000552c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005530:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005534:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005538:	10000737          	lui	a4,0x10000
    8000553c:	461d                	li	a2,7
    8000553e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005542:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005546:	00002597          	auipc	a1,0x2
    8000554a:	29258593          	addi	a1,a1,658 # 800077d8 <etext+0x7d8>
    8000554e:	0001e517          	auipc	a0,0x1e
    80005552:	19a50513          	addi	a0,a0,410 # 800236e8 <uart_tx_lock>
    80005556:	1fa000ef          	jal	80005750 <initlock>
}
    8000555a:	60a2                	ld	ra,8(sp)
    8000555c:	6402                	ld	s0,0(sp)
    8000555e:	0141                	addi	sp,sp,16
    80005560:	8082                	ret

0000000080005562 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005562:	1101                	addi	sp,sp,-32
    80005564:	ec06                	sd	ra,24(sp)
    80005566:	e822                	sd	s0,16(sp)
    80005568:	e426                	sd	s1,8(sp)
    8000556a:	1000                	addi	s0,sp,32
    8000556c:	84aa                	mv	s1,a0
  push_off();
    8000556e:	222000ef          	jal	80005790 <push_off>

  if(panicked){
    80005572:	00005797          	auipc	a5,0x5
    80005576:	e6a7a783          	lw	a5,-406(a5) # 8000a3dc <panicked>
    8000557a:	e795                	bnez	a5,800055a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000557c:	10000737          	lui	a4,0x10000
    80005580:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005582:	00074783          	lbu	a5,0(a4)
    80005586:	0207f793          	andi	a5,a5,32
    8000558a:	dfe5                	beqz	a5,80005582 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000558c:	0ff4f513          	zext.b	a0,s1
    80005590:	100007b7          	lui	a5,0x10000
    80005594:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005598:	27c000ef          	jal	80005814 <pop_off>
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6105                	addi	sp,sp,32
    800055a4:	8082                	ret
    for(;;)
    800055a6:	a001                	j	800055a6 <uartputc_sync+0x44>

00000000800055a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800055a8:	00005797          	auipc	a5,0x5
    800055ac:	e387b783          	ld	a5,-456(a5) # 8000a3e0 <uart_tx_r>
    800055b0:	00005717          	auipc	a4,0x5
    800055b4:	e3873703          	ld	a4,-456(a4) # 8000a3e8 <uart_tx_w>
    800055b8:	08f70263          	beq	a4,a5,8000563c <uartstart+0x94>
{
    800055bc:	7139                	addi	sp,sp,-64
    800055be:	fc06                	sd	ra,56(sp)
    800055c0:	f822                	sd	s0,48(sp)
    800055c2:	f426                	sd	s1,40(sp)
    800055c4:	f04a                	sd	s2,32(sp)
    800055c6:	ec4e                	sd	s3,24(sp)
    800055c8:	e852                	sd	s4,16(sp)
    800055ca:	e456                	sd	s5,8(sp)
    800055cc:	e05a                	sd	s6,0(sp)
    800055ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055d0:	10000937          	lui	s2,0x10000
    800055d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055d6:	0001ea97          	auipc	s5,0x1e
    800055da:	112a8a93          	addi	s5,s5,274 # 800236e8 <uart_tx_lock>
    uart_tx_r += 1;
    800055de:	00005497          	auipc	s1,0x5
    800055e2:	e0248493          	addi	s1,s1,-510 # 8000a3e0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800055e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800055ea:	00005997          	auipc	s3,0x5
    800055ee:	dfe98993          	addi	s3,s3,-514 # 8000a3e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800055f2:	00094703          	lbu	a4,0(s2)
    800055f6:	02077713          	andi	a4,a4,32
    800055fa:	c71d                	beqz	a4,80005628 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800055fc:	01f7f713          	andi	a4,a5,31
    80005600:	9756                	add	a4,a4,s5
    80005602:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005606:	0785                	addi	a5,a5,1
    80005608:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000560a:	8526                	mv	a0,s1
    8000560c:	da7fb0ef          	jal	800013b2 <wakeup>
    WriteReg(THR, c);
    80005610:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005614:	609c                	ld	a5,0(s1)
    80005616:	0009b703          	ld	a4,0(s3)
    8000561a:	fcf71ce3          	bne	a4,a5,800055f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000561e:	100007b7          	lui	a5,0x10000
    80005622:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005624:	0007c783          	lbu	a5,0(a5)
  }
}
    80005628:	70e2                	ld	ra,56(sp)
    8000562a:	7442                	ld	s0,48(sp)
    8000562c:	74a2                	ld	s1,40(sp)
    8000562e:	7902                	ld	s2,32(sp)
    80005630:	69e2                	ld	s3,24(sp)
    80005632:	6a42                	ld	s4,16(sp)
    80005634:	6aa2                	ld	s5,8(sp)
    80005636:	6b02                	ld	s6,0(sp)
    80005638:	6121                	addi	sp,sp,64
    8000563a:	8082                	ret
      ReadReg(ISR);
    8000563c:	100007b7          	lui	a5,0x10000
    80005640:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005642:	0007c783          	lbu	a5,0(a5)
      return;
    80005646:	8082                	ret

0000000080005648 <uartputc>:
{
    80005648:	7179                	addi	sp,sp,-48
    8000564a:	f406                	sd	ra,40(sp)
    8000564c:	f022                	sd	s0,32(sp)
    8000564e:	ec26                	sd	s1,24(sp)
    80005650:	e84a                	sd	s2,16(sp)
    80005652:	e44e                	sd	s3,8(sp)
    80005654:	e052                	sd	s4,0(sp)
    80005656:	1800                	addi	s0,sp,48
    80005658:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000565a:	0001e517          	auipc	a0,0x1e
    8000565e:	08e50513          	addi	a0,a0,142 # 800236e8 <uart_tx_lock>
    80005662:	16e000ef          	jal	800057d0 <acquire>
  if(panicked){
    80005666:	00005797          	auipc	a5,0x5
    8000566a:	d767a783          	lw	a5,-650(a5) # 8000a3dc <panicked>
    8000566e:	efbd                	bnez	a5,800056ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005670:	00005717          	auipc	a4,0x5
    80005674:	d7873703          	ld	a4,-648(a4) # 8000a3e8 <uart_tx_w>
    80005678:	00005797          	auipc	a5,0x5
    8000567c:	d687b783          	ld	a5,-664(a5) # 8000a3e0 <uart_tx_r>
    80005680:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005684:	0001e997          	auipc	s3,0x1e
    80005688:	06498993          	addi	s3,s3,100 # 800236e8 <uart_tx_lock>
    8000568c:	00005497          	auipc	s1,0x5
    80005690:	d5448493          	addi	s1,s1,-684 # 8000a3e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005694:	00005917          	auipc	s2,0x5
    80005698:	d5490913          	addi	s2,s2,-684 # 8000a3e8 <uart_tx_w>
    8000569c:	00e79d63          	bne	a5,a4,800056b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800056a0:	85ce                	mv	a1,s3
    800056a2:	8526                	mv	a0,s1
    800056a4:	cc3fb0ef          	jal	80001366 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056a8:	00093703          	ld	a4,0(s2)
    800056ac:	609c                	ld	a5,0(s1)
    800056ae:	02078793          	addi	a5,a5,32
    800056b2:	fee787e3          	beq	a5,a4,800056a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800056b6:	0001e497          	auipc	s1,0x1e
    800056ba:	03248493          	addi	s1,s1,50 # 800236e8 <uart_tx_lock>
    800056be:	01f77793          	andi	a5,a4,31
    800056c2:	97a6                	add	a5,a5,s1
    800056c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800056c8:	0705                	addi	a4,a4,1
    800056ca:	00005797          	auipc	a5,0x5
    800056ce:	d0e7bf23          	sd	a4,-738(a5) # 8000a3e8 <uart_tx_w>
  uartstart();
    800056d2:	ed7ff0ef          	jal	800055a8 <uartstart>
  release(&uart_tx_lock);
    800056d6:	8526                	mv	a0,s1
    800056d8:	190000ef          	jal	80005868 <release>
}
    800056dc:	70a2                	ld	ra,40(sp)
    800056de:	7402                	ld	s0,32(sp)
    800056e0:	64e2                	ld	s1,24(sp)
    800056e2:	6942                	ld	s2,16(sp)
    800056e4:	69a2                	ld	s3,8(sp)
    800056e6:	6a02                	ld	s4,0(sp)
    800056e8:	6145                	addi	sp,sp,48
    800056ea:	8082                	ret
    for(;;)
    800056ec:	a001                	j	800056ec <uartputc+0xa4>

00000000800056ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800056ee:	1141                	addi	sp,sp,-16
    800056f0:	e422                	sd	s0,8(sp)
    800056f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800056f4:	100007b7          	lui	a5,0x10000
    800056f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800056fa:	0007c783          	lbu	a5,0(a5)
    800056fe:	8b85                	andi	a5,a5,1
    80005700:	cb81                	beqz	a5,80005710 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005702:	100007b7          	lui	a5,0x10000
    80005706:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000570a:	6422                	ld	s0,8(sp)
    8000570c:	0141                	addi	sp,sp,16
    8000570e:	8082                	ret
    return -1;
    80005710:	557d                	li	a0,-1
    80005712:	bfe5                	j	8000570a <uartgetc+0x1c>

0000000080005714 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005714:	1101                	addi	sp,sp,-32
    80005716:	ec06                	sd	ra,24(sp)
    80005718:	e822                	sd	s0,16(sp)
    8000571a:	e426                	sd	s1,8(sp)
    8000571c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000571e:	54fd                	li	s1,-1
    80005720:	a019                	j	80005726 <uartintr+0x12>
      break;
    consoleintr(c);
    80005722:	85fff0ef          	jal	80004f80 <consoleintr>
    int c = uartgetc();
    80005726:	fc9ff0ef          	jal	800056ee <uartgetc>
    if(c == -1)
    8000572a:	fe951ce3          	bne	a0,s1,80005722 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000572e:	0001e497          	auipc	s1,0x1e
    80005732:	fba48493          	addi	s1,s1,-70 # 800236e8 <uart_tx_lock>
    80005736:	8526                	mv	a0,s1
    80005738:	098000ef          	jal	800057d0 <acquire>
  uartstart();
    8000573c:	e6dff0ef          	jal	800055a8 <uartstart>
  release(&uart_tx_lock);
    80005740:	8526                	mv	a0,s1
    80005742:	126000ef          	jal	80005868 <release>
}
    80005746:	60e2                	ld	ra,24(sp)
    80005748:	6442                	ld	s0,16(sp)
    8000574a:	64a2                	ld	s1,8(sp)
    8000574c:	6105                	addi	sp,sp,32
    8000574e:	8082                	ret

0000000080005750 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005750:	1141                	addi	sp,sp,-16
    80005752:	e422                	sd	s0,8(sp)
    80005754:	0800                	addi	s0,sp,16
  lk->name = name;
    80005756:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005758:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000575c:	00053823          	sd	zero,16(a0)
}
    80005760:	6422                	ld	s0,8(sp)
    80005762:	0141                	addi	sp,sp,16
    80005764:	8082                	ret

0000000080005766 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005766:	411c                	lw	a5,0(a0)
    80005768:	e399                	bnez	a5,8000576e <holding+0x8>
    8000576a:	4501                	li	a0,0
  return r;
}
    8000576c:	8082                	ret
{
    8000576e:	1101                	addi	sp,sp,-32
    80005770:	ec06                	sd	ra,24(sp)
    80005772:	e822                	sd	s0,16(sp)
    80005774:	e426                	sd	s1,8(sp)
    80005776:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005778:	6904                	ld	s1,16(a0)
    8000577a:	e02fb0ef          	jal	80000d7c <mycpu>
    8000577e:	40a48533          	sub	a0,s1,a0
    80005782:	00153513          	seqz	a0,a0
}
    80005786:	60e2                	ld	ra,24(sp)
    80005788:	6442                	ld	s0,16(sp)
    8000578a:	64a2                	ld	s1,8(sp)
    8000578c:	6105                	addi	sp,sp,32
    8000578e:	8082                	ret

0000000080005790 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005790:	1101                	addi	sp,sp,-32
    80005792:	ec06                	sd	ra,24(sp)
    80005794:	e822                	sd	s0,16(sp)
    80005796:	e426                	sd	s1,8(sp)
    80005798:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000579a:	100024f3          	csrr	s1,sstatus
    8000579e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800057a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800057a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800057a8:	dd4fb0ef          	jal	80000d7c <mycpu>
    800057ac:	5d3c                	lw	a5,120(a0)
    800057ae:	cb99                	beqz	a5,800057c4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800057b0:	dccfb0ef          	jal	80000d7c <mycpu>
    800057b4:	5d3c                	lw	a5,120(a0)
    800057b6:	2785                	addiw	a5,a5,1
    800057b8:	dd3c                	sw	a5,120(a0)
}
    800057ba:	60e2                	ld	ra,24(sp)
    800057bc:	6442                	ld	s0,16(sp)
    800057be:	64a2                	ld	s1,8(sp)
    800057c0:	6105                	addi	sp,sp,32
    800057c2:	8082                	ret
    mycpu()->intena = old;
    800057c4:	db8fb0ef          	jal	80000d7c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800057c8:	8085                	srli	s1,s1,0x1
    800057ca:	8885                	andi	s1,s1,1
    800057cc:	dd64                	sw	s1,124(a0)
    800057ce:	b7cd                	j	800057b0 <push_off+0x20>

00000000800057d0 <acquire>:
{
    800057d0:	1101                	addi	sp,sp,-32
    800057d2:	ec06                	sd	ra,24(sp)
    800057d4:	e822                	sd	s0,16(sp)
    800057d6:	e426                	sd	s1,8(sp)
    800057d8:	1000                	addi	s0,sp,32
    800057da:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800057dc:	fb5ff0ef          	jal	80005790 <push_off>
  if(holding(lk))
    800057e0:	8526                	mv	a0,s1
    800057e2:	f85ff0ef          	jal	80005766 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057e6:	4705                	li	a4,1
  if(holding(lk))
    800057e8:	e105                	bnez	a0,80005808 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800057ea:	87ba                	mv	a5,a4
    800057ec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800057f0:	2781                	sext.w	a5,a5
    800057f2:	ffe5                	bnez	a5,800057ea <acquire+0x1a>
  __sync_synchronize();
    800057f4:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800057f8:	d84fb0ef          	jal	80000d7c <mycpu>
    800057fc:	e888                	sd	a0,16(s1)
}
    800057fe:	60e2                	ld	ra,24(sp)
    80005800:	6442                	ld	s0,16(sp)
    80005802:	64a2                	ld	s1,8(sp)
    80005804:	6105                	addi	sp,sp,32
    80005806:	8082                	ret
    panic("acquire");
    80005808:	00002517          	auipc	a0,0x2
    8000580c:	fd850513          	addi	a0,a0,-40 # 800077e0 <etext+0x7e0>
    80005810:	c93ff0ef          	jal	800054a2 <panic>

0000000080005814 <pop_off>:

void
pop_off(void)
{
    80005814:	1141                	addi	sp,sp,-16
    80005816:	e406                	sd	ra,8(sp)
    80005818:	e022                	sd	s0,0(sp)
    8000581a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000581c:	d60fb0ef          	jal	80000d7c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005820:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005824:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005826:	e78d                	bnez	a5,80005850 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005828:	5d3c                	lw	a5,120(a0)
    8000582a:	02f05963          	blez	a5,8000585c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000582e:	37fd                	addiw	a5,a5,-1
    80005830:	0007871b          	sext.w	a4,a5
    80005834:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005836:	eb09                	bnez	a4,80005848 <pop_off+0x34>
    80005838:	5d7c                	lw	a5,124(a0)
    8000583a:	c799                	beqz	a5,80005848 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000583c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005840:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005844:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005848:	60a2                	ld	ra,8(sp)
    8000584a:	6402                	ld	s0,0(sp)
    8000584c:	0141                	addi	sp,sp,16
    8000584e:	8082                	ret
    panic("pop_off - interruptible");
    80005850:	00002517          	auipc	a0,0x2
    80005854:	f9850513          	addi	a0,a0,-104 # 800077e8 <etext+0x7e8>
    80005858:	c4bff0ef          	jal	800054a2 <panic>
    panic("pop_off");
    8000585c:	00002517          	auipc	a0,0x2
    80005860:	fa450513          	addi	a0,a0,-92 # 80007800 <etext+0x800>
    80005864:	c3fff0ef          	jal	800054a2 <panic>

0000000080005868 <release>:
{
    80005868:	1101                	addi	sp,sp,-32
    8000586a:	ec06                	sd	ra,24(sp)
    8000586c:	e822                	sd	s0,16(sp)
    8000586e:	e426                	sd	s1,8(sp)
    80005870:	1000                	addi	s0,sp,32
    80005872:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005874:	ef3ff0ef          	jal	80005766 <holding>
    80005878:	c105                	beqz	a0,80005898 <release+0x30>
  lk->cpu = 0;
    8000587a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000587e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005882:	0310000f          	fence	rw,w
    80005886:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000588a:	f8bff0ef          	jal	80005814 <pop_off>
}
    8000588e:	60e2                	ld	ra,24(sp)
    80005890:	6442                	ld	s0,16(sp)
    80005892:	64a2                	ld	s1,8(sp)
    80005894:	6105                	addi	sp,sp,32
    80005896:	8082                	ret
    panic("release");
    80005898:	00002517          	auipc	a0,0x2
    8000589c:	f7050513          	addi	a0,a0,-144 # 80007808 <etext+0x808>
    800058a0:	c03ff0ef          	jal	800054a2 <panic>
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
