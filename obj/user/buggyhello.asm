
obj/user/buggyhello.debug：     文件格式 elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 65 00 00 00       	call   8000a7 <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800052:	e8 ce 00 00 00       	call   800125 <sys_getenvid>
  800057:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800064:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800069:	85 db                	test   %ebx,%ebx
  80006b:	7e 07                	jle    800074 <libmain+0x2d>
		binaryname = argv[0];
  80006d:	8b 06                	mov    (%esi),%eax
  80006f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800074:	83 ec 08             	sub    $0x8,%esp
  800077:	56                   	push   %esi
  800078:	53                   	push   %ebx
  800079:	e8 b5 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007e:	e8 0a 00 00 00       	call   80008d <exit>
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800089:	5b                   	pop    %ebx
  80008a:	5e                   	pop    %esi
  80008b:	5d                   	pop    %ebp
  80008c:	c3                   	ret    

0080008d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008d:	55                   	push   %ebp
  80008e:	89 e5                	mov    %esp,%ebp
  800090:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800093:	e8 b3 04 00 00       	call   80054b <close_all>
	sys_env_destroy(0);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	6a 00                	push   $0x0
  80009d:	e8 42 00 00 00       	call   8000e4 <sys_env_destroy>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	c9                   	leave  
  8000a6:	c3                   	ret    

008000a7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b8:	89 c3                	mov    %eax,%ebx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 c6                	mov    %eax,%esi
  8000be:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5f                   	pop    %edi
  8000c3:	5d                   	pop    %ebp
  8000c4:	c3                   	ret    

008000c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	57                   	push   %edi
  8000c9:	56                   	push   %esi
  8000ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d5:	89 d1                	mov    %edx,%ecx
  8000d7:	89 d3                	mov    %edx,%ebx
  8000d9:	89 d7                	mov    %edx,%edi
  8000db:	89 d6                	mov    %edx,%esi
  8000dd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8000fa:	89 cb                	mov    %ecx,%ebx
  8000fc:	89 cf                	mov    %ecx,%edi
  8000fe:	89 ce                	mov    %ecx,%esi
  800100:	cd 30                	int    $0x30
	if(check && ret > 0)
  800102:	85 c0                	test   %eax,%eax
  800104:	7f 08                	jg     80010e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800109:	5b                   	pop    %ebx
  80010a:	5e                   	pop    %esi
  80010b:	5f                   	pop    %edi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	6a 03                	push   $0x3
  800114:	68 8a 22 80 00       	push   $0x80228a
  800119:	6a 23                	push   $0x23
  80011b:	68 a7 22 80 00       	push   $0x8022a7
  800120:	e8 b1 13 00 00       	call   8014d6 <_panic>

00800125 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	57                   	push   %edi
  800129:	56                   	push   %esi
  80012a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012b:	ba 00 00 00 00       	mov    $0x0,%edx
  800130:	b8 02 00 00 00       	mov    $0x2,%eax
  800135:	89 d1                	mov    %edx,%ecx
  800137:	89 d3                	mov    %edx,%ebx
  800139:	89 d7                	mov    %edx,%edi
  80013b:	89 d6                	mov    %edx,%esi
  80013d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    

00800144 <sys_yield>:

void
sys_yield(void)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	57                   	push   %edi
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800154:	89 d1                	mov    %edx,%ecx
  800156:	89 d3                	mov    %edx,%ebx
  800158:	89 d7                	mov    %edx,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80015e:	5b                   	pop    %ebx
  80015f:	5e                   	pop    %esi
  800160:	5f                   	pop    %edi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	57                   	push   %edi
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	8b 55 08             	mov    0x8(%ebp),%edx
  800174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800177:	b8 04 00 00 00       	mov    $0x4,%eax
  80017c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80017f:	89 f7                	mov    %esi,%edi
  800181:	cd 30                	int    $0x30
	if(check && ret > 0)
  800183:	85 c0                	test   %eax,%eax
  800185:	7f 08                	jg     80018f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018a:	5b                   	pop    %ebx
  80018b:	5e                   	pop    %esi
  80018c:	5f                   	pop    %edi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	50                   	push   %eax
  800193:	6a 04                	push   $0x4
  800195:	68 8a 22 80 00       	push   $0x80228a
  80019a:	6a 23                	push   $0x23
  80019c:	68 a7 22 80 00       	push   $0x8022a7
  8001a1:	e8 30 13 00 00       	call   8014d6 <_panic>

008001a6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	57                   	push   %edi
  8001aa:	56                   	push   %esi
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001af:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	7f 08                	jg     8001d1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5f                   	pop    %edi
  8001cf:	5d                   	pop    %ebp
  8001d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	6a 05                	push   $0x5
  8001d7:	68 8a 22 80 00       	push   $0x80228a
  8001dc:	6a 23                	push   $0x23
  8001de:	68 a7 22 80 00       	push   $0x8022a7
  8001e3:	e8 ee 12 00 00       	call   8014d6 <_panic>

008001e8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	57                   	push   %edi
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fc:	b8 06 00 00 00       	mov    $0x6,%eax
  800201:	89 df                	mov    %ebx,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	cd 30                	int    $0x30
	if(check && ret > 0)
  800207:	85 c0                	test   %eax,%eax
  800209:	7f 08                	jg     800213 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80020b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	50                   	push   %eax
  800217:	6a 06                	push   $0x6
  800219:	68 8a 22 80 00       	push   $0x80228a
  80021e:	6a 23                	push   $0x23
  800220:	68 a7 22 80 00       	push   $0x8022a7
  800225:	e8 ac 12 00 00       	call   8014d6 <_panic>

0080022a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800233:	bb 00 00 00 00       	mov    $0x0,%ebx
  800238:	8b 55 08             	mov    0x8(%ebp),%edx
  80023b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023e:	b8 08 00 00 00       	mov    $0x8,%eax
  800243:	89 df                	mov    %ebx,%edi
  800245:	89 de                	mov    %ebx,%esi
  800247:	cd 30                	int    $0x30
	if(check && ret > 0)
  800249:	85 c0                	test   %eax,%eax
  80024b:	7f 08                	jg     800255 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800250:	5b                   	pop    %ebx
  800251:	5e                   	pop    %esi
  800252:	5f                   	pop    %edi
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	50                   	push   %eax
  800259:	6a 08                	push   $0x8
  80025b:	68 8a 22 80 00       	push   $0x80228a
  800260:	6a 23                	push   $0x23
  800262:	68 a7 22 80 00       	push   $0x8022a7
  800267:	e8 6a 12 00 00       	call   8014d6 <_panic>

0080026c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	57                   	push   %edi
  800270:	56                   	push   %esi
  800271:	53                   	push   %ebx
  800272:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800275:	bb 00 00 00 00       	mov    $0x0,%ebx
  80027a:	8b 55 08             	mov    0x8(%ebp),%edx
  80027d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800280:	b8 09 00 00 00       	mov    $0x9,%eax
  800285:	89 df                	mov    %ebx,%edi
  800287:	89 de                	mov    %ebx,%esi
  800289:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028b:	85 c0                	test   %eax,%eax
  80028d:	7f 08                	jg     800297 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80028f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5f                   	pop    %edi
  800295:	5d                   	pop    %ebp
  800296:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	50                   	push   %eax
  80029b:	6a 09                	push   $0x9
  80029d:	68 8a 22 80 00       	push   $0x80228a
  8002a2:	6a 23                	push   $0x23
  8002a4:	68 a7 22 80 00       	push   $0x8022a7
  8002a9:	e8 28 12 00 00       	call   8014d6 <_panic>

008002ae <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	57                   	push   %edi
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002c7:	89 df                	mov    %ebx,%edi
  8002c9:	89 de                	mov    %ebx,%esi
  8002cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	7f 08                	jg     8002d9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	6a 0a                	push   $0xa
  8002df:	68 8a 22 80 00       	push   $0x80228a
  8002e4:	6a 23                	push   $0x23
  8002e6:	68 a7 22 80 00       	push   $0x8022a7
  8002eb:	e8 e6 11 00 00       	call   8014d6 <_panic>

008002f0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800301:	be 00 00 00 00       	mov    $0x0,%esi
  800306:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800309:	8b 7d 14             	mov    0x14(%ebp),%edi
  80030c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	b8 0d 00 00 00       	mov    $0xd,%eax
  800329:	89 cb                	mov    %ecx,%ebx
  80032b:	89 cf                	mov    %ecx,%edi
  80032d:	89 ce                	mov    %ecx,%esi
  80032f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800331:	85 c0                	test   %eax,%eax
  800333:	7f 08                	jg     80033d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800335:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	50                   	push   %eax
  800341:	6a 0d                	push   $0xd
  800343:	68 8a 22 80 00       	push   $0x80228a
  800348:	6a 23                	push   $0x23
  80034a:	68 a7 22 80 00       	push   $0x8022a7
  80034f:	e8 82 11 00 00       	call   8014d6 <_panic>

00800354 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035a:	ba 00 00 00 00       	mov    $0x0,%edx
  80035f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800364:	89 d1                	mov    %edx,%ecx
  800366:	89 d3                	mov    %edx,%ebx
  800368:	89 d7                	mov    %edx,%edi
  80036a:	89 d6                	mov    %edx,%esi
  80036c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800376:	8b 45 08             	mov    0x8(%ebp),%eax
  800379:	05 00 00 00 30       	add    $0x30000000,%eax
  80037e:	c1 e8 0c             	shr    $0xc,%eax
}
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80038e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800393:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	c1 ea 16             	shr    $0x16,%edx
  8003a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ae:	f6 c2 01             	test   $0x1,%dl
  8003b1:	74 2d                	je     8003e0 <fd_alloc+0x46>
  8003b3:	89 c2                	mov    %eax,%edx
  8003b5:	c1 ea 0c             	shr    $0xc,%edx
  8003b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003bf:	f6 c2 01             	test   $0x1,%dl
  8003c2:	74 1c                	je     8003e0 <fd_alloc+0x46>
  8003c4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8003c9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003ce:	75 d2                	jne    8003a2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8003d9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003de:	eb 0a                	jmp    8003ea <fd_alloc+0x50>
			*fd_store = fd;
  8003e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003f2:	83 f8 1f             	cmp    $0x1f,%eax
  8003f5:	77 30                	ja     800427 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003f7:	c1 e0 0c             	shl    $0xc,%eax
  8003fa:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003ff:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800405:	f6 c2 01             	test   $0x1,%dl
  800408:	74 24                	je     80042e <fd_lookup+0x42>
  80040a:	89 c2                	mov    %eax,%edx
  80040c:	c1 ea 0c             	shr    $0xc,%edx
  80040f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800416:	f6 c2 01             	test   $0x1,%dl
  800419:	74 1a                	je     800435 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80041b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80041e:	89 02                	mov    %eax,(%edx)
	return 0;
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800425:	5d                   	pop    %ebp
  800426:	c3                   	ret    
		return -E_INVAL;
  800427:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80042c:	eb f7                	jmp    800425 <fd_lookup+0x39>
		return -E_INVAL;
  80042e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800433:	eb f0                	jmp    800425 <fd_lookup+0x39>
  800435:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80043a:	eb e9                	jmp    800425 <fd_lookup+0x39>

0080043c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80043c:	55                   	push   %ebp
  80043d:	89 e5                	mov    %esp,%ebp
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800445:	ba 00 00 00 00       	mov    $0x0,%edx
  80044a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80044f:	39 08                	cmp    %ecx,(%eax)
  800451:	74 38                	je     80048b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  800453:	83 c2 01             	add    $0x1,%edx
  800456:	8b 04 95 34 23 80 00 	mov    0x802334(,%edx,4),%eax
  80045d:	85 c0                	test   %eax,%eax
  80045f:	75 ee                	jne    80044f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800461:	a1 08 40 80 00       	mov    0x804008,%eax
  800466:	8b 40 48             	mov    0x48(%eax),%eax
  800469:	83 ec 04             	sub    $0x4,%esp
  80046c:	51                   	push   %ecx
  80046d:	50                   	push   %eax
  80046e:	68 b8 22 80 00       	push   $0x8022b8
  800473:	e8 39 11 00 00       	call   8015b1 <cprintf>
	*dev = 0;
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800489:	c9                   	leave  
  80048a:	c3                   	ret    
			*dev = devtab[i];
  80048b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80048e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	eb f2                	jmp    800489 <dev_lookup+0x4d>

00800497 <fd_close>:
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	57                   	push   %edi
  80049b:	56                   	push   %esi
  80049c:	53                   	push   %ebx
  80049d:	83 ec 24             	sub    $0x24,%esp
  8004a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004a9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004aa:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004b0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004b3:	50                   	push   %eax
  8004b4:	e8 33 ff ff ff       	call   8003ec <fd_lookup>
  8004b9:	89 c3                	mov    %eax,%ebx
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	85 c0                	test   %eax,%eax
  8004c0:	78 05                	js     8004c7 <fd_close+0x30>
	    || fd != fd2)
  8004c2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8004c5:	74 16                	je     8004dd <fd_close+0x46>
		return (must_exist ? r : 0);
  8004c7:	89 f8                	mov    %edi,%eax
  8004c9:	84 c0                	test   %al,%al
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 44 d8             	cmove  %eax,%ebx
}
  8004d3:	89 d8                	mov    %ebx,%eax
  8004d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004d8:	5b                   	pop    %ebx
  8004d9:	5e                   	pop    %esi
  8004da:	5f                   	pop    %edi
  8004db:	5d                   	pop    %ebp
  8004dc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	ff 36                	pushl  (%esi)
  8004e6:	e8 51 ff ff ff       	call   80043c <dev_lookup>
  8004eb:	89 c3                	mov    %eax,%ebx
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	85 c0                	test   %eax,%eax
  8004f2:	78 1a                	js     80050e <fd_close+0x77>
		if (dev->dev_close)
  8004f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8004fa:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8004ff:	85 c0                	test   %eax,%eax
  800501:	74 0b                	je     80050e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	56                   	push   %esi
  800507:	ff d0                	call   *%eax
  800509:	89 c3                	mov    %eax,%ebx
  80050b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	56                   	push   %esi
  800512:	6a 00                	push   $0x0
  800514:	e8 cf fc ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	eb b5                	jmp    8004d3 <fd_close+0x3c>

0080051e <close>:

int
close(int fdnum)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800527:	50                   	push   %eax
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	e8 bc fe ff ff       	call   8003ec <fd_lookup>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	85 c0                	test   %eax,%eax
  800535:	79 02                	jns    800539 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800537:	c9                   	leave  
  800538:	c3                   	ret    
		return fd_close(fd, 1);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	6a 01                	push   $0x1
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	e8 51 ff ff ff       	call   800497 <fd_close>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	eb ec                	jmp    800537 <close+0x19>

