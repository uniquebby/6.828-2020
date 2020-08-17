
obj/user/faultwritekernel.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	*(unsigned*)0xf0100000 = 0;
  800033:	c7 05 00 00 10 f0 00 	movl   $0x0,0xf0100000
  80003a:	00 00 00 
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 ce 00 00 00       	call   80011c <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x2d>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	55                   	push   %ebp
  800085:	89 e5                	mov    %esp,%ebp
  800087:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008a:	e8 b3 04 00 00       	call   800542 <close_all>
	sys_env_destroy(0);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	6a 00                	push   $0x0
  800094:	e8 42 00 00 00       	call   8000db <sys_env_destroy>
}
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	57                   	push   %edi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000af:	89 c3                	mov    %eax,%ebx
  8000b1:	89 c7                	mov    %eax,%edi
  8000b3:	89 c6                	mov    %eax,%esi
  8000b5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    

008000bc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	57                   	push   %edi
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	89 d3                	mov    %edx,%ebx
  8000d0:	89 d7                	mov    %edx,%edi
  8000d2:	89 d6                	mov    %edx,%esi
  8000d4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5f                   	pop    %edi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f1:	89 cb                	mov    %ecx,%ebx
  8000f3:	89 cf                	mov    %ecx,%edi
  8000f5:	89 ce                	mov    %ecx,%esi
  8000f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f9:	85 c0                	test   %eax,%eax
  8000fb:	7f 08                	jg     800105 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	50                   	push   %eax
  800109:	6a 03                	push   $0x3
  80010b:	68 6a 22 80 00       	push   $0x80226a
  800110:	6a 23                	push   $0x23
  800112:	68 87 22 80 00       	push   $0x802287
  800117:	e8 b1 13 00 00       	call   8014cd <_panic>

0080011c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011c:	55                   	push   %ebp
  80011d:	89 e5                	mov    %esp,%ebp
  80011f:	57                   	push   %edi
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
	asm volatile("int %1\n"
  800122:	ba 00 00 00 00       	mov    $0x0,%edx
  800127:	b8 02 00 00 00       	mov    $0x2,%eax
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	89 d3                	mov    %edx,%ebx
  800130:	89 d7                	mov    %edx,%edi
  800132:	89 d6                	mov    %edx,%esi
  800134:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5f                   	pop    %edi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <sys_yield>:

void
sys_yield(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	57                   	push   %edi
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	asm volatile("int %1\n"
  800141:	ba 00 00 00 00       	mov    $0x0,%edx
  800146:	b8 0b 00 00 00       	mov    $0xb,%eax
  80014b:	89 d1                	mov    %edx,%ecx
  80014d:	89 d3                	mov    %edx,%ebx
  80014f:	89 d7                	mov    %edx,%edi
  800151:	89 d6                	mov    %edx,%esi
  800153:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
  800160:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800163:	be 00 00 00 00       	mov    $0x0,%esi
  800168:	8b 55 08             	mov    0x8(%ebp),%edx
  80016b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016e:	b8 04 00 00 00       	mov    $0x4,%eax
  800173:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800176:	89 f7                	mov    %esi,%edi
  800178:	cd 30                	int    $0x30
	if(check && ret > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 08                	jg     800186 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	6a 04                	push   $0x4
  80018c:	68 6a 22 80 00       	push   $0x80226a
  800191:	6a 23                	push   $0x23
  800193:	68 87 22 80 00       	push   $0x802287
  800198:	e8 30 13 00 00       	call   8014cd <_panic>

0080019d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	57                   	push   %edi
  8001a1:	56                   	push   %esi
  8001a2:	53                   	push   %ebx
  8001a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	7f 08                	jg     8001c8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c3:	5b                   	pop    %ebx
  8001c4:	5e                   	pop    %esi
  8001c5:	5f                   	pop    %edi
  8001c6:	5d                   	pop    %ebp
  8001c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	50                   	push   %eax
  8001cc:	6a 05                	push   $0x5
  8001ce:	68 6a 22 80 00       	push   $0x80226a
  8001d3:	6a 23                	push   $0x23
  8001d5:	68 87 22 80 00       	push   $0x802287
  8001da:	e8 ee 12 00 00       	call   8014cd <_panic>

008001df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	57                   	push   %edi
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f8:	89 df                	mov    %ebx,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fe:	85 c0                	test   %eax,%eax
  800200:	7f 08                	jg     80020a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800202:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5f                   	pop    %edi
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	50                   	push   %eax
  80020e:	6a 06                	push   $0x6
  800210:	68 6a 22 80 00       	push   $0x80226a
  800215:	6a 23                	push   $0x23
  800217:	68 87 22 80 00       	push   $0x802287
  80021c:	e8 ac 12 00 00       	call   8014cd <_panic>

00800221 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 08 00 00 00       	mov    $0x8,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 08                	push   $0x8
  800252:	68 6a 22 80 00       	push   $0x80226a
  800257:	6a 23                	push   $0x23
  800259:	68 87 22 80 00       	push   $0x802287
  80025e:	e8 6a 12 00 00       	call   8014cd <_panic>

00800263 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800271:	8b 55 08             	mov    0x8(%ebp),%edx
  800274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800277:	b8 09 00 00 00       	mov    $0x9,%eax
  80027c:	89 df                	mov    %ebx,%edi
  80027e:	89 de                	mov    %ebx,%esi
  800280:	cd 30                	int    $0x30
	if(check && ret > 0)
  800282:	85 c0                	test   %eax,%eax
  800284:	7f 08                	jg     80028e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	6a 09                	push   $0x9
  800294:	68 6a 22 80 00       	push   $0x80226a
  800299:	6a 23                	push   $0x23
  80029b:	68 87 22 80 00       	push   $0x802287
  8002a0:	e8 28 12 00 00       	call   8014cd <_panic>

008002a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002be:	89 df                	mov    %ebx,%edi
  8002c0:	89 de                	mov    %ebx,%esi
  8002c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	7f 08                	jg     8002d0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	50                   	push   %eax
  8002d4:	6a 0a                	push   $0xa
  8002d6:	68 6a 22 80 00       	push   $0x80226a
  8002db:	6a 23                	push   $0x23
  8002dd:	68 87 22 80 00       	push   $0x802287
  8002e2:	e8 e6 11 00 00       	call   8014cd <_panic>

008002e7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f8:	be 00 00 00 00       	mov    $0x0,%esi
  8002fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800300:	8b 7d 14             	mov    0x14(%ebp),%edi
  800303:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800305:	5b                   	pop    %ebx
  800306:	5e                   	pop    %esi
  800307:	5f                   	pop    %edi
  800308:	5d                   	pop    %ebp
  800309:	c3                   	ret    

0080030a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	57                   	push   %edi
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800313:	b9 00 00 00 00       	mov    $0x0,%ecx
  800318:	8b 55 08             	mov    0x8(%ebp),%edx
  80031b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800320:	89 cb                	mov    %ecx,%ebx
  800322:	89 cf                	mov    %ecx,%edi
  800324:	89 ce                	mov    %ecx,%esi
  800326:	cd 30                	int    $0x30
	if(check && ret > 0)
  800328:	85 c0                	test   %eax,%eax
  80032a:	7f 08                	jg     800334 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	50                   	push   %eax
  800338:	6a 0d                	push   $0xd
  80033a:	68 6a 22 80 00       	push   $0x80226a
  80033f:	6a 23                	push   $0x23
  800341:	68 87 22 80 00       	push   $0x802287
  800346:	e8 82 11 00 00       	call   8014cd <_panic>

0080034b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
	asm volatile("int %1\n"
  800351:	ba 00 00 00 00       	mov    $0x0,%edx
  800356:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035b:	89 d1                	mov    %edx,%ecx
  80035d:	89 d3                	mov    %edx,%ebx
  80035f:	89 d7                	mov    %edx,%edi
  800361:	89 d6                	mov    %edx,%esi
  800363:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800365:	5b                   	pop    %ebx
  800366:	5e                   	pop    %esi
  800367:	5f                   	pop    %edi
  800368:	5d                   	pop    %ebp
  800369:	c3                   	ret    

0080036a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	05 00 00 00 30       	add    $0x30000000,%eax
  800375:	c1 e8 0c             	shr    $0xc,%eax
}
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80037a:	55                   	push   %ebp
  80037b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80037d:	8b 45 08             	mov    0x8(%ebp),%eax
  800380:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80038a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    

00800391 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800399:	89 c2                	mov    %eax,%edx
  80039b:	c1 ea 16             	shr    $0x16,%edx
  80039e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003a5:	f6 c2 01             	test   $0x1,%dl
  8003a8:	74 2d                	je     8003d7 <fd_alloc+0x46>
  8003aa:	89 c2                	mov    %eax,%edx
  8003ac:	c1 ea 0c             	shr    $0xc,%edx
  8003af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003b6:	f6 c2 01             	test   $0x1,%dl
  8003b9:	74 1c                	je     8003d7 <fd_alloc+0x46>
  8003bb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003c0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003c5:	75 d2                	jne    800399 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003d0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003d5:	eb 0a                	jmp    8003e1 <fd_alloc+0x50>
			*fd_store = fd;
  8003d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003da:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003e1:	5d                   	pop    %ebp
  8003e2:	c3                   	ret    

008003e3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003e3:	55                   	push   %ebp
  8003e4:	89 e5                	mov    %esp,%ebp
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003e9:	83 f8 1f             	cmp    $0x1f,%eax
  8003ec:	77 30                	ja     80041e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003ee:	c1 e0 0c             	shl    $0xc,%eax
  8003f1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003f6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8003fc:	f6 c2 01             	test   $0x1,%dl
  8003ff:	74 24                	je     800425 <fd_lookup+0x42>
  800401:	89 c2                	mov    %eax,%edx
  800403:	c1 ea 0c             	shr    $0xc,%edx
  800406:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040d:	f6 c2 01             	test   $0x1,%dl
  800410:	74 1a                	je     80042c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800412:	8b 55 0c             	mov    0xc(%ebp),%edx
  800415:	89 02                	mov    %eax,(%edx)
	return 0;
  800417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80041c:	5d                   	pop    %ebp
  80041d:	c3                   	ret    
		return -E_INVAL;
  80041e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800423:	eb f7                	jmp    80041c <fd_lookup+0x39>
		return -E_INVAL;
  800425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042a:	eb f0                	jmp    80041c <fd_lookup+0x39>
  80042c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800431:	eb e9                	jmp    80041c <fd_lookup+0x39>

00800433 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
  800441:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800446:	39 08                	cmp    %ecx,(%eax)
  800448:	74 38                	je     800482 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80044a:	83 c2 01             	add    $0x1,%edx
  80044d:	8b 04 95 14 23 80 00 	mov    0x802314(,%edx,4),%eax
  800454:	85 c0                	test   %eax,%eax
  800456:	75 ee                	jne    800446 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800458:	a1 08 40 80 00       	mov    0x804008,%eax
  80045d:	8b 40 48             	mov    0x48(%eax),%eax
  800460:	83 ec 04             	sub    $0x4,%esp
  800463:	51                   	push   %ecx
  800464:	50                   	push   %eax
  800465:	68 98 22 80 00       	push   $0x802298
  80046a:	e8 39 11 00 00       	call   8015a8 <cprintf>
	*dev = 0;
  80046f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800478:	83 c4 10             	add    $0x10,%esp
  80047b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800480:	c9                   	leave  
  800481:	c3                   	ret    
			*dev = devtab[i];
  800482:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800485:	89 01                	mov    %eax,(%ecx)
			return 0;
  800487:	b8 00 00 00 00       	mov    $0x0,%eax
  80048c:	eb f2                	jmp    800480 <dev_lookup+0x4d>

0080048e <fd_close>:
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	57                   	push   %edi
  800492:	56                   	push   %esi
  800493:	53                   	push   %ebx
  800494:	83 ec 24             	sub    $0x24,%esp
  800497:	8b 75 08             	mov    0x8(%ebp),%esi
  80049a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80049d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004a1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004a7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004aa:	50                   	push   %eax
  8004ab:	e8 33 ff ff ff       	call   8003e3 <fd_lookup>
  8004b0:	89 c3                	mov    %eax,%ebx
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	85 c0                	test   %eax,%eax
  8004b7:	78 05                	js     8004be <fd_close+0x30>
	    || fd != fd2)
  8004b9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004bc:	74 16                	je     8004d4 <fd_close+0x46>
		return (must_exist ? r : 0);
  8004be:	89 f8                	mov    %edi,%eax
  8004c0:	84 c0                	test   %al,%al
  8004c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c7:	0f 44 d8             	cmove  %eax,%ebx
}
  8004ca:	89 d8                	mov    %ebx,%eax
  8004cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004cf:	5b                   	pop    %ebx
  8004d0:	5e                   	pop    %esi
  8004d1:	5f                   	pop    %edi
  8004d2:	5d                   	pop    %ebp
  8004d3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004da:	50                   	push   %eax
  8004db:	ff 36                	pushl  (%esi)
  8004dd:	e8 51 ff ff ff       	call   800433 <dev_lookup>
  8004e2:	89 c3                	mov    %eax,%ebx
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	85 c0                	test   %eax,%eax
  8004e9:	78 1a                	js     800505 <fd_close+0x77>
		if (dev->dev_close)
  8004eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ee:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004f6:	85 c0                	test   %eax,%eax
  8004f8:	74 0b                	je     800505 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8004fa:	83 ec 0c             	sub    $0xc,%esp
  8004fd:	56                   	push   %esi
  8004fe:	ff d0                	call   *%eax
  800500:	89 c3                	mov    %eax,%ebx
  800502:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	56                   	push   %esi
  800509:	6a 00                	push   $0x0
  80050b:	e8 cf fc ff ff       	call   8001df <sys_page_unmap>
	return r;
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	eb b5                	jmp    8004ca <fd_close+0x3c>

00800515 <close>:

int
close(int fdnum)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80051b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80051e:	50                   	push   %eax
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 bc fe ff ff       	call   8003e3 <fd_lookup>
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	85 c0                	test   %eax,%eax
  80052c:	79 02                	jns    800530 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80052e:	c9                   	leave  
  80052f:	c3                   	ret    
		return fd_close(fd, 1);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	6a 01                	push   $0x1
  800535:	ff 75 f4             	pushl  -0xc(%ebp)
  800538:	e8 51 ff ff ff       	call   80048e <fd_close>
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	eb ec                	jmp    80052e <close+0x19>

00800542 <close_all>:

void
close_all(void)
{
  800542:	55                   	push   %ebp
  800543:	89 e5                	mov    %esp,%ebp
  800545:	53                   	push   %ebx
  800546:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800549:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80054e:	83 ec 0c             	sub    $0xc,%esp
  800551:	53                   	push   %ebx
  800552:	e8 be ff ff ff       	call   800515 <close>
	for (i = 0; i < MAXFD; i++)
  800557:	83 c3 01             	add    $0x1,%ebx
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	83 fb 20             	cmp    $0x20,%ebx
  800560:	75 ec                	jne    80054e <close_all+0xc>
}
  800562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	57                   	push   %edi
  80056b:	56                   	push   %esi
  80056c:	53                   	push   %ebx
  80056d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800570:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	ff 75 08             	pushl  0x8(%ebp)
  800577:	e8 67 fe ff ff       	call   8003e3 <fd_lookup>
  80057c:	89 c3                	mov    %eax,%ebx
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	85 c0                	test   %eax,%eax
  800583:	0f 88 81 00 00 00    	js     80060a <dup+0xa3>
		return r;
	close(newfdnum);
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	e8 81 ff ff ff       	call   800515 <close>

	newfd = INDEX2FD(newfdnum);
  800594:	8b 75 0c             	mov    0xc(%ebp),%esi
  800597:	c1 e6 0c             	shl    $0xc,%esi
  80059a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005a0:	83 c4 04             	add    $0x4,%esp
  8005a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005a6:	e8 cf fd ff ff       	call   80037a <fd2data>
  8005ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005ad:	89 34 24             	mov    %esi,(%esp)
  8005b0:	e8 c5 fd ff ff       	call   80037a <fd2data>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005ba:	89 d8                	mov    %ebx,%eax
  8005bc:	c1 e8 16             	shr    $0x16,%eax
  8005bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005c6:	a8 01                	test   $0x1,%al
  8005c8:	74 11                	je     8005db <dup+0x74>
  8005ca:	89 d8                	mov    %ebx,%eax
  8005cc:	c1 e8 0c             	shr    $0xc,%eax
  8005cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005d6:	f6 c2 01             	test   $0x1,%dl
  8005d9:	75 39                	jne    800614 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005de:	89 d0                	mov    %edx,%eax
  8005e0:	c1 e8 0c             	shr    $0xc,%eax
  8005e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005ea:	83 ec 0c             	sub    $0xc,%esp
  8005ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8005f2:	50                   	push   %eax
  8005f3:	56                   	push   %esi
  8005f4:	6a 00                	push   $0x0
  8005f6:	52                   	push   %edx
  8005f7:	6a 00                	push   $0x0
  8005f9:	e8 9f fb ff ff       	call   80019d <sys_page_map>
  8005fe:	89 c3                	mov    %eax,%ebx
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	85 c0                	test   %eax,%eax
  800605:	78 31                	js     800638 <dup+0xd1>
		goto err;

	return newfdnum;
  800607:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80060a:	89 d8                	mov    %ebx,%eax
  80060c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060f:	5b                   	pop    %ebx
  800610:	5e                   	pop    %esi
  800611:	5f                   	pop    %edi
  800612:	5d                   	pop    %ebp
  800613:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800614:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	25 07 0e 00 00       	and    $0xe07,%eax
  800623:	50                   	push   %eax
  800624:	57                   	push   %edi
  800625:	6a 00                	push   $0x0
  800627:	53                   	push   %ebx
  800628:	6a 00                	push   $0x0
  80062a:	e8 6e fb ff ff       	call   80019d <sys_page_map>
  80062f:	89 c3                	mov    %eax,%ebx
  800631:	83 c4 20             	add    $0x20,%esp
  800634:	85 c0                	test   %eax,%eax
  800636:	79 a3                	jns    8005db <dup+0x74>
	sys_page_unmap(0, newfd);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	56                   	push   %esi
  80063c:	6a 00                	push   $0x0
  80063e:	e8 9c fb ff ff       	call   8001df <sys_page_unmap>
	sys_page_unmap(0, nva);
  800643:	83 c4 08             	add    $0x8,%esp
  800646:	57                   	push   %edi
  800647:	6a 00                	push   $0x0
  800649:	e8 91 fb ff ff       	call   8001df <sys_page_unmap>
	return r;
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb b7                	jmp    80060a <dup+0xa3>

00800653 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	53                   	push   %ebx
  800657:	83 ec 1c             	sub    $0x1c,%esp
  80065a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80065d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800660:	50                   	push   %eax
  800661:	53                   	push   %ebx
  800662:	e8 7c fd ff ff       	call   8003e3 <fd_lookup>
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	85 c0                	test   %eax,%eax
  80066c:	78 3f                	js     8006ad <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800674:	50                   	push   %eax
  800675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800678:	ff 30                	pushl  (%eax)
  80067a:	e8 b4 fd ff ff       	call   800433 <dev_lookup>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	85 c0                	test   %eax,%eax
  800684:	78 27                	js     8006ad <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800689:	8b 42 08             	mov    0x8(%edx),%eax
  80068c:	83 e0 03             	and    $0x3,%eax
  80068f:	83 f8 01             	cmp    $0x1,%eax
  800692:	74 1e                	je     8006b2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800697:	8b 40 08             	mov    0x8(%eax),%eax
  80069a:	85 c0                	test   %eax,%eax
  80069c:	74 35                	je     8006d3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80069e:	83 ec 04             	sub    $0x4,%esp
  8006a1:	ff 75 10             	pushl  0x10(%ebp)
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	52                   	push   %edx
  8006a8:	ff d0                	call   *%eax
  8006aa:	83 c4 10             	add    $0x10,%esp
}
  8006ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8006b7:	8b 40 48             	mov    0x48(%eax),%eax
  8006ba:	83 ec 04             	sub    $0x4,%esp
  8006bd:	53                   	push   %ebx
  8006be:	50                   	push   %eax
  8006bf:	68 d9 22 80 00       	push   $0x8022d9
  8006c4:	e8 df 0e 00 00       	call   8015a8 <cprintf>
		return -E_INVAL;
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006d1:	eb da                	jmp    8006ad <read+0x5a>
		return -E_NOT_SUPP;
  8006d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006d8:	eb d3                	jmp    8006ad <read+0x5a>

008006da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	57                   	push   %edi
  8006de:	56                   	push   %esi
  8006df:	53                   	push   %ebx
  8006e0:	83 ec 0c             	sub    $0xc,%esp
  8006e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ee:	39 f3                	cmp    %esi,%ebx
  8006f0:	73 23                	jae    800715 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	89 f0                	mov    %esi,%eax
  8006f7:	29 d8                	sub    %ebx,%eax
  8006f9:	50                   	push   %eax
  8006fa:	89 d8                	mov    %ebx,%eax
  8006fc:	03 45 0c             	add    0xc(%ebp),%eax
  8006ff:	50                   	push   %eax
  800700:	57                   	push   %edi
  800701:	e8 4d ff ff ff       	call   800653 <read>
		if (m < 0)
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	85 c0                	test   %eax,%eax
  80070b:	78 06                	js     800713 <readn+0x39>
			return m;
		if (m == 0)
  80070d:	74 06                	je     800715 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80070f:	01 c3                	add    %eax,%ebx
  800711:	eb db                	jmp    8006ee <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800713:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800715:	89 d8                	mov    %ebx,%eax
  800717:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	53                   	push   %ebx
  800723:	83 ec 1c             	sub    $0x1c,%esp
  800726:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800729:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	53                   	push   %ebx
  80072e:	e8 b0 fc ff ff       	call   8003e3 <fd_lookup>
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	85 c0                	test   %eax,%eax
  800738:	78 3a                	js     800774 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800740:	50                   	push   %eax
  800741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800744:	ff 30                	pushl  (%eax)
  800746:	e8 e8 fc ff ff       	call   800433 <dev_lookup>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 c0                	test   %eax,%eax
  800750:	78 22                	js     800774 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800755:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800759:	74 1e                	je     800779 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80075b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075e:	8b 52 0c             	mov    0xc(%edx),%edx
  800761:	85 d2                	test   %edx,%edx
  800763:	74 35                	je     80079a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	ff 75 10             	pushl  0x10(%ebp)
  80076b:	ff 75 0c             	pushl  0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	ff d2                	call   *%edx
  800771:	83 c4 10             	add    $0x10,%esp
}
  800774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800777:	c9                   	leave  
  800778:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800779:	a1 08 40 80 00       	mov    0x804008,%eax
  80077e:	8b 40 48             	mov    0x48(%eax),%eax
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	53                   	push   %ebx
  800785:	50                   	push   %eax
  800786:	68 f5 22 80 00       	push   $0x8022f5
  80078b:	e8 18 0e 00 00       	call   8015a8 <cprintf>
		return -E_INVAL;
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800798:	eb da                	jmp    800774 <write+0x55>
		return -E_NOT_SUPP;
  80079a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079f:	eb d3                	jmp    800774 <write+0x55>