0080054b <close_all>:

void
close_all(void)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	53                   	push   %ebx
  80054f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800552:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800557:	83 ec 0c             	sub    $0xc,%esp
  80055a:	53                   	push   %ebx
  80055b:	e8 be ff ff ff       	call   80051e <close>
	for (i = 0; i < MAXFD; i++)
  800560:	83 c3 01             	add    $0x1,%ebx
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	83 fb 20             	cmp    $0x20,%ebx
  800569:	75 ec                	jne    800557 <close_all+0xc>
}
  80056b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	57                   	push   %edi
  800574:	56                   	push   %esi
  800575:	53                   	push   %ebx
  800576:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800579:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80057c:	50                   	push   %eax
  80057d:	ff 75 08             	pushl  0x8(%ebp)
  800580:	e8 67 fe ff ff       	call   8003ec <fd_lookup>
  800585:	89 c3                	mov    %eax,%ebx
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	85 c0                	test   %eax,%eax
  80058c:	0f 88 81 00 00 00    	js     800613 <dup+0xa3>
		return r;
	close(newfdnum);
  800592:	83 ec 0c             	sub    $0xc,%esp
  800595:	ff 75 0c             	pushl  0xc(%ebp)
  800598:	e8 81 ff ff ff       	call   80051e <close>

	newfd = INDEX2FD(newfdnum);
  80059d:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005a0:	c1 e6 0c             	shl    $0xc,%esi
  8005a3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005a9:	83 c4 04             	add    $0x4,%esp
  8005ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005af:	e8 cf fd ff ff       	call   800383 <fd2data>
  8005b4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8005b6:	89 34 24             	mov    %esi,(%esp)
  8005b9:	e8 c5 fd ff ff       	call   800383 <fd2data>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8005c3:	89 d8                	mov    %ebx,%eax
  8005c5:	c1 e8 16             	shr    $0x16,%eax
  8005c8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005cf:	a8 01                	test   $0x1,%al
  8005d1:	74 11                	je     8005e4 <dup+0x74>
  8005d3:	89 d8                	mov    %ebx,%eax
  8005d5:	c1 e8 0c             	shr    $0xc,%eax
  8005d8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005df:	f6 c2 01             	test   $0x1,%dl
  8005e2:	75 39                	jne    80061d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	c1 e8 0c             	shr    $0xc,%eax
  8005ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f3:	83 ec 0c             	sub    $0xc,%esp
  8005f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8005fb:	50                   	push   %eax
  8005fc:	56                   	push   %esi
  8005fd:	6a 00                	push   $0x0
  8005ff:	52                   	push   %edx
  800600:	6a 00                	push   $0x0
  800602:	e8 9f fb ff ff       	call   8001a6 <sys_page_map>
  800607:	89 c3                	mov    %eax,%ebx
  800609:	83 c4 20             	add    $0x20,%esp
  80060c:	85 c0                	test   %eax,%eax
  80060e:	78 31                	js     800641 <dup+0xd1>
		goto err;

	return newfdnum;
  800610:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800613:	89 d8                	mov    %ebx,%eax
  800615:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800618:	5b                   	pop    %ebx
  800619:	5e                   	pop    %esi
  80061a:	5f                   	pop    %edi
  80061b:	5d                   	pop    %ebp
  80061c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80061d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	25 07 0e 00 00       	and    $0xe07,%eax
  80062c:	50                   	push   %eax
  80062d:	57                   	push   %edi
  80062e:	6a 00                	push   $0x0
  800630:	53                   	push   %ebx
  800631:	6a 00                	push   $0x0
  800633:	e8 6e fb ff ff       	call   8001a6 <sys_page_map>
  800638:	89 c3                	mov    %eax,%ebx
  80063a:	83 c4 20             	add    $0x20,%esp
  80063d:	85 c0                	test   %eax,%eax
  80063f:	79 a3                	jns    8005e4 <dup+0x74>
	sys_page_unmap(0, newfd);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	56                   	push   %esi
  800645:	6a 00                	push   $0x0
  800647:	e8 9c fb ff ff       	call   8001e8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80064c:	83 c4 08             	add    $0x8,%esp
  80064f:	57                   	push   %edi
  800650:	6a 00                	push   $0x0
  800652:	e8 91 fb ff ff       	call   8001e8 <sys_page_unmap>
	return r;
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	eb b7                	jmp    800613 <dup+0xa3>

0080065c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	53                   	push   %ebx
  800660:	83 ec 1c             	sub    $0x1c,%esp
  800663:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800666:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800669:	50                   	push   %eax
  80066a:	53                   	push   %ebx
  80066b:	e8 7c fd ff ff       	call   8003ec <fd_lookup>
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	85 c0                	test   %eax,%eax
  800675:	78 3f                	js     8006b6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80067d:	50                   	push   %eax
  80067e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800681:	ff 30                	pushl  (%eax)
  800683:	e8 b4 fd ff ff       	call   80043c <dev_lookup>
  800688:	83 c4 10             	add    $0x10,%esp
  80068b:	85 c0                	test   %eax,%eax
  80068d:	78 27                	js     8006b6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80068f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800692:	8b 42 08             	mov    0x8(%edx),%eax
  800695:	83 e0 03             	and    $0x3,%eax
  800698:	83 f8 01             	cmp    $0x1,%eax
  80069b:	74 1e                	je     8006bb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80069d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a0:	8b 40 08             	mov    0x8(%eax),%eax
  8006a3:	85 c0                	test   %eax,%eax
  8006a5:	74 35                	je     8006dc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8006a7:	83 ec 04             	sub    $0x4,%esp
  8006aa:	ff 75 10             	pushl  0x10(%ebp)
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	52                   	push   %edx
  8006b1:	ff d0                	call   *%eax
  8006b3:	83 c4 10             	add    $0x10,%esp
}
  8006b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b9:	c9                   	leave  
  8006ba:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8006bb:	a1 08 40 80 00       	mov    0x804008,%eax
  8006c0:	8b 40 48             	mov    0x48(%eax),%eax
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	50                   	push   %eax
  8006c8:	68 f9 22 80 00       	push   $0x8022f9
  8006cd:	e8 df 0e 00 00       	call   8015b1 <cprintf>
		return -E_INVAL;
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006da:	eb da                	jmp    8006b6 <read+0x5a>
		return -E_NOT_SUPP;
  8006dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006e1:	eb d3                	jmp    8006b6 <read+0x5a>

008006e3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	57                   	push   %edi
  8006e7:	56                   	push   %esi
  8006e8:	53                   	push   %ebx
  8006e9:	83 ec 0c             	sub    $0xc,%esp
  8006ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006ef:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f7:	39 f3                	cmp    %esi,%ebx
  8006f9:	73 23                	jae    80071e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	89 f0                	mov    %esi,%eax
  800700:	29 d8                	sub    %ebx,%eax
  800702:	50                   	push   %eax
  800703:	89 d8                	mov    %ebx,%eax
  800705:	03 45 0c             	add    0xc(%ebp),%eax
  800708:	50                   	push   %eax
  800709:	57                   	push   %edi
  80070a:	e8 4d ff ff ff       	call   80065c <read>
		if (m < 0)
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	85 c0                	test   %eax,%eax
  800714:	78 06                	js     80071c <readn+0x39>
			return m;
		if (m == 0)
  800716:	74 06                	je     80071e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800718:	01 c3                	add    %eax,%ebx
  80071a:	eb db                	jmp    8006f7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80071c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80071e:	89 d8                	mov    %ebx,%eax
  800720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800723:	5b                   	pop    %ebx
  800724:	5e                   	pop    %esi
  800725:	5f                   	pop    %edi
  800726:	5d                   	pop    %ebp
  800727:	c3                   	ret    

00800728 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	53                   	push   %ebx
  80072c:	83 ec 1c             	sub    $0x1c,%esp
  80072f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800732:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800735:	50                   	push   %eax
  800736:	53                   	push   %ebx
  800737:	e8 b0 fc ff ff       	call   8003ec <fd_lookup>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	85 c0                	test   %eax,%eax
  800741:	78 3a                	js     80077d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074d:	ff 30                	pushl  (%eax)
  80074f:	e8 e8 fc ff ff       	call   80043c <dev_lookup>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	85 c0                	test   %eax,%eax
  800759:	78 22                	js     80077d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80075b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800762:	74 1e                	je     800782 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800767:	8b 52 0c             	mov    0xc(%edx),%edx
  80076a:	85 d2                	test   %edx,%edx
  80076c:	74 35                	je     8007a3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80076e:	83 ec 04             	sub    $0x4,%esp
  800771:	ff 75 10             	pushl  0x10(%ebp)
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	ff d2                	call   *%edx
  80077a:	83 c4 10             	add    $0x10,%esp
}
  80077d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800780:	c9                   	leave  
  800781:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800782:	a1 08 40 80 00       	mov    0x804008,%eax
  800787:	8b 40 48             	mov    0x48(%eax),%eax
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	68 15 23 80 00       	push   $0x802315
  800794:	e8 18 0e 00 00       	call   8015b1 <cprintf>
		return -E_INVAL;
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a1:	eb da                	jmp    80077d <write+0x55>
		return -E_NOT_SUPP;
  8007a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007a8:	eb d3                	jmp    80077d <write+0x55>

008007aa <seek>:

int
seek(int fdnum, off_t offset)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8007b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b3:	50                   	push   %eax
  8007b4:	ff 75 08             	pushl  0x8(%ebp)
  8007b7:	e8 30 fc ff ff       	call   8003ec <fd_lookup>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	78 0e                	js     8007d1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8007c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8007cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	53                   	push   %ebx
  8007d7:	83 ec 1c             	sub    $0x1c,%esp
  8007da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007e0:	50                   	push   %eax
  8007e1:	53                   	push   %ebx
  8007e2:	e8 05 fc ff ff       	call   8003ec <fd_lookup>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	78 37                	js     800825 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f8:	ff 30                	pushl  (%eax)
  8007fa:	e8 3d fc ff ff       	call   80043c <dev_lookup>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	85 c0                	test   %eax,%eax
  800804:	78 1f                	js     800825 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800809:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80080d:	74 1b                	je     80082a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80080f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800812:	8b 52 18             	mov    0x18(%edx),%edx
  800815:	85 d2                	test   %edx,%edx
  800817:	74 32                	je     80084b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 0c             	pushl  0xc(%ebp)
  80081f:	50                   	push   %eax
  800820:	ff d2                	call   *%edx
  800822:	83 c4 10             	add    $0x10,%esp
}
  800825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800828:	c9                   	leave  
  800829:	c3                   	ret    
			thisenv->env_id, fdnum);
  80082a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80082f:	8b 40 48             	mov    0x48(%eax),%eax
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	53                   	push   %ebx
  800836:	50                   	push   %eax
  800837:	68 d8 22 80 00       	push   $0x8022d8
  80083c:	e8 70 0d 00 00       	call   8015b1 <cprintf>
		return -E_INVAL;
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800849:	eb da                	jmp    800825 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80084b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800850:	eb d3                	jmp    800825 <ftruncate+0x52>

00800852 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 1c             	sub    $0x1c,%esp
  800859:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085f:	50                   	push   %eax
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 84 fb ff ff       	call   8003ec <fd_lookup>
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	85 c0                	test   %eax,%eax
  80086d:	78 4b                	js     8008ba <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800875:	50                   	push   %eax
  800876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800879:	ff 30                	pushl  (%eax)
  80087b:	e8 bc fb ff ff       	call   80043c <dev_lookup>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	78 33                	js     8008ba <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80088e:	74 2f                	je     8008bf <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800890:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800893:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80089a:	00 00 00 
	stat->st_isdir = 0;
  80089d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8008a4:	00 00 00 
	stat->st_dev = dev;
  8008a7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008b4:	ff 50 14             	call   *0x14(%eax)
  8008b7:	83 c4 10             	add    $0x10,%esp
}
  8008ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_NOT_SUPP;
  8008bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c4:	eb f4                	jmp    8008ba <fstat+0x68>

008008c6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
  8008c9:	56                   	push   %esi
  8008ca:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	6a 00                	push   $0x0
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 2f 02 00 00       	call   800b07 <open>
  8008d8:	89 c3                	mov    %eax,%ebx
  8008da:	83 c4 10             	add    $0x10,%esp
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	78 1b                	js     8008fc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	50                   	push   %eax
  8008e8:	e8 65 ff ff ff       	call   800852 <fstat>
  8008ed:	89 c6                	mov    %eax,%esi
	close(fd);
  8008ef:	89 1c 24             	mov    %ebx,(%esp)
  8008f2:	e8 27 fc ff ff       	call   80051e <close>
	return r;
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	89 f3                	mov    %esi,%ebx
}
  8008fc:	89 d8                	mov    %ebx,%eax
  8008fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800901:	5b                   	pop    %ebx
  800902:	5e                   	pop    %esi
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	56                   	push   %esi
  800909:	53                   	push   %ebx
  80090a:	89 c6                	mov    %eax,%esi
  80090c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80090e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800915:	74 27                	je     80093e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800917:	6a 07                	push   $0x7
  800919:	68 00 50 80 00       	push   $0x805000
  80091e:	56                   	push   %esi
  80091f:	ff 35 00 40 80 00    	pushl  0x804000
  800925:	e8 0c 16 00 00       	call   801f36 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80092a:	83 c4 0c             	add    $0xc,%esp
  80092d:	6a 00                	push   $0x0
  80092f:	53                   	push   %ebx
  800930:	6a 00                	push   $0x0
  800932:	e8 8c 15 00 00       	call   801ec3 <ipc_recv>
}
  800937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80093a:	5b                   	pop    %ebx
  80093b:	5e                   	pop    %esi
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80093e:	83 ec 0c             	sub    $0xc,%esp
  800941:	6a 01                	push   $0x1
  800943:	e8 5a 16 00 00       	call   801fa2 <ipc_find_env>
  800948:	a3 00 40 80 00       	mov    %eax,0x804000
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb c5                	jmp    800917 <fsipc+0x12>

00800952 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 40 0c             	mov    0xc(%eax),%eax
  80095e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800963:	8b 45 0c             	mov    0xc(%ebp),%eax
  800966:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80096b:	ba 00 00 00 00       	mov    $0x0,%edx
  800970:	b8 02 00 00 00       	mov    $0x2,%eax
  800975:	e8 8b ff ff ff       	call   800905 <fsipc>
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <devfile_flush>:
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 40 0c             	mov    0xc(%eax),%eax
  800988:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80098d:	ba 00 00 00 00       	mov    $0x0,%edx
  800992:	b8 06 00 00 00       	mov    $0x6,%eax
  800997:	e8 69 ff ff ff       	call   800905 <fsipc>
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <devfile_stat>:
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ae:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8009b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b8:	b8 05 00 00 00       	mov    $0x5,%eax
  8009bd:	e8 43 ff ff ff       	call   800905 <fsipc>
  8009c2:	85 c0                	test   %eax,%eax
  8009c4:	78 2c                	js     8009f2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	68 00 50 80 00       	push   $0x805000
  8009ce:	53                   	push   %ebx
  8009cf:	e8 b9 11 00 00       	call   801b8d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009d4:	a1 80 50 80 00       	mov    0x805080,%eax
  8009d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009df:	a1 84 50 80 00       	mov    0x805084,%eax
  8009e4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <devfile_write>:
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	83 ec 04             	sub    $0x4,%esp
  8009fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  800a01:	85 db                	test   %ebx,%ebx
  800a03:	75 07                	jne    800a0c <devfile_write+0x15>
	return n_all;
  800a05:	89 d8                	mov    %ebx,%eax
}
  800a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	8b 40 0c             	mov    0xc(%eax),%eax
  800a12:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800a17:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800a1d:	83 ec 04             	sub    $0x4,%esp
  800a20:	53                   	push   %ebx
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	68 08 50 80 00       	push   $0x805008
  800a29:	e8 ed 12 00 00       	call   801d1b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a33:	b8 04 00 00 00       	mov    $0x4,%eax
  800a38:	e8 c8 fe ff ff       	call   800905 <fsipc>
  800a3d:	83 c4 10             	add    $0x10,%esp
  800a40:	85 c0                	test   %eax,%eax
  800a42:	78 c3                	js     800a07 <devfile_write+0x10>
	  assert(r <= n_left);
  800a44:	39 d8                	cmp    %ebx,%eax
  800a46:	77 0b                	ja     800a53 <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800a48:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a4d:	7f 1d                	jg     800a6c <devfile_write+0x75>
    n_all += r;
  800a4f:	89 c3                	mov    %eax,%ebx
  800a51:	eb b2                	jmp    800a05 <devfile_write+0xe>
	  assert(r <= n_left);
  800a53:	68 48 23 80 00       	push   $0x802348
  800a58:	68 54 23 80 00       	push   $0x802354
  800a5d:	68 9f 00 00 00       	push   $0x9f
  800a62:	68 69 23 80 00       	push   $0x802369
  800a67:	e8 6a 0a 00 00       	call   8014d6 <_panic>
	  assert(r <= PGSIZE);
  800a6c:	68 74 23 80 00       	push   $0x802374
  800a71:	68 54 23 80 00       	push   $0x802354
  800a76:	68 a0 00 00 00       	push   $0xa0
  800a7b:	68 69 23 80 00       	push   $0x802369
  800a80:	e8 51 0a 00 00       	call   8014d6 <_panic>

00800a85 <devfile_read>:
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	56                   	push   %esi
  800a89:	53                   	push   %ebx
  800a8a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8b 40 0c             	mov    0xc(%eax),%eax
  800a93:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a98:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa8:	e8 58 fe ff ff       	call   800905 <fsipc>
  800aad:	89 c3                	mov    %eax,%ebx
  800aaf:	85 c0                	test   %eax,%eax
  800ab1:	78 1f                	js     800ad2 <devfile_read+0x4d>
	assert(r <= n);
  800ab3:	39 f0                	cmp    %esi,%eax
  800ab5:	77 24                	ja     800adb <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ab7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800abc:	7f 33                	jg     800af1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800abe:	83 ec 04             	sub    $0x4,%esp
  800ac1:	50                   	push   %eax
  800ac2:	68 00 50 80 00       	push   $0x805000
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	e8 4c 12 00 00       	call   801d1b <memmove>
	return r;
  800acf:	83 c4 10             	add    $0x10,%esp
}
  800ad2:	89 d8                	mov    %ebx,%eax
  800ad4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    
	assert(r <= n);
  800adb:	68 80 23 80 00       	push   $0x802380
  800ae0:	68 54 23 80 00       	push   $0x802354
  800ae5:	6a 7c                	push   $0x7c
  800ae7:	68 69 23 80 00       	push   $0x802369
  800aec:	e8 e5 09 00 00       	call   8014d6 <_panic>
	assert(r <= PGSIZE);
  800af1:	68 74 23 80 00       	push   $0x802374
  800af6:	68 54 23 80 00       	push   $0x802354
  800afb:	6a 7d                	push   $0x7d
  800afd:	68 69 23 80 00       	push   $0x802369
  800b02:	e8 cf 09 00 00       	call   8014d6 <_panic>

00800b07 <open>:
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	83 ec 1c             	sub    $0x1c,%esp
  800b0f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b12:	56                   	push   %esi
  800b13:	e8 3c 10 00 00       	call   801b54 <strlen>
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b20:	7f 6c                	jg     800b8e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b28:	50                   	push   %eax
  800b29:	e8 6c f8 ff ff       	call   80039a <fd_alloc>
  800b2e:	89 c3                	mov    %eax,%ebx
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	85 c0                	test   %eax,%eax
  800b35:	78 3c                	js     800b73 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	56                   	push   %esi
  800b3b:	68 00 50 80 00       	push   $0x805000
  800b40:	e8 48 10 00 00       	call   801b8d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b50:	b8 01 00 00 00       	mov    $0x1,%eax
  800b55:	e8 ab fd ff ff       	call   800905 <fsipc>
  800b5a:	89 c3                	mov    %eax,%ebx
  800b5c:	83 c4 10             	add    $0x10,%esp
  800b5f:	85 c0                	test   %eax,%eax
  800b61:	78 19                	js     800b7c <open+0x75>
	return fd2num(fd);
  800b63:	83 ec 0c             	sub    $0xc,%esp
  800b66:	ff 75 f4             	pushl  -0xc(%ebp)
  800b69:	e8 05 f8 ff ff       	call   800373 <fd2num>
  800b6e:	89 c3                	mov    %eax,%ebx
  800b70:	83 c4 10             	add    $0x10,%esp
}
  800b73:	89 d8                	mov    %ebx,%eax
  800b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b78:	5b                   	pop    %ebx
  800b79:	5e                   	pop    %esi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    
		fd_close(fd, 0);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	6a 00                	push   $0x0
  800b81:	ff 75 f4             	pushl  -0xc(%ebp)
  800b84:	e8 0e f9 ff ff       	call   800497 <fd_close>
		return r;
  800b89:	83 c4 10             	add    $0x10,%esp
  800b8c:	eb e5                	jmp    800b73 <open+0x6c>
		return -E_BAD_PATH;
  800b8e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b93:	eb de                	jmp    800b73 <open+0x6c>

00800b95 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 08 00 00 00       	mov    $0x8,%eax
  800ba5:	e8 5b fd ff ff       	call   800905 <fsipc>
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800bb4:	83 ec 0c             	sub    $0xc,%esp
  800bb7:	ff 75 08             	pushl  0x8(%ebp)
  800bba:	e8 c4 f7 ff ff       	call   800383 <fd2data>
  800bbf:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800bc1:	83 c4 08             	add    $0x8,%esp
  800bc4:	68 87 23 80 00       	push   $0x802387
  800bc9:	53                   	push   %ebx
  800bca:	e8 be 0f 00 00       	call   801b8d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800bcf:	8b 46 04             	mov    0x4(%esi),%eax
  800bd2:	2b 06                	sub    (%esi),%eax
  800bd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800bda:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800be1:	00 00 00 
	stat->st_dev = &devpipe;
  800be4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800beb:	30 80 00 
	return 0;
}
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	53                   	push   %ebx
  800bfe:	83 ec 0c             	sub    $0xc,%esp
  800c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c04:	53                   	push   %ebx
  800c05:	6a 00                	push   $0x0
  800c07:	e8 dc f5 ff ff       	call   8001e8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c0c:	89 1c 24             	mov    %ebx,(%esp)
  800c0f:	e8 6f f7 ff ff       	call   800383 <fd2data>
  800c14:	83 c4 08             	add    $0x8,%esp
  800c17:	50                   	push   %eax
  800c18:	6a 00                	push   $0x0
  800c1a:	e8 c9 f5 ff ff       	call   8001e8 <sys_page_unmap>
}
  800c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <_pipeisclosed>:
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 1c             	sub    $0x1c,%esp
  800c2d:	89 c7                	mov    %eax,%edi
  800c2f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800c31:	a1 08 40 80 00       	mov    0x804008,%eax
  800c36:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800c39:	83 ec 0c             	sub    $0xc,%esp
  800c3c:	57                   	push   %edi
  800c3d:	e8 99 13 00 00       	call   801fdb <pageref>
  800c42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c45:	89 34 24             	mov    %esi,(%esp)
  800c48:	e8 8e 13 00 00       	call   801fdb <pageref>
		nn = thisenv->env_runs;
  800c4d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800c53:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800c56:	83 c4 10             	add    $0x10,%esp
  800c59:	39 cb                	cmp    %ecx,%ebx
  800c5b:	74 1b                	je     800c78 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800c5d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c60:	75 cf                	jne    800c31 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800c62:	8b 42 58             	mov    0x58(%edx),%eax
  800c65:	6a 01                	push   $0x1
  800c67:	50                   	push   %eax
  800c68:	53                   	push   %ebx
  800c69:	68 8e 23 80 00       	push   $0x80238e
  800c6e:	e8 3e 09 00 00       	call   8015b1 <cprintf>
  800c73:	83 c4 10             	add    $0x10,%esp
  800c76:	eb b9                	jmp    800c31 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c78:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c7b:	0f 94 c0             	sete   %al
  800c7e:	0f b6 c0             	movzbl %al,%eax
}
  800c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <devpipe_write>:
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 28             	sub    $0x28,%esp
  800c92:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c95:	56                   	push   %esi
  800c96:	e8 e8 f6 ff ff       	call   800383 <fd2data>
  800c9b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c9d:	83 c4 10             	add    $0x10,%esp
  800ca0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ca8:	74 4f                	je     800cf9 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800caa:	8b 43 04             	mov    0x4(%ebx),%eax
  800cad:	8b 0b                	mov    (%ebx),%ecx
  800caf:	8d 51 20             	lea    0x20(%ecx),%edx
  800cb2:	39 d0                	cmp    %edx,%eax
  800cb4:	72 14                	jb     800cca <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800cb6:	89 da                	mov    %ebx,%edx
  800cb8:	89 f0                	mov    %esi,%eax
  800cba:	e8 65 ff ff ff       	call   800c24 <_pipeisclosed>
  800cbf:	85 c0                	test   %eax,%eax
  800cc1:	75 3b                	jne    800cfe <devpipe_write+0x75>
			sys_yield();
  800cc3:	e8 7c f4 ff ff       	call   800144 <sys_yield>
  800cc8:	eb e0                	jmp    800caa <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800cca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800cd1:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	c1 fa 1f             	sar    $0x1f,%edx
  800cd9:	89 d1                	mov    %edx,%ecx
  800cdb:	c1 e9 1b             	shr    $0x1b,%ecx
  800cde:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800ce1:	83 e2 1f             	and    $0x1f,%edx
  800ce4:	29 ca                	sub    %ecx,%edx
  800ce6:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800cea:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800cee:	83 c0 01             	add    $0x1,%eax
  800cf1:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800cf4:	83 c7 01             	add    $0x1,%edi
  800cf7:	eb ac                	jmp    800ca5 <devpipe_write+0x1c>
	return i;
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	eb 05                	jmp    800d03 <devpipe_write+0x7a>
				return 0;
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <devpipe_read>:
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 18             	sub    $0x18,%esp
  800d14:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d17:	57                   	push   %edi
  800d18:	e8 66 f6 ff ff       	call   800383 <fd2data>
  800d1d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	be 00 00 00 00       	mov    $0x0,%esi
  800d27:	3b 75 10             	cmp    0x10(%ebp),%esi
  800d2a:	75 14                	jne    800d40 <devpipe_read+0x35>
	return i;
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	eb 02                	jmp    800d33 <devpipe_read+0x28>
				return i;
  800d31:	89 f0                	mov    %esi,%eax
}
  800d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    
			sys_yield();
  800d3b:	e8 04 f4 ff ff       	call   800144 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  800d40:	8b 03                	mov    (%ebx),%eax
  800d42:	3b 43 04             	cmp    0x4(%ebx),%eax
  800d45:	75 18                	jne    800d5f <devpipe_read+0x54>
			if (i > 0)
  800d47:	85 f6                	test   %esi,%esi
  800d49:	75 e6                	jne    800d31 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  800d4b:	89 da                	mov    %ebx,%edx
  800d4d:	89 f8                	mov    %edi,%eax
  800d4f:	e8 d0 fe ff ff       	call   800c24 <_pipeisclosed>
  800d54:	85 c0                	test   %eax,%eax
  800d56:	74 e3                	je     800d3b <devpipe_read+0x30>
				return 0;
  800d58:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5d:	eb d4                	jmp    800d33 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800d5f:	99                   	cltd   
  800d60:	c1 ea 1b             	shr    $0x1b,%edx
  800d63:	01 d0                	add    %edx,%eax
  800d65:	83 e0 1f             	and    $0x1f,%eax
  800d68:	29 d0                	sub    %edx,%eax
  800d6a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d72:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800d75:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800d78:	83 c6 01             	add    $0x1,%esi
  800d7b:	eb aa                	jmp    800d27 <devpipe_read+0x1c>