008007a1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 08             	pushl  0x8(%ebp)
  8007ae:	e8 30 fc ff ff       	call   8003e3 <fd_lookup>
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	78 0e                	js     8007c8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	53                   	push   %ebx
  8007ce:	83 ec 1c             	sub    $0x1c,%esp
  8007d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	53                   	push   %ebx
  8007d9:	e8 05 fc ff ff       	call   8003e3 <fd_lookup>
  8007de:	83 c4 10             	add    $0x10,%esp
  8007e1:	85 c0                	test   %eax,%eax
  8007e3:	78 37                	js     80081c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007eb:	50                   	push   %eax
  8007ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ef:	ff 30                	pushl  (%eax)
  8007f1:	e8 3d fc ff ff       	call   800433 <dev_lookup>
  8007f6:	83 c4 10             	add    $0x10,%esp
  8007f9:	85 c0                	test   %eax,%eax
  8007fb:	78 1f                	js     80081c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800800:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800804:	74 1b                	je     800821 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800809:	8b 52 18             	mov    0x18(%edx),%edx
  80080c:	85 d2                	test   %edx,%edx
  80080e:	74 32                	je     800842 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	50                   	push   %eax
  800817:	ff d2                	call   *%edx
  800819:	83 c4 10             	add    $0x10,%esp
}
  80081c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081f:	c9                   	leave  
  800820:	c3                   	ret    
			thisenv->env_id, fdnum);
  800821:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800826:	8b 40 48             	mov    0x48(%eax),%eax
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	53                   	push   %ebx
  80082d:	50                   	push   %eax
  80082e:	68 b8 22 80 00       	push   $0x8022b8
  800833:	e8 70 0d 00 00       	call   8015a8 <cprintf>
		return -E_INVAL;
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800840:	eb da                	jmp    80081c <ftruncate+0x52>
		return -E_NOT_SUPP;
  800842:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800847:	eb d3                	jmp    80081c <ftruncate+0x52>

00800849 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	53                   	push   %ebx
  80084d:	83 ec 1c             	sub    $0x1c,%esp
  800850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800853:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800856:	50                   	push   %eax
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	e8 84 fb ff ff       	call   8003e3 <fd_lookup>
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	85 c0                	test   %eax,%eax
  800864:	78 4b                	js     8008b1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	ff 30                	pushl  (%eax)
  800872:	e8 bc fb ff ff       	call   800433 <dev_lookup>
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	85 c0                	test   %eax,%eax
  80087c:	78 33                	js     8008b1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800881:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800885:	74 2f                	je     8008b6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800887:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80088a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800891:	00 00 00 
	stat->st_isdir = 0;
  800894:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80089b:	00 00 00 
	stat->st_dev = dev;
  80089e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ab:	ff 50 14             	call   *0x14(%eax)
  8008ae:	83 c4 10             	add    $0x10,%esp
}
  8008b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b4:	c9                   	leave  
  8008b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8008b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bb:	eb f4                	jmp    8008b1 <fstat+0x68>

008008bd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	6a 00                	push   $0x0
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 2f 02 00 00       	call   800afe <open>
  8008cf:	89 c3                	mov    %eax,%ebx
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	85 c0                	test   %eax,%eax
  8008d6:	78 1b                	js     8008f3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	e8 65 ff ff ff       	call   800849 <fstat>
  8008e4:	89 c6                	mov    %eax,%esi
	close(fd);
  8008e6:	89 1c 24             	mov    %ebx,(%esp)
  8008e9:	e8 27 fc ff ff       	call   800515 <close>
	return r;
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 f3                	mov    %esi,%ebx
}
  8008f3:	89 d8                	mov    %ebx,%eax
  8008f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f8:	5b                   	pop    %ebx
  8008f9:	5e                   	pop    %esi
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	89 c6                	mov    %eax,%esi
  800903:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800905:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80090c:	74 27                	je     800935 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80090e:	6a 07                	push   $0x7
  800910:	68 00 50 80 00       	push   $0x805000
  800915:	56                   	push   %esi
  800916:	ff 35 00 40 80 00    	pushl  0x804000
  80091c:	e8 0c 16 00 00       	call   801f2d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800921:	83 c4 0c             	add    $0xc,%esp
  800924:	6a 00                	push   $0x0
  800926:	53                   	push   %ebx
  800927:	6a 00                	push   $0x0
  800929:	e8 8c 15 00 00       	call   801eba <ipc_recv>
}
  80092e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800935:	83 ec 0c             	sub    $0xc,%esp
  800938:	6a 01                	push   $0x1
  80093a:	e8 5a 16 00 00       	call   801f99 <ipc_find_env>
  80093f:	a3 00 40 80 00       	mov    %eax,0x804000
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb c5                	jmp    80090e <fsipc+0x12>

00800949 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 40 0c             	mov    0xc(%eax),%eax
  800955:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800962:	ba 00 00 00 00       	mov    $0x0,%edx
  800967:	b8 02 00 00 00       	mov    $0x2,%eax
  80096c:	e8 8b ff ff ff       	call   8008fc <fsipc>
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <devfile_flush>:
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 40 0c             	mov    0xc(%eax),%eax
  80097f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	b8 06 00 00 00       	mov    $0x6,%eax
  80098e:	e8 69 ff ff ff       	call   8008fc <fsipc>
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <devfile_stat>:
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	53                   	push   %ebx
  800999:	83 ec 04             	sub    $0x4,%esp
  80099c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8009a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8009af:	b8 05 00 00 00       	mov    $0x5,%eax
  8009b4:	e8 43 ff ff ff       	call   8008fc <fsipc>
  8009b9:	85 c0                	test   %eax,%eax
  8009bb:	78 2c                	js     8009e9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	68 00 50 80 00       	push   $0x805000
  8009c5:	53                   	push   %ebx
  8009c6:	e8 b9 11 00 00       	call   801b84 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009cb:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009d6:	a1 84 50 80 00       	mov    0x805084,%eax
  8009db:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <devfile_write>:
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	53                   	push   %ebx
  8009f2:	83 ec 04             	sub    $0x4,%esp
  8009f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  8009f8:	85 db                	test   %ebx,%ebx
  8009fa:	75 07                	jne    800a03 <devfile_write+0x15>
	return n_all;
  8009fc:	89 d8                	mov    %ebx,%eax
}
  8009fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8b 40 0c             	mov    0xc(%eax),%eax
  800a09:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a0e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a14:	83 ec 04             	sub    $0x4,%esp
  800a17:	53                   	push   %ebx
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	68 08 50 80 00       	push   $0x805008
  800a20:	e8 ed 12 00 00       	call   801d12 <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	b8 04 00 00 00       	mov    $0x4,%eax
  800a2f:	e8 c8 fe ff ff       	call   8008fc <fsipc>
  800a34:	83 c4 10             	add    $0x10,%esp
  800a37:	85 c0                	test   %eax,%eax
  800a39:	78 c3                	js     8009fe <devfile_write+0x10>
	  assert(r <= n_left);
  800a3b:	39 d8                	cmp    %ebx,%eax
  800a3d:	77 0b                	ja     800a4a <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a3f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a44:	7f 1d                	jg     800a63 <devfile_write+0x75>
    n_all += r;
  800a46:	89 c3                	mov    %eax,%ebx
  800a48:	eb b2                	jmp    8009fc <devfile_write+0xe>
	  assert(r <= n_left);
  800a4a:	68 28 23 80 00       	push   $0x802328
  800a4f:	68 34 23 80 00       	push   $0x802334
  800a54:	68 9f 00 00 00       	push   $0x9f
  800a59:	68 49 23 80 00       	push   $0x802349
  800a5e:	e8 6a 0a 00 00       	call   8014cd <_panic>
	  assert(r <= PGSIZE);
  800a63:	68 54 23 80 00       	push   $0x802354
  800a68:	68 34 23 80 00       	push   $0x802334
  800a6d:	68 a0 00 00 00       	push   $0xa0
  800a72:	68 49 23 80 00       	push   $0x802349
  800a77:	e8 51 0a 00 00       	call   8014cd <_panic>

00800a7c <devfile_read>:
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 40 0c             	mov    0xc(%eax),%eax
  800a8a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a8f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a95:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9f:	e8 58 fe ff ff       	call   8008fc <fsipc>
  800aa4:	89 c3                	mov    %eax,%ebx
  800aa6:	85 c0                	test   %eax,%eax
  800aa8:	78 1f                	js     800ac9 <devfile_read+0x4d>
	assert(r <= n);
  800aaa:	39 f0                	cmp    %esi,%eax
  800aac:	77 24                	ja     800ad2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800aae:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ab3:	7f 33                	jg     800ae8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	50                   	push   %eax
  800ab9:	68 00 50 80 00       	push   $0x805000
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	e8 4c 12 00 00       	call   801d12 <memmove>
	return r;
  800ac6:	83 c4 10             	add    $0x10,%esp
}
  800ac9:	89 d8                	mov    %ebx,%eax
  800acb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ace:	5b                   	pop    %ebx
  800acf:	5e                   	pop    %esi
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    
	assert(r <= n);
  800ad2:	68 60 23 80 00       	push   $0x802360
  800ad7:	68 34 23 80 00       	push   $0x802334
  800adc:	6a 7c                	push   $0x7c
  800ade:	68 49 23 80 00       	push   $0x802349
  800ae3:	e8 e5 09 00 00       	call   8014cd <_panic>
	assert(r <= PGSIZE);
  800ae8:	68 54 23 80 00       	push   $0x802354
  800aed:	68 34 23 80 00       	push   $0x802334
  800af2:	6a 7d                	push   $0x7d
  800af4:	68 49 23 80 00       	push   $0x802349
  800af9:	e8 cf 09 00 00       	call   8014cd <_panic>

00800afe <open>:
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	56                   	push   %esi
  800b02:	53                   	push   %ebx
  800b03:	83 ec 1c             	sub    $0x1c,%esp
  800b06:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b09:	56                   	push   %esi
  800b0a:	e8 3c 10 00 00       	call   801b4b <strlen>
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b17:	7f 6c                	jg     800b85 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b19:	83 ec 0c             	sub    $0xc,%esp
  800b1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b1f:	50                   	push   %eax
  800b20:	e8 6c f8 ff ff       	call   800391 <fd_alloc>
  800b25:	89 c3                	mov    %eax,%ebx
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	85 c0                	test   %eax,%eax
  800b2c:	78 3c                	js     800b6a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	56                   	push   %esi
  800b32:	68 00 50 80 00       	push   $0x805000
  800b37:	e8 48 10 00 00       	call   801b84 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b47:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4c:	e8 ab fd ff ff       	call   8008fc <fsipc>
  800b51:	89 c3                	mov    %eax,%ebx
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	85 c0                	test   %eax,%eax
  800b58:	78 19                	js     800b73 <open+0x75>
	return fd2num(fd);
  800b5a:	83 ec 0c             	sub    $0xc,%esp
  800b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b60:	e8 05 f8 ff ff       	call   80036a <fd2num>
  800b65:	89 c3                	mov    %eax,%ebx
  800b67:	83 c4 10             	add    $0x10,%esp
}
  800b6a:	89 d8                	mov    %ebx,%eax
  800b6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    
		fd_close(fd, 0);
  800b73:	83 ec 08             	sub    $0x8,%esp
  800b76:	6a 00                	push   $0x0
  800b78:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7b:	e8 0e f9 ff ff       	call   80048e <fd_close>
		return r;
  800b80:	83 c4 10             	add    $0x10,%esp
  800b83:	eb e5                	jmp    800b6a <open+0x6c>
		return -E_BAD_PATH;
  800b85:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b8a:	eb de                	jmp    800b6a <open+0x6c>

00800b8c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b92:	ba 00 00 00 00       	mov    $0x0,%edx
  800b97:	b8 08 00 00 00       	mov    $0x8,%eax
  800b9c:	e8 5b fd ff ff       	call   8008fc <fsipc>
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bab:	83 ec 0c             	sub    $0xc,%esp
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 c4 f7 ff ff       	call   80037a <fd2data>
  800bb6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bb8:	83 c4 08             	add    $0x8,%esp
  800bbb:	68 67 23 80 00       	push   $0x802367
  800bc0:	53                   	push   %ebx
  800bc1:	e8 be 0f 00 00       	call   801b84 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bc6:	8b 46 04             	mov    0x4(%esi),%eax
  800bc9:	2b 06                	sub    (%esi),%eax
  800bcb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bd1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800bd8:	00 00 00 
	stat->st_dev = &devpipe;
  800bdb:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800be2:	30 80 00 
	return 0;
}
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	53                   	push   %ebx
  800bf5:	83 ec 0c             	sub    $0xc,%esp
  800bf8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800bfb:	53                   	push   %ebx
  800bfc:	6a 00                	push   $0x0
  800bfe:	e8 dc f5 ff ff       	call   8001df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c03:	89 1c 24             	mov    %ebx,(%esp)
  800c06:	e8 6f f7 ff ff       	call   80037a <fd2data>
  800c0b:	83 c4 08             	add    $0x8,%esp
  800c0e:	50                   	push   %eax
  800c0f:	6a 00                	push   $0x0
  800c11:	e8 c9 f5 ff ff       	call   8001df <sys_page_unmap>
}
  800c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <_pipeisclosed>:
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	83 ec 1c             	sub    $0x1c,%esp
  800c24:	89 c7                	mov    %eax,%edi
  800c26:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c28:	a1 08 40 80 00       	mov    0x804008,%eax
  800c2d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c30:	83 ec 0c             	sub    $0xc,%esp
  800c33:	57                   	push   %edi
  800c34:	e8 99 13 00 00       	call   801fd2 <pageref>
  800c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3c:	89 34 24             	mov    %esi,(%esp)
  800c3f:	e8 8e 13 00 00       	call   801fd2 <pageref>
		nn = thisenv->env_runs;
  800c44:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c4a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	39 cb                	cmp    %ecx,%ebx
  800c52:	74 1b                	je     800c6f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c54:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c57:	75 cf                	jne    800c28 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c59:	8b 42 58             	mov    0x58(%edx),%eax
  800c5c:	6a 01                	push   $0x1
  800c5e:	50                   	push   %eax
  800c5f:	53                   	push   %ebx
  800c60:	68 6e 23 80 00       	push   $0x80236e
  800c65:	e8 3e 09 00 00       	call   8015a8 <cprintf>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	eb b9                	jmp    800c28 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c6f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c72:	0f 94 c0             	sete   %al
  800c75:	0f b6 c0             	movzbl %al,%eax
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <devpipe_write>:
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 28             	sub    $0x28,%esp
  800c89:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c8c:	56                   	push   %esi
  800c8d:	e8 e8 f6 ff ff       	call   80037a <fd2data>
  800c92:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c9f:	74 4f                	je     800cf0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800ca1:	8b 43 04             	mov    0x4(%ebx),%eax
  800ca4:	8b 0b                	mov    (%ebx),%ecx
  800ca6:	8d 51 20             	lea    0x20(%ecx),%edx
  800ca9:	39 d0                	cmp    %edx,%eax
  800cab:	72 14                	jb     800cc1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cad:	89 da                	mov    %ebx,%edx
  800caf:	89 f0                	mov    %esi,%eax
  800cb1:	e8 65 ff ff ff       	call   800c1b <_pipeisclosed>
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	75 3b                	jne    800cf5 <devpipe_write+0x75>
			sys_yield();
  800cba:	e8 7c f4 ff ff       	call   80013b <sys_yield>
  800cbf:	eb e0                	jmp    800ca1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cc8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800ccb:	89 c2                	mov    %eax,%edx
  800ccd:	c1 fa 1f             	sar    $0x1f,%edx
  800cd0:	89 d1                	mov    %edx,%ecx
  800cd2:	c1 e9 1b             	shr    $0x1b,%ecx
  800cd5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800cd8:	83 e2 1f             	and    $0x1f,%edx
  800cdb:	29 ca                	sub    %ecx,%edx
  800cdd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800ce1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800ce5:	83 c0 01             	add    $0x1,%eax
  800ce8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800ceb:	83 c7 01             	add    $0x1,%edi
  800cee:	eb ac                	jmp    800c9c <devpipe_write+0x1c>
	return i;
  800cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf3:	eb 05                	jmp    800cfa <devpipe_write+0x7a>
				return 0;
  800cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <devpipe_read>:
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 18             	sub    $0x18,%esp
  800d0b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d0e:	57                   	push   %edi
  800d0f:	e8 66 f6 ff ff       	call   80037a <fd2data>
  800d14:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	be 00 00 00 00       	mov    $0x0,%esi
  800d1e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d21:	75 14                	jne    800d37 <devpipe_read+0x35>
	return i;
  800d23:	8b 45 10             	mov    0x10(%ebp),%eax
  800d26:	eb 02                	jmp    800d2a <devpipe_read+0x28>
				return i;
  800d28:	89 f0                	mov    %esi,%eax
}
  800d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
			sys_yield();
  800d32:	e8 04 f4 ff ff       	call   80013b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d37:	8b 03                	mov    (%ebx),%eax
  800d39:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d3c:	75 18                	jne    800d56 <devpipe_read+0x54>
			if (i > 0)
  800d3e:	85 f6                	test   %esi,%esi
  800d40:	75 e6                	jne    800d28 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d42:	89 da                	mov    %ebx,%edx
  800d44:	89 f8                	mov    %edi,%eax
  800d46:	e8 d0 fe ff ff       	call   800c1b <_pipeisclosed>
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	74 e3                	je     800d32 <devpipe_read+0x30>
				return 0;
  800d4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d54:	eb d4                	jmp    800d2a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d56:	99                   	cltd   
  800d57:	c1 ea 1b             	shr    $0x1b,%edx
  800d5a:	01 d0                	add    %edx,%eax
  800d5c:	83 e0 1f             	and    $0x1f,%eax
  800d5f:	29 d0                	sub    %edx,%eax
  800d61:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d6c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d6f:	83 c6 01             	add    $0x1,%esi
  800d72:	eb aa                	jmp    800d1e <devpipe_read+0x1c>