00800d7d <pipe>:
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d88:	50                   	push   %eax
  800d89:	e8 0c f6 ff ff       	call   80039a <fd_alloc>
  800d8e:	89 c3                	mov    %eax,%ebx
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	85 c0                	test   %eax,%eax
  800d95:	0f 88 23 01 00 00    	js     800ebe <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d9b:	83 ec 04             	sub    $0x4,%esp
  800d9e:	68 07 04 00 00       	push   $0x407
  800da3:	ff 75 f4             	pushl  -0xc(%ebp)
  800da6:	6a 00                	push   $0x0
  800da8:	e8 b6 f3 ff ff       	call   800163 <sys_page_alloc>
  800dad:	89 c3                	mov    %eax,%ebx
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	85 c0                	test   %eax,%eax
  800db4:	0f 88 04 01 00 00    	js     800ebe <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dc0:	50                   	push   %eax
  800dc1:	e8 d4 f5 ff ff       	call   80039a <fd_alloc>
  800dc6:	89 c3                	mov    %eax,%ebx
  800dc8:	83 c4 10             	add    $0x10,%esp
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	0f 88 db 00 00 00    	js     800eae <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dd3:	83 ec 04             	sub    $0x4,%esp
  800dd6:	68 07 04 00 00       	push   $0x407
  800ddb:	ff 75 f0             	pushl  -0x10(%ebp)
  800dde:	6a 00                	push   $0x0
  800de0:	e8 7e f3 ff ff       	call   800163 <sys_page_alloc>
  800de5:	89 c3                	mov    %eax,%ebx
  800de7:	83 c4 10             	add    $0x10,%esp
  800dea:	85 c0                	test   %eax,%eax
  800dec:	0f 88 bc 00 00 00    	js     800eae <pipe+0x131>
	va = fd2data(fd0);
  800df2:	83 ec 0c             	sub    $0xc,%esp
  800df5:	ff 75 f4             	pushl  -0xc(%ebp)
  800df8:	e8 86 f5 ff ff       	call   800383 <fd2data>
  800dfd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800dff:	83 c4 0c             	add    $0xc,%esp
  800e02:	68 07 04 00 00       	push   $0x407
  800e07:	50                   	push   %eax
  800e08:	6a 00                	push   $0x0
  800e0a:	e8 54 f3 ff ff       	call   800163 <sys_page_alloc>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	0f 88 82 00 00 00    	js     800e9e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e22:	e8 5c f5 ff ff       	call   800383 <fd2data>
  800e27:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e2e:	50                   	push   %eax
  800e2f:	6a 00                	push   $0x0
  800e31:	56                   	push   %esi
  800e32:	6a 00                	push   $0x0
  800e34:	e8 6d f3 ff ff       	call   8001a6 <sys_page_map>
  800e39:	89 c3                	mov    %eax,%ebx
  800e3b:	83 c4 20             	add    $0x20,%esp
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	78 4e                	js     800e90 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  800e42:	a1 20 30 80 00       	mov    0x803020,%eax
  800e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  800e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  800e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e59:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  800e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6b:	e8 03 f5 ff ff       	call   800373 <fd2num>
  800e70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e73:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e75:	83 c4 04             	add    $0x4,%esp
  800e78:	ff 75 f0             	pushl  -0x10(%ebp)
  800e7b:	e8 f3 f4 ff ff       	call   800373 <fd2num>
  800e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e83:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e86:	83 c4 10             	add    $0x10,%esp
  800e89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8e:	eb 2e                	jmp    800ebe <pipe+0x141>
	sys_page_unmap(0, va);
  800e90:	83 ec 08             	sub    $0x8,%esp
  800e93:	56                   	push   %esi
  800e94:	6a 00                	push   $0x0
  800e96:	e8 4d f3 ff ff       	call   8001e8 <sys_page_unmap>
  800e9b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea4:	6a 00                	push   $0x0
  800ea6:	e8 3d f3 ff ff       	call   8001e8 <sys_page_unmap>
  800eab:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb4:	6a 00                	push   $0x0
  800eb6:	e8 2d f3 ff ff       	call   8001e8 <sys_page_unmap>
  800ebb:	83 c4 10             	add    $0x10,%esp
}
  800ebe:	89 d8                	mov    %ebx,%eax
  800ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <pipeisclosed>:
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ecd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ed0:	50                   	push   %eax
  800ed1:	ff 75 08             	pushl  0x8(%ebp)
  800ed4:	e8 13 f5 ff ff       	call   8003ec <fd_lookup>
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	85 c0                	test   %eax,%eax
  800ede:	78 18                	js     800ef8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee6:	e8 98 f4 ff ff       	call   800383 <fd2data>
	return _pipeisclosed(fd, p);
  800eeb:	89 c2                	mov    %eax,%edx
  800eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef0:	e8 2f fd ff ff       	call   800c24 <_pipeisclosed>
  800ef5:	83 c4 10             	add    $0x10,%esp
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800f00:	68 a6 23 80 00       	push   $0x8023a6
  800f05:	ff 75 0c             	pushl  0xc(%ebp)
  800f08:	e8 80 0c 00 00       	call   801b8d <strcpy>
	return 0;
}
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <devsock_close>:
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	53                   	push   %ebx
  800f18:	83 ec 10             	sub    $0x10,%esp
  800f1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800f1e:	53                   	push   %ebx
  800f1f:	e8 b7 10 00 00       	call   801fdb <pageref>
  800f24:	83 c4 10             	add    $0x10,%esp
		return 0;
  800f27:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  800f2c:	83 f8 01             	cmp    $0x1,%eax
  800f2f:	74 07                	je     800f38 <devsock_close+0x24>
}
  800f31:	89 d0                	mov    %edx,%eax
  800f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	ff 73 0c             	pushl  0xc(%ebx)
  800f3e:	e8 b9 02 00 00       	call   8011fc <nsipc_close>
  800f43:	89 c2                	mov    %eax,%edx
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	eb e7                	jmp    800f31 <devsock_close+0x1d>

00800f4a <devsock_write>:
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800f50:	6a 00                	push   $0x0
  800f52:	ff 75 10             	pushl  0x10(%ebp)
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	ff 70 0c             	pushl  0xc(%eax)
  800f5e:	e8 76 03 00 00       	call   8012d9 <nsipc_send>
}
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <devsock_read>:
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f6b:	6a 00                	push   $0x0
  800f6d:	ff 75 10             	pushl  0x10(%ebp)
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff 70 0c             	pushl  0xc(%eax)
  800f79:	e8 ef 02 00 00       	call   80126d <nsipc_recv>
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <fd2sockid>:
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800f86:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f89:	52                   	push   %edx
  800f8a:	50                   	push   %eax
  800f8b:	e8 5c f4 ff ff       	call   8003ec <fd_lookup>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	85 c0                	test   %eax,%eax
  800f95:	78 10                	js     800fa7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9a:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  800fa0:	39 08                	cmp    %ecx,(%eax)
  800fa2:	75 05                	jne    800fa9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800fa4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    
		return -E_NOT_SUPP;
  800fa9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fae:	eb f7                	jmp    800fa7 <fd2sockid+0x27>

00800fb0 <alloc_sockfd>:
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	83 ec 1c             	sub    $0x1c,%esp
  800fb8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800fba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fbd:	50                   	push   %eax
  800fbe:	e8 d7 f3 ff ff       	call   80039a <fd_alloc>
  800fc3:	89 c3                	mov    %eax,%ebx
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	78 43                	js     80100f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	68 07 04 00 00       	push   $0x407
  800fd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 85 f1 ff ff       	call   800163 <sys_page_alloc>
  800fde:	89 c3                	mov    %eax,%ebx
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	78 28                	js     80100f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fea:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800ff0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800ffc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	50                   	push   %eax
  801003:	e8 6b f3 ff ff       	call   800373 <fd2num>
  801008:	89 c3                	mov    %eax,%ebx
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	eb 0c                	jmp    80101b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	56                   	push   %esi
  801013:	e8 e4 01 00 00       	call   8011fc <nsipc_close>
		return r;
  801018:	83 c4 10             	add    $0x10,%esp
}
  80101b:	89 d8                	mov    %ebx,%eax
  80101d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    

00801024 <accept>:
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	e8 4e ff ff ff       	call   800f80 <fd2sockid>
  801032:	85 c0                	test   %eax,%eax
  801034:	78 1b                	js     801051 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801036:	83 ec 04             	sub    $0x4,%esp
  801039:	ff 75 10             	pushl  0x10(%ebp)
  80103c:	ff 75 0c             	pushl  0xc(%ebp)
  80103f:	50                   	push   %eax
  801040:	e8 0e 01 00 00       	call   801153 <nsipc_accept>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	85 c0                	test   %eax,%eax
  80104a:	78 05                	js     801051 <accept+0x2d>
	return alloc_sockfd(r);
  80104c:	e8 5f ff ff ff       	call   800fb0 <alloc_sockfd>
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <bind>:
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	e8 1f ff ff ff       	call   800f80 <fd2sockid>
  801061:	85 c0                	test   %eax,%eax
  801063:	78 12                	js     801077 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801065:	83 ec 04             	sub    $0x4,%esp
  801068:	ff 75 10             	pushl  0x10(%ebp)
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	50                   	push   %eax
  80106f:	e8 31 01 00 00       	call   8011a5 <nsipc_bind>
  801074:	83 c4 10             	add    $0x10,%esp
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <shutdown>:
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	e8 f9 fe ff ff       	call   800f80 <fd2sockid>
  801087:	85 c0                	test   %eax,%eax
  801089:	78 0f                	js     80109a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	50                   	push   %eax
  801092:	e8 43 01 00 00       	call   8011da <nsipc_shutdown>
  801097:	83 c4 10             	add    $0x10,%esp
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <connect>:
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	e8 d6 fe ff ff       	call   800f80 <fd2sockid>
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	78 12                	js     8010c0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8010ae:	83 ec 04             	sub    $0x4,%esp
  8010b1:	ff 75 10             	pushl  0x10(%ebp)
  8010b4:	ff 75 0c             	pushl  0xc(%ebp)
  8010b7:	50                   	push   %eax
  8010b8:	e8 59 01 00 00       	call   801216 <nsipc_connect>
  8010bd:	83 c4 10             	add    $0x10,%esp
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <listen>:
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	e8 b0 fe ff ff       	call   800f80 <fd2sockid>
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	78 0f                	js     8010e3 <listen+0x21>
	return nsipc_listen(r, backlog);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	50                   	push   %eax
  8010db:	e8 6b 01 00 00       	call   80124b <nsipc_listen>
  8010e0:	83 c4 10             	add    $0x10,%esp
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8010eb:	ff 75 10             	pushl  0x10(%ebp)
  8010ee:	ff 75 0c             	pushl  0xc(%ebp)
  8010f1:	ff 75 08             	pushl  0x8(%ebp)
  8010f4:	e8 3e 02 00 00       	call   801337 <nsipc_socket>
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	78 05                	js     801105 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801100:	e8 ab fe ff ff       	call   800fb0 <alloc_sockfd>
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	53                   	push   %ebx
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801110:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801117:	74 26                	je     80113f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801119:	6a 07                	push   $0x7
  80111b:	68 00 60 80 00       	push   $0x806000
  801120:	53                   	push   %ebx
  801121:	ff 35 04 40 80 00    	pushl  0x804004
  801127:	e8 0a 0e 00 00       	call   801f36 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80112c:	83 c4 0c             	add    $0xc,%esp
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	6a 00                	push   $0x0
  801135:	e8 89 0d 00 00       	call   801ec3 <ipc_recv>
}
  80113a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	6a 02                	push   $0x2
  801144:	e8 59 0e 00 00       	call   801fa2 <ipc_find_env>
  801149:	a3 04 40 80 00       	mov    %eax,0x804004
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	eb c6                	jmp    801119 <nsipc+0x12>

00801153 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801163:	8b 06                	mov    (%esi),%eax
  801165:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80116a:	b8 01 00 00 00       	mov    $0x1,%eax
  80116f:	e8 93 ff ff ff       	call   801107 <nsipc>
  801174:	89 c3                	mov    %eax,%ebx
  801176:	85 c0                	test   %eax,%eax
  801178:	79 09                	jns    801183 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80117a:	89 d8                	mov    %ebx,%eax
  80117c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801183:	83 ec 04             	sub    $0x4,%esp
  801186:	ff 35 10 60 80 00    	pushl  0x806010
  80118c:	68 00 60 80 00       	push   $0x806000
  801191:	ff 75 0c             	pushl  0xc(%ebp)
  801194:	e8 82 0b 00 00       	call   801d1b <memmove>
		*addrlen = ret->ret_addrlen;
  801199:	a1 10 60 80 00       	mov    0x806010,%eax
  80119e:	89 06                	mov    %eax,(%esi)
  8011a0:	83 c4 10             	add    $0x10,%esp
	return r;
  8011a3:	eb d5                	jmp    80117a <nsipc_accept+0x27>

008011a5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8011b7:	53                   	push   %ebx
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	68 04 60 80 00       	push   $0x806004
  8011c0:	e8 56 0b 00 00       	call   801d1b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8011c5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8011cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8011d0:	e8 32 ff ff ff       	call   801107 <nsipc>
}
  8011d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8011f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f5:	e8 0d ff ff ff       	call   801107 <nsipc>
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <nsipc_close>:

int
nsipc_close(int s)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80120a:	b8 04 00 00 00       	mov    $0x4,%eax
  80120f:	e8 f3 fe ff ff       	call   801107 <nsipc>
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	53                   	push   %ebx
  80121a:	83 ec 08             	sub    $0x8,%esp
  80121d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801228:	53                   	push   %ebx
  801229:	ff 75 0c             	pushl  0xc(%ebp)
  80122c:	68 04 60 80 00       	push   $0x806004
  801231:	e8 e5 0a 00 00       	call   801d1b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801236:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80123c:	b8 05 00 00 00       	mov    $0x5,%eax
  801241:	e8 c1 fe ff ff       	call   801107 <nsipc>
}
  801246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801261:	b8 06 00 00 00       	mov    $0x6,%eax
  801266:	e8 9c fe ff ff       	call   801107 <nsipc>
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	56                   	push   %esi
  801271:	53                   	push   %ebx
  801272:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80127d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801283:	8b 45 14             	mov    0x14(%ebp),%eax
  801286:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80128b:	b8 07 00 00 00       	mov    $0x7,%eax
  801290:	e8 72 fe ff ff       	call   801107 <nsipc>
  801295:	89 c3                	mov    %eax,%ebx
  801297:	85 c0                	test   %eax,%eax
  801299:	78 1f                	js     8012ba <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80129b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8012a0:	7f 21                	jg     8012c3 <nsipc_recv+0x56>
  8012a2:	39 c6                	cmp    %eax,%esi
  8012a4:	7c 1d                	jl     8012c3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	50                   	push   %eax
  8012aa:	68 00 60 80 00       	push   $0x806000
  8012af:	ff 75 0c             	pushl  0xc(%ebp)
  8012b2:	e8 64 0a 00 00       	call   801d1b <memmove>
  8012b7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5e                   	pop    %esi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8012c3:	68 b2 23 80 00       	push   $0x8023b2
  8012c8:	68 54 23 80 00       	push   $0x802354
  8012cd:	6a 62                	push   $0x62
  8012cf:	68 c7 23 80 00       	push   $0x8023c7
  8012d4:	e8 fd 01 00 00       	call   8014d6 <_panic>

008012d9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8012eb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8012f1:	7f 2e                	jg     801321 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8012f3:	83 ec 04             	sub    $0x4,%esp
  8012f6:	53                   	push   %ebx
  8012f7:	ff 75 0c             	pushl  0xc(%ebp)
  8012fa:	68 0c 60 80 00       	push   $0x80600c
  8012ff:	e8 17 0a 00 00       	call   801d1b <memmove>
	nsipcbuf.send.req_size = size;
  801304:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801312:	b8 08 00 00 00       	mov    $0x8,%eax
  801317:	e8 eb fd ff ff       	call   801107 <nsipc>
}
  80131c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131f:	c9                   	leave  
  801320:	c3                   	ret    
	assert(size < 1600);
  801321:	68 d3 23 80 00       	push   $0x8023d3
  801326:	68 54 23 80 00       	push   $0x802354
  80132b:	6a 6d                	push   $0x6d
  80132d:	68 c7 23 80 00       	push   $0x8023c7
  801332:	e8 9f 01 00 00       	call   8014d6 <_panic>