00800d74 <pipe>:
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d7f:	50                   	push   %eax
  800d80:	e8 0c f6 ff ff       	call   800391 <fd_alloc>
  800d85:	89 c3                	mov    %eax,%ebx
  800d87:	83 c4 10             	add    $0x10,%esp
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	0f 88 23 01 00 00    	js     800eb5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	68 07 04 00 00       	push   $0x407
  800d9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9d:	6a 00                	push   $0x0
  800d9f:	e8 b6 f3 ff ff       	call   80015a <sys_page_alloc>
  800da4:	89 c3                	mov    %eax,%ebx
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	85 c0                	test   %eax,%eax
  800dab:	0f 88 04 01 00 00    	js     800eb5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800db7:	50                   	push   %eax
  800db8:	e8 d4 f5 ff ff       	call   800391 <fd_alloc>
  800dbd:	89 c3                	mov    %eax,%ebx
  800dbf:	83 c4 10             	add    $0x10,%esp
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	0f 88 db 00 00 00    	js     800ea5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dca:	83 ec 04             	sub    $0x4,%esp
  800dcd:	68 07 04 00 00       	push   $0x407
  800dd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd5:	6a 00                	push   $0x0
  800dd7:	e8 7e f3 ff ff       	call   80015a <sys_page_alloc>
  800ddc:	89 c3                	mov    %eax,%ebx
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	85 c0                	test   %eax,%eax
  800de3:	0f 88 bc 00 00 00    	js     800ea5 <pipe+0x131>
	va = fd2data(fd0);
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	ff 75 f4             	pushl  -0xc(%ebp)
  800def:	e8 86 f5 ff ff       	call   80037a <fd2data>
  800df4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800df6:	83 c4 0c             	add    $0xc,%esp
  800df9:	68 07 04 00 00       	push   $0x407
  800dfe:	50                   	push   %eax
  800dff:	6a 00                	push   $0x0
  800e01:	e8 54 f3 ff ff       	call   80015a <sys_page_alloc>
  800e06:	89 c3                	mov    %eax,%ebx
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	0f 88 82 00 00 00    	js     800e95 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	ff 75 f0             	pushl  -0x10(%ebp)
  800e19:	e8 5c f5 ff ff       	call   80037a <fd2data>
  800e1e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e25:	50                   	push   %eax
  800e26:	6a 00                	push   $0x0
  800e28:	56                   	push   %esi
  800e29:	6a 00                	push   $0x0
  800e2b:	e8 6d f3 ff ff       	call   80019d <sys_page_map>
  800e30:	89 c3                	mov    %eax,%ebx
  800e32:	83 c4 20             	add    $0x20,%esp
  800e35:	85 c0                	test   %eax,%eax
  800e37:	78 4e                	js     800e87 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e39:	a1 20 30 80 00       	mov    0x803020,%eax
  800e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e41:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e46:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e50:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e55:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e62:	e8 03 f5 ff ff       	call   80036a <fd2num>
  800e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e6c:	83 c4 04             	add    $0x4,%esp
  800e6f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e72:	e8 f3 f4 ff ff       	call   80036a <fd2num>
  800e77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e7d:	83 c4 10             	add    $0x10,%esp
  800e80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e85:	eb 2e                	jmp    800eb5 <pipe+0x141>
	sys_page_unmap(0, va);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	56                   	push   %esi
  800e8b:	6a 00                	push   $0x0
  800e8d:	e8 4d f3 ff ff       	call   8001df <sys_page_unmap>
  800e92:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e95:	83 ec 08             	sub    $0x8,%esp
  800e98:	ff 75 f0             	pushl  -0x10(%ebp)
  800e9b:	6a 00                	push   $0x0
  800e9d:	e8 3d f3 ff ff       	call   8001df <sys_page_unmap>
  800ea2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 f4             	pushl  -0xc(%ebp)
  800eab:	6a 00                	push   $0x0
  800ead:	e8 2d f3 ff ff       	call   8001df <sys_page_unmap>
  800eb2:	83 c4 10             	add    $0x10,%esp
}
  800eb5:	89 d8                	mov    %ebx,%eax
  800eb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <pipeisclosed>:
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec7:	50                   	push   %eax
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 13 f5 ff ff       	call   8003e3 <fd_lookup>
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	78 18                	js     800eef <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	ff 75 f4             	pushl  -0xc(%ebp)
  800edd:	e8 98 f4 ff ff       	call   80037a <fd2data>
	return _pipeisclosed(fd, p);
  800ee2:	89 c2                	mov    %eax,%edx
  800ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee7:	e8 2f fd ff ff       	call   800c1b <_pipeisclosed>
  800eec:	83 c4 10             	add    $0x10,%esp
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800ef7:	68 86 23 80 00       	push   $0x802386
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	e8 80 0c 00 00       	call   801b84 <strcpy>
	return 0;
}
  800f04:	b8 00 00 00 00       	mov    $0x0,%eax
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <devsock_close>:
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 10             	sub    $0x10,%esp
  800f12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f15:	53                   	push   %ebx
  800f16:	e8 b7 10 00 00       	call   801fd2 <pageref>
  800f1b:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f1e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f23:	83 f8 01             	cmp    $0x1,%eax
  800f26:	74 07                	je     800f2f <devsock_close+0x24>
}
  800f28:	89 d0                	mov    %edx,%eax
  800f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	ff 73 0c             	pushl  0xc(%ebx)
  800f35:	e8 b9 02 00 00       	call   8011f3 <nsipc_close>
  800f3a:	89 c2                	mov    %eax,%edx
  800f3c:	83 c4 10             	add    $0x10,%esp
  800f3f:	eb e7                	jmp    800f28 <devsock_close+0x1d>

00800f41 <devsock_write>:
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f47:	6a 00                	push   $0x0
  800f49:	ff 75 10             	pushl  0x10(%ebp)
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	ff 70 0c             	pushl  0xc(%eax)
  800f55:	e8 76 03 00 00       	call   8012d0 <nsipc_send>
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <devsock_read>:
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f62:	6a 00                	push   $0x0
  800f64:	ff 75 10             	pushl  0x10(%ebp)
  800f67:	ff 75 0c             	pushl  0xc(%ebp)
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	ff 70 0c             	pushl  0xc(%eax)
  800f70:	e8 ef 02 00 00       	call   801264 <nsipc_recv>
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <fd2sockid>:
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f7d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f80:	52                   	push   %edx
  800f81:	50                   	push   %eax
  800f82:	e8 5c f4 ff ff       	call   8003e3 <fd_lookup>
  800f87:	83 c4 10             	add    $0x10,%esp
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	78 10                	js     800f9e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f91:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800f97:	39 08                	cmp    %ecx,(%eax)
  800f99:	75 05                	jne    800fa0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800f9b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    
		return -E_NOT_SUPP;
  800fa0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fa5:	eb f7                	jmp    800f9e <fd2sockid+0x27>

00800fa7 <alloc_sockfd>:
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 1c             	sub    $0x1c,%esp
  800faf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb4:	50                   	push   %eax
  800fb5:	e8 d7 f3 ff ff       	call   800391 <fd_alloc>
  800fba:	89 c3                	mov    %eax,%ebx
  800fbc:	83 c4 10             	add    $0x10,%esp
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	78 43                	js     801006 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fc3:	83 ec 04             	sub    $0x4,%esp
  800fc6:	68 07 04 00 00       	push   $0x407
  800fcb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fce:	6a 00                	push   $0x0
  800fd0:	e8 85 f1 ff ff       	call   80015a <sys_page_alloc>
  800fd5:	89 c3                	mov    %eax,%ebx
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	78 28                	js     801006 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fec:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800ff3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800ff6:	83 ec 0c             	sub    $0xc,%esp
  800ff9:	50                   	push   %eax
  800ffa:	e8 6b f3 ff ff       	call   80036a <fd2num>
  800fff:	89 c3                	mov    %eax,%ebx
  801001:	83 c4 10             	add    $0x10,%esp
  801004:	eb 0c                	jmp    801012 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	56                   	push   %esi
  80100a:	e8 e4 01 00 00       	call   8011f3 <nsipc_close>
		return r;
  80100f:	83 c4 10             	add    $0x10,%esp
}
  801012:	89 d8                	mov    %ebx,%eax
  801014:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <accept>:
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	e8 4e ff ff ff       	call   800f77 <fd2sockid>
  801029:	85 c0                	test   %eax,%eax
  80102b:	78 1b                	js     801048 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	ff 75 10             	pushl  0x10(%ebp)
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	50                   	push   %eax
  801037:	e8 0e 01 00 00       	call   80114a <nsipc_accept>
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 05                	js     801048 <accept+0x2d>
	return alloc_sockfd(r);
  801043:	e8 5f ff ff ff       	call   800fa7 <alloc_sockfd>
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <bind>:
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	e8 1f ff ff ff       	call   800f77 <fd2sockid>
  801058:	85 c0                	test   %eax,%eax
  80105a:	78 12                	js     80106e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80105c:	83 ec 04             	sub    $0x4,%esp
  80105f:	ff 75 10             	pushl  0x10(%ebp)
  801062:	ff 75 0c             	pushl  0xc(%ebp)
  801065:	50                   	push   %eax
  801066:	e8 31 01 00 00       	call   80119c <nsipc_bind>
  80106b:	83 c4 10             	add    $0x10,%esp
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <shutdown>:
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	e8 f9 fe ff ff       	call   800f77 <fd2sockid>
  80107e:	85 c0                	test   %eax,%eax
  801080:	78 0f                	js     801091 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	ff 75 0c             	pushl  0xc(%ebp)
  801088:	50                   	push   %eax
  801089:	e8 43 01 00 00       	call   8011d1 <nsipc_shutdown>
  80108e:	83 c4 10             	add    $0x10,%esp
}
  801091:	c9                   	leave  
  801092:	c3                   	ret    

00801093 <connect>:
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	e8 d6 fe ff ff       	call   800f77 <fd2sockid>
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	78 12                	js     8010b7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010a5:	83 ec 04             	sub    $0x4,%esp
  8010a8:	ff 75 10             	pushl  0x10(%ebp)
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	50                   	push   %eax
  8010af:	e8 59 01 00 00       	call   80120d <nsipc_connect>
  8010b4:	83 c4 10             	add    $0x10,%esp
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <listen>:
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	e8 b0 fe ff ff       	call   800f77 <fd2sockid>
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	78 0f                	js     8010da <listen+0x21>
	return nsipc_listen(r, backlog);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	ff 75 0c             	pushl  0xc(%ebp)
  8010d1:	50                   	push   %eax
  8010d2:	e8 6b 01 00 00       	call   801242 <nsipc_listen>
  8010d7:	83 c4 10             	add    $0x10,%esp
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <socket>:

int
socket(int domain, int type, int protocol)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010e2:	ff 75 10             	pushl  0x10(%ebp)
  8010e5:	ff 75 0c             	pushl  0xc(%ebp)
  8010e8:	ff 75 08             	pushl  0x8(%ebp)
  8010eb:	e8 3e 02 00 00       	call   80132e <nsipc_socket>
  8010f0:	83 c4 10             	add    $0x10,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 05                	js     8010fc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8010f7:	e8 ab fe ff ff       	call   800fa7 <alloc_sockfd>
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	53                   	push   %ebx
  801102:	83 ec 04             	sub    $0x4,%esp
  801105:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801107:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80110e:	74 26                	je     801136 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801110:	6a 07                	push   $0x7
  801112:	68 00 60 80 00       	push   $0x806000
  801117:	53                   	push   %ebx
  801118:	ff 35 04 40 80 00    	pushl  0x804004
  80111e:	e8 0a 0e 00 00       	call   801f2d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801123:	83 c4 0c             	add    $0xc,%esp
  801126:	6a 00                	push   $0x0
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	e8 89 0d 00 00       	call   801eba <ipc_recv>
}
  801131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801134:	c9                   	leave  
  801135:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	6a 02                	push   $0x2
  80113b:	e8 59 0e 00 00       	call   801f99 <ipc_find_env>
  801140:	a3 04 40 80 00       	mov    %eax,0x804004
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb c6                	jmp    801110 <nsipc+0x12>

0080114a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	56                   	push   %esi
  80114e:	53                   	push   %ebx
  80114f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80115a:	8b 06                	mov    (%esi),%eax
  80115c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801161:	b8 01 00 00 00       	mov    $0x1,%eax
  801166:	e8 93 ff ff ff       	call   8010fe <nsipc>
  80116b:	89 c3                	mov    %eax,%ebx
  80116d:	85 c0                	test   %eax,%eax
  80116f:	79 09                	jns    80117a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801171:	89 d8                	mov    %ebx,%eax
  801173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5d                   	pop    %ebp
  801179:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	ff 35 10 60 80 00    	pushl  0x806010
  801183:	68 00 60 80 00       	push   $0x806000
  801188:	ff 75 0c             	pushl  0xc(%ebp)
  80118b:	e8 82 0b 00 00       	call   801d12 <memmove>
		*addrlen = ret->ret_addrlen;
  801190:	a1 10 60 80 00       	mov    0x806010,%eax
  801195:	89 06                	mov    %eax,(%esi)
  801197:	83 c4 10             	add    $0x10,%esp
	return r;
  80119a:	eb d5                	jmp    801171 <nsipc_accept+0x27>

0080119c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	53                   	push   %ebx
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011ae:	53                   	push   %ebx
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	68 04 60 80 00       	push   $0x806004
  8011b7:	e8 56 0b 00 00       	call   801d12 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011bc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8011c7:	e8 32 ff ff ff       	call   8010fe <nsipc>
}
  8011cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ec:	e8 0d ff ff ff       	call   8010fe <nsipc>
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <nsipc_close>:

int
nsipc_close(int s)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801201:	b8 04 00 00 00       	mov    $0x4,%eax
  801206:	e8 f3 fe ff ff       	call   8010fe <nsipc>
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	53                   	push   %ebx
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80121f:	53                   	push   %ebx
  801220:	ff 75 0c             	pushl  0xc(%ebp)
  801223:	68 04 60 80 00       	push   $0x806004
  801228:	e8 e5 0a 00 00       	call   801d12 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80122d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801233:	b8 05 00 00 00       	mov    $0x5,%eax
  801238:	e8 c1 fe ff ff       	call   8010fe <nsipc>
}
  80123d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801258:	b8 06 00 00 00       	mov    $0x6,%eax
  80125d:	e8 9c fe ff ff       	call   8010fe <nsipc>
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801274:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80127a:	8b 45 14             	mov    0x14(%ebp),%eax
  80127d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801282:	b8 07 00 00 00       	mov    $0x7,%eax
  801287:	e8 72 fe ff ff       	call   8010fe <nsipc>
  80128c:	89 c3                	mov    %eax,%ebx
  80128e:	85 c0                	test   %eax,%eax
  801290:	78 1f                	js     8012b1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801292:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801297:	7f 21                	jg     8012ba <nsipc_recv+0x56>
  801299:	39 c6                	cmp    %eax,%esi
  80129b:	7c 1d                	jl     8012ba <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80129d:	83 ec 04             	sub    $0x4,%esp
  8012a0:	50                   	push   %eax
  8012a1:	68 00 60 80 00       	push   $0x806000
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	e8 64 0a 00 00       	call   801d12 <memmove>
  8012ae:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012ba:	68 92 23 80 00       	push   $0x802392
  8012bf:	68 34 23 80 00       	push   $0x802334
  8012c4:	6a 62                	push   $0x62
  8012c6:	68 a7 23 80 00       	push   $0x8023a7
  8012cb:	e8 fd 01 00 00       	call   8014cd <_panic>