00801337 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801355:	b8 09 00 00 00       	mov    $0x9,%eax
  80135a:	e8 a8 fd ff ff       	call   801107 <nsipc>
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801361:	b8 00 00 00 00       	mov    $0x0,%eax
  801366:	c3                   	ret    

00801367 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80136d:	68 df 23 80 00       	push   $0x8023df
  801372:	ff 75 0c             	pushl  0xc(%ebp)
  801375:	e8 13 08 00 00       	call   801b8d <strcpy>
	return 0;
}
  80137a:	b8 00 00 00 00       	mov    $0x0,%eax
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <devcons_write>:
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	57                   	push   %edi
  801385:	56                   	push   %esi
  801386:	53                   	push   %ebx
  801387:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80138d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801392:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801398:	3b 75 10             	cmp    0x10(%ebp),%esi
  80139b:	73 31                	jae    8013ce <devcons_write+0x4d>
		m = n - tot;
  80139d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013a0:	29 f3                	sub    %esi,%ebx
  8013a2:	83 fb 7f             	cmp    $0x7f,%ebx
  8013a5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8013aa:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	53                   	push   %ebx
  8013b1:	89 f0                	mov    %esi,%eax
  8013b3:	03 45 0c             	add    0xc(%ebp),%eax
  8013b6:	50                   	push   %eax
  8013b7:	57                   	push   %edi
  8013b8:	e8 5e 09 00 00       	call   801d1b <memmove>
		sys_cputs(buf, m);
  8013bd:	83 c4 08             	add    $0x8,%esp
  8013c0:	53                   	push   %ebx
  8013c1:	57                   	push   %edi
  8013c2:	e8 e0 ec ff ff       	call   8000a7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8013c7:	01 de                	add    %ebx,%esi
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	eb ca                	jmp    801398 <devcons_write+0x17>
}
  8013ce:	89 f0                	mov    %esi,%eax
  8013d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d3:	5b                   	pop    %ebx
  8013d4:	5e                   	pop    %esi
  8013d5:	5f                   	pop    %edi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <devcons_read>:
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8013e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e7:	74 21                	je     80140a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8013e9:	e8 d7 ec ff ff       	call   8000c5 <sys_cgetc>
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 07                	jne    8013f9 <devcons_read+0x21>
		sys_yield();
  8013f2:	e8 4d ed ff ff       	call   800144 <sys_yield>
  8013f7:	eb f0                	jmp    8013e9 <devcons_read+0x11>
	if (c < 0)
  8013f9:	78 0f                	js     80140a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8013fb:	83 f8 04             	cmp    $0x4,%eax
  8013fe:	74 0c                	je     80140c <devcons_read+0x34>
	*(char*)vbuf = c;
  801400:	8b 55 0c             	mov    0xc(%ebp),%edx
  801403:	88 02                	mov    %al,(%edx)
	return 1;
  801405:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    
		return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	eb f7                	jmp    80140a <devcons_read+0x32>

00801413 <cputchar>:
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80141f:	6a 01                	push   $0x1
  801421:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	e8 7d ec ff ff       	call   8000a7 <sys_cputs>
}
  80142a:	83 c4 10             	add    $0x10,%esp
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    

0080142f <getchar>:
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801435:	6a 01                	push   $0x1
  801437:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	6a 00                	push   $0x0
  80143d:	e8 1a f2 ff ff       	call   80065c <read>
	if (r < 0)
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 06                	js     80144f <getchar+0x20>
	if (r < 1)
  801449:	74 06                	je     801451 <getchar+0x22>
	return c;
  80144b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80144f:	c9                   	leave  
  801450:	c3                   	ret    
		return -E_EOF;
  801451:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801456:	eb f7                	jmp    80144f <getchar+0x20>

00801458 <iscons>:
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801461:	50                   	push   %eax
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	e8 82 ef ff ff       	call   8003ec <fd_lookup>
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 11                	js     801482 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801474:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80147a:	39 10                	cmp    %edx,(%eax)
  80147c:	0f 94 c0             	sete   %al
  80147f:	0f b6 c0             	movzbl %al,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <opencons>:
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80148a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	e8 07 ef ff ff       	call   80039a <fd_alloc>
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	78 3a                	js     8014d4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	68 07 04 00 00       	push   $0x407
  8014a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a5:	6a 00                	push   $0x0
  8014a7:	e8 b7 ec ff ff       	call   800163 <sys_page_alloc>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 21                	js     8014d4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8014b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8014bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8014c8:	83 ec 0c             	sub    $0xc,%esp
  8014cb:	50                   	push   %eax
  8014cc:	e8 a2 ee ff ff       	call   800373 <fd2num>
  8014d1:	83 c4 10             	add    $0x10,%esp
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8014db:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8014de:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8014e4:	e8 3c ec ff ff       	call   800125 <sys_getenvid>
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	ff 75 08             	pushl  0x8(%ebp)
  8014f2:	56                   	push   %esi
  8014f3:	50                   	push   %eax
  8014f4:	68 ec 23 80 00       	push   $0x8023ec
  8014f9:	e8 b3 00 00 00       	call   8015b1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8014fe:	83 c4 18             	add    $0x18,%esp
  801501:	53                   	push   %ebx
  801502:	ff 75 10             	pushl  0x10(%ebp)
  801505:	e8 56 00 00 00       	call   801560 <vcprintf>
	cprintf("\n");
  80150a:	c7 04 24 9f 23 80 00 	movl   $0x80239f,(%esp)
  801511:	e8 9b 00 00 00       	call   8015b1 <cprintf>
  801516:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801519:	cc                   	int3   
  80151a:	eb fd                	jmp    801519 <_panic+0x43>

0080151c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	53                   	push   %ebx
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801526:	8b 13                	mov    (%ebx),%edx
  801528:	8d 42 01             	lea    0x1(%edx),%eax
  80152b:	89 03                	mov    %eax,(%ebx)
  80152d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801530:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801534:	3d ff 00 00 00       	cmp    $0xff,%eax
  801539:	74 09                	je     801544 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80153b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80153f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801542:	c9                   	leave  
  801543:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	68 ff 00 00 00       	push   $0xff
  80154c:	8d 43 08             	lea    0x8(%ebx),%eax
  80154f:	50                   	push   %eax
  801550:	e8 52 eb ff ff       	call   8000a7 <sys_cputs>
		b->idx = 0;
  801555:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	eb db                	jmp    80153b <putch+0x1f>