008012d0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012e2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012e8:	7f 2e                	jg     801318 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	53                   	push   %ebx
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	68 0c 60 80 00       	push   $0x80600c
  8012f6:	e8 17 0a 00 00       	call   801d12 <memmove>
	nsipcbuf.send.req_size = size;
  8012fb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801309:	b8 08 00 00 00       	mov    $0x8,%eax
  80130e:	e8 eb fd ff ff       	call   8010fe <nsipc>
}
  801313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801316:	c9                   	leave  
  801317:	c3                   	ret    
	assert(size < 1600);
  801318:	68 b3 23 80 00       	push   $0x8023b3
  80131d:	68 34 23 80 00       	push   $0x802334
  801322:	6a 6d                	push   $0x6d
  801324:	68 a7 23 80 00       	push   $0x8023a7
  801329:	e8 9f 01 00 00       	call   8014cd <_panic>

0080132e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80134c:	b8 09 00 00 00       	mov    $0x9,%eax
  801351:	e8 a8 fd ff ff       	call   8010fe <nsipc>
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
  80135d:	c3                   	ret    

0080135e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801364:	68 bf 23 80 00       	push   $0x8023bf
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	e8 13 08 00 00       	call   801b84 <strcpy>
	return 0;
}
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <devcons_write>:
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801384:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801389:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80138f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801392:	73 31                	jae    8013c5 <devcons_write+0x4d>
		m = n - tot;
  801394:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801397:	29 f3                	sub    %esi,%ebx
  801399:	83 fb 7f             	cmp    $0x7f,%ebx
  80139c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013a1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013a4:	83 ec 04             	sub    $0x4,%esp
  8013a7:	53                   	push   %ebx
  8013a8:	89 f0                	mov    %esi,%eax
  8013aa:	03 45 0c             	add    0xc(%ebp),%eax
  8013ad:	50                   	push   %eax
  8013ae:	57                   	push   %edi
  8013af:	e8 5e 09 00 00       	call   801d12 <memmove>
		sys_cputs(buf, m);
  8013b4:	83 c4 08             	add    $0x8,%esp
  8013b7:	53                   	push   %ebx
  8013b8:	57                   	push   %edi
  8013b9:	e8 e0 ec ff ff       	call   80009e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013be:	01 de                	add    %ebx,%esi
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	eb ca                	jmp    80138f <devcons_write+0x17>
}
  8013c5:	89 f0                	mov    %esi,%eax
  8013c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ca:	5b                   	pop    %ebx
  8013cb:	5e                   	pop    %esi
  8013cc:	5f                   	pop    %edi
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    

008013cf <devcons_read>:
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013de:	74 21                	je     801401 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013e0:	e8 d7 ec ff ff       	call   8000bc <sys_cgetc>
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	75 07                	jne    8013f0 <devcons_read+0x21>
		sys_yield();
  8013e9:	e8 4d ed ff ff       	call   80013b <sys_yield>
  8013ee:	eb f0                	jmp    8013e0 <devcons_read+0x11>
	if (c < 0)
  8013f0:	78 0f                	js     801401 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013f2:	83 f8 04             	cmp    $0x4,%eax
  8013f5:	74 0c                	je     801403 <devcons_read+0x34>
	*(char*)vbuf = c;
  8013f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fa:	88 02                	mov    %al,(%edx)
	return 1;
  8013fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    
		return 0;
  801403:	b8 00 00 00 00       	mov    $0x0,%eax
  801408:	eb f7                	jmp    801401 <devcons_read+0x32>

0080140a <cputchar>:
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801416:	6a 01                	push   $0x1
  801418:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80141b:	50                   	push   %eax
  80141c:	e8 7d ec ff ff       	call   80009e <sys_cputs>
}
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <getchar>:
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80142c:	6a 01                	push   $0x1
  80142e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	6a 00                	push   $0x0
  801434:	e8 1a f2 ff ff       	call   800653 <read>
	if (r < 0)
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 06                	js     801446 <getchar+0x20>
	if (r < 1)
  801440:	74 06                	je     801448 <getchar+0x22>
	return c;
  801442:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    
		return -E_EOF;
  801448:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80144d:	eb f7                	jmp    801446 <getchar+0x20>

0080144f <iscons>:
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801458:	50                   	push   %eax
  801459:	ff 75 08             	pushl  0x8(%ebp)
  80145c:	e8 82 ef ff ff       	call   8003e3 <fd_lookup>
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	78 11                	js     801479 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801471:	39 10                	cmp    %edx,(%eax)
  801473:	0f 94 c0             	sete   %al
  801476:	0f b6 c0             	movzbl %al,%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <opencons>:
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801484:	50                   	push   %eax
  801485:	e8 07 ef ff ff       	call   800391 <fd_alloc>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 3a                	js     8014cb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	68 07 04 00 00       	push   $0x407
  801499:	ff 75 f4             	pushl  -0xc(%ebp)
  80149c:	6a 00                	push   $0x0
  80149e:	e8 b7 ec ff ff       	call   80015a <sys_page_alloc>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 21                	js     8014cb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ad:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014b3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	50                   	push   %eax
  8014c3:	e8 a2 ee ff ff       	call   80036a <fd2num>
  8014c8:	83 c4 10             	add    $0x10,%esp
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014d2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014d5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014db:	e8 3c ec ff ff       	call   80011c <sys_getenvid>
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	ff 75 0c             	pushl  0xc(%ebp)
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	56                   	push   %esi
  8014ea:	50                   	push   %eax
  8014eb:	68 cc 23 80 00       	push   $0x8023cc
  8014f0:	e8 b3 00 00 00       	call   8015a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014f5:	83 c4 18             	add    $0x18,%esp
  8014f8:	53                   	push   %ebx
  8014f9:	ff 75 10             	pushl  0x10(%ebp)
  8014fc:	e8 56 00 00 00       	call   801557 <vcprintf>
	cprintf("\n");
  801501:	c7 04 24 7f 23 80 00 	movl   $0x80237f,(%esp)
  801508:	e8 9b 00 00 00       	call   8015a8 <cprintf>
  80150d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801510:	cc                   	int3   
  801511:	eb fd                	jmp    801510 <_panic+0x43>

00801513 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	53                   	push   %ebx
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80151d:	8b 13                	mov    (%ebx),%edx
  80151f:	8d 42 01             	lea    0x1(%edx),%eax
  801522:	89 03                	mov    %eax,(%ebx)
  801524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801527:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80152b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801530:	74 09                	je     80153b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801532:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801539:	c9                   	leave  
  80153a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	68 ff 00 00 00       	push   $0xff
  801543:	8d 43 08             	lea    0x8(%ebx),%eax
  801546:	50                   	push   %eax
  801547:	e8 52 eb ff ff       	call   80009e <sys_cputs>
		b->idx = 0;
  80154c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb db                	jmp    801532 <putch+0x1f>

00801557 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801560:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801567:	00 00 00 
	b.cnt = 0;
  80156a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801571:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	ff 75 08             	pushl  0x8(%ebp)
  80157a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	68 13 15 80 00       	push   $0x801513
  801586:	e8 19 01 00 00       	call   8016a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80158b:	83 c4 08             	add    $0x8,%esp
  80158e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801594:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80159a:	50                   	push   %eax
  80159b:	e8 fe ea ff ff       	call   80009e <sys_cputs>

	return b.cnt;
}
  8015a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015b1:	50                   	push   %eax
  8015b2:	ff 75 08             	pushl  0x8(%ebp)
  8015b5:	e8 9d ff ff ff       	call   801557 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 1c             	sub    $0x1c,%esp
  8015c5:	89 c7                	mov    %eax,%edi
  8015c7:	89 d6                	mov    %edx,%esi
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015dd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015e3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015e6:	89 d0                	mov    %edx,%eax
  8015e8:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ee:	73 15                	jae    801605 <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015f0:	83 eb 01             	sub    $0x1,%ebx
  8015f3:	85 db                	test   %ebx,%ebx
  8015f5:	7e 43                	jle    80163a <printnum+0x7e>
			putch(padc, putdat);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	56                   	push   %esi
  8015fb:	ff 75 18             	pushl  0x18(%ebp)
  8015fe:	ff d7                	call   *%edi
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	eb eb                	jmp    8015f0 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801605:	83 ec 0c             	sub    $0xc,%esp
  801608:	ff 75 18             	pushl  0x18(%ebp)
  80160b:	8b 45 14             	mov    0x14(%ebp),%eax
  80160e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801611:	53                   	push   %ebx
  801612:	ff 75 10             	pushl  0x10(%ebp)
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	ff 75 e4             	pushl  -0x1c(%ebp)
  80161b:	ff 75 e0             	pushl  -0x20(%ebp)
  80161e:	ff 75 dc             	pushl  -0x24(%ebp)
  801621:	ff 75 d8             	pushl  -0x28(%ebp)
  801624:	e8 e7 09 00 00       	call   802010 <__udivdi3>
  801629:	83 c4 18             	add    $0x18,%esp
  80162c:	52                   	push   %edx
  80162d:	50                   	push   %eax
  80162e:	89 f2                	mov    %esi,%edx
  801630:	89 f8                	mov    %edi,%eax
  801632:	e8 85 ff ff ff       	call   8015bc <printnum>
  801637:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80163a:	83 ec 08             	sub    $0x8,%esp
  80163d:	56                   	push   %esi
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	ff 75 e4             	pushl  -0x1c(%ebp)
  801644:	ff 75 e0             	pushl  -0x20(%ebp)
  801647:	ff 75 dc             	pushl  -0x24(%ebp)
  80164a:	ff 75 d8             	pushl  -0x28(%ebp)
  80164d:	e8 ce 0a 00 00       	call   802120 <__umoddi3>
  801652:	83 c4 14             	add    $0x14,%esp
  801655:	0f be 80 ef 23 80 00 	movsbl 0x8023ef(%eax),%eax
  80165c:	50                   	push   %eax
  80165d:	ff d7                	call   *%edi
}
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5f                   	pop    %edi
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    

0080166a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801670:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801674:	8b 10                	mov    (%eax),%edx
  801676:	3b 50 04             	cmp    0x4(%eax),%edx
  801679:	73 0a                	jae    801685 <sprintputch+0x1b>
		*b->buf++ = ch;
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 08                	mov    %ecx,(%eax)
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	88 02                	mov    %al,(%edx)
}
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <printfmt>:
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80168d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801690:	50                   	push   %eax
  801691:	ff 75 10             	pushl  0x10(%ebp)
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 05 00 00 00       	call   8016a4 <vprintfmt>
}
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <vprintfmt>:
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	57                   	push   %edi
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 3c             	sub    $0x3c,%esp
  8016ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016b3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016b6:	eb 0a                	jmp    8016c2 <vprintfmt+0x1e>
			putch(ch, putdat);
  8016b8:	83 ec 08             	sub    $0x8,%esp
  8016bb:	53                   	push   %ebx
  8016bc:	50                   	push   %eax
  8016bd:	ff d6                	call   *%esi
  8016bf:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016c2:	83 c7 01             	add    $0x1,%edi
  8016c5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016c9:	83 f8 25             	cmp    $0x25,%eax
  8016cc:	74 0c                	je     8016da <vprintfmt+0x36>
			if (ch == '\0')
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	75 e6                	jne    8016b8 <vprintfmt+0x14>
}
  8016d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    
		padc = ' ';
  8016da:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016de:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016e5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016f3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8016f8:	8d 47 01             	lea    0x1(%edi),%eax
  8016fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016fe:	0f b6 17             	movzbl (%edi),%edx
  801701:	8d 42 dd             	lea    -0x23(%edx),%eax
  801704:	3c 55                	cmp    $0x55,%al
  801706:	0f 87 ba 03 00 00    	ja     801ac6 <vprintfmt+0x422>
  80170c:	0f b6 c0             	movzbl %al,%eax
  80170f:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  801716:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801719:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80171d:	eb d9                	jmp    8016f8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  80171f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801722:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801726:	eb d0                	jmp    8016f8 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801728:	0f b6 d2             	movzbl %dl,%edx
  80172b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
  801733:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801736:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801739:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80173d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801740:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801743:	83 f9 09             	cmp    $0x9,%ecx
  801746:	77 55                	ja     80179d <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801748:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80174b:	eb e9                	jmp    801736 <vprintfmt+0x92>
			precision = va_arg(ap, int);
  80174d:	8b 45 14             	mov    0x14(%ebp),%eax
  801750:	8b 00                	mov    (%eax),%eax
  801752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801755:	8b 45 14             	mov    0x14(%ebp),%eax
  801758:	8d 40 04             	lea    0x4(%eax),%eax
  80175b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80175e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801761:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801765:	79 91                	jns    8016f8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801767:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80176a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80176d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801774:	eb 82                	jmp    8016f8 <vprintfmt+0x54>
  801776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	0f 49 d0             	cmovns %eax,%edx
  801783:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801789:	e9 6a ff ff ff       	jmp    8016f8 <vprintfmt+0x54>
  80178e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801791:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801798:	e9 5b ff ff ff       	jmp    8016f8 <vprintfmt+0x54>
  80179d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017a3:	eb bc                	jmp    801761 <vprintfmt+0xbd>
			lflag++;
  8017a5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017ab:	e9 48 ff ff ff       	jmp    8016f8 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b3:	8d 78 04             	lea    0x4(%eax),%edi
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	53                   	push   %ebx
  8017ba:	ff 30                	pushl  (%eax)
  8017bc:	ff d6                	call   *%esi
			break;
  8017be:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017c1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017c4:	e9 9c 02 00 00       	jmp    801a65 <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cc:	8d 78 04             	lea    0x4(%eax),%edi
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	99                   	cltd   
  8017d2:	31 d0                	xor    %edx,%eax
  8017d4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017d6:	83 f8 0f             	cmp    $0xf,%eax
  8017d9:	7f 23                	jg     8017fe <vprintfmt+0x15a>
  8017db:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  8017e2:	85 d2                	test   %edx,%edx
  8017e4:	74 18                	je     8017fe <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017e6:	52                   	push   %edx
  8017e7:	68 46 23 80 00       	push   $0x802346
  8017ec:	53                   	push   %ebx
  8017ed:	56                   	push   %esi
  8017ee:	e8 94 fe ff ff       	call   801687 <printfmt>
  8017f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017f6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8017f9:	e9 67 02 00 00       	jmp    801a65 <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  8017fe:	50                   	push   %eax
  8017ff:	68 07 24 80 00       	push   $0x802407
  801804:	53                   	push   %ebx
  801805:	56                   	push   %esi
  801806:	e8 7c fe ff ff       	call   801687 <printfmt>
  80180b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80180e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801811:	e9 4f 02 00 00       	jmp    801a65 <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801816:	8b 45 14             	mov    0x14(%ebp),%eax
  801819:	83 c0 04             	add    $0x4,%eax
  80181c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80181f:	8b 45 14             	mov    0x14(%ebp),%eax
  801822:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801824:	85 d2                	test   %edx,%edx
  801826:	b8 00 24 80 00       	mov    $0x802400,%eax
  80182b:	0f 45 c2             	cmovne %edx,%eax
  80182e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801831:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801835:	7e 06                	jle    80183d <vprintfmt+0x199>
  801837:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80183b:	75 0d                	jne    80184a <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80183d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801840:	89 c7                	mov    %eax,%edi
  801842:	03 45 e0             	add    -0x20(%ebp),%eax
  801845:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801848:	eb 3f                	jmp    801889 <vprintfmt+0x1e5>
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	ff 75 d8             	pushl  -0x28(%ebp)
  801850:	50                   	push   %eax
  801851:	e8 0d 03 00 00       	call   801b63 <strnlen>
  801856:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801859:	29 c2                	sub    %eax,%edx
  80185b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801863:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801867:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80186a:	85 ff                	test   %edi,%edi
  80186c:	7e 58                	jle    8018c6 <vprintfmt+0x222>
					putch(padc, putdat);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	53                   	push   %ebx
  801872:	ff 75 e0             	pushl  -0x20(%ebp)
  801875:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801877:	83 ef 01             	sub    $0x1,%edi
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	eb eb                	jmp    80186a <vprintfmt+0x1c6>
					putch(ch, putdat);
  80187f:	83 ec 08             	sub    $0x8,%esp
  801882:	53                   	push   %ebx
  801883:	52                   	push   %edx
  801884:	ff d6                	call   *%esi
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80188c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80188e:	83 c7 01             	add    $0x1,%edi
  801891:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801895:	0f be d0             	movsbl %al,%edx
  801898:	85 d2                	test   %edx,%edx
  80189a:	74 45                	je     8018e1 <vprintfmt+0x23d>
  80189c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018a0:	78 06                	js     8018a8 <vprintfmt+0x204>
  8018a2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018a6:	78 35                	js     8018dd <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018ac:	74 d1                	je     80187f <vprintfmt+0x1db>
  8018ae:	0f be c0             	movsbl %al,%eax
  8018b1:	83 e8 20             	sub    $0x20,%eax
  8018b4:	83 f8 5e             	cmp    $0x5e,%eax
  8018b7:	76 c6                	jbe    80187f <vprintfmt+0x1db>
					putch('?', putdat);
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	53                   	push   %ebx
  8018bd:	6a 3f                	push   $0x3f
  8018bf:	ff d6                	call   *%esi
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	eb c3                	jmp    801889 <vprintfmt+0x1e5>
  8018c6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018c9:	85 d2                	test   %edx,%edx
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d0:	0f 49 c2             	cmovns %edx,%eax
  8018d3:	29 c2                	sub    %eax,%edx
  8018d5:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018d8:	e9 60 ff ff ff       	jmp    80183d <vprintfmt+0x199>
  8018dd:	89 cf                	mov    %ecx,%edi
  8018df:	eb 02                	jmp    8018e3 <vprintfmt+0x23f>
  8018e1:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018e3:	85 ff                	test   %edi,%edi
  8018e5:	7e 10                	jle    8018f7 <vprintfmt+0x253>
				putch(' ', putdat);
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	53                   	push   %ebx
  8018eb:	6a 20                	push   $0x20
  8018ed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018ef:	83 ef 01             	sub    $0x1,%edi
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	eb ec                	jmp    8018e3 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  8018f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8018fd:	e9 63 01 00 00       	jmp    801a65 <vprintfmt+0x3c1>
	if (lflag >= 2)
  801902:	83 f9 01             	cmp    $0x1,%ecx
  801905:	7f 1b                	jg     801922 <vprintfmt+0x27e>
	else if (lflag)
  801907:	85 c9                	test   %ecx,%ecx
  801909:	74 63                	je     80196e <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  80190b:	8b 45 14             	mov    0x14(%ebp),%eax
  80190e:	8b 00                	mov    (%eax),%eax
  801910:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801913:	99                   	cltd   
  801914:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801917:	8b 45 14             	mov    0x14(%ebp),%eax
  80191a:	8d 40 04             	lea    0x4(%eax),%eax
  80191d:	89 45 14             	mov    %eax,0x14(%ebp)
  801920:	eb 17                	jmp    801939 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  801922:	8b 45 14             	mov    0x14(%ebp),%eax
  801925:	8b 50 04             	mov    0x4(%eax),%edx
  801928:	8b 00                	mov    (%eax),%eax
  80192a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80192d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801930:	8b 45 14             	mov    0x14(%ebp),%eax
  801933:	8d 40 08             	lea    0x8(%eax),%eax
  801936:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801939:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80193c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80193f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801944:	85 c9                	test   %ecx,%ecx
  801946:	0f 89 ff 00 00 00    	jns    801a4b <vprintfmt+0x3a7>
				putch('-', putdat);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	53                   	push   %ebx
  801950:	6a 2d                	push   $0x2d
  801952:	ff d6                	call   *%esi
				num = -(long long) num;
  801954:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801957:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80195a:	f7 da                	neg    %edx
  80195c:	83 d1 00             	adc    $0x0,%ecx
  80195f:	f7 d9                	neg    %ecx
  801961:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801964:	b8 0a 00 00 00       	mov    $0xa,%eax
  801969:	e9 dd 00 00 00       	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  80196e:	8b 45 14             	mov    0x14(%ebp),%eax
  801971:	8b 00                	mov    (%eax),%eax
  801973:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801976:	99                   	cltd   
  801977:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	8d 40 04             	lea    0x4(%eax),%eax
  801980:	89 45 14             	mov    %eax,0x14(%ebp)
  801983:	eb b4                	jmp    801939 <vprintfmt+0x295>
	if (lflag >= 2)
  801985:	83 f9 01             	cmp    $0x1,%ecx
  801988:	7f 1e                	jg     8019a8 <vprintfmt+0x304>
	else if (lflag)
  80198a:	85 c9                	test   %ecx,%ecx
  80198c:	74 32                	je     8019c0 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  80198e:	8b 45 14             	mov    0x14(%ebp),%eax
  801991:	8b 10                	mov    (%eax),%edx
  801993:	b9 00 00 00 00       	mov    $0x0,%ecx
  801998:	8d 40 04             	lea    0x4(%eax),%eax
  80199b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80199e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019a3:	e9 a3 00 00 00       	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ab:	8b 10                	mov    (%eax),%edx
  8019ad:	8b 48 04             	mov    0x4(%eax),%ecx
  8019b0:	8d 40 08             	lea    0x8(%eax),%eax
  8019b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019bb:	e9 8b 00 00 00       	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c3:	8b 10                	mov    (%eax),%edx
  8019c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ca:	8d 40 04             	lea    0x4(%eax),%eax
  8019cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019d5:	eb 74                	jmp    801a4b <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019d7:	83 f9 01             	cmp    $0x1,%ecx
  8019da:	7f 1b                	jg     8019f7 <vprintfmt+0x353>
	else if (lflag)
  8019dc:	85 c9                	test   %ecx,%ecx
  8019de:	74 2c                	je     801a0c <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e3:	8b 10                	mov    (%eax),%edx
  8019e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ea:	8d 40 04             	lea    0x4(%eax),%eax
  8019ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019f0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019f5:	eb 54                	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fa:	8b 10                	mov    (%eax),%edx
  8019fc:	8b 48 04             	mov    0x4(%eax),%ecx
  8019ff:	8d 40 08             	lea    0x8(%eax),%eax
  801a02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a05:	b8 08 00 00 00       	mov    $0x8,%eax
  801a0a:	eb 3f                	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0f:	8b 10                	mov    (%eax),%edx
  801a11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a16:	8d 40 04             	lea    0x4(%eax),%eax
  801a19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a1c:	b8 08 00 00 00       	mov    $0x8,%eax
  801a21:	eb 28                	jmp    801a4b <vprintfmt+0x3a7>
			putch('0', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	53                   	push   %ebx
  801a27:	6a 30                	push   $0x30
  801a29:	ff d6                	call   *%esi
			putch('x', putdat);
  801a2b:	83 c4 08             	add    $0x8,%esp
  801a2e:	53                   	push   %ebx
  801a2f:	6a 78                	push   $0x78
  801a31:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a33:	8b 45 14             	mov    0x14(%ebp),%eax
  801a36:	8b 10                	mov    (%eax),%edx
  801a38:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a3d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a40:	8d 40 04             	lea    0x4(%eax),%eax
  801a43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a46:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a52:	57                   	push   %edi
  801a53:	ff 75 e0             	pushl  -0x20(%ebp)
  801a56:	50                   	push   %eax
  801a57:	51                   	push   %ecx
  801a58:	52                   	push   %edx
  801a59:	89 da                	mov    %ebx,%edx
  801a5b:	89 f0                	mov    %esi,%eax
  801a5d:	e8 5a fb ff ff       	call   8015bc <printnum>
			break;
  801a62:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a65:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a68:	e9 55 fc ff ff       	jmp    8016c2 <vprintfmt+0x1e>
	if (lflag >= 2)
  801a6d:	83 f9 01             	cmp    $0x1,%ecx
  801a70:	7f 1b                	jg     801a8d <vprintfmt+0x3e9>
	else if (lflag)
  801a72:	85 c9                	test   %ecx,%ecx
  801a74:	74 2c                	je     801aa2 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a76:	8b 45 14             	mov    0x14(%ebp),%eax
  801a79:	8b 10                	mov    (%eax),%edx
  801a7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a80:	8d 40 04             	lea    0x4(%eax),%eax
  801a83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a86:	b8 10 00 00 00       	mov    $0x10,%eax
  801a8b:	eb be                	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a90:	8b 10                	mov    (%eax),%edx
  801a92:	8b 48 04             	mov    0x4(%eax),%ecx
  801a95:	8d 40 08             	lea    0x8(%eax),%eax
  801a98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a9b:	b8 10 00 00 00       	mov    $0x10,%eax
  801aa0:	eb a9                	jmp    801a4b <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 10                	mov    (%eax),%edx
  801aa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aac:	8d 40 04             	lea    0x4(%eax),%eax
  801aaf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ab2:	b8 10 00 00 00       	mov    $0x10,%eax
  801ab7:	eb 92                	jmp    801a4b <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ab9:	83 ec 08             	sub    $0x8,%esp
  801abc:	53                   	push   %ebx
  801abd:	6a 25                	push   $0x25
  801abf:	ff d6                	call   *%esi
			break;
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	eb 9f                	jmp    801a65 <vprintfmt+0x3c1>
			putch('%', putdat);
  801ac6:	83 ec 08             	sub    $0x8,%esp
  801ac9:	53                   	push   %ebx
  801aca:	6a 25                	push   $0x25
  801acc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	89 f8                	mov    %edi,%eax
  801ad3:	eb 03                	jmp    801ad8 <vprintfmt+0x434>
  801ad5:	83 e8 01             	sub    $0x1,%eax
  801ad8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801adc:	75 f7                	jne    801ad5 <vprintfmt+0x431>
  801ade:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ae1:	eb 82                	jmp    801a65 <vprintfmt+0x3c1>

00801ae3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 18             	sub    $0x18,%esp
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801af2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801af6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b00:	85 c0                	test   %eax,%eax
  801b02:	74 26                	je     801b2a <vsnprintf+0x47>
  801b04:	85 d2                	test   %edx,%edx
  801b06:	7e 22                	jle    801b2a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b08:	ff 75 14             	pushl  0x14(%ebp)
  801b0b:	ff 75 10             	pushl  0x10(%ebp)
  801b0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	68 6a 16 80 00       	push   $0x80166a
  801b17:	e8 88 fb ff ff       	call   8016a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b25:	83 c4 10             	add    $0x10,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    
		return -E_INVAL;
  801b2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2f:	eb f7                	jmp    801b28 <vsnprintf+0x45>

00801b31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b37:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b3a:	50                   	push   %eax
  801b3b:	ff 75 10             	pushl  0x10(%ebp)
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	e8 9a ff ff ff       	call   801ae3 <vsnprintf>
	va_end(ap);

	return rc;
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
  801b56:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b5a:	74 05                	je     801b61 <strlen+0x16>
		n++;
  801b5c:	83 c0 01             	add    $0x1,%eax
  801b5f:	eb f5                	jmp    801b56 <strlen+0xb>
	return n;
}
  801b61:	5d                   	pop    %ebp
  801b62:	c3                   	ret    

00801b63 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b69:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b71:	39 c2                	cmp    %eax,%edx
  801b73:	74 0d                	je     801b82 <strnlen+0x1f>
  801b75:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b79:	74 05                	je     801b80 <strnlen+0x1d>
		n++;
  801b7b:	83 c2 01             	add    $0x1,%edx
  801b7e:	eb f1                	jmp    801b71 <strnlen+0xe>
  801b80:	89 d0                	mov    %edx,%eax
	return n;
}
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    

00801b84 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801b97:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801b9a:	83 c2 01             	add    $0x1,%edx
  801b9d:	84 c9                	test   %cl,%cl
  801b9f:	75 f2                	jne    801b93 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801ba1:	5b                   	pop    %ebx
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 10             	sub    $0x10,%esp
  801bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bae:	53                   	push   %ebx
  801baf:	e8 97 ff ff ff       	call   801b4b <strlen>
  801bb4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	01 d8                	add    %ebx,%eax
  801bbc:	50                   	push   %eax
  801bbd:	e8 c2 ff ff ff       	call   801b84 <strcpy>
	return dst;
}
  801bc2:	89 d8                	mov    %ebx,%eax
  801bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	56                   	push   %esi
  801bcd:	53                   	push   %ebx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bd4:	89 c6                	mov    %eax,%esi
  801bd6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801bd9:	89 c2                	mov    %eax,%edx
  801bdb:	39 f2                	cmp    %esi,%edx
  801bdd:	74 11                	je     801bf0 <strncpy+0x27>
		*dst++ = *src;
  801bdf:	83 c2 01             	add    $0x1,%edx
  801be2:	0f b6 19             	movzbl (%ecx),%ebx
  801be5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801be8:	80 fb 01             	cmp    $0x1,%bl
  801beb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801bee:	eb eb                	jmp    801bdb <strncpy+0x12>
	}
	return ret;
}
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    