00801560 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801569:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801570:	00 00 00 
	b.cnt = 0;
  801573:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80157a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801589:	50                   	push   %eax
  80158a:	68 1c 15 80 00       	push   $0x80151c
  80158f:	e8 19 01 00 00       	call   8016ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801594:	83 c4 08             	add    $0x8,%esp
  801597:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80159d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	e8 fe ea ff ff       	call   8000a7 <sys_cputs>

	return b.cnt;
}
  8015a9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8015b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 9d ff ff ff       	call   801560 <vcprintf>
	va_end(ap);

	return cnt;
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	57                   	push   %edi
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 1c             	sub    $0x1c,%esp
  8015ce:	89 c7                	mov    %eax,%edi
  8015d0:	89 d6                	mov    %edx,%esi
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015db:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8015e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8015ec:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015ef:	89 d0                	mov    %edx,%eax
  8015f1:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  8015f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015f7:	73 15                	jae    80160e <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015f9:	83 eb 01             	sub    $0x1,%ebx
  8015fc:	85 db                	test   %ebx,%ebx
  8015fe:	7e 43                	jle    801643 <printnum+0x7e>
			putch(padc, putdat);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	56                   	push   %esi
  801604:	ff 75 18             	pushl  0x18(%ebp)
  801607:	ff d7                	call   *%edi
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	eb eb                	jmp    8015f9 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	ff 75 18             	pushl  0x18(%ebp)
  801614:	8b 45 14             	mov    0x14(%ebp),%eax
  801617:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80161a:	53                   	push   %ebx
  80161b:	ff 75 10             	pushl  0x10(%ebp)
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	ff 75 e4             	pushl  -0x1c(%ebp)
  801624:	ff 75 e0             	pushl  -0x20(%ebp)
  801627:	ff 75 dc             	pushl  -0x24(%ebp)
  80162a:	ff 75 d8             	pushl  -0x28(%ebp)
  80162d:	e8 ee 09 00 00       	call   802020 <__udivdi3>
  801632:	83 c4 18             	add    $0x18,%esp
  801635:	52                   	push   %edx
  801636:	50                   	push   %eax
  801637:	89 f2                	mov    %esi,%edx
  801639:	89 f8                	mov    %edi,%eax
  80163b:	e8 85 ff ff ff       	call   8015c5 <printnum>
  801640:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801643:	83 ec 08             	sub    $0x8,%esp
  801646:	56                   	push   %esi
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80164d:	ff 75 e0             	pushl  -0x20(%ebp)
  801650:	ff 75 dc             	pushl  -0x24(%ebp)
  801653:	ff 75 d8             	pushl  -0x28(%ebp)
  801656:	e8 d5 0a 00 00       	call   802130 <__umoddi3>
  80165b:	83 c4 14             	add    $0x14,%esp
  80165e:	0f be 80 0f 24 80 00 	movsbl 0x80240f(%eax),%eax
  801665:	50                   	push   %eax
  801666:	ff d7                	call   *%edi
}
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166e:	5b                   	pop    %ebx
  80166f:	5e                   	pop    %esi
  801670:	5f                   	pop    %edi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801679:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80167d:	8b 10                	mov    (%eax),%edx
  80167f:	3b 50 04             	cmp    0x4(%eax),%edx
  801682:	73 0a                	jae    80168e <sprintputch+0x1b>
		*b->buf++ = ch;
  801684:	8d 4a 01             	lea    0x1(%edx),%ecx
  801687:	89 08                	mov    %ecx,(%eax)
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	88 02                	mov    %al,(%edx)
}
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <printfmt>:
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801696:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801699:	50                   	push   %eax
  80169a:	ff 75 10             	pushl  0x10(%ebp)
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	e8 05 00 00 00       	call   8016ad <vprintfmt>
}
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <vprintfmt>:
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	57                   	push   %edi
  8016b1:	56                   	push   %esi
  8016b2:	53                   	push   %ebx
  8016b3:	83 ec 3c             	sub    $0x3c,%esp
  8016b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8016bf:	eb 0a                	jmp    8016cb <vprintfmt+0x1e>
			putch(ch, putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	53                   	push   %ebx
  8016c5:	50                   	push   %eax
  8016c6:	ff d6                	call   *%esi
  8016c8:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016cb:	83 c7 01             	add    $0x1,%edi
  8016ce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016d2:	83 f8 25             	cmp    $0x25,%eax
  8016d5:	74 0c                	je     8016e3 <vprintfmt+0x36>
			if (ch == '\0')
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	75 e6                	jne    8016c1 <vprintfmt+0x14>
}
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
		padc = ' ';
  8016e3:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8016e7:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8016ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8016f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801701:	8d 47 01             	lea    0x1(%edi),%eax
  801704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801707:	0f b6 17             	movzbl (%edi),%edx
  80170a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80170d:	3c 55                	cmp    $0x55,%al
  80170f:	0f 87 ba 03 00 00    	ja     801acf <vprintfmt+0x422>
  801715:	0f b6 c0             	movzbl %al,%eax
  801718:	ff 24 85 60 25 80 00 	jmp    *0x802560(,%eax,4)
  80171f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801722:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801726:	eb d9                	jmp    801701 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801728:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80172b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80172f:	eb d0                	jmp    801701 <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801731:	0f b6 d2             	movzbl %dl,%edx
  801734:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80173f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801742:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801746:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801749:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80174c:	83 f9 09             	cmp    $0x9,%ecx
  80174f:	77 55                	ja     8017a6 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801751:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801754:	eb e9                	jmp    80173f <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801756:	8b 45 14             	mov    0x14(%ebp),%eax
  801759:	8b 00                	mov    (%eax),%eax
  80175b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80175e:	8b 45 14             	mov    0x14(%ebp),%eax
  801761:	8d 40 04             	lea    0x4(%eax),%eax
  801764:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801767:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80176a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80176e:	79 91                	jns    801701 <vprintfmt+0x54>
				width = precision, precision = -1;
  801770:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801773:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801776:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80177d:	eb 82                	jmp    801701 <vprintfmt+0x54>
  80177f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801782:	85 c0                	test   %eax,%eax
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	0f 49 d0             	cmovns %eax,%edx
  80178c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80178f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801792:	e9 6a ff ff ff       	jmp    801701 <vprintfmt+0x54>
  801797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80179a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8017a1:	e9 5b ff ff ff       	jmp    801701 <vprintfmt+0x54>
  8017a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8017a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017ac:	eb bc                	jmp    80176a <vprintfmt+0xbd>
			lflag++;
  8017ae:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8017b4:	e9 48 ff ff ff       	jmp    801701 <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  8017b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bc:	8d 78 04             	lea    0x4(%eax),%edi
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	53                   	push   %ebx
  8017c3:	ff 30                	pushl  (%eax)
  8017c5:	ff d6                	call   *%esi
			break;
  8017c7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8017ca:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8017cd:	e9 9c 02 00 00       	jmp    801a6e <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  8017d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8017d5:	8d 78 04             	lea    0x4(%eax),%edi
  8017d8:	8b 00                	mov    (%eax),%eax
  8017da:	99                   	cltd   
  8017db:	31 d0                	xor    %edx,%eax
  8017dd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8017df:	83 f8 0f             	cmp    $0xf,%eax
  8017e2:	7f 23                	jg     801807 <vprintfmt+0x15a>
  8017e4:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  8017eb:	85 d2                	test   %edx,%edx
  8017ed:	74 18                	je     801807 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  8017ef:	52                   	push   %edx
  8017f0:	68 66 23 80 00       	push   $0x802366
  8017f5:	53                   	push   %ebx
  8017f6:	56                   	push   %esi
  8017f7:	e8 94 fe ff ff       	call   801690 <printfmt>
  8017fc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8017ff:	89 7d 14             	mov    %edi,0x14(%ebp)
  801802:	e9 67 02 00 00       	jmp    801a6e <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  801807:	50                   	push   %eax
  801808:	68 27 24 80 00       	push   $0x802427
  80180d:	53                   	push   %ebx
  80180e:	56                   	push   %esi
  80180f:	e8 7c fe ff ff       	call   801690 <printfmt>
  801814:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801817:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80181a:	e9 4f 02 00 00       	jmp    801a6e <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  80181f:	8b 45 14             	mov    0x14(%ebp),%eax
  801822:	83 c0 04             	add    $0x4,%eax
  801825:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801828:	8b 45 14             	mov    0x14(%ebp),%eax
  80182b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80182d:	85 d2                	test   %edx,%edx
  80182f:	b8 20 24 80 00       	mov    $0x802420,%eax
  801834:	0f 45 c2             	cmovne %edx,%eax
  801837:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80183a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183e:	7e 06                	jle    801846 <vprintfmt+0x199>
  801840:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801844:	75 0d                	jne    801853 <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801846:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801849:	89 c7                	mov    %eax,%edi
  80184b:	03 45 e0             	add    -0x20(%ebp),%eax
  80184e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801851:	eb 3f                	jmp    801892 <vprintfmt+0x1e5>
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	ff 75 d8             	pushl  -0x28(%ebp)
  801859:	50                   	push   %eax
  80185a:	e8 0d 03 00 00       	call   801b6c <strnlen>
  80185f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801862:	29 c2                	sub    %eax,%edx
  801864:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80186c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801870:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801873:	85 ff                	test   %edi,%edi
  801875:	7e 58                	jle    8018cf <vprintfmt+0x222>
					putch(padc, putdat);
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	53                   	push   %ebx
  80187b:	ff 75 e0             	pushl  -0x20(%ebp)
  80187e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801880:	83 ef 01             	sub    $0x1,%edi
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	eb eb                	jmp    801873 <vprintfmt+0x1c6>
					putch(ch, putdat);
  801888:	83 ec 08             	sub    $0x8,%esp
  80188b:	53                   	push   %ebx
  80188c:	52                   	push   %edx
  80188d:	ff d6                	call   *%esi
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801895:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801897:	83 c7 01             	add    $0x1,%edi
  80189a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80189e:	0f be d0             	movsbl %al,%edx
  8018a1:	85 d2                	test   %edx,%edx
  8018a3:	74 45                	je     8018ea <vprintfmt+0x23d>
  8018a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018a9:	78 06                	js     8018b1 <vprintfmt+0x204>
  8018ab:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8018af:	78 35                	js     8018e6 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  8018b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8018b5:	74 d1                	je     801888 <vprintfmt+0x1db>
  8018b7:	0f be c0             	movsbl %al,%eax
  8018ba:	83 e8 20             	sub    $0x20,%eax
  8018bd:	83 f8 5e             	cmp    $0x5e,%eax
  8018c0:	76 c6                	jbe    801888 <vprintfmt+0x1db>
					putch('?', putdat);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	53                   	push   %ebx
  8018c6:	6a 3f                	push   $0x3f
  8018c8:	ff d6                	call   *%esi
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	eb c3                	jmp    801892 <vprintfmt+0x1e5>
  8018cf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8018d2:	85 d2                	test   %edx,%edx
  8018d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d9:	0f 49 c2             	cmovns %edx,%eax
  8018dc:	29 c2                	sub    %eax,%edx
  8018de:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8018e1:	e9 60 ff ff ff       	jmp    801846 <vprintfmt+0x199>
  8018e6:	89 cf                	mov    %ecx,%edi
  8018e8:	eb 02                	jmp    8018ec <vprintfmt+0x23f>
  8018ea:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  8018ec:	85 ff                	test   %edi,%edi
  8018ee:	7e 10                	jle    801900 <vprintfmt+0x253>
				putch(' ', putdat);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	53                   	push   %ebx
  8018f4:	6a 20                	push   $0x20
  8018f6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8018f8:	83 ef 01             	sub    $0x1,%edi
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	eb ec                	jmp    8018ec <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  801900:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801903:	89 45 14             	mov    %eax,0x14(%ebp)
  801906:	e9 63 01 00 00       	jmp    801a6e <vprintfmt+0x3c1>
	if (lflag >= 2)
  80190b:	83 f9 01             	cmp    $0x1,%ecx
  80190e:	7f 1b                	jg     80192b <vprintfmt+0x27e>
	else if (lflag)
  801910:	85 c9                	test   %ecx,%ecx
  801912:	74 63                	je     801977 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801914:	8b 45 14             	mov    0x14(%ebp),%eax
  801917:	8b 00                	mov    (%eax),%eax
  801919:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80191c:	99                   	cltd   
  80191d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801920:	8b 45 14             	mov    0x14(%ebp),%eax
  801923:	8d 40 04             	lea    0x4(%eax),%eax
  801926:	89 45 14             	mov    %eax,0x14(%ebp)
  801929:	eb 17                	jmp    801942 <vprintfmt+0x295>
		return va_arg(*ap, long long);
  80192b:	8b 45 14             	mov    0x14(%ebp),%eax
  80192e:	8b 50 04             	mov    0x4(%eax),%edx
  801931:	8b 00                	mov    (%eax),%eax
  801933:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801936:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801939:	8b 45 14             	mov    0x14(%ebp),%eax
  80193c:	8d 40 08             	lea    0x8(%eax),%eax
  80193f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801942:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801945:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801948:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80194d:	85 c9                	test   %ecx,%ecx
  80194f:	0f 89 ff 00 00 00    	jns    801a54 <vprintfmt+0x3a7>
				putch('-', putdat);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	53                   	push   %ebx
  801959:	6a 2d                	push   $0x2d
  80195b:	ff d6                	call   *%esi
				num = -(long long) num;
  80195d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801960:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801963:	f7 da                	neg    %edx
  801965:	83 d1 00             	adc    $0x0,%ecx
  801968:	f7 d9                	neg    %ecx
  80196a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80196d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801972:	e9 dd 00 00 00       	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  801977:	8b 45 14             	mov    0x14(%ebp),%eax
  80197a:	8b 00                	mov    (%eax),%eax
  80197c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80197f:	99                   	cltd   
  801980:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	8d 40 04             	lea    0x4(%eax),%eax
  801989:	89 45 14             	mov    %eax,0x14(%ebp)
  80198c:	eb b4                	jmp    801942 <vprintfmt+0x295>
	if (lflag >= 2)
  80198e:	83 f9 01             	cmp    $0x1,%ecx
  801991:	7f 1e                	jg     8019b1 <vprintfmt+0x304>
	else if (lflag)
  801993:	85 c9                	test   %ecx,%ecx
  801995:	74 32                	je     8019c9 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  801997:	8b 45 14             	mov    0x14(%ebp),%eax
  80199a:	8b 10                	mov    (%eax),%edx
  80199c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a1:	8d 40 04             	lea    0x4(%eax),%eax
  8019a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019ac:	e9 a3 00 00 00       	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  8019b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b4:	8b 10                	mov    (%eax),%edx
  8019b6:	8b 48 04             	mov    0x4(%eax),%ecx
  8019b9:	8d 40 08             	lea    0x8(%eax),%eax
  8019bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019c4:	e9 8b 00 00 00       	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	8b 10                	mov    (%eax),%edx
  8019ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d3:	8d 40 04             	lea    0x4(%eax),%eax
  8019d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8019d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8019de:	eb 74                	jmp    801a54 <vprintfmt+0x3a7>
	if (lflag >= 2)
  8019e0:	83 f9 01             	cmp    $0x1,%ecx
  8019e3:	7f 1b                	jg     801a00 <vprintfmt+0x353>
	else if (lflag)
  8019e5:	85 c9                	test   %ecx,%ecx
  8019e7:	74 2c                	je     801a15 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  8019e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ec:	8b 10                	mov    (%eax),%edx
  8019ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f3:	8d 40 04             	lea    0x4(%eax),%eax
  8019f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8019f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fe:	eb 54                	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a00:	8b 45 14             	mov    0x14(%ebp),%eax
  801a03:	8b 10                	mov    (%eax),%edx
  801a05:	8b 48 04             	mov    0x4(%eax),%ecx
  801a08:	8d 40 08             	lea    0x8(%eax),%eax
  801a0b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a0e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a13:	eb 3f                	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801a15:	8b 45 14             	mov    0x14(%ebp),%eax
  801a18:	8b 10                	mov    (%eax),%edx
  801a1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1f:	8d 40 04             	lea    0x4(%eax),%eax
  801a22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801a25:	b8 08 00 00 00       	mov    $0x8,%eax
  801a2a:	eb 28                	jmp    801a54 <vprintfmt+0x3a7>
			putch('0', putdat);
  801a2c:	83 ec 08             	sub    $0x8,%esp
  801a2f:	53                   	push   %ebx
  801a30:	6a 30                	push   $0x30
  801a32:	ff d6                	call   *%esi
			putch('x', putdat);
  801a34:	83 c4 08             	add    $0x8,%esp
  801a37:	53                   	push   %ebx
  801a38:	6a 78                	push   $0x78
  801a3a:	ff d6                	call   *%esi
			num = (unsigned long long)
  801a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3f:	8b 10                	mov    (%eax),%edx
  801a41:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801a46:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801a49:	8d 40 04             	lea    0x4(%eax),%eax
  801a4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a4f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801a5b:	57                   	push   %edi
  801a5c:	ff 75 e0             	pushl  -0x20(%ebp)
  801a5f:	50                   	push   %eax
  801a60:	51                   	push   %ecx
  801a61:	52                   	push   %edx
  801a62:	89 da                	mov    %ebx,%edx
  801a64:	89 f0                	mov    %esi,%eax
  801a66:	e8 5a fb ff ff       	call   8015c5 <printnum>
			break;
  801a6b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801a6e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a71:	e9 55 fc ff ff       	jmp    8016cb <vprintfmt+0x1e>
	if (lflag >= 2)
  801a76:	83 f9 01             	cmp    $0x1,%ecx
  801a79:	7f 1b                	jg     801a96 <vprintfmt+0x3e9>
	else if (lflag)
  801a7b:	85 c9                	test   %ecx,%ecx
  801a7d:	74 2c                	je     801aab <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a82:	8b 10                	mov    (%eax),%edx
  801a84:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a89:	8d 40 04             	lea    0x4(%eax),%eax
  801a8c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801a8f:	b8 10 00 00 00       	mov    $0x10,%eax
  801a94:	eb be                	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801a96:	8b 45 14             	mov    0x14(%ebp),%eax
  801a99:	8b 10                	mov    (%eax),%edx
  801a9b:	8b 48 04             	mov    0x4(%eax),%ecx
  801a9e:	8d 40 08             	lea    0x8(%eax),%eax
  801aa1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801aa4:	b8 10 00 00 00       	mov    $0x10,%eax
  801aa9:	eb a9                	jmp    801a54 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801aab:	8b 45 14             	mov    0x14(%ebp),%eax
  801aae:	8b 10                	mov    (%eax),%edx
  801ab0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab5:	8d 40 04             	lea    0x4(%eax),%eax
  801ab8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801abb:	b8 10 00 00 00       	mov    $0x10,%eax
  801ac0:	eb 92                	jmp    801a54 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ac2:	83 ec 08             	sub    $0x8,%esp
  801ac5:	53                   	push   %ebx
  801ac6:	6a 25                	push   $0x25
  801ac8:	ff d6                	call   *%esi
			break;
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	eb 9f                	jmp    801a6e <vprintfmt+0x3c1>
			putch('%', putdat);
  801acf:	83 ec 08             	sub    $0x8,%esp
  801ad2:	53                   	push   %ebx
  801ad3:	6a 25                	push   $0x25
  801ad5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	89 f8                	mov    %edi,%eax
  801adc:	eb 03                	jmp    801ae1 <vprintfmt+0x434>
  801ade:	83 e8 01             	sub    $0x1,%eax
  801ae1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ae5:	75 f7                	jne    801ade <vprintfmt+0x431>
  801ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aea:	eb 82                	jmp    801a6e <vprintfmt+0x3c1>

00801aec <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 18             	sub    $0x18,%esp
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801af8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801afb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801aff:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801b02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	74 26                	je     801b33 <vsnprintf+0x47>
  801b0d:	85 d2                	test   %edx,%edx
  801b0f:	7e 22                	jle    801b33 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b11:	ff 75 14             	pushl  0x14(%ebp)
  801b14:	ff 75 10             	pushl  0x10(%ebp)
  801b17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	68 73 16 80 00       	push   $0x801673
  801b20:	e8 88 fb ff ff       	call   8016ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2e:	83 c4 10             	add    $0x10,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    
		return -E_INVAL;
  801b33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b38:	eb f7                	jmp    801b31 <vsnprintf+0x45>

00801b3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b40:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801b43:	50                   	push   %eax
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	ff 75 08             	pushl  0x8(%ebp)
  801b4d:	e8 9a ff ff ff       	call   801aec <vsnprintf>
	va_end(ap);

	return rc;
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801b63:	74 05                	je     801b6a <strlen+0x16>
		n++;
  801b65:	83 c0 01             	add    $0x1,%eax
  801b68:	eb f5                	jmp    801b5f <strlen+0xb>
	return n;
}
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    

00801b6c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b72:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b75:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7a:	39 c2                	cmp    %eax,%edx
  801b7c:	74 0d                	je     801b8b <strnlen+0x1f>
  801b7e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  801b82:	74 05                	je     801b89 <strnlen+0x1d>
		n++;
  801b84:	83 c2 01             	add    $0x1,%edx
  801b87:	eb f1                	jmp    801b7a <strnlen+0xe>
  801b89:	89 d0                	mov    %edx,%eax
	return n;
}
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    

00801b8d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	53                   	push   %ebx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801b97:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801ba0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801ba3:	83 c2 01             	add    $0x1,%edx
  801ba6:	84 c9                	test   %cl,%cl
  801ba8:	75 f2                	jne    801b9c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801baa:	5b                   	pop    %ebx
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <strcat>:

char *
strcat(char *dst, const char *src)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	53                   	push   %ebx
  801bb1:	83 ec 10             	sub    $0x10,%esp
  801bb4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801bb7:	53                   	push   %ebx
  801bb8:	e8 97 ff ff ff       	call   801b54 <strlen>
  801bbd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	01 d8                	add    %ebx,%eax
  801bc5:	50                   	push   %eax
  801bc6:	e8 c2 ff ff ff       	call   801b8d <strcpy>
	return dst;
}
  801bcb:	89 d8                	mov    %ebx,%eax
  801bcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bdd:	89 c6                	mov    %eax,%esi
  801bdf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801be2:	89 c2                	mov    %eax,%edx
  801be4:	39 f2                	cmp    %esi,%edx
  801be6:	74 11                	je     801bf9 <strncpy+0x27>
		*dst++ = *src;
  801be8:	83 c2 01             	add    $0x1,%edx
  801beb:	0f b6 19             	movzbl (%ecx),%ebx
  801bee:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801bf1:	80 fb 01             	cmp    $0x1,%bl
  801bf4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  801bf7:	eb eb                	jmp    801be4 <strncpy+0x12>
	}
	return ret;
}
  801bf9:	5b                   	pop    %ebx
  801bfa:	5e                   	pop    %esi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    