00801bf4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	8b 75 08             	mov    0x8(%ebp),%esi
  801bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bff:	8b 55 10             	mov    0x10(%ebp),%edx
  801c02:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c04:	85 d2                	test   %edx,%edx
  801c06:	74 21                	je     801c29 <strlcpy+0x35>
  801c08:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c0c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c0e:	39 c2                	cmp    %eax,%edx
  801c10:	74 14                	je     801c26 <strlcpy+0x32>
  801c12:	0f b6 19             	movzbl (%ecx),%ebx
  801c15:	84 db                	test   %bl,%bl
  801c17:	74 0b                	je     801c24 <strlcpy+0x30>
			*dst++ = *src++;
  801c19:	83 c1 01             	add    $0x1,%ecx
  801c1c:	83 c2 01             	add    $0x1,%edx
  801c1f:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c22:	eb ea                	jmp    801c0e <strlcpy+0x1a>
  801c24:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c26:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c29:	29 f0                	sub    %esi,%eax
}
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5d                   	pop    %ebp
  801c2e:	c3                   	ret    

00801c2f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c38:	0f b6 01             	movzbl (%ecx),%eax
  801c3b:	84 c0                	test   %al,%al
  801c3d:	74 0c                	je     801c4b <strcmp+0x1c>
  801c3f:	3a 02                	cmp    (%edx),%al
  801c41:	75 08                	jne    801c4b <strcmp+0x1c>
		p++, q++;
  801c43:	83 c1 01             	add    $0x1,%ecx
  801c46:	83 c2 01             	add    $0x1,%edx
  801c49:	eb ed                	jmp    801c38 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c4b:	0f b6 c0             	movzbl %al,%eax
  801c4e:	0f b6 12             	movzbl (%edx),%edx
  801c51:	29 d0                	sub    %edx,%eax
}
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	53                   	push   %ebx
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c64:	eb 06                	jmp    801c6c <strncmp+0x17>
		n--, p++, q++;
  801c66:	83 c0 01             	add    $0x1,%eax
  801c69:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c6c:	39 d8                	cmp    %ebx,%eax
  801c6e:	74 16                	je     801c86 <strncmp+0x31>
  801c70:	0f b6 08             	movzbl (%eax),%ecx
  801c73:	84 c9                	test   %cl,%cl
  801c75:	74 04                	je     801c7b <strncmp+0x26>
  801c77:	3a 0a                	cmp    (%edx),%cl
  801c79:	74 eb                	je     801c66 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c7b:	0f b6 00             	movzbl (%eax),%eax
  801c7e:	0f b6 12             	movzbl (%edx),%edx
  801c81:	29 d0                	sub    %edx,%eax
}
  801c83:	5b                   	pop    %ebx
  801c84:	5d                   	pop    %ebp
  801c85:	c3                   	ret    
		return 0;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8b:	eb f6                	jmp    801c83 <strncmp+0x2e>

00801c8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801c97:	0f b6 10             	movzbl (%eax),%edx
  801c9a:	84 d2                	test   %dl,%dl
  801c9c:	74 09                	je     801ca7 <strchr+0x1a>
		if (*s == c)
  801c9e:	38 ca                	cmp    %cl,%dl
  801ca0:	74 0a                	je     801cac <strchr+0x1f>
	for (; *s; s++)
  801ca2:	83 c0 01             	add    $0x1,%eax
  801ca5:	eb f0                	jmp    801c97 <strchr+0xa>
			return (char *) s;
	return 0;
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cb8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cbb:	38 ca                	cmp    %cl,%dl
  801cbd:	74 09                	je     801cc8 <strfind+0x1a>
  801cbf:	84 d2                	test   %dl,%dl
  801cc1:	74 05                	je     801cc8 <strfind+0x1a>
	for (; *s; s++)
  801cc3:	83 c0 01             	add    $0x1,%eax
  801cc6:	eb f0                	jmp    801cb8 <strfind+0xa>
			break;
	return (char *) s;
}
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    

00801cca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	57                   	push   %edi
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cd3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cd6:	85 c9                	test   %ecx,%ecx
  801cd8:	74 31                	je     801d0b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801cda:	89 f8                	mov    %edi,%eax
  801cdc:	09 c8                	or     %ecx,%eax
  801cde:	a8 03                	test   $0x3,%al
  801ce0:	75 23                	jne    801d05 <memset+0x3b>
		c &= 0xFF;
  801ce2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ce6:	89 d3                	mov    %edx,%ebx
  801ce8:	c1 e3 08             	shl    $0x8,%ebx
  801ceb:	89 d0                	mov    %edx,%eax
  801ced:	c1 e0 18             	shl    $0x18,%eax
  801cf0:	89 d6                	mov    %edx,%esi
  801cf2:	c1 e6 10             	shl    $0x10,%esi
  801cf5:	09 f0                	or     %esi,%eax
  801cf7:	09 c2                	or     %eax,%edx
  801cf9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801cfb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801cfe:	89 d0                	mov    %edx,%eax
  801d00:	fc                   	cld    
  801d01:	f3 ab                	rep stos %eax,%es:(%edi)
  801d03:	eb 06                	jmp    801d0b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	fc                   	cld    
  801d09:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d0b:	89 f8                	mov    %edi,%eax
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5f                   	pop    %edi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d20:	39 c6                	cmp    %eax,%esi
  801d22:	73 32                	jae    801d56 <memmove+0x44>
  801d24:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d27:	39 c2                	cmp    %eax,%edx
  801d29:	76 2b                	jbe    801d56 <memmove+0x44>
		s += n;
		d += n;
  801d2b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d2e:	89 fe                	mov    %edi,%esi
  801d30:	09 ce                	or     %ecx,%esi
  801d32:	09 d6                	or     %edx,%esi
  801d34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d3a:	75 0e                	jne    801d4a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d3c:	83 ef 04             	sub    $0x4,%edi
  801d3f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d45:	fd                   	std    
  801d46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d48:	eb 09                	jmp    801d53 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d4a:	83 ef 01             	sub    $0x1,%edi
  801d4d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d50:	fd                   	std    
  801d51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d53:	fc                   	cld    
  801d54:	eb 1a                	jmp    801d70 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d56:	89 c2                	mov    %eax,%edx
  801d58:	09 ca                	or     %ecx,%edx
  801d5a:	09 f2                	or     %esi,%edx
  801d5c:	f6 c2 03             	test   $0x3,%dl
  801d5f:	75 0a                	jne    801d6b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d61:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d64:	89 c7                	mov    %eax,%edi
  801d66:	fc                   	cld    
  801d67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d69:	eb 05                	jmp    801d70 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d6b:	89 c7                	mov    %eax,%edi
  801d6d:	fc                   	cld    
  801d6e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d7a:	ff 75 10             	pushl  0x10(%ebp)
  801d7d:	ff 75 0c             	pushl  0xc(%ebp)
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	e8 8a ff ff ff       	call   801d12 <memmove>
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	56                   	push   %esi
  801d8e:	53                   	push   %ebx
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d95:	89 c6                	mov    %eax,%esi
  801d97:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d9a:	39 f0                	cmp    %esi,%eax
  801d9c:	74 1c                	je     801dba <memcmp+0x30>
		if (*s1 != *s2)
  801d9e:	0f b6 08             	movzbl (%eax),%ecx
  801da1:	0f b6 1a             	movzbl (%edx),%ebx
  801da4:	38 d9                	cmp    %bl,%cl
  801da6:	75 08                	jne    801db0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801da8:	83 c0 01             	add    $0x1,%eax
  801dab:	83 c2 01             	add    $0x1,%edx
  801dae:	eb ea                	jmp    801d9a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801db0:	0f b6 c1             	movzbl %cl,%eax
  801db3:	0f b6 db             	movzbl %bl,%ebx
  801db6:	29 d8                	sub    %ebx,%eax
  801db8:	eb 05                	jmp    801dbf <memcmp+0x35>
	}

	return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	5b                   	pop    %ebx
  801dc0:	5e                   	pop    %esi
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dcc:	89 c2                	mov    %eax,%edx
  801dce:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dd1:	39 d0                	cmp    %edx,%eax
  801dd3:	73 09                	jae    801dde <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd5:	38 08                	cmp    %cl,(%eax)
  801dd7:	74 05                	je     801dde <memfind+0x1b>
	for (; s < ends; s++)
  801dd9:	83 c0 01             	add    $0x1,%eax
  801ddc:	eb f3                	jmp    801dd1 <memfind+0xe>
			break;
	return (void *) s;
}
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    

00801de0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	57                   	push   %edi
  801de4:	56                   	push   %esi
  801de5:	53                   	push   %ebx
  801de6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801dec:	eb 03                	jmp    801df1 <strtol+0x11>
		s++;
  801dee:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801df1:	0f b6 01             	movzbl (%ecx),%eax
  801df4:	3c 20                	cmp    $0x20,%al
  801df6:	74 f6                	je     801dee <strtol+0xe>
  801df8:	3c 09                	cmp    $0x9,%al
  801dfa:	74 f2                	je     801dee <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801dfc:	3c 2b                	cmp    $0x2b,%al
  801dfe:	74 2a                	je     801e2a <strtol+0x4a>
	int neg = 0;
  801e00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e05:	3c 2d                	cmp    $0x2d,%al
  801e07:	74 2b                	je     801e34 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e09:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e0f:	75 0f                	jne    801e20 <strtol+0x40>
  801e11:	80 39 30             	cmpb   $0x30,(%ecx)
  801e14:	74 28                	je     801e3e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e16:	85 db                	test   %ebx,%ebx
  801e18:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e1d:	0f 44 d8             	cmove  %eax,%ebx
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
  801e25:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e28:	eb 50                	jmp    801e7a <strtol+0x9a>
		s++;
  801e2a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e32:	eb d5                	jmp    801e09 <strtol+0x29>
		s++, neg = 1;
  801e34:	83 c1 01             	add    $0x1,%ecx
  801e37:	bf 01 00 00 00       	mov    $0x1,%edi
  801e3c:	eb cb                	jmp    801e09 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e3e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e42:	74 0e                	je     801e52 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e44:	85 db                	test   %ebx,%ebx
  801e46:	75 d8                	jne    801e20 <strtol+0x40>
		s++, base = 8;
  801e48:	83 c1 01             	add    $0x1,%ecx
  801e4b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e50:	eb ce                	jmp    801e20 <strtol+0x40>
		s += 2, base = 16;
  801e52:	83 c1 02             	add    $0x2,%ecx
  801e55:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e5a:	eb c4                	jmp    801e20 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e5f:	89 f3                	mov    %esi,%ebx
  801e61:	80 fb 19             	cmp    $0x19,%bl
  801e64:	77 29                	ja     801e8f <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e66:	0f be d2             	movsbl %dl,%edx
  801e69:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e6c:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e6f:	7d 30                	jge    801ea1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e71:	83 c1 01             	add    $0x1,%ecx
  801e74:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e78:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e7a:	0f b6 11             	movzbl (%ecx),%edx
  801e7d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e80:	89 f3                	mov    %esi,%ebx
  801e82:	80 fb 09             	cmp    $0x9,%bl
  801e85:	77 d5                	ja     801e5c <strtol+0x7c>
			dig = *s - '0';
  801e87:	0f be d2             	movsbl %dl,%edx
  801e8a:	83 ea 30             	sub    $0x30,%edx
  801e8d:	eb dd                	jmp    801e6c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e8f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e92:	89 f3                	mov    %esi,%ebx
  801e94:	80 fb 19             	cmp    $0x19,%bl
  801e97:	77 08                	ja     801ea1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  801e99:	0f be d2             	movsbl %dl,%edx
  801e9c:	83 ea 37             	sub    $0x37,%edx
  801e9f:	eb cb                	jmp    801e6c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ea1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea5:	74 05                	je     801eac <strtol+0xcc>
		*endptr = (char *) s;
  801ea7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eaa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	f7 da                	neg    %edx
  801eb0:	85 ff                	test   %edi,%edi
  801eb2:	0f 45 c2             	cmovne %edx,%eax
}
  801eb5:	5b                   	pop    %ebx
  801eb6:	5e                   	pop    %esi
  801eb7:	5f                   	pop    %edi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	56                   	push   %esi
  801ebe:	53                   	push   %ebx
  801ebf:	8b 75 08             	mov    0x8(%ebp),%esi
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	74 4f                	je     801f1b <ipc_recv+0x61>
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	50                   	push   %eax
  801ed0:	e8 35 e4 ff ff       	call   80030a <sys_ipc_recv>
  801ed5:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ed8:	85 f6                	test   %esi,%esi
  801eda:	74 14                	je     801ef0 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801edc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	75 09                	jne    801eee <ipc_recv+0x34>
  801ee5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801eeb:	8b 52 74             	mov    0x74(%edx),%edx
  801eee:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801ef0:	85 db                	test   %ebx,%ebx
  801ef2:	74 14                	je     801f08 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801ef4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	75 09                	jne    801f06 <ipc_recv+0x4c>
  801efd:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f03:	8b 52 78             	mov    0x78(%edx),%edx
  801f06:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	75 08                	jne    801f14 <ipc_recv+0x5a>
  801f0c:	a1 08 40 80 00       	mov    0x804008,%eax
  801f11:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	68 00 00 c0 ee       	push   $0xeec00000
  801f23:	e8 e2 e3 ff ff       	call   80030a <sys_ipc_recv>
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	eb ab                	jmp    801ed8 <ipc_recv+0x1e>