00801bfd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
  801c02:	8b 75 08             	mov    0x8(%ebp),%esi
  801c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c08:	8b 55 10             	mov    0x10(%ebp),%edx
  801c0b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801c0d:	85 d2                	test   %edx,%edx
  801c0f:	74 21                	je     801c32 <strlcpy+0x35>
  801c11:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801c15:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801c17:	39 c2                	cmp    %eax,%edx
  801c19:	74 14                	je     801c2f <strlcpy+0x32>
  801c1b:	0f b6 19             	movzbl (%ecx),%ebx
  801c1e:	84 db                	test   %bl,%bl
  801c20:	74 0b                	je     801c2d <strlcpy+0x30>
			*dst++ = *src++;
  801c22:	83 c1 01             	add    $0x1,%ecx
  801c25:	83 c2 01             	add    $0x1,%edx
  801c28:	88 5a ff             	mov    %bl,-0x1(%edx)
  801c2b:	eb ea                	jmp    801c17 <strlcpy+0x1a>
  801c2d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801c2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c32:	29 f0                	sub    %esi,%eax
}
  801c34:	5b                   	pop    %ebx
  801c35:	5e                   	pop    %esi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    

00801c38 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801c41:	0f b6 01             	movzbl (%ecx),%eax
  801c44:	84 c0                	test   %al,%al
  801c46:	74 0c                	je     801c54 <strcmp+0x1c>
  801c48:	3a 02                	cmp    (%edx),%al
  801c4a:	75 08                	jne    801c54 <strcmp+0x1c>
		p++, q++;
  801c4c:	83 c1 01             	add    $0x1,%ecx
  801c4f:	83 c2 01             	add    $0x1,%edx
  801c52:	eb ed                	jmp    801c41 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801c54:	0f b6 c0             	movzbl %al,%eax
  801c57:	0f b6 12             	movzbl (%edx),%edx
  801c5a:	29 d0                	sub    %edx,%eax
}
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    

00801c5e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	53                   	push   %ebx
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	89 c3                	mov    %eax,%ebx
  801c6a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801c6d:	eb 06                	jmp    801c75 <strncmp+0x17>
		n--, p++, q++;
  801c6f:	83 c0 01             	add    $0x1,%eax
  801c72:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801c75:	39 d8                	cmp    %ebx,%eax
  801c77:	74 16                	je     801c8f <strncmp+0x31>
  801c79:	0f b6 08             	movzbl (%eax),%ecx
  801c7c:	84 c9                	test   %cl,%cl
  801c7e:	74 04                	je     801c84 <strncmp+0x26>
  801c80:	3a 0a                	cmp    (%edx),%cl
  801c82:	74 eb                	je     801c6f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801c84:	0f b6 00             	movzbl (%eax),%eax
  801c87:	0f b6 12             	movzbl (%edx),%edx
  801c8a:	29 d0                	sub    %edx,%eax
}
  801c8c:	5b                   	pop    %ebx
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    
		return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	eb f6                	jmp    801c8c <strncmp+0x2e>

00801c96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ca0:	0f b6 10             	movzbl (%eax),%edx
  801ca3:	84 d2                	test   %dl,%dl
  801ca5:	74 09                	je     801cb0 <strchr+0x1a>
		if (*s == c)
  801ca7:	38 ca                	cmp    %cl,%dl
  801ca9:	74 0a                	je     801cb5 <strchr+0x1f>
	for (; *s; s++)
  801cab:	83 c0 01             	add    $0x1,%eax
  801cae:	eb f0                	jmp    801ca0 <strchr+0xa>
			return (char *) s;
	return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    

00801cb7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801cc1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801cc4:	38 ca                	cmp    %cl,%dl
  801cc6:	74 09                	je     801cd1 <strfind+0x1a>
  801cc8:	84 d2                	test   %dl,%dl
  801cca:	74 05                	je     801cd1 <strfind+0x1a>
	for (; *s; s++)
  801ccc:	83 c0 01             	add    $0x1,%eax
  801ccf:	eb f0                	jmp    801cc1 <strfind+0xa>
			break;
	return (char *) s;
}
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	57                   	push   %edi
  801cd7:	56                   	push   %esi
  801cd8:	53                   	push   %ebx
  801cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801cdf:	85 c9                	test   %ecx,%ecx
  801ce1:	74 31                	je     801d14 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ce3:	89 f8                	mov    %edi,%eax
  801ce5:	09 c8                	or     %ecx,%eax
  801ce7:	a8 03                	test   $0x3,%al
  801ce9:	75 23                	jne    801d0e <memset+0x3b>
		c &= 0xFF;
  801ceb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801cef:	89 d3                	mov    %edx,%ebx
  801cf1:	c1 e3 08             	shl    $0x8,%ebx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	c1 e0 18             	shl    $0x18,%eax
  801cf9:	89 d6                	mov    %edx,%esi
  801cfb:	c1 e6 10             	shl    $0x10,%esi
  801cfe:	09 f0                	or     %esi,%eax
  801d00:	09 c2                	or     %eax,%edx
  801d02:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801d04:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	fc                   	cld    
  801d0a:	f3 ab                	rep stos %eax,%es:(%edi)
  801d0c:	eb 06                	jmp    801d14 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d11:	fc                   	cld    
  801d12:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801d14:	89 f8                	mov    %edi,%eax
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5f                   	pop    %edi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    

00801d1b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	57                   	push   %edi
  801d1f:	56                   	push   %esi
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801d29:	39 c6                	cmp    %eax,%esi
  801d2b:	73 32                	jae    801d5f <memmove+0x44>
  801d2d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801d30:	39 c2                	cmp    %eax,%edx
  801d32:	76 2b                	jbe    801d5f <memmove+0x44>
		s += n;
		d += n;
  801d34:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d37:	89 fe                	mov    %edi,%esi
  801d39:	09 ce                	or     %ecx,%esi
  801d3b:	09 d6                	or     %edx,%esi
  801d3d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801d43:	75 0e                	jne    801d53 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d45:	83 ef 04             	sub    $0x4,%edi
  801d48:	8d 72 fc             	lea    -0x4(%edx),%esi
  801d4b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801d4e:	fd                   	std    
  801d4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d51:	eb 09                	jmp    801d5c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d53:	83 ef 01             	sub    $0x1,%edi
  801d56:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801d59:	fd                   	std    
  801d5a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d5c:	fc                   	cld    
  801d5d:	eb 1a                	jmp    801d79 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801d5f:	89 c2                	mov    %eax,%edx
  801d61:	09 ca                	or     %ecx,%edx
  801d63:	09 f2                	or     %esi,%edx
  801d65:	f6 c2 03             	test   $0x3,%dl
  801d68:	75 0a                	jne    801d74 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801d6d:	89 c7                	mov    %eax,%edi
  801d6f:	fc                   	cld    
  801d70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801d72:	eb 05                	jmp    801d79 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  801d74:	89 c7                	mov    %eax,%edi
  801d76:	fc                   	cld    
  801d77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    

00801d7d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801d83:	ff 75 10             	pushl  0x10(%ebp)
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	ff 75 08             	pushl  0x8(%ebp)
  801d8c:	e8 8a ff ff ff       	call   801d1b <memmove>
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	56                   	push   %esi
  801d97:	53                   	push   %ebx
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9e:	89 c6                	mov    %eax,%esi
  801da0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801da3:	39 f0                	cmp    %esi,%eax
  801da5:	74 1c                	je     801dc3 <memcmp+0x30>
		if (*s1 != *s2)
  801da7:	0f b6 08             	movzbl (%eax),%ecx
  801daa:	0f b6 1a             	movzbl (%edx),%ebx
  801dad:	38 d9                	cmp    %bl,%cl
  801daf:	75 08                	jne    801db9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801db1:	83 c0 01             	add    $0x1,%eax
  801db4:	83 c2 01             	add    $0x1,%edx
  801db7:	eb ea                	jmp    801da3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801db9:	0f b6 c1             	movzbl %cl,%eax
  801dbc:	0f b6 db             	movzbl %bl,%ebx
  801dbf:	29 d8                	sub    %ebx,%eax
  801dc1:	eb 05                	jmp    801dc8 <memcmp+0x35>
	}

	return 0;
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc8:	5b                   	pop    %ebx
  801dc9:	5e                   	pop    %esi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801dd5:	89 c2                	mov    %eax,%edx
  801dd7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801dda:	39 d0                	cmp    %edx,%eax
  801ddc:	73 09                	jae    801de7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dde:	38 08                	cmp    %cl,(%eax)
  801de0:	74 05                	je     801de7 <memfind+0x1b>
	for (; s < ends; s++)
  801de2:	83 c0 01             	add    $0x1,%eax
  801de5:	eb f3                	jmp    801dda <memfind+0xe>
			break;
	return (void *) s;
}
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	57                   	push   %edi
  801ded:	56                   	push   %esi
  801dee:	53                   	push   %ebx
  801def:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801df5:	eb 03                	jmp    801dfa <strtol+0x11>
		s++;
  801df7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801dfa:	0f b6 01             	movzbl (%ecx),%eax
  801dfd:	3c 20                	cmp    $0x20,%al
  801dff:	74 f6                	je     801df7 <strtol+0xe>
  801e01:	3c 09                	cmp    $0x9,%al
  801e03:	74 f2                	je     801df7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801e05:	3c 2b                	cmp    $0x2b,%al
  801e07:	74 2a                	je     801e33 <strtol+0x4a>
	int neg = 0;
  801e09:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801e0e:	3c 2d                	cmp    $0x2d,%al
  801e10:	74 2b                	je     801e3d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e12:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801e18:	75 0f                	jne    801e29 <strtol+0x40>
  801e1a:	80 39 30             	cmpb   $0x30,(%ecx)
  801e1d:	74 28                	je     801e47 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801e1f:	85 db                	test   %ebx,%ebx
  801e21:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e26:	0f 44 d8             	cmove  %eax,%ebx
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801e31:	eb 50                	jmp    801e83 <strtol+0x9a>
		s++;
  801e33:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801e36:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3b:	eb d5                	jmp    801e12 <strtol+0x29>
		s++, neg = 1;
  801e3d:	83 c1 01             	add    $0x1,%ecx
  801e40:	bf 01 00 00 00       	mov    $0x1,%edi
  801e45:	eb cb                	jmp    801e12 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e47:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801e4b:	74 0e                	je     801e5b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  801e4d:	85 db                	test   %ebx,%ebx
  801e4f:	75 d8                	jne    801e29 <strtol+0x40>
		s++, base = 8;
  801e51:	83 c1 01             	add    $0x1,%ecx
  801e54:	bb 08 00 00 00       	mov    $0x8,%ebx
  801e59:	eb ce                	jmp    801e29 <strtol+0x40>
		s += 2, base = 16;
  801e5b:	83 c1 02             	add    $0x2,%ecx
  801e5e:	bb 10 00 00 00       	mov    $0x10,%ebx
  801e63:	eb c4                	jmp    801e29 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801e65:	8d 72 9f             	lea    -0x61(%edx),%esi
  801e68:	89 f3                	mov    %esi,%ebx
  801e6a:	80 fb 19             	cmp    $0x19,%bl
  801e6d:	77 29                	ja     801e98 <strtol+0xaf>
			dig = *s - 'a' + 10;
  801e6f:	0f be d2             	movsbl %dl,%edx
  801e72:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801e75:	3b 55 10             	cmp    0x10(%ebp),%edx
  801e78:	7d 30                	jge    801eaa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  801e7a:	83 c1 01             	add    $0x1,%ecx
  801e7d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e81:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801e83:	0f b6 11             	movzbl (%ecx),%edx
  801e86:	8d 72 d0             	lea    -0x30(%edx),%esi
  801e89:	89 f3                	mov    %esi,%ebx
  801e8b:	80 fb 09             	cmp    $0x9,%bl
  801e8e:	77 d5                	ja     801e65 <strtol+0x7c>
			dig = *s - '0';
  801e90:	0f be d2             	movsbl %dl,%edx
  801e93:	83 ea 30             	sub    $0x30,%edx
  801e96:	eb dd                	jmp    801e75 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  801e98:	8d 72 bf             	lea    -0x41(%edx),%esi
  801e9b:	89 f3                	mov    %esi,%ebx
  801e9d:	80 fb 19             	cmp    $0x19,%bl
  801ea0:	77 08                	ja     801eaa <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ea2:	0f be d2             	movsbl %dl,%edx
  801ea5:	83 ea 37             	sub    $0x37,%edx
  801ea8:	eb cb                	jmp    801e75 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  801eaa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eae:	74 05                	je     801eb5 <strtol+0xcc>
		*endptr = (char *) s;
  801eb0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eb3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801eb5:	89 c2                	mov    %eax,%edx
  801eb7:	f7 da                	neg    %edx
  801eb9:	85 ff                	test   %edi,%edi
  801ebb:	0f 45 c2             	cmovne %edx,%eax
}
  801ebe:	5b                   	pop    %ebx
  801ebf:	5e                   	pop    %esi
  801ec0:	5f                   	pop    %edi
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    

00801ec3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	8b 75 08             	mov    0x8(%ebp),%esi
  801ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	74 4f                	je     801f24 <ipc_recv+0x61>
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	50                   	push   %eax
  801ed9:	e8 35 e4 ff ff       	call   800313 <sys_ipc_recv>
  801ede:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801ee1:	85 f6                	test   %esi,%esi
  801ee3:	74 14                	je     801ef9 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801ee5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eea:	85 c0                	test   %eax,%eax
  801eec:	75 09                	jne    801ef7 <ipc_recv+0x34>
  801eee:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ef4:	8b 52 74             	mov    0x74(%edx),%edx
  801ef7:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801ef9:	85 db                	test   %ebx,%ebx
  801efb:	74 14                	je     801f11 <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801efd:	ba 00 00 00 00       	mov    $0x0,%edx
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 09                	jne    801f0f <ipc_recv+0x4c>
  801f06:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f0c:	8b 52 78             	mov    0x78(%edx),%edx
  801f0f:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801f11:	85 c0                	test   %eax,%eax
  801f13:	75 08                	jne    801f1d <ipc_recv+0x5a>
  801f15:	a1 08 40 80 00       	mov    0x804008,%eax
  801f1a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801f1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	68 00 00 c0 ee       	push   $0xeec00000
  801f2c:	e8 e2 e3 ff ff       	call   800313 <sys_ipc_recv>
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	eb ab                	jmp    801ee1 <ipc_recv+0x1e>

00801f36 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	57                   	push   %edi
  801f3a:	56                   	push   %esi
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f42:	8b 75 10             	mov    0x10(%ebp),%esi
  801f45:	eb 20                	jmp    801f67 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f47:	6a 00                	push   $0x0
  801f49:	68 00 00 c0 ee       	push   $0xeec00000
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	57                   	push   %edi
  801f52:	e8 99 e3 ff ff       	call   8002f0 <sys_ipc_try_send>
  801f57:	89 c3                	mov    %eax,%ebx
  801f59:	83 c4 10             	add    $0x10,%esp
  801f5c:	eb 1f                	jmp    801f7d <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801f5e:	e8 e1 e1 ff ff       	call   800144 <sys_yield>
	while(retval != 0) {
  801f63:	85 db                	test   %ebx,%ebx
  801f65:	74 33                	je     801f9a <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801f67:	85 f6                	test   %esi,%esi
  801f69:	74 dc                	je     801f47 <ipc_send+0x11>
  801f6b:	ff 75 14             	pushl  0x14(%ebp)
  801f6e:	56                   	push   %esi
  801f6f:	ff 75 0c             	pushl  0xc(%ebp)
  801f72:	57                   	push   %edi
  801f73:	e8 78 e3 ff ff       	call   8002f0 <sys_ipc_try_send>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  801f7d:	83 fb f9             	cmp    $0xfffffff9,%ebx
  801f80:	74 dc                	je     801f5e <ipc_send+0x28>
  801f82:	85 db                	test   %ebx,%ebx
  801f84:	74 d8                	je     801f5e <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 20 27 80 00       	push   $0x802720
  801f8e:	6a 35                	push   $0x35
  801f90:	68 50 27 80 00       	push   $0x802750
  801f95:	e8 3c f5 ff ff       	call   8014d6 <_panic>
	}
}
  801f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9d:	5b                   	pop    %ebx
  801f9e:	5e                   	pop    %esi
  801f9f:	5f                   	pop    %edi
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    

00801fa2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fad:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fb0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fb6:	8b 52 50             	mov    0x50(%edx),%edx
  801fb9:	39 ca                	cmp    %ecx,%edx
  801fbb:	74 11                	je     801fce <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fbd:	83 c0 01             	add    $0x1,%eax
  801fc0:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fc5:	75 e6                	jne    801fad <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcc:	eb 0b                	jmp    801fd9 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fd1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fd6:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fd9:	5d                   	pop    %ebp
  801fda:	c3                   	ret    

00801fdb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fe1:	89 d0                	mov    %edx,%eax
  801fe3:	c1 e8 16             	shr    $0x16,%eax
  801fe6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ff2:	f6 c1 01             	test   $0x1,%cl
  801ff5:	74 1d                	je     802014 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ff7:	c1 ea 0c             	shr    $0xc,%edx
  801ffa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802001:	f6 c2 01             	test   $0x1,%dl
  802004:	74 0e                	je     802014 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802006:	c1 ea 0c             	shr    $0xc,%edx
  802009:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802010:	ef 
  802011:	0f b7 c0             	movzwl %ax,%eax
}
  802014:	5d                   	pop    %ebp
  802015:	c3                   	ret    
  802016:	66 90                	xchg   %ax,%ax
  802018:	66 90                	xchg   %ax,%ax
  80201a:	66 90                	xchg   %ax,%ax
  80201c:	66 90                	xchg   %ax,%ax
  80201e:	66 90                	xchg   %ax,%ax

00802020 <__udivdi3>:
  802020:	f3 0f 1e fb          	endbr32 
  802024:	55                   	push   %ebp
  802025:	57                   	push   %edi
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	83 ec 1c             	sub    $0x1c,%esp
  80202b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80202f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802033:	8b 74 24 34          	mov    0x34(%esp),%esi
  802037:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80203b:	85 d2                	test   %edx,%edx
  80203d:	75 49                	jne    802088 <__udivdi3+0x68>
  80203f:	39 f3                	cmp    %esi,%ebx
  802041:	76 15                	jbe    802058 <__udivdi3+0x38>
  802043:	31 ff                	xor    %edi,%edi
  802045:	89 e8                	mov    %ebp,%eax
  802047:	89 f2                	mov    %esi,%edx
  802049:	f7 f3                	div    %ebx
  80204b:	89 fa                	mov    %edi,%edx
  80204d:	83 c4 1c             	add    $0x1c,%esp
  802050:	5b                   	pop    %ebx
  802051:	5e                   	pop    %esi
  802052:	5f                   	pop    %edi
  802053:	5d                   	pop    %ebp
  802054:	c3                   	ret    
  802055:	8d 76 00             	lea    0x0(%esi),%esi
  802058:	89 d9                	mov    %ebx,%ecx
  80205a:	85 db                	test   %ebx,%ebx
  80205c:	75 0b                	jne    802069 <__udivdi3+0x49>
  80205e:	b8 01 00 00 00       	mov    $0x1,%eax
  802063:	31 d2                	xor    %edx,%edx
  802065:	f7 f3                	div    %ebx
  802067:	89 c1                	mov    %eax,%ecx
  802069:	31 d2                	xor    %edx,%edx
  80206b:	89 f0                	mov    %esi,%eax
  80206d:	f7 f1                	div    %ecx
  80206f:	89 c6                	mov    %eax,%esi
  802071:	89 e8                	mov    %ebp,%eax
  802073:	89 f7                	mov    %esi,%edi
  802075:	f7 f1                	div    %ecx
  802077:	89 fa                	mov    %edi,%edx
  802079:	83 c4 1c             	add    $0x1c,%esp
  80207c:	5b                   	pop    %ebx
  80207d:	5e                   	pop    %esi
  80207e:	5f                   	pop    %edi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
  802081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802088:	39 f2                	cmp    %esi,%edx
  80208a:	77 1c                	ja     8020a8 <__udivdi3+0x88>
  80208c:	0f bd fa             	bsr    %edx,%edi
  80208f:	83 f7 1f             	xor    $0x1f,%edi
  802092:	75 2c                	jne    8020c0 <__udivdi3+0xa0>
  802094:	39 f2                	cmp    %esi,%edx
  802096:	72 06                	jb     80209e <__udivdi3+0x7e>
  802098:	31 c0                	xor    %eax,%eax
  80209a:	39 eb                	cmp    %ebp,%ebx
  80209c:	77 ad                	ja     80204b <__udivdi3+0x2b>
  80209e:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a3:	eb a6                	jmp    80204b <__udivdi3+0x2b>
  8020a5:	8d 76 00             	lea    0x0(%esi),%esi
  8020a8:	31 ff                	xor    %edi,%edi
  8020aa:	31 c0                	xor    %eax,%eax
  8020ac:	89 fa                	mov    %edi,%edx
  8020ae:	83 c4 1c             	add    $0x1c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020bd:	8d 76 00             	lea    0x0(%esi),%esi
  8020c0:	89 f9                	mov    %edi,%ecx
  8020c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020c7:	29 f8                	sub    %edi,%eax
  8020c9:	d3 e2                	shl    %cl,%edx
  8020cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020cf:	89 c1                	mov    %eax,%ecx
  8020d1:	89 da                	mov    %ebx,%edx
  8020d3:	d3 ea                	shr    %cl,%edx
  8020d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020d9:	09 d1                	or     %edx,%ecx
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e3                	shl    %cl,%ebx
  8020e5:	89 c1                	mov    %eax,%ecx
  8020e7:	d3 ea                	shr    %cl,%edx
  8020e9:	89 f9                	mov    %edi,%ecx
  8020eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020ef:	89 eb                	mov    %ebp,%ebx
  8020f1:	d3 e6                	shl    %cl,%esi
  8020f3:	89 c1                	mov    %eax,%ecx
  8020f5:	d3 eb                	shr    %cl,%ebx
  8020f7:	09 de                	or     %ebx,%esi
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	f7 74 24 08          	divl   0x8(%esp)
  8020ff:	89 d6                	mov    %edx,%esi
  802101:	89 c3                	mov    %eax,%ebx
  802103:	f7 64 24 0c          	mull   0xc(%esp)
  802107:	39 d6                	cmp    %edx,%esi
  802109:	72 15                	jb     802120 <__udivdi3+0x100>
  80210b:	89 f9                	mov    %edi,%ecx
  80210d:	d3 e5                	shl    %cl,%ebp
  80210f:	39 c5                	cmp    %eax,%ebp
  802111:	73 04                	jae    802117 <__udivdi3+0xf7>
  802113:	39 d6                	cmp    %edx,%esi
  802115:	74 09                	je     802120 <__udivdi3+0x100>
  802117:	89 d8                	mov    %ebx,%eax
  802119:	31 ff                	xor    %edi,%edi
  80211b:	e9 2b ff ff ff       	jmp    80204b <__udivdi3+0x2b>
  802120:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802123:	31 ff                	xor    %edi,%edi
  802125:	e9 21 ff ff ff       	jmp    80204b <__udivdi3+0x2b>
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	66 90                	xchg   %ax,%ax
  80212e:	66 90                	xchg   %ax,%ax

00802130 <__umoddi3>:
  802130:	f3 0f 1e fb          	endbr32 
  802134:	55                   	push   %ebp
  802135:	57                   	push   %edi
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	83 ec 1c             	sub    $0x1c,%esp
  80213b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80213f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802143:	8b 74 24 30          	mov    0x30(%esp),%esi
  802147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80214b:	89 da                	mov    %ebx,%edx
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 3f                	jne    802190 <__umoddi3+0x60>
  802151:	39 df                	cmp    %ebx,%edi
  802153:	76 13                	jbe    802168 <__umoddi3+0x38>
  802155:	89 f0                	mov    %esi,%eax
  802157:	f7 f7                	div    %edi
  802159:	89 d0                	mov    %edx,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	89 fd                	mov    %edi,%ebp
  80216a:	85 ff                	test   %edi,%edi
  80216c:	75 0b                	jne    802179 <__umoddi3+0x49>
  80216e:	b8 01 00 00 00       	mov    $0x1,%eax
  802173:	31 d2                	xor    %edx,%edx
  802175:	f7 f7                	div    %edi
  802177:	89 c5                	mov    %eax,%ebp
  802179:	89 d8                	mov    %ebx,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	f7 f5                	div    %ebp
  80217f:	89 f0                	mov    %esi,%eax
  802181:	f7 f5                	div    %ebp
  802183:	89 d0                	mov    %edx,%eax
  802185:	eb d4                	jmp    80215b <__umoddi3+0x2b>
  802187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80218e:	66 90                	xchg   %ax,%ax
  802190:	89 f1                	mov    %esi,%ecx
  802192:	39 d8                	cmp    %ebx,%eax
  802194:	76 0a                	jbe    8021a0 <__umoddi3+0x70>
  802196:	89 f0                	mov    %esi,%eax
  802198:	83 c4 1c             	add    $0x1c,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5f                   	pop    %edi
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    
  8021a0:	0f bd e8             	bsr    %eax,%ebp
  8021a3:	83 f5 1f             	xor    $0x1f,%ebp
  8021a6:	75 20                	jne    8021c8 <__umoddi3+0x98>
  8021a8:	39 d8                	cmp    %ebx,%eax
  8021aa:	0f 82 b0 00 00 00    	jb     802260 <__umoddi3+0x130>
  8021b0:	39 f7                	cmp    %esi,%edi
  8021b2:	0f 86 a8 00 00 00    	jbe    802260 <__umoddi3+0x130>
  8021b8:	89 c8                	mov    %ecx,%eax
  8021ba:	83 c4 1c             	add    $0x1c,%esp
  8021bd:	5b                   	pop    %ebx
  8021be:	5e                   	pop    %esi
  8021bf:	5f                   	pop    %edi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
  8021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c8:	89 e9                	mov    %ebp,%ecx
  8021ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8021cf:	29 ea                	sub    %ebp,%edx
  8021d1:	d3 e0                	shl    %cl,%eax
  8021d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021d7:	89 d1                	mov    %edx,%ecx
  8021d9:	89 f8                	mov    %edi,%eax
  8021db:	d3 e8                	shr    %cl,%eax
  8021dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8021e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021e9:	09 c1                	or     %eax,%ecx
  8021eb:	89 d8                	mov    %ebx,%eax
  8021ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021f1:	89 e9                	mov    %ebp,%ecx
  8021f3:	d3 e7                	shl    %cl,%edi
  8021f5:	89 d1                	mov    %edx,%ecx
  8021f7:	d3 e8                	shr    %cl,%eax
  8021f9:	89 e9                	mov    %ebp,%ecx
  8021fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021ff:	d3 e3                	shl    %cl,%ebx
  802201:	89 c7                	mov    %eax,%edi
  802203:	89 d1                	mov    %edx,%ecx
  802205:	89 f0                	mov    %esi,%eax
  802207:	d3 e8                	shr    %cl,%eax
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	89 fa                	mov    %edi,%edx
  80220d:	d3 e6                	shl    %cl,%esi
  80220f:	09 d8                	or     %ebx,%eax
  802211:	f7 74 24 08          	divl   0x8(%esp)
  802215:	89 d1                	mov    %edx,%ecx
  802217:	89 f3                	mov    %esi,%ebx
  802219:	f7 64 24 0c          	mull   0xc(%esp)
  80221d:	89 c6                	mov    %eax,%esi
  80221f:	89 d7                	mov    %edx,%edi
  802221:	39 d1                	cmp    %edx,%ecx
  802223:	72 06                	jb     80222b <__umoddi3+0xfb>
  802225:	75 10                	jne    802237 <__umoddi3+0x107>
  802227:	39 c3                	cmp    %eax,%ebx
  802229:	73 0c                	jae    802237 <__umoddi3+0x107>
  80222b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80222f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802233:	89 d7                	mov    %edx,%edi
  802235:	89 c6                	mov    %eax,%esi
  802237:	89 ca                	mov    %ecx,%edx
  802239:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80223e:	29 f3                	sub    %esi,%ebx
  802240:	19 fa                	sbb    %edi,%edx
  802242:	89 d0                	mov    %edx,%eax
  802244:	d3 e0                	shl    %cl,%eax
  802246:	89 e9                	mov    %ebp,%ecx
  802248:	d3 eb                	shr    %cl,%ebx
  80224a:	d3 ea                	shr    %cl,%edx
  80224c:	09 d8                	or     %ebx,%eax
  80224e:	83 c4 1c             	add    $0x1c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
  802256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80225d:	8d 76 00             	lea    0x0(%esi),%esi
  802260:	89 da                	mov    %ebx,%edx
  802262:	29 fe                	sub    %edi,%esi
  802264:	19 c2                	sbb    %eax,%edx
  802266:	89 f1                	mov    %esi,%ecx
  802268:	89 c8                	mov    %ecx,%eax
  80226a:	e9 4b ff ff ff       	jmp    8021ba <__umoddi3+0x8a>