00801f2d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	57                   	push   %edi
  801f31:	56                   	push   %esi
  801f32:	53                   	push   %ebx
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f39:	8b 75 10             	mov    0x10(%ebp),%esi
  801f3c:	eb 20                	jmp    801f5e <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f3e:	6a 00                	push   $0x0
  801f40:	68 00 00 c0 ee       	push   $0xeec00000
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	57                   	push   %edi
  801f49:	e8 99 e3 ff ff       	call   8002e7 <sys_ipc_try_send>
  801f4e:	89 c3                	mov    %eax,%ebx
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	eb 1f                	jmp    801f74 <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f55:	e8 e1 e1 ff ff       	call   80013b <sys_yield>
	while(retval != 0) {
  801f5a:	85 db                	test   %ebx,%ebx
  801f5c:	74 33                	je     801f91 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f5e:	85 f6                	test   %esi,%esi
  801f60:	74 dc                	je     801f3e <ipc_send+0x11>
  801f62:	ff 75 14             	pushl  0x14(%ebp)
  801f65:	56                   	push   %esi
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	57                   	push   %edi
  801f6a:	e8 78 e3 ff ff       	call   8002e7 <sys_ipc_try_send>
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f74:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f77:	74 dc                	je     801f55 <ipc_send+0x28>
  801f79:	85 db                	test   %ebx,%ebx
  801f7b:	74 d8                	je     801f55 <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	68 00 27 80 00       	push   $0x802700
  801f85:	6a 35                	push   $0x35
  801f87:	68 30 27 80 00       	push   $0x802730
  801f8c:	e8 3c f5 ff ff       	call   8014cd <_panic>
	}
}
  801f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5f                   	pop    %edi
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    

00801f99 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fa4:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fa7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fad:	8b 52 50             	mov    0x50(%edx),%edx
  801fb0:	39 ca                	cmp    %ecx,%edx
  801fb2:	74 11                	je     801fc5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fb4:	83 c0 01             	add    $0x1,%eax
  801fb7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fbc:	75 e6                	jne    801fa4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc3:	eb 0b                	jmp    801fd0 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fc5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fc8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fcd:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fd8:	89 d0                	mov    %edx,%eax
  801fda:	c1 e8 16             	shr    $0x16,%eax
  801fdd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fe9:	f6 c1 01             	test   $0x1,%cl
  801fec:	74 1d                	je     80200b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fee:	c1 ea 0c             	shr    $0xc,%edx
  801ff1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ff8:	f6 c2 01             	test   $0x1,%dl
  801ffb:	74 0e                	je     80200b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ffd:	c1 ea 0c             	shr    $0xc,%edx
  802000:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802007:	ef 
  802008:	0f b7 c0             	movzwl %ax,%eax
}
  80200b:	5d                   	pop    %ebp
  80200c:	c3                   	ret    
  80200d:	66 90                	xchg   %ax,%ax
  80200f:	90                   	nop

00802010 <__udivdi3>:
  802010:	f3 0f 1e fb          	endbr32 
  802014:	55                   	push   %ebp
  802015:	57                   	push   %edi
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	83 ec 1c             	sub    $0x1c,%esp
  80201b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80201f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802023:	8b 74 24 34          	mov    0x34(%esp),%esi
  802027:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80202b:	85 d2                	test   %edx,%edx
  80202d:	75 49                	jne    802078 <__udivdi3+0x68>
  80202f:	39 f3                	cmp    %esi,%ebx
  802031:	76 15                	jbe    802048 <__udivdi3+0x38>
  802033:	31 ff                	xor    %edi,%edi
  802035:	89 e8                	mov    %ebp,%eax
  802037:	89 f2                	mov    %esi,%edx
  802039:	f7 f3                	div    %ebx
  80203b:	89 fa                	mov    %edi,%edx
  80203d:	83 c4 1c             	add    $0x1c,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    
  802045:	8d 76 00             	lea    0x0(%esi),%esi
  802048:	89 d9                	mov    %ebx,%ecx
  80204a:	85 db                	test   %ebx,%ebx
  80204c:	75 0b                	jne    802059 <__udivdi3+0x49>
  80204e:	b8 01 00 00 00       	mov    $0x1,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	f7 f3                	div    %ebx
  802057:	89 c1                	mov    %eax,%ecx
  802059:	31 d2                	xor    %edx,%edx
  80205b:	89 f0                	mov    %esi,%eax
  80205d:	f7 f1                	div    %ecx
  80205f:	89 c6                	mov    %eax,%esi
  802061:	89 e8                	mov    %ebp,%eax
  802063:	89 f7                	mov    %esi,%edi
  802065:	f7 f1                	div    %ecx
  802067:	89 fa                	mov    %edi,%edx
  802069:	83 c4 1c             	add    $0x1c,%esp
  80206c:	5b                   	pop    %ebx
  80206d:	5e                   	pop    %esi
  80206e:	5f                   	pop    %edi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    
  802071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802078:	39 f2                	cmp    %esi,%edx
  80207a:	77 1c                	ja     802098 <__udivdi3+0x88>
  80207c:	0f bd fa             	bsr    %edx,%edi
  80207f:	83 f7 1f             	xor    $0x1f,%edi
  802082:	75 2c                	jne    8020b0 <__udivdi3+0xa0>
  802084:	39 f2                	cmp    %esi,%edx
  802086:	72 06                	jb     80208e <__udivdi3+0x7e>
  802088:	31 c0                	xor    %eax,%eax
  80208a:	39 eb                	cmp    %ebp,%ebx
  80208c:	77 ad                	ja     80203b <__udivdi3+0x2b>
  80208e:	b8 01 00 00 00       	mov    $0x1,%eax
  802093:	eb a6                	jmp    80203b <__udivdi3+0x2b>
  802095:	8d 76 00             	lea    0x0(%esi),%esi
  802098:	31 ff                	xor    %edi,%edi
  80209a:	31 c0                	xor    %eax,%eax
  80209c:	89 fa                	mov    %edi,%edx
  80209e:	83 c4 1c             	add    $0x1c,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5f                   	pop    %edi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    
  8020a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020ad:	8d 76 00             	lea    0x0(%esi),%esi
  8020b0:	89 f9                	mov    %edi,%ecx
  8020b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020b7:	29 f8                	sub    %edi,%eax
  8020b9:	d3 e2                	shl    %cl,%edx
  8020bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020bf:	89 c1                	mov    %eax,%ecx
  8020c1:	89 da                	mov    %ebx,%edx
  8020c3:	d3 ea                	shr    %cl,%edx
  8020c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020c9:	09 d1                	or     %edx,%ecx
  8020cb:	89 f2                	mov    %esi,%edx
  8020cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d1:	89 f9                	mov    %edi,%ecx
  8020d3:	d3 e3                	shl    %cl,%ebx
  8020d5:	89 c1                	mov    %eax,%ecx
  8020d7:	d3 ea                	shr    %cl,%edx
  8020d9:	89 f9                	mov    %edi,%ecx
  8020db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020df:	89 eb                	mov    %ebp,%ebx
  8020e1:	d3 e6                	shl    %cl,%esi
  8020e3:	89 c1                	mov    %eax,%ecx
  8020e5:	d3 eb                	shr    %cl,%ebx
  8020e7:	09 de                	or     %ebx,%esi
  8020e9:	89 f0                	mov    %esi,%eax
  8020eb:	f7 74 24 08          	divl   0x8(%esp)
  8020ef:	89 d6                	mov    %edx,%esi
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	f7 64 24 0c          	mull   0xc(%esp)
  8020f7:	39 d6                	cmp    %edx,%esi
  8020f9:	72 15                	jb     802110 <__udivdi3+0x100>
  8020fb:	89 f9                	mov    %edi,%ecx
  8020fd:	d3 e5                	shl    %cl,%ebp
  8020ff:	39 c5                	cmp    %eax,%ebp
  802101:	73 04                	jae    802107 <__udivdi3+0xf7>
  802103:	39 d6                	cmp    %edx,%esi
  802105:	74 09                	je     802110 <__udivdi3+0x100>
  802107:	89 d8                	mov    %ebx,%eax
  802109:	31 ff                	xor    %edi,%edi
  80210b:	e9 2b ff ff ff       	jmp    80203b <__udivdi3+0x2b>
  802110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802113:	31 ff                	xor    %edi,%edi
  802115:	e9 21 ff ff ff       	jmp    80203b <__udivdi3+0x2b>
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	66 90                	xchg   %ax,%ax
  80211e:	66 90                	xchg   %ax,%ax

00802120 <__umoddi3>:
  802120:	f3 0f 1e fb          	endbr32 
  802124:	55                   	push   %ebp
  802125:	57                   	push   %edi
  802126:	56                   	push   %esi
  802127:	53                   	push   %ebx
  802128:	83 ec 1c             	sub    $0x1c,%esp
  80212b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80212f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802133:	8b 74 24 30          	mov    0x30(%esp),%esi
  802137:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80213b:	89 da                	mov    %ebx,%edx
  80213d:	85 c0                	test   %eax,%eax
  80213f:	75 3f                	jne    802180 <__umoddi3+0x60>
  802141:	39 df                	cmp    %ebx,%edi
  802143:	76 13                	jbe    802158 <__umoddi3+0x38>
  802145:	89 f0                	mov    %esi,%eax
  802147:	f7 f7                	div    %edi
  802149:	89 d0                	mov    %edx,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	89 fd                	mov    %edi,%ebp
  80215a:	85 ff                	test   %edi,%edi
  80215c:	75 0b                	jne    802169 <__umoddi3+0x49>
  80215e:	b8 01 00 00 00       	mov    $0x1,%eax
  802163:	31 d2                	xor    %edx,%edx
  802165:	f7 f7                	div    %edi
  802167:	89 c5                	mov    %eax,%ebp
  802169:	89 d8                	mov    %ebx,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f5                	div    %ebp
  80216f:	89 f0                	mov    %esi,%eax
  802171:	f7 f5                	div    %ebp
  802173:	89 d0                	mov    %edx,%eax
  802175:	eb d4                	jmp    80214b <__umoddi3+0x2b>
  802177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80217e:	66 90                	xchg   %ax,%ax
  802180:	89 f1                	mov    %esi,%ecx
  802182:	39 d8                	cmp    %ebx,%eax
  802184:	76 0a                	jbe    802190 <__umoddi3+0x70>
  802186:	89 f0                	mov    %esi,%eax
  802188:	83 c4 1c             	add    $0x1c,%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5f                   	pop    %edi
  80218e:	5d                   	pop    %ebp
  80218f:	c3                   	ret    
  802190:	0f bd e8             	bsr    %eax,%ebp
  802193:	83 f5 1f             	xor    $0x1f,%ebp
  802196:	75 20                	jne    8021b8 <__umoddi3+0x98>
  802198:	39 d8                	cmp    %ebx,%eax
  80219a:	0f 82 b0 00 00 00    	jb     802250 <__umoddi3+0x130>
  8021a0:	39 f7                	cmp    %esi,%edi
  8021a2:	0f 86 a8 00 00 00    	jbe    802250 <__umoddi3+0x130>
  8021a8:	89 c8                	mov    %ecx,%eax
  8021aa:	83 c4 1c             	add    $0x1c,%esp
  8021ad:	5b                   	pop    %ebx
  8021ae:	5e                   	pop    %esi
  8021af:	5f                   	pop    %edi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    
  8021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b8:	89 e9                	mov    %ebp,%ecx
  8021ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8021bf:	29 ea                	sub    %ebp,%edx
  8021c1:	d3 e0                	shl    %cl,%eax
  8021c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c7:	89 d1                	mov    %edx,%ecx
  8021c9:	89 f8                	mov    %edi,%eax
  8021cb:	d3 e8                	shr    %cl,%eax
  8021cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021d9:	09 c1                	or     %eax,%ecx
  8021db:	89 d8                	mov    %ebx,%eax
  8021dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021e1:	89 e9                	mov    %ebp,%ecx
  8021e3:	d3 e7                	shl    %cl,%edi
  8021e5:	89 d1                	mov    %edx,%ecx
  8021e7:	d3 e8                	shr    %cl,%eax
  8021e9:	89 e9                	mov    %ebp,%ecx
  8021eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021ef:	d3 e3                	shl    %cl,%ebx
  8021f1:	89 c7                	mov    %eax,%edi
  8021f3:	89 d1                	mov    %edx,%ecx
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	d3 e8                	shr    %cl,%eax
  8021f9:	89 e9                	mov    %ebp,%ecx
  8021fb:	89 fa                	mov    %edi,%edx
  8021fd:	d3 e6                	shl    %cl,%esi
  8021ff:	09 d8                	or     %ebx,%eax
  802201:	f7 74 24 08          	divl   0x8(%esp)
  802205:	89 d1                	mov    %edx,%ecx
  802207:	89 f3                	mov    %esi,%ebx
  802209:	f7 64 24 0c          	mull   0xc(%esp)
  80220d:	89 c6                	mov    %eax,%esi
  80220f:	89 d7                	mov    %edx,%edi
  802211:	39 d1                	cmp    %edx,%ecx
  802213:	72 06                	jb     80221b <__umoddi3+0xfb>
  802215:	75 10                	jne    802227 <__umoddi3+0x107>
  802217:	39 c3                	cmp    %eax,%ebx
  802219:	73 0c                	jae    802227 <__umoddi3+0x107>
  80221b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80221f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802223:	89 d7                	mov    %edx,%edi
  802225:	89 c6                	mov    %eax,%esi
  802227:	89 ca                	mov    %ecx,%edx
  802229:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80222e:	29 f3                	sub    %esi,%ebx
  802230:	19 fa                	sbb    %edi,%edx
  802232:	89 d0                	mov    %edx,%eax
  802234:	d3 e0                	shl    %cl,%eax
  802236:	89 e9                	mov    %ebp,%ecx
  802238:	d3 eb                	shr    %cl,%ebx
  80223a:	d3 ea                	shr    %cl,%edx
  80223c:	09 d8                	or     %ebx,%eax
  80223e:	83 c4 1c             	add    $0x1c,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
  802246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	89 da                	mov    %ebx,%edx
  802252:	29 fe                	sub    %edi,%esi
  802254:	19 c2                	sbb    %eax,%edx
  802256:	89 f1                	mov    %esi,%ecx
  802258:	89 c8                	mov    %ecx,%eax
  80225a:	e9 4b ff ff ff       	jmp    8021aa <__umoddi3+0x8a>
