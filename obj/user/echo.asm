
obj/user/echo.debug：     文件格式 elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 60                	jmp    8000b5 <umain+0x82>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 20 23 80 00       	push   $0x802320
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 c3 01 00 00       	call   800228 <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 01                	push   $0x1
  800087:	68 23 23 80 00       	push   $0x802323
  80008c:	6a 01                	push   $0x1
  80008e:	e8 a1 0a 00 00       	call   800b34 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 a3 00 00 00       	call   800144 <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 85 0a 00 00       	call   800b34 <write>
	for (i = 1; i < argc; i++) {
  8000af:	83 c3 01             	add    $0x1,%ebx
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	39 df                	cmp    %ebx,%edi
  8000b7:	7e 07                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000b9:	83 fb 01             	cmp    $0x1,%ebx
  8000bc:	7f c4                	jg     800082 <umain+0x4f>
  8000be:	eb d6                	jmp    800096 <umain+0x63>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 43 24 80 00       	push   $0x802443
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 55 0a 00 00       	call   800b34 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 3d 04 00 00       	call   800531 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x2d>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800130:	e8 22 08 00 00       	call   800957 <close_all>
	sys_env_destroy(0);
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	6a 00                	push   $0x0
  80013a:	e8 b1 03 00 00       	call   8004f0 <sys_env_destroy>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	c9                   	leave  
  800143:	c3                   	ret    

00800144 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80014a:	b8 00 00 00 00       	mov    $0x0,%eax
  80014f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800153:	74 05                	je     80015a <strlen+0x16>
		n++;
  800155:	83 c0 01             	add    $0x1,%eax
  800158:	eb f5                	jmp    80014f <strlen+0xb>
	return n;
}
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800162:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	39 c2                	cmp    %eax,%edx
  80016c:	74 0d                	je     80017b <strnlen+0x1f>
  80016e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800172:	74 05                	je     800179 <strnlen+0x1d>
		n++;
  800174:	83 c2 01             	add    $0x1,%edx
  800177:	eb f1                	jmp    80016a <strnlen+0xe>
  800179:	89 d0                	mov    %edx,%eax
	return n;
}
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	53                   	push   %ebx
  800181:	8b 45 08             	mov    0x8(%ebp),%eax
  800184:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800187:	ba 00 00 00 00       	mov    $0x0,%edx
  80018c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800190:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800193:	83 c2 01             	add    $0x1,%edx
  800196:	84 c9                	test   %cl,%cl
  800198:	75 f2                	jne    80018c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80019a:	5b                   	pop    %ebx
  80019b:	5d                   	pop    %ebp
  80019c:	c3                   	ret    

0080019d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 10             	sub    $0x10,%esp
  8001a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001a7:	53                   	push   %ebx
  8001a8:	e8 97 ff ff ff       	call   800144 <strlen>
  8001ad:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001b0:	ff 75 0c             	pushl  0xc(%ebp)
  8001b3:	01 d8                	add    %ebx,%eax
  8001b5:	50                   	push   %eax
  8001b6:	e8 c2 ff ff ff       	call   80017d <strcpy>
	return dst;
}
  8001bb:	89 d8                	mov    %ebx,%eax
  8001bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cd:	89 c6                	mov    %eax,%esi
  8001cf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001d2:	89 c2                	mov    %eax,%edx
  8001d4:	39 f2                	cmp    %esi,%edx
  8001d6:	74 11                	je     8001e9 <strncpy+0x27>
		*dst++ = *src;
  8001d8:	83 c2 01             	add    $0x1,%edx
  8001db:	0f b6 19             	movzbl (%ecx),%ebx
  8001de:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001e1:	80 fb 01             	cmp    $0x1,%bl
  8001e4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8001e7:	eb eb                	jmp    8001d4 <strncpy+0x12>
	}
	return ret;
}
  8001e9:	5b                   	pop    %ebx
  8001ea:	5e                   	pop    %esi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f8:	8b 55 10             	mov    0x10(%ebp),%edx
  8001fb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8001fd:	85 d2                	test   %edx,%edx
  8001ff:	74 21                	je     800222 <strlcpy+0x35>
  800201:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800205:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800207:	39 c2                	cmp    %eax,%edx
  800209:	74 14                	je     80021f <strlcpy+0x32>
  80020b:	0f b6 19             	movzbl (%ecx),%ebx
  80020e:	84 db                	test   %bl,%bl
  800210:	74 0b                	je     80021d <strlcpy+0x30>
			*dst++ = *src++;
  800212:	83 c1 01             	add    $0x1,%ecx
  800215:	83 c2 01             	add    $0x1,%edx
  800218:	88 5a ff             	mov    %bl,-0x1(%edx)
  80021b:	eb ea                	jmp    800207 <strlcpy+0x1a>
  80021d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80021f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800222:	29 f0                	sub    %esi,%eax
}
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800231:	0f b6 01             	movzbl (%ecx),%eax
  800234:	84 c0                	test   %al,%al
  800236:	74 0c                	je     800244 <strcmp+0x1c>
  800238:	3a 02                	cmp    (%edx),%al
  80023a:	75 08                	jne    800244 <strcmp+0x1c>
		p++, q++;
  80023c:	83 c1 01             	add    $0x1,%ecx
  80023f:	83 c2 01             	add    $0x1,%edx
  800242:	eb ed                	jmp    800231 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800244:	0f b6 c0             	movzbl %al,%eax
  800247:	0f b6 12             	movzbl (%edx),%edx
  80024a:	29 d0                	sub    %edx,%eax
}
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	53                   	push   %ebx
  800252:	8b 45 08             	mov    0x8(%ebp),%eax
  800255:	8b 55 0c             	mov    0xc(%ebp),%edx
  800258:	89 c3                	mov    %eax,%ebx
  80025a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80025d:	eb 06                	jmp    800265 <strncmp+0x17>
		n--, p++, q++;
  80025f:	83 c0 01             	add    $0x1,%eax
  800262:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800265:	39 d8                	cmp    %ebx,%eax
  800267:	74 16                	je     80027f <strncmp+0x31>
  800269:	0f b6 08             	movzbl (%eax),%ecx
  80026c:	84 c9                	test   %cl,%cl
  80026e:	74 04                	je     800274 <strncmp+0x26>
  800270:	3a 0a                	cmp    (%edx),%cl
  800272:	74 eb                	je     80025f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800274:	0f b6 00             	movzbl (%eax),%eax
  800277:	0f b6 12             	movzbl (%edx),%edx
  80027a:	29 d0                	sub    %edx,%eax
}
  80027c:	5b                   	pop    %ebx
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    
		return 0;
  80027f:	b8 00 00 00 00       	mov    $0x0,%eax
  800284:	eb f6                	jmp    80027c <strncmp+0x2e>

00800286 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	8b 45 08             	mov    0x8(%ebp),%eax
  80028c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800290:	0f b6 10             	movzbl (%eax),%edx
  800293:	84 d2                	test   %dl,%dl
  800295:	74 09                	je     8002a0 <strchr+0x1a>
		if (*s == c)
  800297:	38 ca                	cmp    %cl,%dl
  800299:	74 0a                	je     8002a5 <strchr+0x1f>
	for (; *s; s++)
  80029b:	83 c0 01             	add    $0x1,%eax
  80029e:	eb f0                	jmp    800290 <strchr+0xa>
			return (char *) s;
	return 0;
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002a5:	5d                   	pop    %ebp
  8002a6:	c3                   	ret    

008002a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002b1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002b4:	38 ca                	cmp    %cl,%dl
  8002b6:	74 09                	je     8002c1 <strfind+0x1a>
  8002b8:	84 d2                	test   %dl,%dl
  8002ba:	74 05                	je     8002c1 <strfind+0x1a>
	for (; *s; s++)
  8002bc:	83 c0 01             	add    $0x1,%eax
  8002bf:	eb f0                	jmp    8002b1 <strfind+0xa>
			break;
	return (char *) s;
}
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    

008002c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	57                   	push   %edi
  8002c7:	56                   	push   %esi
  8002c8:	53                   	push   %ebx
  8002c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002cf:	85 c9                	test   %ecx,%ecx
  8002d1:	74 31                	je     800304 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002d3:	89 f8                	mov    %edi,%eax
  8002d5:	09 c8                	or     %ecx,%eax
  8002d7:	a8 03                	test   $0x3,%al
  8002d9:	75 23                	jne    8002fe <memset+0x3b>
		c &= 0xFF;
  8002db:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8002df:	89 d3                	mov    %edx,%ebx
  8002e1:	c1 e3 08             	shl    $0x8,%ebx
  8002e4:	89 d0                	mov    %edx,%eax
  8002e6:	c1 e0 18             	shl    $0x18,%eax
  8002e9:	89 d6                	mov    %edx,%esi
  8002eb:	c1 e6 10             	shl    $0x10,%esi
  8002ee:	09 f0                	or     %esi,%eax
  8002f0:	09 c2                	or     %eax,%edx
  8002f2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8002f4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8002f7:	89 d0                	mov    %edx,%eax
  8002f9:	fc                   	cld    
  8002fa:	f3 ab                	rep stos %eax,%es:(%edi)
  8002fc:	eb 06                	jmp    800304 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	fc                   	cld    
  800302:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800304:	89 f8                	mov    %edi,%eax
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    

0080030b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	8b 75 0c             	mov    0xc(%ebp),%esi
  800316:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800319:	39 c6                	cmp    %eax,%esi
  80031b:	73 32                	jae    80034f <memmove+0x44>
  80031d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800320:	39 c2                	cmp    %eax,%edx
  800322:	76 2b                	jbe    80034f <memmove+0x44>
		s += n;
		d += n;
  800324:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800327:	89 fe                	mov    %edi,%esi
  800329:	09 ce                	or     %ecx,%esi
  80032b:	09 d6                	or     %edx,%esi
  80032d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800333:	75 0e                	jne    800343 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800335:	83 ef 04             	sub    $0x4,%edi
  800338:	8d 72 fc             	lea    -0x4(%edx),%esi
  80033b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80033e:	fd                   	std    
  80033f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800341:	eb 09                	jmp    80034c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800343:	83 ef 01             	sub    $0x1,%edi
  800346:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800349:	fd                   	std    
  80034a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80034c:	fc                   	cld    
  80034d:	eb 1a                	jmp    800369 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80034f:	89 c2                	mov    %eax,%edx
  800351:	09 ca                	or     %ecx,%edx
  800353:	09 f2                	or     %esi,%edx
  800355:	f6 c2 03             	test   $0x3,%dl
  800358:	75 0a                	jne    800364 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80035a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80035d:	89 c7                	mov    %eax,%edi
  80035f:	fc                   	cld    
  800360:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800362:	eb 05                	jmp    800369 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800364:	89 c7                	mov    %eax,%edi
  800366:	fc                   	cld    
  800367:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800369:	5e                   	pop    %esi
  80036a:	5f                   	pop    %edi
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800373:	ff 75 10             	pushl  0x10(%ebp)
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 8a ff ff ff       	call   80030b <memmove>
}
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	56                   	push   %esi
  800387:	53                   	push   %ebx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038e:	89 c6                	mov    %eax,%esi
  800390:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800393:	39 f0                	cmp    %esi,%eax
  800395:	74 1c                	je     8003b3 <memcmp+0x30>
		if (*s1 != *s2)
  800397:	0f b6 08             	movzbl (%eax),%ecx
  80039a:	0f b6 1a             	movzbl (%edx),%ebx
  80039d:	38 d9                	cmp    %bl,%cl
  80039f:	75 08                	jne    8003a9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003a1:	83 c0 01             	add    $0x1,%eax
  8003a4:	83 c2 01             	add    $0x1,%edx
  8003a7:	eb ea                	jmp    800393 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8003a9:	0f b6 c1             	movzbl %cl,%eax
  8003ac:	0f b6 db             	movzbl %bl,%ebx
  8003af:	29 d8                	sub    %ebx,%eax
  8003b1:	eb 05                	jmp    8003b8 <memcmp+0x35>
	}

	return 0;
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003c5:	89 c2                	mov    %eax,%edx
  8003c7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8003ca:	39 d0                	cmp    %edx,%eax
  8003cc:	73 09                	jae    8003d7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8003ce:	38 08                	cmp    %cl,(%eax)
  8003d0:	74 05                	je     8003d7 <memfind+0x1b>
	for (; s < ends; s++)
  8003d2:	83 c0 01             	add    $0x1,%eax
  8003d5:	eb f3                	jmp    8003ca <memfind+0xe>
			break;
	return (void *) s;
}
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    

008003d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	57                   	push   %edi
  8003dd:	56                   	push   %esi
  8003de:	53                   	push   %ebx
  8003df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8003e5:	eb 03                	jmp    8003ea <strtol+0x11>
		s++;
  8003e7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8003ea:	0f b6 01             	movzbl (%ecx),%eax
  8003ed:	3c 20                	cmp    $0x20,%al
  8003ef:	74 f6                	je     8003e7 <strtol+0xe>
  8003f1:	3c 09                	cmp    $0x9,%al
  8003f3:	74 f2                	je     8003e7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8003f5:	3c 2b                	cmp    $0x2b,%al
  8003f7:	74 2a                	je     800423 <strtol+0x4a>
	int neg = 0;
  8003f9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8003fe:	3c 2d                	cmp    $0x2d,%al
  800400:	74 2b                	je     80042d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800402:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800408:	75 0f                	jne    800419 <strtol+0x40>
  80040a:	80 39 30             	cmpb   $0x30,(%ecx)
  80040d:	74 28                	je     800437 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80040f:	85 db                	test   %ebx,%ebx
  800411:	b8 0a 00 00 00       	mov    $0xa,%eax
  800416:	0f 44 d8             	cmove  %eax,%ebx
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800421:	eb 50                	jmp    800473 <strtol+0x9a>
		s++;
  800423:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800426:	bf 00 00 00 00       	mov    $0x0,%edi
  80042b:	eb d5                	jmp    800402 <strtol+0x29>
		s++, neg = 1;
  80042d:	83 c1 01             	add    $0x1,%ecx
  800430:	bf 01 00 00 00       	mov    $0x1,%edi
  800435:	eb cb                	jmp    800402 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800437:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80043b:	74 0e                	je     80044b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  80043d:	85 db                	test   %ebx,%ebx
  80043f:	75 d8                	jne    800419 <strtol+0x40>
		s++, base = 8;
  800441:	83 c1 01             	add    $0x1,%ecx
  800444:	bb 08 00 00 00       	mov    $0x8,%ebx
  800449:	eb ce                	jmp    800419 <strtol+0x40>
		s += 2, base = 16;
  80044b:	83 c1 02             	add    $0x2,%ecx
  80044e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800453:	eb c4                	jmp    800419 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800455:	8d 72 9f             	lea    -0x61(%edx),%esi
  800458:	89 f3                	mov    %esi,%ebx
  80045a:	80 fb 19             	cmp    $0x19,%bl
  80045d:	77 29                	ja     800488 <strtol+0xaf>
			dig = *s - 'a' + 10;
  80045f:	0f be d2             	movsbl %dl,%edx
  800462:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800465:	3b 55 10             	cmp    0x10(%ebp),%edx
  800468:	7d 30                	jge    80049a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  80046a:	83 c1 01             	add    $0x1,%ecx
  80046d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800471:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800473:	0f b6 11             	movzbl (%ecx),%edx
  800476:	8d 72 d0             	lea    -0x30(%edx),%esi
  800479:	89 f3                	mov    %esi,%ebx
  80047b:	80 fb 09             	cmp    $0x9,%bl
  80047e:	77 d5                	ja     800455 <strtol+0x7c>
			dig = *s - '0';
  800480:	0f be d2             	movsbl %dl,%edx
  800483:	83 ea 30             	sub    $0x30,%edx
  800486:	eb dd                	jmp    800465 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800488:	8d 72 bf             	lea    -0x41(%edx),%esi
  80048b:	89 f3                	mov    %esi,%ebx
  80048d:	80 fb 19             	cmp    $0x19,%bl
  800490:	77 08                	ja     80049a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800492:	0f be d2             	movsbl %dl,%edx
  800495:	83 ea 37             	sub    $0x37,%edx
  800498:	eb cb                	jmp    800465 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  80049a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049e:	74 05                	je     8004a5 <strtol+0xcc>
		*endptr = (char *) s;
  8004a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004a3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004a5:	89 c2                	mov    %eax,%edx
  8004a7:	f7 da                	neg    %edx
  8004a9:	85 ff                	test   %edi,%edi
  8004ab:	0f 45 c2             	cmovne %edx,%eax
}
  8004ae:	5b                   	pop    %ebx
  8004af:	5e                   	pop    %esi
  8004b0:	5f                   	pop    %edi
  8004b1:	5d                   	pop    %ebp
  8004b2:	c3                   	ret    

008004b3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	57                   	push   %edi
  8004b7:	56                   	push   %esi
  8004b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004be:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c4:	89 c3                	mov    %eax,%ebx
  8004c6:	89 c7                	mov    %eax,%edi
  8004c8:	89 c6                	mov    %eax,%esi
  8004ca:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004cc:	5b                   	pop    %ebx
  8004cd:	5e                   	pop    %esi
  8004ce:	5f                   	pop    %edi
  8004cf:	5d                   	pop    %ebp
  8004d0:	c3                   	ret    

008004d1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8004d1:	55                   	push   %ebp
  8004d2:	89 e5                	mov    %esp,%ebp
  8004d4:	57                   	push   %edi
  8004d5:	56                   	push   %esi
  8004d6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8004d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8004e1:	89 d1                	mov    %edx,%ecx
  8004e3:	89 d3                	mov    %edx,%ebx
  8004e5:	89 d7                	mov    %edx,%edi
  8004e7:	89 d6                	mov    %edx,%esi
  8004e9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8004eb:	5b                   	pop    %ebx
  8004ec:	5e                   	pop    %esi
  8004ed:	5f                   	pop    %edi
  8004ee:	5d                   	pop    %ebp
  8004ef:	c3                   	ret    

008004f0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8004f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800501:	b8 03 00 00 00       	mov    $0x3,%eax
  800506:	89 cb                	mov    %ecx,%ebx
  800508:	89 cf                	mov    %ecx,%edi
  80050a:	89 ce                	mov    %ecx,%esi
  80050c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80050e:	85 c0                	test   %eax,%eax
  800510:	7f 08                	jg     80051a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800512:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800515:	5b                   	pop    %ebx
  800516:	5e                   	pop    %esi
  800517:	5f                   	pop    %edi
  800518:	5d                   	pop    %ebp
  800519:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	6a 03                	push   $0x3
  800520:	68 2f 23 80 00       	push   $0x80232f
  800525:	6a 23                	push   $0x23
  800527:	68 4c 23 80 00       	push   $0x80234c
  80052c:	e8 b1 13 00 00       	call   8018e2 <_panic>

00800531 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	57                   	push   %edi
  800535:	56                   	push   %esi
  800536:	53                   	push   %ebx
	asm volatile("int %1\n"
  800537:	ba 00 00 00 00       	mov    $0x0,%edx
  80053c:	b8 02 00 00 00       	mov    $0x2,%eax
  800541:	89 d1                	mov    %edx,%ecx
  800543:	89 d3                	mov    %edx,%ebx
  800545:	89 d7                	mov    %edx,%edi
  800547:	89 d6                	mov    %edx,%esi
  800549:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80054b:	5b                   	pop    %ebx
  80054c:	5e                   	pop    %esi
  80054d:	5f                   	pop    %edi
  80054e:	5d                   	pop    %ebp
  80054f:	c3                   	ret    

00800550 <sys_yield>:

void
sys_yield(void)
{
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	57                   	push   %edi
  800554:	56                   	push   %esi
  800555:	53                   	push   %ebx
	asm volatile("int %1\n"
  800556:	ba 00 00 00 00       	mov    $0x0,%edx
  80055b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800560:	89 d1                	mov    %edx,%ecx
  800562:	89 d3                	mov    %edx,%ebx
  800564:	89 d7                	mov    %edx,%edi
  800566:	89 d6                	mov    %edx,%esi
  800568:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80056a:	5b                   	pop    %ebx
  80056b:	5e                   	pop    %esi
  80056c:	5f                   	pop    %edi
  80056d:	5d                   	pop    %ebp
  80056e:	c3                   	ret    

0080056f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	57                   	push   %edi
  800573:	56                   	push   %esi
  800574:	53                   	push   %ebx
  800575:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800578:	be 00 00 00 00       	mov    $0x0,%esi
  80057d:	8b 55 08             	mov    0x8(%ebp),%edx
  800580:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800583:	b8 04 00 00 00       	mov    $0x4,%eax
  800588:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058b:	89 f7                	mov    %esi,%edi
  80058d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80058f:	85 c0                	test   %eax,%eax
  800591:	7f 08                	jg     80059b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800593:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800596:	5b                   	pop    %ebx
  800597:	5e                   	pop    %esi
  800598:	5f                   	pop    %edi
  800599:	5d                   	pop    %ebp
  80059a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80059b:	83 ec 0c             	sub    $0xc,%esp
  80059e:	50                   	push   %eax
  80059f:	6a 04                	push   $0x4
  8005a1:	68 2f 23 80 00       	push   $0x80232f
  8005a6:	6a 23                	push   $0x23
  8005a8:	68 4c 23 80 00       	push   $0x80234c
  8005ad:	e8 30 13 00 00       	call   8018e2 <_panic>

008005b2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	57                   	push   %edi
  8005b6:	56                   	push   %esi
  8005b7:	53                   	push   %ebx
  8005b8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8005be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c1:	b8 05 00 00 00       	mov    $0x5,%eax
  8005c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005c9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8005cc:	8b 75 18             	mov    0x18(%ebp),%esi
  8005cf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	7f 08                	jg     8005dd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8005d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d8:	5b                   	pop    %ebx
  8005d9:	5e                   	pop    %esi
  8005da:	5f                   	pop    %edi
  8005db:	5d                   	pop    %ebp
  8005dc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	50                   	push   %eax
  8005e1:	6a 05                	push   $0x5
  8005e3:	68 2f 23 80 00       	push   $0x80232f
  8005e8:	6a 23                	push   $0x23
  8005ea:	68 4c 23 80 00       	push   $0x80234c
  8005ef:	e8 ee 12 00 00       	call   8018e2 <_panic>

008005f4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	57                   	push   %edi
  8005f8:	56                   	push   %esi
  8005f9:	53                   	push   %ebx
  8005fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800602:	8b 55 08             	mov    0x8(%ebp),%edx
  800605:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800608:	b8 06 00 00 00       	mov    $0x6,%eax
  80060d:	89 df                	mov    %ebx,%edi
  80060f:	89 de                	mov    %ebx,%esi
  800611:	cd 30                	int    $0x30
	if(check && ret > 0)
  800613:	85 c0                	test   %eax,%eax
  800615:	7f 08                	jg     80061f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800617:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80061a:	5b                   	pop    %ebx
  80061b:	5e                   	pop    %esi
  80061c:	5f                   	pop    %edi
  80061d:	5d                   	pop    %ebp
  80061e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80061f:	83 ec 0c             	sub    $0xc,%esp
  800622:	50                   	push   %eax
  800623:	6a 06                	push   $0x6
  800625:	68 2f 23 80 00       	push   $0x80232f
  80062a:	6a 23                	push   $0x23
  80062c:	68 4c 23 80 00       	push   $0x80234c
  800631:	e8 ac 12 00 00       	call   8018e2 <_panic>

00800636 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	57                   	push   %edi
  80063a:	56                   	push   %esi
  80063b:	53                   	push   %ebx
  80063c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80063f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800644:	8b 55 08             	mov    0x8(%ebp),%edx
  800647:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80064a:	b8 08 00 00 00       	mov    $0x8,%eax
  80064f:	89 df                	mov    %ebx,%edi
  800651:	89 de                	mov    %ebx,%esi
  800653:	cd 30                	int    $0x30
	if(check && ret > 0)
  800655:	85 c0                	test   %eax,%eax
  800657:	7f 08                	jg     800661 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800659:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80065c:	5b                   	pop    %ebx
  80065d:	5e                   	pop    %esi
  80065e:	5f                   	pop    %edi
  80065f:	5d                   	pop    %ebp
  800660:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	6a 08                	push   $0x8
  800667:	68 2f 23 80 00       	push   $0x80232f
  80066c:	6a 23                	push   $0x23
  80066e:	68 4c 23 80 00       	push   $0x80234c
  800673:	e8 6a 12 00 00       	call   8018e2 <_panic>

00800678 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	57                   	push   %edi
  80067c:	56                   	push   %esi
  80067d:	53                   	push   %ebx
  80067e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800681:	bb 00 00 00 00       	mov    $0x0,%ebx
  800686:	8b 55 08             	mov    0x8(%ebp),%edx
  800689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068c:	b8 09 00 00 00       	mov    $0x9,%eax
  800691:	89 df                	mov    %ebx,%edi
  800693:	89 de                	mov    %ebx,%esi
  800695:	cd 30                	int    $0x30
	if(check && ret > 0)
  800697:	85 c0                	test   %eax,%eax
  800699:	7f 08                	jg     8006a3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80069b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069e:	5b                   	pop    %ebx
  80069f:	5e                   	pop    %esi
  8006a0:	5f                   	pop    %edi
  8006a1:	5d                   	pop    %ebp
  8006a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006a3:	83 ec 0c             	sub    $0xc,%esp
  8006a6:	50                   	push   %eax
  8006a7:	6a 09                	push   $0x9
  8006a9:	68 2f 23 80 00       	push   $0x80232f
  8006ae:	6a 23                	push   $0x23
  8006b0:	68 4c 23 80 00       	push   $0x80234c
  8006b5:	e8 28 12 00 00       	call   8018e2 <_panic>

008006ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
  8006bd:	57                   	push   %edi
  8006be:	56                   	push   %esi
  8006bf:	53                   	push   %ebx
  8006c0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d3:	89 df                	mov    %ebx,%edi
  8006d5:	89 de                	mov    %ebx,%esi
  8006d7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006d9:	85 c0                	test   %eax,%eax
  8006db:	7f 08                	jg     8006e5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8006dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006e0:	5b                   	pop    %ebx
  8006e1:	5e                   	pop    %esi
  8006e2:	5f                   	pop    %edi
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	50                   	push   %eax
  8006e9:	6a 0a                	push   $0xa
  8006eb:	68 2f 23 80 00       	push   $0x80232f
  8006f0:	6a 23                	push   $0x23
  8006f2:	68 4c 23 80 00       	push   $0x80234c
  8006f7:	e8 e6 11 00 00       	call   8018e2 <_panic>

008006fc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	57                   	push   %edi
  800700:	56                   	push   %esi
  800701:	53                   	push   %ebx
	asm volatile("int %1\n"
  800702:	8b 55 08             	mov    0x8(%ebp),%edx
  800705:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800708:	b8 0c 00 00 00       	mov    $0xc,%eax
  80070d:	be 00 00 00 00       	mov    $0x0,%esi
  800712:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800715:	8b 7d 14             	mov    0x14(%ebp),%edi
  800718:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	57                   	push   %edi
  800723:	56                   	push   %esi
  800724:	53                   	push   %ebx
  800725:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072d:	8b 55 08             	mov    0x8(%ebp),%edx
  800730:	b8 0d 00 00 00       	mov    $0xd,%eax
  800735:	89 cb                	mov    %ecx,%ebx
  800737:	89 cf                	mov    %ecx,%edi
  800739:	89 ce                	mov    %ecx,%esi
  80073b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80073d:	85 c0                	test   %eax,%eax
  80073f:	7f 08                	jg     800749 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800741:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800744:	5b                   	pop    %ebx
  800745:	5e                   	pop    %esi
  800746:	5f                   	pop    %edi
  800747:	5d                   	pop    %ebp
  800748:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	50                   	push   %eax
  80074d:	6a 0d                	push   $0xd
  80074f:	68 2f 23 80 00       	push   $0x80232f
  800754:	6a 23                	push   $0x23
  800756:	68 4c 23 80 00       	push   $0x80234c
  80075b:	e8 82 11 00 00       	call   8018e2 <_panic>

00800760 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	57                   	push   %edi
  800764:	56                   	push   %esi
  800765:	53                   	push   %ebx
	asm volatile("int %1\n"
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
  80076b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800770:	89 d1                	mov    %edx,%ecx
  800772:	89 d3                	mov    %edx,%ebx
  800774:	89 d7                	mov    %edx,%edi
  800776:	89 d6                	mov    %edx,%esi
  800778:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80077a:	5b                   	pop    %ebx
  80077b:	5e                   	pop    %esi
  80077c:	5f                   	pop    %edi
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	05 00 00 00 30       	add    $0x30000000,%eax
  80078a:	c1 e8 0c             	shr    $0xc,%eax
}
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80079a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80079f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8007a4:	5d                   	pop    %ebp
  8007a5:	c3                   	ret    

008007a6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8007ae:	89 c2                	mov    %eax,%edx
  8007b0:	c1 ea 16             	shr    $0x16,%edx
  8007b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8007ba:	f6 c2 01             	test   $0x1,%dl
  8007bd:	74 2d                	je     8007ec <fd_alloc+0x46>
  8007bf:	89 c2                	mov    %eax,%edx
  8007c1:	c1 ea 0c             	shr    $0xc,%edx
  8007c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007cb:	f6 c2 01             	test   $0x1,%dl
  8007ce:	74 1c                	je     8007ec <fd_alloc+0x46>
  8007d0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8007d5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8007da:	75 d2                	jne    8007ae <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8007e5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8007ea:	eb 0a                	jmp    8007f6 <fd_alloc+0x50>
			*fd_store = fd;
  8007ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ef:	89 01                	mov    %eax,(%ecx)
			return 0;
  8007f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8007fe:	83 f8 1f             	cmp    $0x1f,%eax
  800801:	77 30                	ja     800833 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800803:	c1 e0 0c             	shl    $0xc,%eax
  800806:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80080b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800811:	f6 c2 01             	test   $0x1,%dl
  800814:	74 24                	je     80083a <fd_lookup+0x42>
  800816:	89 c2                	mov    %eax,%edx
  800818:	c1 ea 0c             	shr    $0xc,%edx
  80081b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800822:	f6 c2 01             	test   $0x1,%dl
  800825:	74 1a                	je     800841 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082a:	89 02                	mov    %eax,(%edx)
	return 0;
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    
		return -E_INVAL;
  800833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800838:	eb f7                	jmp    800831 <fd_lookup+0x39>
		return -E_INVAL;
  80083a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083f:	eb f0                	jmp    800831 <fd_lookup+0x39>
  800841:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800846:	eb e9                	jmp    800831 <fd_lookup+0x39>

00800848 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800851:	ba 00 00 00 00       	mov    $0x0,%edx
  800856:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80085b:	39 08                	cmp    %ecx,(%eax)
  80085d:	74 38                	je     800897 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80085f:	83 c2 01             	add    $0x1,%edx
  800862:	8b 04 95 d8 23 80 00 	mov    0x8023d8(,%edx,4),%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	75 ee                	jne    80085b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80086d:	a1 08 40 80 00       	mov    0x804008,%eax
  800872:	8b 40 48             	mov    0x48(%eax),%eax
  800875:	83 ec 04             	sub    $0x4,%esp
  800878:	51                   	push   %ecx
  800879:	50                   	push   %eax
  80087a:	68 5c 23 80 00       	push   $0x80235c
  80087f:	e8 39 11 00 00       	call   8019bd <cprintf>
	*dev = 0;
  800884:	8b 45 0c             	mov    0xc(%ebp),%eax
  800887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800895:	c9                   	leave  
  800896:	c3                   	ret    
			*dev = devtab[i];
  800897:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a1:	eb f2                	jmp    800895 <dev_lookup+0x4d>

008008a3 <fd_close>:
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	57                   	push   %edi
  8008a7:	56                   	push   %esi
  8008a8:	53                   	push   %ebx
  8008a9:	83 ec 24             	sub    $0x24,%esp
  8008ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8008af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8008b5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8008b6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8008bc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8008bf:	50                   	push   %eax
  8008c0:	e8 33 ff ff ff       	call   8007f8 <fd_lookup>
  8008c5:	89 c3                	mov    %eax,%ebx
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	85 c0                	test   %eax,%eax
  8008cc:	78 05                	js     8008d3 <fd_close+0x30>
	    || fd != fd2)
  8008ce:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8008d1:	74 16                	je     8008e9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8008d3:	89 f8                	mov    %edi,%eax
  8008d5:	84 c0                	test   %al,%al
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	0f 44 d8             	cmove  %eax,%ebx
}
  8008df:	89 d8                	mov    %ebx,%eax
  8008e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5f                   	pop    %edi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8008ef:	50                   	push   %eax
  8008f0:	ff 36                	pushl  (%esi)
  8008f2:	e8 51 ff ff ff       	call   800848 <dev_lookup>
  8008f7:	89 c3                	mov    %eax,%ebx
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	85 c0                	test   %eax,%eax
  8008fe:	78 1a                	js     80091a <fd_close+0x77>
		if (dev->dev_close)
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800906:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80090b:	85 c0                	test   %eax,%eax
  80090d:	74 0b                	je     80091a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80090f:	83 ec 0c             	sub    $0xc,%esp
  800912:	56                   	push   %esi
  800913:	ff d0                	call   *%eax
  800915:	89 c3                	mov    %eax,%ebx
  800917:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	56                   	push   %esi
  80091e:	6a 00                	push   $0x0
  800920:	e8 cf fc ff ff       	call   8005f4 <sys_page_unmap>
	return r;
  800925:	83 c4 10             	add    $0x10,%esp
  800928:	eb b5                	jmp    8008df <fd_close+0x3c>

0080092a <close>:

int
close(int fdnum)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800930:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800933:	50                   	push   %eax
  800934:	ff 75 08             	pushl  0x8(%ebp)
  800937:	e8 bc fe ff ff       	call   8007f8 <fd_lookup>
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	85 c0                	test   %eax,%eax
  800941:	79 02                	jns    800945 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  800943:	c9                   	leave  
  800944:	c3                   	ret    
		return fd_close(fd, 1);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	6a 01                	push   $0x1
  80094a:	ff 75 f4             	pushl  -0xc(%ebp)
  80094d:	e8 51 ff ff ff       	call   8008a3 <fd_close>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	eb ec                	jmp    800943 <close+0x19>

00800957 <close_all>:

void
close_all(void)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80095e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	53                   	push   %ebx
  800967:	e8 be ff ff ff       	call   80092a <close>
	for (i = 0; i < MAXFD; i++)
  80096c:	83 c3 01             	add    $0x1,%ebx
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	83 fb 20             	cmp    $0x20,%ebx
  800975:	75 ec                	jne    800963 <close_all+0xc>
}
  800977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	57                   	push   %edi
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800985:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800988:	50                   	push   %eax
  800989:	ff 75 08             	pushl  0x8(%ebp)
  80098c:	e8 67 fe ff ff       	call   8007f8 <fd_lookup>
  800991:	89 c3                	mov    %eax,%ebx
  800993:	83 c4 10             	add    $0x10,%esp
  800996:	85 c0                	test   %eax,%eax
  800998:	0f 88 81 00 00 00    	js     800a1f <dup+0xa3>
		return r;
	close(newfdnum);
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	e8 81 ff ff ff       	call   80092a <close>

	newfd = INDEX2FD(newfdnum);
  8009a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ac:	c1 e6 0c             	shl    $0xc,%esi
  8009af:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8009b5:	83 c4 04             	add    $0x4,%esp
  8009b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009bb:	e8 cf fd ff ff       	call   80078f <fd2data>
  8009c0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8009c2:	89 34 24             	mov    %esi,(%esp)
  8009c5:	e8 c5 fd ff ff       	call   80078f <fd2data>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009cf:	89 d8                	mov    %ebx,%eax
  8009d1:	c1 e8 16             	shr    $0x16,%eax
  8009d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8009db:	a8 01                	test   $0x1,%al
  8009dd:	74 11                	je     8009f0 <dup+0x74>
  8009df:	89 d8                	mov    %ebx,%eax
  8009e1:	c1 e8 0c             	shr    $0xc,%eax
  8009e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8009eb:	f6 c2 01             	test   $0x1,%dl
  8009ee:	75 39                	jne    800a29 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f3:	89 d0                	mov    %edx,%eax
  8009f5:	c1 e8 0c             	shr    $0xc,%eax
  8009f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8009ff:	83 ec 0c             	sub    $0xc,%esp
  800a02:	25 07 0e 00 00       	and    $0xe07,%eax
  800a07:	50                   	push   %eax
  800a08:	56                   	push   %esi
  800a09:	6a 00                	push   $0x0
  800a0b:	52                   	push   %edx
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 9f fb ff ff       	call   8005b2 <sys_page_map>
  800a13:	89 c3                	mov    %eax,%ebx
  800a15:	83 c4 20             	add    $0x20,%esp
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	78 31                	js     800a4d <dup+0xd1>
		goto err;

	return newfdnum;
  800a1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800a1f:	89 d8                	mov    %ebx,%eax
  800a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5f                   	pop    %edi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a29:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800a30:	83 ec 0c             	sub    $0xc,%esp
  800a33:	25 07 0e 00 00       	and    $0xe07,%eax
  800a38:	50                   	push   %eax
  800a39:	57                   	push   %edi
  800a3a:	6a 00                	push   $0x0
  800a3c:	53                   	push   %ebx
  800a3d:	6a 00                	push   $0x0
  800a3f:	e8 6e fb ff ff       	call   8005b2 <sys_page_map>
  800a44:	89 c3                	mov    %eax,%ebx
  800a46:	83 c4 20             	add    $0x20,%esp
  800a49:	85 c0                	test   %eax,%eax
  800a4b:	79 a3                	jns    8009f0 <dup+0x74>
	sys_page_unmap(0, newfd);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	56                   	push   %esi
  800a51:	6a 00                	push   $0x0
  800a53:	e8 9c fb ff ff       	call   8005f4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800a58:	83 c4 08             	add    $0x8,%esp
  800a5b:	57                   	push   %edi
  800a5c:	6a 00                	push   $0x0
  800a5e:	e8 91 fb ff ff       	call   8005f4 <sys_page_unmap>
	return r;
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	eb b7                	jmp    800a1f <dup+0xa3>

00800a68 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	53                   	push   %ebx
  800a6c:	83 ec 1c             	sub    $0x1c,%esp
  800a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a75:	50                   	push   %eax
  800a76:	53                   	push   %ebx
  800a77:	e8 7c fd ff ff       	call   8007f8 <fd_lookup>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	78 3f                	js     800ac2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a89:	50                   	push   %eax
  800a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8d:	ff 30                	pushl  (%eax)
  800a8f:	e8 b4 fd ff ff       	call   800848 <dev_lookup>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	85 c0                	test   %eax,%eax
  800a99:	78 27                	js     800ac2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800a9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a9e:	8b 42 08             	mov    0x8(%edx),%eax
  800aa1:	83 e0 03             	and    $0x3,%eax
  800aa4:	83 f8 01             	cmp    $0x1,%eax
  800aa7:	74 1e                	je     800ac7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aac:	8b 40 08             	mov    0x8(%eax),%eax
  800aaf:	85 c0                	test   %eax,%eax
  800ab1:	74 35                	je     800ae8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	ff 75 10             	pushl  0x10(%ebp)
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	52                   	push   %edx
  800abd:	ff d0                	call   *%eax
  800abf:	83 c4 10             	add    $0x10,%esp
}
  800ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800ac7:	a1 08 40 80 00       	mov    0x804008,%eax
  800acc:	8b 40 48             	mov    0x48(%eax),%eax
  800acf:	83 ec 04             	sub    $0x4,%esp
  800ad2:	53                   	push   %ebx
  800ad3:	50                   	push   %eax
  800ad4:	68 9d 23 80 00       	push   $0x80239d
  800ad9:	e8 df 0e 00 00       	call   8019bd <cprintf>
		return -E_INVAL;
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae6:	eb da                	jmp    800ac2 <read+0x5a>
		return -E_NOT_SUPP;
  800ae8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800aed:	eb d3                	jmp    800ac2 <read+0x5a>

00800aef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	83 ec 0c             	sub    $0xc,%esp
  800af8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800afe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b03:	39 f3                	cmp    %esi,%ebx
  800b05:	73 23                	jae    800b2a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b07:	83 ec 04             	sub    $0x4,%esp
  800b0a:	89 f0                	mov    %esi,%eax
  800b0c:	29 d8                	sub    %ebx,%eax
  800b0e:	50                   	push   %eax
  800b0f:	89 d8                	mov    %ebx,%eax
  800b11:	03 45 0c             	add    0xc(%ebp),%eax
  800b14:	50                   	push   %eax
  800b15:	57                   	push   %edi
  800b16:	e8 4d ff ff ff       	call   800a68 <read>
		if (m < 0)
  800b1b:	83 c4 10             	add    $0x10,%esp
  800b1e:	85 c0                	test   %eax,%eax
  800b20:	78 06                	js     800b28 <readn+0x39>
			return m;
		if (m == 0)
  800b22:	74 06                	je     800b2a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  800b24:	01 c3                	add    %eax,%ebx
  800b26:	eb db                	jmp    800b03 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b28:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800b2a:	89 d8                	mov    %ebx,%eax
  800b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	53                   	push   %ebx
  800b38:	83 ec 1c             	sub    $0x1c,%esp
  800b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b3e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b41:	50                   	push   %eax
  800b42:	53                   	push   %ebx
  800b43:	e8 b0 fc ff ff       	call   8007f8 <fd_lookup>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	85 c0                	test   %eax,%eax
  800b4d:	78 3a                	js     800b89 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b55:	50                   	push   %eax
  800b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b59:	ff 30                	pushl  (%eax)
  800b5b:	e8 e8 fc ff ff       	call   800848 <dev_lookup>
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	85 c0                	test   %eax,%eax
  800b65:	78 22                	js     800b89 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800b6e:	74 1e                	je     800b8e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b73:	8b 52 0c             	mov    0xc(%edx),%edx
  800b76:	85 d2                	test   %edx,%edx
  800b78:	74 35                	je     800baf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800b7a:	83 ec 04             	sub    $0x4,%esp
  800b7d:	ff 75 10             	pushl  0x10(%ebp)
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	50                   	push   %eax
  800b84:	ff d2                	call   *%edx
  800b86:	83 c4 10             	add    $0x10,%esp
}
  800b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800b8e:	a1 08 40 80 00       	mov    0x804008,%eax
  800b93:	8b 40 48             	mov    0x48(%eax),%eax
  800b96:	83 ec 04             	sub    $0x4,%esp
  800b99:	53                   	push   %ebx
  800b9a:	50                   	push   %eax
  800b9b:	68 b9 23 80 00       	push   $0x8023b9
  800ba0:	e8 18 0e 00 00       	call   8019bd <cprintf>
		return -E_INVAL;
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bad:	eb da                	jmp    800b89 <write+0x55>
		return -E_NOT_SUPP;
  800baf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800bb4:	eb d3                	jmp    800b89 <write+0x55>

00800bb6 <seek>:

int
seek(int fdnum, off_t offset)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	ff 75 08             	pushl  0x8(%ebp)
  800bc3:	e8 30 fc ff ff       	call   8007f8 <fd_lookup>
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	85 c0                	test   %eax,%eax
  800bcd:	78 0e                	js     800bdd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	53                   	push   %ebx
  800be3:	83 ec 1c             	sub    $0x1c,%esp
  800be6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bec:	50                   	push   %eax
  800bed:	53                   	push   %ebx
  800bee:	e8 05 fc ff ff       	call   8007f8 <fd_lookup>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	85 c0                	test   %eax,%eax
  800bf8:	78 37                	js     800c31 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c00:	50                   	push   %eax
  800c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c04:	ff 30                	pushl  (%eax)
  800c06:	e8 3d fc ff ff       	call   800848 <dev_lookup>
  800c0b:	83 c4 10             	add    $0x10,%esp
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	78 1f                	js     800c31 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c15:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c19:	74 1b                	je     800c36 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1e:	8b 52 18             	mov    0x18(%edx),%edx
  800c21:	85 d2                	test   %edx,%edx
  800c23:	74 32                	je     800c57 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	50                   	push   %eax
  800c2c:	ff d2                	call   *%edx
  800c2e:	83 c4 10             	add    $0x10,%esp
}
  800c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    
			thisenv->env_id, fdnum);
  800c36:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c3b:	8b 40 48             	mov    0x48(%eax),%eax
  800c3e:	83 ec 04             	sub    $0x4,%esp
  800c41:	53                   	push   %ebx
  800c42:	50                   	push   %eax
  800c43:	68 7c 23 80 00       	push   $0x80237c
  800c48:	e8 70 0d 00 00       	call   8019bd <cprintf>
		return -E_INVAL;
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c55:	eb da                	jmp    800c31 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800c57:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c5c:	eb d3                	jmp    800c31 <ftruncate+0x52>

00800c5e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	53                   	push   %ebx
  800c62:	83 ec 1c             	sub    $0x1c,%esp
  800c65:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c6b:	50                   	push   %eax
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 84 fb ff ff       	call   8007f8 <fd_lookup>
  800c74:	83 c4 10             	add    $0x10,%esp
  800c77:	85 c0                	test   %eax,%eax
  800c79:	78 4b                	js     800cc6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c85:	ff 30                	pushl  (%eax)
  800c87:	e8 bc fb ff ff       	call   800848 <dev_lookup>
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	78 33                	js     800cc6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c96:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800c9a:	74 2f                	je     800ccb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800c9c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800c9f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800ca6:	00 00 00 
	stat->st_isdir = 0;
  800ca9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cb0:	00 00 00 
	stat->st_dev = dev;
  800cb3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	53                   	push   %ebx
  800cbd:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc0:	ff 50 14             	call   *0x14(%eax)
  800cc3:	83 c4 10             	add    $0x10,%esp
}
  800cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    
		return -E_NOT_SUPP;
  800ccb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cd0:	eb f4                	jmp    800cc6 <fstat+0x68>

00800cd2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	6a 00                	push   $0x0
  800cdc:	ff 75 08             	pushl  0x8(%ebp)
  800cdf:	e8 2f 02 00 00       	call   800f13 <open>
  800ce4:	89 c3                	mov    %eax,%ebx
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	78 1b                	js     800d08 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	50                   	push   %eax
  800cf4:	e8 65 ff ff ff       	call   800c5e <fstat>
  800cf9:	89 c6                	mov    %eax,%esi
	close(fd);
  800cfb:	89 1c 24             	mov    %ebx,(%esp)
  800cfe:	e8 27 fc ff ff       	call   80092a <close>
	return r;
  800d03:	83 c4 10             	add    $0x10,%esp
  800d06:	89 f3                	mov    %esi,%ebx
}
  800d08:	89 d8                	mov    %ebx,%eax
  800d0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	89 c6                	mov    %eax,%esi
  800d18:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800d1a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800d21:	74 27                	je     800d4a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800d23:	6a 07                	push   $0x7
  800d25:	68 00 50 80 00       	push   $0x805000
  800d2a:	56                   	push   %esi
  800d2b:	ff 35 00 40 80 00    	pushl  0x804000
  800d31:	e8 9d 12 00 00       	call   801fd3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800d36:	83 c4 0c             	add    $0xc,%esp
  800d39:	6a 00                	push   $0x0
  800d3b:	53                   	push   %ebx
  800d3c:	6a 00                	push   $0x0
  800d3e:	e8 1d 12 00 00       	call   801f60 <ipc_recv>
}
  800d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	6a 01                	push   $0x1
  800d4f:	e8 eb 12 00 00       	call   80203f <ipc_find_env>
  800d54:	a3 00 40 80 00       	mov    %eax,0x804000
  800d59:	83 c4 10             	add    $0x10,%esp
  800d5c:	eb c5                	jmp    800d23 <fsipc+0x12>

00800d5e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8b 40 0c             	mov    0xc(%eax),%eax
  800d6a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800d77:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7c:	b8 02 00 00 00       	mov    $0x2,%eax
  800d81:	e8 8b ff ff ff       	call   800d11 <fsipc>
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <devfile_flush>:
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 40 0c             	mov    0xc(%eax),%eax
  800d94:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800d99:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800da3:	e8 69 ff ff ff       	call   800d11 <fsipc>
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <devfile_stat>:
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	53                   	push   %ebx
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8b 40 0c             	mov    0xc(%eax),%eax
  800dba:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc9:	e8 43 ff ff ff       	call   800d11 <fsipc>
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	78 2c                	js     800dfe <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800dd2:	83 ec 08             	sub    $0x8,%esp
  800dd5:	68 00 50 80 00       	push   $0x805000
  800dda:	53                   	push   %ebx
  800ddb:	e8 9d f3 ff ff       	call   80017d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800de0:	a1 80 50 80 00       	mov    0x805080,%eax
  800de5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800deb:	a1 84 50 80 00       	mov    0x805084,%eax
  800df0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800df6:	83 c4 10             	add    $0x10,%esp
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <devfile_write>:
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	53                   	push   %ebx
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if (n_left > 0) {
  800e0d:	85 db                	test   %ebx,%ebx
  800e0f:	75 07                	jne    800e18 <devfile_write+0x15>
	return n_all;
  800e11:	89 d8                	mov    %ebx,%eax
}
  800e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e16:	c9                   	leave  
  800e17:	c3                   	ret    
	  fsipcbuf.write.req_fileid = fd->fd_file.id;
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  800e1e:	a3 00 50 80 00       	mov    %eax,0x805000
	  fsipcbuf.write.req_n = n_left;
  800e23:	89 1d 04 50 80 00    	mov    %ebx,0x805004
    memmove(fsipcbuf.write.req_buf, buf, n);
  800e29:	83 ec 04             	sub    $0x4,%esp
  800e2c:	53                   	push   %ebx
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	68 08 50 80 00       	push   $0x805008
  800e35:	e8 d1 f4 ff ff       	call   80030b <memmove>
	  if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3f:	b8 04 00 00 00       	mov    $0x4,%eax
  800e44:	e8 c8 fe ff ff       	call   800d11 <fsipc>
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	78 c3                	js     800e13 <devfile_write+0x10>
	  assert(r <= n_left);
  800e50:	39 d8                	cmp    %ebx,%eax
  800e52:	77 0b                	ja     800e5f <devfile_write+0x5c>
	  assert(r <= PGSIZE);
  800e54:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800e59:	7f 1d                	jg     800e78 <devfile_write+0x75>
    n_all += r;
  800e5b:	89 c3                	mov    %eax,%ebx
  800e5d:	eb b2                	jmp    800e11 <devfile_write+0xe>
	  assert(r <= n_left);
  800e5f:	68 ec 23 80 00       	push   $0x8023ec
  800e64:	68 f8 23 80 00       	push   $0x8023f8
  800e69:	68 9f 00 00 00       	push   $0x9f
  800e6e:	68 0d 24 80 00       	push   $0x80240d
  800e73:	e8 6a 0a 00 00       	call   8018e2 <_panic>
	  assert(r <= PGSIZE);
  800e78:	68 18 24 80 00       	push   $0x802418
  800e7d:	68 f8 23 80 00       	push   $0x8023f8
  800e82:	68 a0 00 00 00       	push   $0xa0
  800e87:	68 0d 24 80 00       	push   $0x80240d
  800e8c:	e8 51 0a 00 00       	call   8018e2 <_panic>

00800e91 <devfile_read>:
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e9f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ea4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaf:	b8 03 00 00 00       	mov    $0x3,%eax
  800eb4:	e8 58 fe ff ff       	call   800d11 <fsipc>
  800eb9:	89 c3                	mov    %eax,%ebx
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	78 1f                	js     800ede <devfile_read+0x4d>
	assert(r <= n);
  800ebf:	39 f0                	cmp    %esi,%eax
  800ec1:	77 24                	ja     800ee7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800ec3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ec8:	7f 33                	jg     800efd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	68 00 50 80 00       	push   $0x805000
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	e8 30 f4 ff ff       	call   80030b <memmove>
	return r;
  800edb:	83 c4 10             	add    $0x10,%esp
}
  800ede:	89 d8                	mov    %ebx,%eax
  800ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee3:	5b                   	pop    %ebx
  800ee4:	5e                   	pop    %esi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
	assert(r <= n);
  800ee7:	68 24 24 80 00       	push   $0x802424
  800eec:	68 f8 23 80 00       	push   $0x8023f8
  800ef1:	6a 7c                	push   $0x7c
  800ef3:	68 0d 24 80 00       	push   $0x80240d
  800ef8:	e8 e5 09 00 00       	call   8018e2 <_panic>
	assert(r <= PGSIZE);
  800efd:	68 18 24 80 00       	push   $0x802418
  800f02:	68 f8 23 80 00       	push   $0x8023f8
  800f07:	6a 7d                	push   $0x7d
  800f09:	68 0d 24 80 00       	push   $0x80240d
  800f0e:	e8 cf 09 00 00       	call   8018e2 <_panic>

00800f13 <open>:
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 1c             	sub    $0x1c,%esp
  800f1b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800f1e:	56                   	push   %esi
  800f1f:	e8 20 f2 ff ff       	call   800144 <strlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f2c:	7f 6c                	jg     800f9a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 6c f8 ff ff       	call   8007a6 <fd_alloc>
  800f3a:	89 c3                	mov    %eax,%ebx
  800f3c:	83 c4 10             	add    $0x10,%esp
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	78 3c                	js     800f7f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	56                   	push   %esi
  800f47:	68 00 50 80 00       	push   $0x805000
  800f4c:	e8 2c f2 ff ff       	call   80017d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f54:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5c:	b8 01 00 00 00       	mov    $0x1,%eax
  800f61:	e8 ab fd ff ff       	call   800d11 <fsipc>
  800f66:	89 c3                	mov    %eax,%ebx
  800f68:	83 c4 10             	add    $0x10,%esp
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	78 19                	js     800f88 <open+0x75>
	return fd2num(fd);
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	ff 75 f4             	pushl  -0xc(%ebp)
  800f75:	e8 05 f8 ff ff       	call   80077f <fd2num>
  800f7a:	89 c3                	mov    %eax,%ebx
  800f7c:	83 c4 10             	add    $0x10,%esp
}
  800f7f:	89 d8                	mov    %ebx,%eax
  800f81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    
		fd_close(fd, 0);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	6a 00                	push   $0x0
  800f8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f90:	e8 0e f9 ff ff       	call   8008a3 <fd_close>
		return r;
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	eb e5                	jmp    800f7f <open+0x6c>
		return -E_BAD_PATH;
  800f9a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800f9f:	eb de                	jmp    800f7f <open+0x6c>

00800fa1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fac:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb1:	e8 5b fd ff ff       	call   800d11 <fsipc>
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
  800fbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	ff 75 08             	pushl  0x8(%ebp)
  800fc6:	e8 c4 f7 ff ff       	call   80078f <fd2data>
  800fcb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800fcd:	83 c4 08             	add    $0x8,%esp
  800fd0:	68 2b 24 80 00       	push   $0x80242b
  800fd5:	53                   	push   %ebx
  800fd6:	e8 a2 f1 ff ff       	call   80017d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800fdb:	8b 46 04             	mov    0x4(%esi),%eax
  800fde:	2b 06                	sub    (%esi),%eax
  800fe0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800fe6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800fed:	00 00 00 
	stat->st_dev = &devpipe;
  800ff0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800ff7:	30 80 00 
	return 0;
}
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  800fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	53                   	push   %ebx
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801010:	53                   	push   %ebx
  801011:	6a 00                	push   $0x0
  801013:	e8 dc f5 ff ff       	call   8005f4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801018:	89 1c 24             	mov    %ebx,(%esp)
  80101b:	e8 6f f7 ff ff       	call   80078f <fd2data>
  801020:	83 c4 08             	add    $0x8,%esp
  801023:	50                   	push   %eax
  801024:	6a 00                	push   $0x0
  801026:	e8 c9 f5 ff ff       	call   8005f4 <sys_page_unmap>
}
  80102b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <_pipeisclosed>:
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
  801036:	83 ec 1c             	sub    $0x1c,%esp
  801039:	89 c7                	mov    %eax,%edi
  80103b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80103d:	a1 08 40 80 00       	mov    0x804008,%eax
  801042:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801045:	83 ec 0c             	sub    $0xc,%esp
  801048:	57                   	push   %edi
  801049:	e8 2a 10 00 00       	call   802078 <pageref>
  80104e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801051:	89 34 24             	mov    %esi,(%esp)
  801054:	e8 1f 10 00 00       	call   802078 <pageref>
		nn = thisenv->env_runs;
  801059:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80105f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801062:	83 c4 10             	add    $0x10,%esp
  801065:	39 cb                	cmp    %ecx,%ebx
  801067:	74 1b                	je     801084 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801069:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80106c:	75 cf                	jne    80103d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80106e:	8b 42 58             	mov    0x58(%edx),%eax
  801071:	6a 01                	push   $0x1
  801073:	50                   	push   %eax
  801074:	53                   	push   %ebx
  801075:	68 32 24 80 00       	push   $0x802432
  80107a:	e8 3e 09 00 00       	call   8019bd <cprintf>
  80107f:	83 c4 10             	add    $0x10,%esp
  801082:	eb b9                	jmp    80103d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801084:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801087:	0f 94 c0             	sete   %al
  80108a:	0f b6 c0             	movzbl %al,%eax
}
  80108d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <devpipe_write>:
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	57                   	push   %edi
  801099:	56                   	push   %esi
  80109a:	53                   	push   %ebx
  80109b:	83 ec 28             	sub    $0x28,%esp
  80109e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8010a1:	56                   	push   %esi
  8010a2:	e8 e8 f6 ff ff       	call   80078f <fd2data>
  8010a7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8010a9:	83 c4 10             	add    $0x10,%esp
  8010ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8010b4:	74 4f                	je     801105 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8010b6:	8b 43 04             	mov    0x4(%ebx),%eax
  8010b9:	8b 0b                	mov    (%ebx),%ecx
  8010bb:	8d 51 20             	lea    0x20(%ecx),%edx
  8010be:	39 d0                	cmp    %edx,%eax
  8010c0:	72 14                	jb     8010d6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8010c2:	89 da                	mov    %ebx,%edx
  8010c4:	89 f0                	mov    %esi,%eax
  8010c6:	e8 65 ff ff ff       	call   801030 <_pipeisclosed>
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	75 3b                	jne    80110a <devpipe_write+0x75>
			sys_yield();
  8010cf:	e8 7c f4 ff ff       	call   800550 <sys_yield>
  8010d4:	eb e0                	jmp    8010b6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8010dd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8010e0:	89 c2                	mov    %eax,%edx
  8010e2:	c1 fa 1f             	sar    $0x1f,%edx
  8010e5:	89 d1                	mov    %edx,%ecx
  8010e7:	c1 e9 1b             	shr    $0x1b,%ecx
  8010ea:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8010ed:	83 e2 1f             	and    $0x1f,%edx
  8010f0:	29 ca                	sub    %ecx,%edx
  8010f2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8010f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8010fa:	83 c0 01             	add    $0x1,%eax
  8010fd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801100:	83 c7 01             	add    $0x1,%edi
  801103:	eb ac                	jmp    8010b1 <devpipe_write+0x1c>
	return i;
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	eb 05                	jmp    80110f <devpipe_write+0x7a>
				return 0;
  80110a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <devpipe_read>:
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
  80111d:	83 ec 18             	sub    $0x18,%esp
  801120:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801123:	57                   	push   %edi
  801124:	e8 66 f6 ff ff       	call   80078f <fd2data>
  801129:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	be 00 00 00 00       	mov    $0x0,%esi
  801133:	3b 75 10             	cmp    0x10(%ebp),%esi
  801136:	75 14                	jne    80114c <devpipe_read+0x35>
	return i;
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	eb 02                	jmp    80113f <devpipe_read+0x28>
				return i;
  80113d:	89 f0                	mov    %esi,%eax
}
  80113f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801142:	5b                   	pop    %ebx
  801143:	5e                   	pop    %esi
  801144:	5f                   	pop    %edi
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    
			sys_yield();
  801147:	e8 04 f4 ff ff       	call   800550 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80114c:	8b 03                	mov    (%ebx),%eax
  80114e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801151:	75 18                	jne    80116b <devpipe_read+0x54>
			if (i > 0)
  801153:	85 f6                	test   %esi,%esi
  801155:	75 e6                	jne    80113d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801157:	89 da                	mov    %ebx,%edx
  801159:	89 f8                	mov    %edi,%eax
  80115b:	e8 d0 fe ff ff       	call   801030 <_pipeisclosed>
  801160:	85 c0                	test   %eax,%eax
  801162:	74 e3                	je     801147 <devpipe_read+0x30>
				return 0;
  801164:	b8 00 00 00 00       	mov    $0x0,%eax
  801169:	eb d4                	jmp    80113f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80116b:	99                   	cltd   
  80116c:	c1 ea 1b             	shr    $0x1b,%edx
  80116f:	01 d0                	add    %edx,%eax
  801171:	83 e0 1f             	and    $0x1f,%eax
  801174:	29 d0                	sub    %edx,%eax
  801176:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80117b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801181:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801184:	83 c6 01             	add    $0x1,%esi
  801187:	eb aa                	jmp    801133 <devpipe_read+0x1c>

00801189 <pipe>:
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801191:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801194:	50                   	push   %eax
  801195:	e8 0c f6 ff ff       	call   8007a6 <fd_alloc>
  80119a:	89 c3                	mov    %eax,%ebx
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	0f 88 23 01 00 00    	js     8012ca <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011a7:	83 ec 04             	sub    $0x4,%esp
  8011aa:	68 07 04 00 00       	push   $0x407
  8011af:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b2:	6a 00                	push   $0x0
  8011b4:	e8 b6 f3 ff ff       	call   80056f <sys_page_alloc>
  8011b9:	89 c3                	mov    %eax,%ebx
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	0f 88 04 01 00 00    	js     8012ca <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cc:	50                   	push   %eax
  8011cd:	e8 d4 f5 ff ff       	call   8007a6 <fd_alloc>
  8011d2:	89 c3                	mov    %eax,%ebx
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	0f 88 db 00 00 00    	js     8012ba <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	68 07 04 00 00       	push   $0x407
  8011e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8011ea:	6a 00                	push   $0x0
  8011ec:	e8 7e f3 ff ff       	call   80056f <sys_page_alloc>
  8011f1:	89 c3                	mov    %eax,%ebx
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	0f 88 bc 00 00 00    	js     8012ba <pipe+0x131>
	va = fd2data(fd0);
  8011fe:	83 ec 0c             	sub    $0xc,%esp
  801201:	ff 75 f4             	pushl  -0xc(%ebp)
  801204:	e8 86 f5 ff ff       	call   80078f <fd2data>
  801209:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80120b:	83 c4 0c             	add    $0xc,%esp
  80120e:	68 07 04 00 00       	push   $0x407
  801213:	50                   	push   %eax
  801214:	6a 00                	push   $0x0
  801216:	e8 54 f3 ff ff       	call   80056f <sys_page_alloc>
  80121b:	89 c3                	mov    %eax,%ebx
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	0f 88 82 00 00 00    	js     8012aa <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801228:	83 ec 0c             	sub    $0xc,%esp
  80122b:	ff 75 f0             	pushl  -0x10(%ebp)
  80122e:	e8 5c f5 ff ff       	call   80078f <fd2data>
  801233:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80123a:	50                   	push   %eax
  80123b:	6a 00                	push   $0x0
  80123d:	56                   	push   %esi
  80123e:	6a 00                	push   $0x0
  801240:	e8 6d f3 ff ff       	call   8005b2 <sys_page_map>
  801245:	89 c3                	mov    %eax,%ebx
  801247:	83 c4 20             	add    $0x20,%esp
  80124a:	85 c0                	test   %eax,%eax
  80124c:	78 4e                	js     80129c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80124e:	a1 20 30 80 00       	mov    0x803020,%eax
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801262:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801265:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801271:	83 ec 0c             	sub    $0xc,%esp
  801274:	ff 75 f4             	pushl  -0xc(%ebp)
  801277:	e8 03 f5 ff ff       	call   80077f <fd2num>
  80127c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801281:	83 c4 04             	add    $0x4,%esp
  801284:	ff 75 f0             	pushl  -0x10(%ebp)
  801287:	e8 f3 f4 ff ff       	call   80077f <fd2num>
  80128c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80128f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129a:	eb 2e                	jmp    8012ca <pipe+0x141>
	sys_page_unmap(0, va);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	56                   	push   %esi
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 4d f3 ff ff       	call   8005f4 <sys_page_unmap>
  8012a7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8012aa:	83 ec 08             	sub    $0x8,%esp
  8012ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b0:	6a 00                	push   $0x0
  8012b2:	e8 3d f3 ff ff       	call   8005f4 <sys_page_unmap>
  8012b7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c0:	6a 00                	push   $0x0
  8012c2:	e8 2d f3 ff ff       	call   8005f4 <sys_page_unmap>
  8012c7:	83 c4 10             	add    $0x10,%esp
}
  8012ca:	89 d8                	mov    %ebx,%eax
  8012cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <pipeisclosed>:
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012dc:	50                   	push   %eax
  8012dd:	ff 75 08             	pushl  0x8(%ebp)
  8012e0:	e8 13 f5 ff ff       	call   8007f8 <fd_lookup>
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	78 18                	js     801304 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f2:	e8 98 f4 ff ff       	call   80078f <fd2data>
	return _pipeisclosed(fd, p);
  8012f7:	89 c2                	mov    %eax,%edx
  8012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fc:	e8 2f fd ff ff       	call   801030 <_pipeisclosed>
  801301:	83 c4 10             	add    $0x10,%esp
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80130c:	68 4a 24 80 00       	push   $0x80244a
  801311:	ff 75 0c             	pushl  0xc(%ebp)
  801314:	e8 64 ee ff ff       	call   80017d <strcpy>
	return 0;
}
  801319:	b8 00 00 00 00       	mov    $0x0,%eax
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <devsock_close>:
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	53                   	push   %ebx
  801324:	83 ec 10             	sub    $0x10,%esp
  801327:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80132a:	53                   	push   %ebx
  80132b:	e8 48 0d 00 00       	call   802078 <pageref>
  801330:	83 c4 10             	add    $0x10,%esp
		return 0;
  801333:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801338:	83 f8 01             	cmp    $0x1,%eax
  80133b:	74 07                	je     801344 <devsock_close+0x24>
}
  80133d:	89 d0                	mov    %edx,%eax
  80133f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801342:	c9                   	leave  
  801343:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801344:	83 ec 0c             	sub    $0xc,%esp
  801347:	ff 73 0c             	pushl  0xc(%ebx)
  80134a:	e8 b9 02 00 00       	call   801608 <nsipc_close>
  80134f:	89 c2                	mov    %eax,%edx
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	eb e7                	jmp    80133d <devsock_close+0x1d>

00801356 <devsock_write>:
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	ff 75 10             	pushl  0x10(%ebp)
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	ff 70 0c             	pushl  0xc(%eax)
  80136a:	e8 76 03 00 00       	call   8016e5 <nsipc_send>
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <devsock_read>:
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801377:	6a 00                	push   $0x0
  801379:	ff 75 10             	pushl  0x10(%ebp)
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	ff 70 0c             	pushl  0xc(%eax)
  801385:	e8 ef 02 00 00       	call   801679 <nsipc_recv>
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <fd2sockid>:
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801392:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801395:	52                   	push   %edx
  801396:	50                   	push   %eax
  801397:	e8 5c f4 ff ff       	call   8007f8 <fd_lookup>
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 10                	js     8013b3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8013a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a6:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  8013ac:	39 08                	cmp    %ecx,(%eax)
  8013ae:	75 05                	jne    8013b5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8013b0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    
		return -E_NOT_SUPP;
  8013b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ba:	eb f7                	jmp    8013b3 <fd2sockid+0x27>

008013bc <alloc_sockfd>:
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	56                   	push   %esi
  8013c0:	53                   	push   %ebx
  8013c1:	83 ec 1c             	sub    $0x1c,%esp
  8013c4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8013c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c9:	50                   	push   %eax
  8013ca:	e8 d7 f3 ff ff       	call   8007a6 <fd_alloc>
  8013cf:	89 c3                	mov    %eax,%ebx
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	78 43                	js     80141b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	68 07 04 00 00       	push   $0x407
  8013e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e3:	6a 00                	push   $0x0
  8013e5:	e8 85 f1 ff ff       	call   80056f <sys_page_alloc>
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 28                	js     80141b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8013f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8013fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8013fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801401:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801408:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	50                   	push   %eax
  80140f:	e8 6b f3 ff ff       	call   80077f <fd2num>
  801414:	89 c3                	mov    %eax,%ebx
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	eb 0c                	jmp    801427 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	56                   	push   %esi
  80141f:	e8 e4 01 00 00       	call   801608 <nsipc_close>
		return r;
  801424:	83 c4 10             	add    $0x10,%esp
}
  801427:	89 d8                	mov    %ebx,%eax
  801429:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142c:	5b                   	pop    %ebx
  80142d:	5e                   	pop    %esi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <accept>:
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	e8 4e ff ff ff       	call   80138c <fd2sockid>
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 1b                	js     80145d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	ff 75 10             	pushl  0x10(%ebp)
  801448:	ff 75 0c             	pushl  0xc(%ebp)
  80144b:	50                   	push   %eax
  80144c:	e8 0e 01 00 00       	call   80155f <nsipc_accept>
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 05                	js     80145d <accept+0x2d>
	return alloc_sockfd(r);
  801458:	e8 5f ff ff ff       	call   8013bc <alloc_sockfd>
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <bind>:
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	e8 1f ff ff ff       	call   80138c <fd2sockid>
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 12                	js     801483 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	ff 75 10             	pushl  0x10(%ebp)
  801477:	ff 75 0c             	pushl  0xc(%ebp)
  80147a:	50                   	push   %eax
  80147b:	e8 31 01 00 00       	call   8015b1 <nsipc_bind>
  801480:	83 c4 10             	add    $0x10,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <shutdown>:
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	e8 f9 fe ff ff       	call   80138c <fd2sockid>
  801493:	85 c0                	test   %eax,%eax
  801495:	78 0f                	js     8014a6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	ff 75 0c             	pushl  0xc(%ebp)
  80149d:	50                   	push   %eax
  80149e:	e8 43 01 00 00       	call   8015e6 <nsipc_shutdown>
  8014a3:	83 c4 10             	add    $0x10,%esp
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <connect>:
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	e8 d6 fe ff ff       	call   80138c <fd2sockid>
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 12                	js     8014cc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	ff 75 10             	pushl  0x10(%ebp)
  8014c0:	ff 75 0c             	pushl  0xc(%ebp)
  8014c3:	50                   	push   %eax
  8014c4:	e8 59 01 00 00       	call   801622 <nsipc_connect>
  8014c9:	83 c4 10             	add    $0x10,%esp
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <listen>:
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	e8 b0 fe ff ff       	call   80138c <fd2sockid>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 0f                	js     8014ef <listen+0x21>
	return nsipc_listen(r, backlog);
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	ff 75 0c             	pushl  0xc(%ebp)
  8014e6:	50                   	push   %eax
  8014e7:	e8 6b 01 00 00       	call   801657 <nsipc_listen>
  8014ec:	83 c4 10             	add    $0x10,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8014f7:	ff 75 10             	pushl  0x10(%ebp)
  8014fa:	ff 75 0c             	pushl  0xc(%ebp)
  8014fd:	ff 75 08             	pushl  0x8(%ebp)
  801500:	e8 3e 02 00 00       	call   801743 <nsipc_socket>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	78 05                	js     801511 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80150c:	e8 ab fe ff ff       	call   8013bc <alloc_sockfd>
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	53                   	push   %ebx
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80151c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801523:	74 26                	je     80154b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801525:	6a 07                	push   $0x7
  801527:	68 00 60 80 00       	push   $0x806000
  80152c:	53                   	push   %ebx
  80152d:	ff 35 04 40 80 00    	pushl  0x804004
  801533:	e8 9b 0a 00 00       	call   801fd3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801538:	83 c4 0c             	add    $0xc,%esp
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	e8 1a 0a 00 00       	call   801f60 <ipc_recv>
}
  801546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801549:	c9                   	leave  
  80154a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	6a 02                	push   $0x2
  801550:	e8 ea 0a 00 00       	call   80203f <ipc_find_env>
  801555:	a3 04 40 80 00       	mov    %eax,0x804004
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	eb c6                	jmp    801525 <nsipc+0x12>

0080155f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80156f:	8b 06                	mov    (%esi),%eax
  801571:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801576:	b8 01 00 00 00       	mov    $0x1,%eax
  80157b:	e8 93 ff ff ff       	call   801513 <nsipc>
  801580:	89 c3                	mov    %eax,%ebx
  801582:	85 c0                	test   %eax,%eax
  801584:	79 09                	jns    80158f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801586:	89 d8                	mov    %ebx,%eax
  801588:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158b:	5b                   	pop    %ebx
  80158c:	5e                   	pop    %esi
  80158d:	5d                   	pop    %ebp
  80158e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80158f:	83 ec 04             	sub    $0x4,%esp
  801592:	ff 35 10 60 80 00    	pushl  0x806010
  801598:	68 00 60 80 00       	push   $0x806000
  80159d:	ff 75 0c             	pushl  0xc(%ebp)
  8015a0:	e8 66 ed ff ff       	call   80030b <memmove>
		*addrlen = ret->ret_addrlen;
  8015a5:	a1 10 60 80 00       	mov    0x806010,%eax
  8015aa:	89 06                	mov    %eax,(%esi)
  8015ac:	83 c4 10             	add    $0x10,%esp
	return r;
  8015af:	eb d5                	jmp    801586 <nsipc_accept+0x27>

008015b1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	53                   	push   %ebx
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8015c3:	53                   	push   %ebx
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	68 04 60 80 00       	push   $0x806004
  8015cc:	e8 3a ed ff ff       	call   80030b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8015d1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8015d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015dc:	e8 32 ff ff ff       	call   801513 <nsipc>
}
  8015e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8015fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801601:	e8 0d ff ff ff       	call   801513 <nsipc>
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <nsipc_close>:

int
nsipc_close(int s)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801616:	b8 04 00 00 00       	mov    $0x4,%eax
  80161b:	e8 f3 fe ff ff       	call   801513 <nsipc>
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	53                   	push   %ebx
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801634:	53                   	push   %ebx
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	68 04 60 80 00       	push   $0x806004
  80163d:	e8 c9 ec ff ff       	call   80030b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801642:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801648:	b8 05 00 00 00       	mov    $0x5,%eax
  80164d:	e8 c1 fe ff ff       	call   801513 <nsipc>
}
  801652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801665:	8b 45 0c             	mov    0xc(%ebp),%eax
  801668:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80166d:	b8 06 00 00 00       	mov    $0x6,%eax
  801672:	e8 9c fe ff ff       	call   801513 <nsipc>
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	56                   	push   %esi
  80167d:	53                   	push   %ebx
  80167e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801689:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80168f:	8b 45 14             	mov    0x14(%ebp),%eax
  801692:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801697:	b8 07 00 00 00       	mov    $0x7,%eax
  80169c:	e8 72 fe ff ff       	call   801513 <nsipc>
  8016a1:	89 c3                	mov    %eax,%ebx
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 1f                	js     8016c6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8016a7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8016ac:	7f 21                	jg     8016cf <nsipc_recv+0x56>
  8016ae:	39 c6                	cmp    %eax,%esi
  8016b0:	7c 1d                	jl     8016cf <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8016b2:	83 ec 04             	sub    $0x4,%esp
  8016b5:	50                   	push   %eax
  8016b6:	68 00 60 80 00       	push   $0x806000
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	e8 48 ec ff ff       	call   80030b <memmove>
  8016c3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8016c6:	89 d8                	mov    %ebx,%eax
  8016c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8016cf:	68 56 24 80 00       	push   $0x802456
  8016d4:	68 f8 23 80 00       	push   $0x8023f8
  8016d9:	6a 62                	push   $0x62
  8016db:	68 6b 24 80 00       	push   $0x80246b
  8016e0:	e8 fd 01 00 00       	call   8018e2 <_panic>

008016e5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8016f7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8016fd:	7f 2e                	jg     80172d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	53                   	push   %ebx
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	68 0c 60 80 00       	push   $0x80600c
  80170b:	e8 fb eb ff ff       	call   80030b <memmove>
	nsipcbuf.send.req_size = size;
  801710:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80171e:	b8 08 00 00 00       	mov    $0x8,%eax
  801723:	e8 eb fd ff ff       	call   801513 <nsipc>
}
  801728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    
	assert(size < 1600);
  80172d:	68 77 24 80 00       	push   $0x802477
  801732:	68 f8 23 80 00       	push   $0x8023f8
  801737:	6a 6d                	push   $0x6d
  801739:	68 6b 24 80 00       	push   $0x80246b
  80173e:	e8 9f 01 00 00       	call   8018e2 <_panic>

00801743 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801751:	8b 45 0c             	mov    0xc(%ebp),%eax
  801754:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801761:	b8 09 00 00 00       	mov    $0x9,%eax
  801766:	e8 a8 fd ff ff       	call   801513 <nsipc>
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	c3                   	ret    

00801773 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801779:	68 83 24 80 00       	push   $0x802483
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	e8 f7 e9 ff ff       	call   80017d <strcpy>
	return 0;
}
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <devcons_write>:
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	57                   	push   %edi
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801799:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80179e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8017a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017a7:	73 31                	jae    8017da <devcons_write+0x4d>
		m = n - tot;
  8017a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017ac:	29 f3                	sub    %esi,%ebx
  8017ae:	83 fb 7f             	cmp    $0x7f,%ebx
  8017b1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8017b6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	53                   	push   %ebx
  8017bd:	89 f0                	mov    %esi,%eax
  8017bf:	03 45 0c             	add    0xc(%ebp),%eax
  8017c2:	50                   	push   %eax
  8017c3:	57                   	push   %edi
  8017c4:	e8 42 eb ff ff       	call   80030b <memmove>
		sys_cputs(buf, m);
  8017c9:	83 c4 08             	add    $0x8,%esp
  8017cc:	53                   	push   %ebx
  8017cd:	57                   	push   %edi
  8017ce:	e8 e0 ec ff ff       	call   8004b3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8017d3:	01 de                	add    %ebx,%esi
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	eb ca                	jmp    8017a4 <devcons_write+0x17>
}
  8017da:	89 f0                	mov    %esi,%eax
  8017dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017df:	5b                   	pop    %ebx
  8017e0:	5e                   	pop    %esi
  8017e1:	5f                   	pop    %edi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    

008017e4 <devcons_read>:
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8017ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f3:	74 21                	je     801816 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8017f5:	e8 d7 ec ff ff       	call   8004d1 <sys_cgetc>
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	75 07                	jne    801805 <devcons_read+0x21>
		sys_yield();
  8017fe:	e8 4d ed ff ff       	call   800550 <sys_yield>
  801803:	eb f0                	jmp    8017f5 <devcons_read+0x11>
	if (c < 0)
  801805:	78 0f                	js     801816 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801807:	83 f8 04             	cmp    $0x4,%eax
  80180a:	74 0c                	je     801818 <devcons_read+0x34>
	*(char*)vbuf = c;
  80180c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180f:	88 02                	mov    %al,(%edx)
	return 1;
  801811:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    
		return 0;
  801818:	b8 00 00 00 00       	mov    $0x0,%eax
  80181d:	eb f7                	jmp    801816 <devcons_read+0x32>

0080181f <cputchar>:
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80182b:	6a 01                	push   $0x1
  80182d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801830:	50                   	push   %eax
  801831:	e8 7d ec ff ff       	call   8004b3 <sys_cputs>
}
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <getchar>:
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801841:	6a 01                	push   $0x1
  801843:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801846:	50                   	push   %eax
  801847:	6a 00                	push   $0x0
  801849:	e8 1a f2 ff ff       	call   800a68 <read>
	if (r < 0)
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	85 c0                	test   %eax,%eax
  801853:	78 06                	js     80185b <getchar+0x20>
	if (r < 1)
  801855:	74 06                	je     80185d <getchar+0x22>
	return c;
  801857:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    
		return -E_EOF;
  80185d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801862:	eb f7                	jmp    80185b <getchar+0x20>

00801864 <iscons>:
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186d:	50                   	push   %eax
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 82 ef ff ff       	call   8007f8 <fd_lookup>
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	85 c0                	test   %eax,%eax
  80187b:	78 11                	js     80188e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80187d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801880:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801886:	39 10                	cmp    %edx,(%eax)
  801888:	0f 94 c0             	sete   %al
  80188b:	0f b6 c0             	movzbl %al,%eax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <opencons>:
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801896:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801899:	50                   	push   %eax
  80189a:	e8 07 ef ff ff       	call   8007a6 <fd_alloc>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 3a                	js     8018e0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	68 07 04 00 00       	push   $0x407
  8018ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b1:	6a 00                	push   $0x0
  8018b3:	e8 b7 ec ff ff       	call   80056f <sys_page_alloc>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 21                	js     8018e0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8018c8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8018ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	50                   	push   %eax
  8018d8:	e8 a2 ee ff ff       	call   80077f <fd2num>
  8018dd:	83 c4 10             	add    $0x10,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	56                   	push   %esi
  8018e6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8018e7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8018ea:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8018f0:	e8 3c ec ff ff       	call   800531 <sys_getenvid>
  8018f5:	83 ec 0c             	sub    $0xc,%esp
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	56                   	push   %esi
  8018ff:	50                   	push   %eax
  801900:	68 90 24 80 00       	push   $0x802490
  801905:	e8 b3 00 00 00       	call   8019bd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80190a:	83 c4 18             	add    $0x18,%esp
  80190d:	53                   	push   %ebx
  80190e:	ff 75 10             	pushl  0x10(%ebp)
  801911:	e8 56 00 00 00       	call   80196c <vcprintf>
	cprintf("\n");
  801916:	c7 04 24 43 24 80 00 	movl   $0x802443,(%esp)
  80191d:	e8 9b 00 00 00       	call   8019bd <cprintf>
  801922:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801925:	cc                   	int3   
  801926:	eb fd                	jmp    801925 <_panic+0x43>

00801928 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	53                   	push   %ebx
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801932:	8b 13                	mov    (%ebx),%edx
  801934:	8d 42 01             	lea    0x1(%edx),%eax
  801937:	89 03                	mov    %eax,(%ebx)
  801939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801940:	3d ff 00 00 00       	cmp    $0xff,%eax
  801945:	74 09                	je     801950 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801947:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80194b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	68 ff 00 00 00       	push   $0xff
  801958:	8d 43 08             	lea    0x8(%ebx),%eax
  80195b:	50                   	push   %eax
  80195c:	e8 52 eb ff ff       	call   8004b3 <sys_cputs>
		b->idx = 0;
  801961:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	eb db                	jmp    801947 <putch+0x1f>

0080196c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801975:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80197c:	00 00 00 
	b.cnt = 0;
  80197f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801986:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801989:	ff 75 0c             	pushl  0xc(%ebp)
  80198c:	ff 75 08             	pushl  0x8(%ebp)
  80198f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801995:	50                   	push   %eax
  801996:	68 28 19 80 00       	push   $0x801928
  80199b:	e8 19 01 00 00       	call   801ab9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8019a0:	83 c4 08             	add    $0x8,%esp
  8019a3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8019a9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8019af:	50                   	push   %eax
  8019b0:	e8 fe ea ff ff       	call   8004b3 <sys_cputs>

	return b.cnt;
}
  8019b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019c3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8019c6:	50                   	push   %eax
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	e8 9d ff ff ff       	call   80196c <vcprintf>
	va_end(ap);

	return cnt;
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	57                   	push   %edi
  8019d5:	56                   	push   %esi
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 1c             	sub    $0x1c,%esp
  8019da:	89 c7                	mov    %eax,%edi
  8019dc:	89 d6                	mov    %edx,%esi
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8019ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8019f5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8019f8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019fb:	89 d0                	mov    %edx,%eax
  8019fd:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  801a00:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a03:	73 15                	jae    801a1a <printnum+0x49>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a05:	83 eb 01             	sub    $0x1,%ebx
  801a08:	85 db                	test   %ebx,%ebx
  801a0a:	7e 43                	jle    801a4f <printnum+0x7e>
			putch(padc, putdat);
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	56                   	push   %esi
  801a10:	ff 75 18             	pushl  0x18(%ebp)
  801a13:	ff d7                	call   *%edi
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	eb eb                	jmp    801a05 <printnum+0x34>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a1a:	83 ec 0c             	sub    $0xc,%esp
  801a1d:	ff 75 18             	pushl  0x18(%ebp)
  801a20:	8b 45 14             	mov    0x14(%ebp),%eax
  801a23:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801a26:	53                   	push   %ebx
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a30:	ff 75 e0             	pushl  -0x20(%ebp)
  801a33:	ff 75 dc             	pushl  -0x24(%ebp)
  801a36:	ff 75 d8             	pushl  -0x28(%ebp)
  801a39:	e8 82 06 00 00       	call   8020c0 <__udivdi3>
  801a3e:	83 c4 18             	add    $0x18,%esp
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	89 f2                	mov    %esi,%edx
  801a45:	89 f8                	mov    %edi,%eax
  801a47:	e8 85 ff ff ff       	call   8019d1 <printnum>
  801a4c:	83 c4 20             	add    $0x20,%esp
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801a4f:	83 ec 08             	sub    $0x8,%esp
  801a52:	56                   	push   %esi
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a59:	ff 75 e0             	pushl  -0x20(%ebp)
  801a5c:	ff 75 dc             	pushl  -0x24(%ebp)
  801a5f:	ff 75 d8             	pushl  -0x28(%ebp)
  801a62:	e8 69 07 00 00       	call   8021d0 <__umoddi3>
  801a67:	83 c4 14             	add    $0x14,%esp
  801a6a:	0f be 80 b3 24 80 00 	movsbl 0x8024b3(%eax),%eax
  801a71:	50                   	push   %eax
  801a72:	ff d7                	call   *%edi
}
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7a:	5b                   	pop    %ebx
  801a7b:	5e                   	pop    %esi
  801a7c:	5f                   	pop    %edi
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    

00801a7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a85:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a89:	8b 10                	mov    (%eax),%edx
  801a8b:	3b 50 04             	cmp    0x4(%eax),%edx
  801a8e:	73 0a                	jae    801a9a <sprintputch+0x1b>
		*b->buf++ = ch;
  801a90:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a93:	89 08                	mov    %ecx,(%eax)
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	88 02                	mov    %al,(%edx)
}
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <printfmt>:
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801aa2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801aa5:	50                   	push   %eax
  801aa6:	ff 75 10             	pushl  0x10(%ebp)
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	e8 05 00 00 00       	call   801ab9 <vprintfmt>
}
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <vprintfmt>:
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	57                   	push   %edi
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	83 ec 3c             	sub    $0x3c,%esp
  801ac2:	8b 75 08             	mov    0x8(%ebp),%esi
  801ac5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ac8:	8b 7d 10             	mov    0x10(%ebp),%edi
  801acb:	eb 0a                	jmp    801ad7 <vprintfmt+0x1e>
			putch(ch, putdat);
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	53                   	push   %ebx
  801ad1:	50                   	push   %eax
  801ad2:	ff d6                	call   *%esi
  801ad4:	83 c4 10             	add    $0x10,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ad7:	83 c7 01             	add    $0x1,%edi
  801ada:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801ade:	83 f8 25             	cmp    $0x25,%eax
  801ae1:	74 0c                	je     801aef <vprintfmt+0x36>
			if (ch == '\0')
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	75 e6                	jne    801acd <vprintfmt+0x14>
}
  801ae7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5f                   	pop    %edi
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    
		padc = ' ';
  801aef:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801af3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801afa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801b01:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801b08:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801b0d:	8d 47 01             	lea    0x1(%edi),%eax
  801b10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b13:	0f b6 17             	movzbl (%edi),%edx
  801b16:	8d 42 dd             	lea    -0x23(%edx),%eax
  801b19:	3c 55                	cmp    $0x55,%al
  801b1b:	0f 87 ba 03 00 00    	ja     801edb <vprintfmt+0x422>
  801b21:	0f b6 c0             	movzbl %al,%eax
  801b24:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  801b2b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801b2e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801b32:	eb d9                	jmp    801b0d <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801b34:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801b37:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801b3b:	eb d0                	jmp    801b0d <vprintfmt+0x54>
		switch (ch = *(unsigned char *) fmt++) {
  801b3d:	0f b6 d2             	movzbl %dl,%edx
  801b40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801b4b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801b4e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801b52:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801b55:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801b58:	83 f9 09             	cmp    $0x9,%ecx
  801b5b:	77 55                	ja     801bb2 <vprintfmt+0xf9>
			for (precision = 0; ; ++fmt) {
  801b5d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801b60:	eb e9                	jmp    801b4b <vprintfmt+0x92>
			precision = va_arg(ap, int);
  801b62:	8b 45 14             	mov    0x14(%ebp),%eax
  801b65:	8b 00                	mov    (%eax),%eax
  801b67:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6d:	8d 40 04             	lea    0x4(%eax),%eax
  801b70:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801b73:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b7a:	79 91                	jns    801b0d <vprintfmt+0x54>
				width = precision, precision = -1;
  801b7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801b89:	eb 82                	jmp    801b0d <vprintfmt+0x54>
  801b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	ba 00 00 00 00       	mov    $0x0,%edx
  801b95:	0f 49 d0             	cmovns %eax,%edx
  801b98:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801b9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801b9e:	e9 6a ff ff ff       	jmp    801b0d <vprintfmt+0x54>
  801ba3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801ba6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801bad:	e9 5b ff ff ff       	jmp    801b0d <vprintfmt+0x54>
  801bb2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801bb5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801bb8:	eb bc                	jmp    801b76 <vprintfmt+0xbd>
			lflag++;
  801bba:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801bbd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801bc0:	e9 48 ff ff ff       	jmp    801b0d <vprintfmt+0x54>
			putch(va_arg(ap, int), putdat);
  801bc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc8:	8d 78 04             	lea    0x4(%eax),%edi
  801bcb:	83 ec 08             	sub    $0x8,%esp
  801bce:	53                   	push   %ebx
  801bcf:	ff 30                	pushl  (%eax)
  801bd1:	ff d6                	call   *%esi
			break;
  801bd3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801bd6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801bd9:	e9 9c 02 00 00       	jmp    801e7a <vprintfmt+0x3c1>
			err = va_arg(ap, int);
  801bde:	8b 45 14             	mov    0x14(%ebp),%eax
  801be1:	8d 78 04             	lea    0x4(%eax),%edi
  801be4:	8b 00                	mov    (%eax),%eax
  801be6:	99                   	cltd   
  801be7:	31 d0                	xor    %edx,%eax
  801be9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801beb:	83 f8 0f             	cmp    $0xf,%eax
  801bee:	7f 23                	jg     801c13 <vprintfmt+0x15a>
  801bf0:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  801bf7:	85 d2                	test   %edx,%edx
  801bf9:	74 18                	je     801c13 <vprintfmt+0x15a>
				printfmt(putch, putdat, "%s", p);
  801bfb:	52                   	push   %edx
  801bfc:	68 0a 24 80 00       	push   $0x80240a
  801c01:	53                   	push   %ebx
  801c02:	56                   	push   %esi
  801c03:	e8 94 fe ff ff       	call   801a9c <printfmt>
  801c08:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801c0b:	89 7d 14             	mov    %edi,0x14(%ebp)
  801c0e:	e9 67 02 00 00       	jmp    801e7a <vprintfmt+0x3c1>
				printfmt(putch, putdat, "error %d", err);
  801c13:	50                   	push   %eax
  801c14:	68 cb 24 80 00       	push   $0x8024cb
  801c19:	53                   	push   %ebx
  801c1a:	56                   	push   %esi
  801c1b:	e8 7c fe ff ff       	call   801a9c <printfmt>
  801c20:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801c23:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801c26:	e9 4f 02 00 00       	jmp    801e7a <vprintfmt+0x3c1>
			if ((p = va_arg(ap, char *)) == NULL)
  801c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2e:	83 c0 04             	add    $0x4,%eax
  801c31:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c34:	8b 45 14             	mov    0x14(%ebp),%eax
  801c37:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801c39:	85 d2                	test   %edx,%edx
  801c3b:	b8 c4 24 80 00       	mov    $0x8024c4,%eax
  801c40:	0f 45 c2             	cmovne %edx,%eax
  801c43:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801c46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c4a:	7e 06                	jle    801c52 <vprintfmt+0x199>
  801c4c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801c50:	75 0d                	jne    801c5f <vprintfmt+0x1a6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c55:	89 c7                	mov    %eax,%edi
  801c57:	03 45 e0             	add    -0x20(%ebp),%eax
  801c5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c5d:	eb 3f                	jmp    801c9e <vprintfmt+0x1e5>
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	ff 75 d8             	pushl  -0x28(%ebp)
  801c65:	50                   	push   %eax
  801c66:	e8 f1 e4 ff ff       	call   80015c <strnlen>
  801c6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6e:	29 c2                	sub    %eax,%edx
  801c70:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801c78:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801c7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801c7f:	85 ff                	test   %edi,%edi
  801c81:	7e 58                	jle    801cdb <vprintfmt+0x222>
					putch(padc, putdat);
  801c83:	83 ec 08             	sub    $0x8,%esp
  801c86:	53                   	push   %ebx
  801c87:	ff 75 e0             	pushl  -0x20(%ebp)
  801c8a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801c8c:	83 ef 01             	sub    $0x1,%edi
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	eb eb                	jmp    801c7f <vprintfmt+0x1c6>
					putch(ch, putdat);
  801c94:	83 ec 08             	sub    $0x8,%esp
  801c97:	53                   	push   %ebx
  801c98:	52                   	push   %edx
  801c99:	ff d6                	call   *%esi
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801ca1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ca3:	83 c7 01             	add    $0x1,%edi
  801ca6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801caa:	0f be d0             	movsbl %al,%edx
  801cad:	85 d2                	test   %edx,%edx
  801caf:	74 45                	je     801cf6 <vprintfmt+0x23d>
  801cb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801cb5:	78 06                	js     801cbd <vprintfmt+0x204>
  801cb7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801cbb:	78 35                	js     801cf2 <vprintfmt+0x239>
				if (altflag && (ch < ' ' || ch > '~'))
  801cbd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801cc1:	74 d1                	je     801c94 <vprintfmt+0x1db>
  801cc3:	0f be c0             	movsbl %al,%eax
  801cc6:	83 e8 20             	sub    $0x20,%eax
  801cc9:	83 f8 5e             	cmp    $0x5e,%eax
  801ccc:	76 c6                	jbe    801c94 <vprintfmt+0x1db>
					putch('?', putdat);
  801cce:	83 ec 08             	sub    $0x8,%esp
  801cd1:	53                   	push   %ebx
  801cd2:	6a 3f                	push   $0x3f
  801cd4:	ff d6                	call   *%esi
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	eb c3                	jmp    801c9e <vprintfmt+0x1e5>
  801cdb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801cde:	85 d2                	test   %edx,%edx
  801ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce5:	0f 49 c2             	cmovns %edx,%eax
  801ce8:	29 c2                	sub    %eax,%edx
  801cea:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801ced:	e9 60 ff ff ff       	jmp    801c52 <vprintfmt+0x199>
  801cf2:	89 cf                	mov    %ecx,%edi
  801cf4:	eb 02                	jmp    801cf8 <vprintfmt+0x23f>
  801cf6:	89 cf                	mov    %ecx,%edi
			for (; width > 0; width--)
  801cf8:	85 ff                	test   %edi,%edi
  801cfa:	7e 10                	jle    801d0c <vprintfmt+0x253>
				putch(' ', putdat);
  801cfc:	83 ec 08             	sub    $0x8,%esp
  801cff:	53                   	push   %ebx
  801d00:	6a 20                	push   $0x20
  801d02:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801d04:	83 ef 01             	sub    $0x1,%edi
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	eb ec                	jmp    801cf8 <vprintfmt+0x23f>
			if ((p = va_arg(ap, char *)) == NULL)
  801d0c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d0f:	89 45 14             	mov    %eax,0x14(%ebp)
  801d12:	e9 63 01 00 00       	jmp    801e7a <vprintfmt+0x3c1>
	if (lflag >= 2)
  801d17:	83 f9 01             	cmp    $0x1,%ecx
  801d1a:	7f 1b                	jg     801d37 <vprintfmt+0x27e>
	else if (lflag)
  801d1c:	85 c9                	test   %ecx,%ecx
  801d1e:	74 63                	je     801d83 <vprintfmt+0x2ca>
		return va_arg(*ap, long);
  801d20:	8b 45 14             	mov    0x14(%ebp),%eax
  801d23:	8b 00                	mov    (%eax),%eax
  801d25:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d28:	99                   	cltd   
  801d29:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2f:	8d 40 04             	lea    0x4(%eax),%eax
  801d32:	89 45 14             	mov    %eax,0x14(%ebp)
  801d35:	eb 17                	jmp    801d4e <vprintfmt+0x295>
		return va_arg(*ap, long long);
  801d37:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3a:	8b 50 04             	mov    0x4(%eax),%edx
  801d3d:	8b 00                	mov    (%eax),%eax
  801d3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801d45:	8b 45 14             	mov    0x14(%ebp),%eax
  801d48:	8d 40 08             	lea    0x8(%eax),%eax
  801d4b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801d4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801d54:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801d59:	85 c9                	test   %ecx,%ecx
  801d5b:	0f 89 ff 00 00 00    	jns    801e60 <vprintfmt+0x3a7>
				putch('-', putdat);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	53                   	push   %ebx
  801d65:	6a 2d                	push   $0x2d
  801d67:	ff d6                	call   *%esi
				num = -(long long) num;
  801d69:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d6c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801d6f:	f7 da                	neg    %edx
  801d71:	83 d1 00             	adc    $0x0,%ecx
  801d74:	f7 d9                	neg    %ecx
  801d76:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801d79:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d7e:	e9 dd 00 00 00       	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, int);
  801d83:	8b 45 14             	mov    0x14(%ebp),%eax
  801d86:	8b 00                	mov    (%eax),%eax
  801d88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d8b:	99                   	cltd   
  801d8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801d8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d92:	8d 40 04             	lea    0x4(%eax),%eax
  801d95:	89 45 14             	mov    %eax,0x14(%ebp)
  801d98:	eb b4                	jmp    801d4e <vprintfmt+0x295>
	if (lflag >= 2)
  801d9a:	83 f9 01             	cmp    $0x1,%ecx
  801d9d:	7f 1e                	jg     801dbd <vprintfmt+0x304>
	else if (lflag)
  801d9f:	85 c9                	test   %ecx,%ecx
  801da1:	74 32                	je     801dd5 <vprintfmt+0x31c>
		return va_arg(*ap, unsigned long);
  801da3:	8b 45 14             	mov    0x14(%ebp),%eax
  801da6:	8b 10                	mov    (%eax),%edx
  801da8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dad:	8d 40 04             	lea    0x4(%eax),%eax
  801db0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801db3:	b8 0a 00 00 00       	mov    $0xa,%eax
  801db8:	e9 a3 00 00 00       	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc0:	8b 10                	mov    (%eax),%edx
  801dc2:	8b 48 04             	mov    0x4(%eax),%ecx
  801dc5:	8d 40 08             	lea    0x8(%eax),%eax
  801dc8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801dcb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801dd0:	e9 8b 00 00 00       	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801dd5:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd8:	8b 10                	mov    (%eax),%edx
  801dda:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ddf:	8d 40 04             	lea    0x4(%eax),%eax
  801de2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801de5:	b8 0a 00 00 00       	mov    $0xa,%eax
  801dea:	eb 74                	jmp    801e60 <vprintfmt+0x3a7>
	if (lflag >= 2)
  801dec:	83 f9 01             	cmp    $0x1,%ecx
  801def:	7f 1b                	jg     801e0c <vprintfmt+0x353>
	else if (lflag)
  801df1:	85 c9                	test   %ecx,%ecx
  801df3:	74 2c                	je     801e21 <vprintfmt+0x368>
		return va_arg(*ap, unsigned long);
  801df5:	8b 45 14             	mov    0x14(%ebp),%eax
  801df8:	8b 10                	mov    (%eax),%edx
  801dfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dff:	8d 40 04             	lea    0x4(%eax),%eax
  801e02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801e05:	b8 08 00 00 00       	mov    $0x8,%eax
  801e0a:	eb 54                	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e0f:	8b 10                	mov    (%eax),%edx
  801e11:	8b 48 04             	mov    0x4(%eax),%ecx
  801e14:	8d 40 08             	lea    0x8(%eax),%eax
  801e17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801e1a:	b8 08 00 00 00       	mov    $0x8,%eax
  801e1f:	eb 3f                	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801e21:	8b 45 14             	mov    0x14(%ebp),%eax
  801e24:	8b 10                	mov    (%eax),%edx
  801e26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e2b:	8d 40 04             	lea    0x4(%eax),%eax
  801e2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801e31:	b8 08 00 00 00       	mov    $0x8,%eax
  801e36:	eb 28                	jmp    801e60 <vprintfmt+0x3a7>
			putch('0', putdat);
  801e38:	83 ec 08             	sub    $0x8,%esp
  801e3b:	53                   	push   %ebx
  801e3c:	6a 30                	push   $0x30
  801e3e:	ff d6                	call   *%esi
			putch('x', putdat);
  801e40:	83 c4 08             	add    $0x8,%esp
  801e43:	53                   	push   %ebx
  801e44:	6a 78                	push   $0x78
  801e46:	ff d6                	call   *%esi
			num = (unsigned long long)
  801e48:	8b 45 14             	mov    0x14(%ebp),%eax
  801e4b:	8b 10                	mov    (%eax),%edx
  801e4d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801e52:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801e55:	8d 40 04             	lea    0x4(%eax),%eax
  801e58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e5b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801e67:	57                   	push   %edi
  801e68:	ff 75 e0             	pushl  -0x20(%ebp)
  801e6b:	50                   	push   %eax
  801e6c:	51                   	push   %ecx
  801e6d:	52                   	push   %edx
  801e6e:	89 da                	mov    %ebx,%edx
  801e70:	89 f0                	mov    %esi,%eax
  801e72:	e8 5a fb ff ff       	call   8019d1 <printnum>
			break;
  801e77:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801e7a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e7d:	e9 55 fc ff ff       	jmp    801ad7 <vprintfmt+0x1e>
	if (lflag >= 2)
  801e82:	83 f9 01             	cmp    $0x1,%ecx
  801e85:	7f 1b                	jg     801ea2 <vprintfmt+0x3e9>
	else if (lflag)
  801e87:	85 c9                	test   %ecx,%ecx
  801e89:	74 2c                	je     801eb7 <vprintfmt+0x3fe>
		return va_arg(*ap, unsigned long);
  801e8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8e:	8b 10                	mov    (%eax),%edx
  801e90:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e95:	8d 40 04             	lea    0x4(%eax),%eax
  801e98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e9b:	b8 10 00 00 00       	mov    $0x10,%eax
  801ea0:	eb be                	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned long long);
  801ea2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea5:	8b 10                	mov    (%eax),%edx
  801ea7:	8b 48 04             	mov    0x4(%eax),%ecx
  801eaa:	8d 40 08             	lea    0x8(%eax),%eax
  801ead:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801eb0:	b8 10 00 00 00       	mov    $0x10,%eax
  801eb5:	eb a9                	jmp    801e60 <vprintfmt+0x3a7>
		return va_arg(*ap, unsigned int);
  801eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eba:	8b 10                	mov    (%eax),%edx
  801ebc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ec1:	8d 40 04             	lea    0x4(%eax),%eax
  801ec4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ec7:	b8 10 00 00 00       	mov    $0x10,%eax
  801ecc:	eb 92                	jmp    801e60 <vprintfmt+0x3a7>
			putch(ch, putdat);
  801ece:	83 ec 08             	sub    $0x8,%esp
  801ed1:	53                   	push   %ebx
  801ed2:	6a 25                	push   $0x25
  801ed4:	ff d6                	call   *%esi
			break;
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	eb 9f                	jmp    801e7a <vprintfmt+0x3c1>
			putch('%', putdat);
  801edb:	83 ec 08             	sub    $0x8,%esp
  801ede:	53                   	push   %ebx
  801edf:	6a 25                	push   $0x25
  801ee1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	89 f8                	mov    %edi,%eax
  801ee8:	eb 03                	jmp    801eed <vprintfmt+0x434>
  801eea:	83 e8 01             	sub    $0x1,%eax
  801eed:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801ef1:	75 f7                	jne    801eea <vprintfmt+0x431>
  801ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ef6:	eb 82                	jmp    801e7a <vprintfmt+0x3c1>

00801ef8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 18             	sub    $0x18,%esp
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f07:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801f0b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801f0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801f15:	85 c0                	test   %eax,%eax
  801f17:	74 26                	je     801f3f <vsnprintf+0x47>
  801f19:	85 d2                	test   %edx,%edx
  801f1b:	7e 22                	jle    801f3f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801f1d:	ff 75 14             	pushl  0x14(%ebp)
  801f20:	ff 75 10             	pushl  0x10(%ebp)
  801f23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801f26:	50                   	push   %eax
  801f27:	68 7f 1a 80 00       	push   $0x801a7f
  801f2c:	e8 88 fb ff ff       	call   801ab9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f34:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	83 c4 10             	add    $0x10,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    
		return -E_INVAL;
  801f3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f44:	eb f7                	jmp    801f3d <vsnprintf+0x45>

00801f46 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f4c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f4f:	50                   	push   %eax
  801f50:	ff 75 10             	pushl  0x10(%ebp)
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	e8 9a ff ff ff       	call   801ef8 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	56                   	push   %esi
  801f64:	53                   	push   %ebx
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
  801f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	74 4f                	je     801fc1 <ipc_recv+0x61>
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	50                   	push   %eax
  801f76:	e8 a4 e7 ff ff       	call   80071f <sys_ipc_recv>
  801f7b:	83 c4 10             	add    $0x10,%esp
	// If page fault fails
	if(from_env_store != NULL)
  801f7e:	85 f6                	test   %esi,%esi
  801f80:	74 14                	je     801f96 <ipc_recv+0x36>
		*from_env_store = (retval == 0) ? thisenv->env_ipc_from : 0;
  801f82:	ba 00 00 00 00       	mov    $0x0,%edx
  801f87:	85 c0                	test   %eax,%eax
  801f89:	75 09                	jne    801f94 <ipc_recv+0x34>
  801f8b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f91:	8b 52 74             	mov    0x74(%edx),%edx
  801f94:	89 16                	mov    %edx,(%esi)
	if(perm_store != NULL)
  801f96:	85 db                	test   %ebx,%ebx
  801f98:	74 14                	je     801fae <ipc_recv+0x4e>
		*perm_store = (retval == 0) ? thisenv->env_ipc_perm : 0;
  801f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 09                	jne    801fac <ipc_recv+0x4c>
  801fa3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fa9:	8b 52 78             	mov    0x78(%edx),%edx
  801fac:	89 13                	mov    %edx,(%ebx)
	return (retval == 0) ? thisenv->env_ipc_value : retval;
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	75 08                	jne    801fba <ipc_recv+0x5a>
  801fb2:	a1 08 40 80 00       	mov    0x804008,%eax
  801fb7:	8b 40 70             	mov    0x70(%eax),%eax
}
  801fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    
 	int32_t retval = (pg == NULL) ? sys_ipc_recv((void*)UTOP) : sys_ipc_recv(pg);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	68 00 00 c0 ee       	push   $0xeec00000
  801fc9:	e8 51 e7 ff ff       	call   80071f <sys_ipc_recv>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	eb ab                	jmp    801f7e <ipc_recv+0x1e>

00801fd3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	57                   	push   %edi
  801fd7:	56                   	push   %esi
  801fd8:	53                   	push   %ebx
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fdf:	8b 75 10             	mov    0x10(%ebp),%esi
  801fe2:	eb 20                	jmp    802004 <ipc_send+0x31>
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
  int32_t retval = -1;
	while(retval != 0) {
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  801fe4:	6a 00                	push   $0x0
  801fe6:	68 00 00 c0 ee       	push   $0xeec00000
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	57                   	push   %edi
  801fef:	e8 08 e7 ff ff       	call   8006fc <sys_ipc_try_send>
  801ff4:	89 c3                	mov    %eax,%ebx
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	eb 1f                	jmp    80201a <ipc_send+0x47>
		if(retval != -E_IPC_NOT_RECV && retval != 0)
			panic("Receving wrong return value of sys_ipc_try_send");
    sys_yield();
  801ffb:	e8 50 e5 ff ff       	call   800550 <sys_yield>
	while(retval != 0) {
  802000:	85 db                	test   %ebx,%ebx
  802002:	74 33                	je     802037 <ipc_send+0x64>
		retval = (pg == NULL) ? sys_ipc_try_send(to_env, val, (void*)UTOP, 0) : sys_ipc_try_send(to_env, val, pg, perm);
  802004:	85 f6                	test   %esi,%esi
  802006:	74 dc                	je     801fe4 <ipc_send+0x11>
  802008:	ff 75 14             	pushl  0x14(%ebp)
  80200b:	56                   	push   %esi
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	57                   	push   %edi
  802010:	e8 e7 e6 ff ff       	call   8006fc <sys_ipc_try_send>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	83 c4 10             	add    $0x10,%esp
		if(retval != -E_IPC_NOT_RECV && retval != 0)
  80201a:	83 fb f9             	cmp    $0xfffffff9,%ebx
  80201d:	74 dc                	je     801ffb <ipc_send+0x28>
  80201f:	85 db                	test   %ebx,%ebx
  802021:	74 d8                	je     801ffb <ipc_send+0x28>
			panic("Receving wrong return value of sys_ipc_try_send");
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	68 c0 27 80 00       	push   $0x8027c0
  80202b:	6a 35                	push   $0x35
  80202d:	68 f0 27 80 00       	push   $0x8027f0
  802032:	e8 ab f8 ff ff       	call   8018e2 <_panic>
	}
}
  802037:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203a:	5b                   	pop    %ebx
  80203b:	5e                   	pop    %esi
  80203c:	5f                   	pop    %edi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80204a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80204d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802053:	8b 52 50             	mov    0x50(%edx),%edx
  802056:	39 ca                	cmp    %ecx,%edx
  802058:	74 11                	je     80206b <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80205a:	83 c0 01             	add    $0x1,%eax
  80205d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802062:	75 e6                	jne    80204a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	eb 0b                	jmp    802076 <ipc_find_env+0x37>
			return envs[i].env_id;
  80206b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80206e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802073:	8b 40 48             	mov    0x48(%eax),%eax
}
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80207e:	89 d0                	mov    %edx,%eax
  802080:	c1 e8 16             	shr    $0x16,%eax
  802083:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80208a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80208f:	f6 c1 01             	test   $0x1,%cl
  802092:	74 1d                	je     8020b1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802094:	c1 ea 0c             	shr    $0xc,%edx
  802097:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80209e:	f6 c2 01             	test   $0x1,%dl
  8020a1:	74 0e                	je     8020b1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020a3:	c1 ea 0c             	shr    $0xc,%edx
  8020a6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020ad:	ef 
  8020ae:	0f b7 c0             	movzwl %ax,%eax
}
  8020b1:	5d                   	pop    %ebp
  8020b2:	c3                   	ret    
  8020b3:	66 90                	xchg   %ax,%ax
  8020b5:	66 90                	xchg   %ax,%ax
  8020b7:	66 90                	xchg   %ax,%ax
  8020b9:	66 90                	xchg   %ax,%ax
  8020bb:	66 90                	xchg   %ax,%ax
  8020bd:	66 90                	xchg   %ax,%ax
  8020bf:	90                   	nop

008020c0 <__udivdi3>:
  8020c0:	f3 0f 1e fb          	endbr32 
  8020c4:	55                   	push   %ebp
  8020c5:	57                   	push   %edi
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	83 ec 1c             	sub    $0x1c,%esp
  8020cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020db:	85 d2                	test   %edx,%edx
  8020dd:	75 49                	jne    802128 <__udivdi3+0x68>
  8020df:	39 f3                	cmp    %esi,%ebx
  8020e1:	76 15                	jbe    8020f8 <__udivdi3+0x38>
  8020e3:	31 ff                	xor    %edi,%edi
  8020e5:	89 e8                	mov    %ebp,%eax
  8020e7:	89 f2                	mov    %esi,%edx
  8020e9:	f7 f3                	div    %ebx
  8020eb:	89 fa                	mov    %edi,%edx
  8020ed:	83 c4 1c             	add    $0x1c,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	89 d9                	mov    %ebx,%ecx
  8020fa:	85 db                	test   %ebx,%ebx
  8020fc:	75 0b                	jne    802109 <__udivdi3+0x49>
  8020fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802103:	31 d2                	xor    %edx,%edx
  802105:	f7 f3                	div    %ebx
  802107:	89 c1                	mov    %eax,%ecx
  802109:	31 d2                	xor    %edx,%edx
  80210b:	89 f0                	mov    %esi,%eax
  80210d:	f7 f1                	div    %ecx
  80210f:	89 c6                	mov    %eax,%esi
  802111:	89 e8                	mov    %ebp,%eax
  802113:	89 f7                	mov    %esi,%edi
  802115:	f7 f1                	div    %ecx
  802117:	89 fa                	mov    %edi,%edx
  802119:	83 c4 1c             	add    $0x1c,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    
  802121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802128:	39 f2                	cmp    %esi,%edx
  80212a:	77 1c                	ja     802148 <__udivdi3+0x88>
  80212c:	0f bd fa             	bsr    %edx,%edi
  80212f:	83 f7 1f             	xor    $0x1f,%edi
  802132:	75 2c                	jne    802160 <__udivdi3+0xa0>
  802134:	39 f2                	cmp    %esi,%edx
  802136:	72 06                	jb     80213e <__udivdi3+0x7e>
  802138:	31 c0                	xor    %eax,%eax
  80213a:	39 eb                	cmp    %ebp,%ebx
  80213c:	77 ad                	ja     8020eb <__udivdi3+0x2b>
  80213e:	b8 01 00 00 00       	mov    $0x1,%eax
  802143:	eb a6                	jmp    8020eb <__udivdi3+0x2b>
  802145:	8d 76 00             	lea    0x0(%esi),%esi
  802148:	31 ff                	xor    %edi,%edi
  80214a:	31 c0                	xor    %eax,%eax
  80214c:	89 fa                	mov    %edi,%edx
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	89 f9                	mov    %edi,%ecx
  802162:	b8 20 00 00 00       	mov    $0x20,%eax
  802167:	29 f8                	sub    %edi,%eax
  802169:	d3 e2                	shl    %cl,%edx
  80216b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	89 da                	mov    %ebx,%edx
  802173:	d3 ea                	shr    %cl,%edx
  802175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802179:	09 d1                	or     %edx,%ecx
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e3                	shl    %cl,%ebx
  802185:	89 c1                	mov    %eax,%ecx
  802187:	d3 ea                	shr    %cl,%edx
  802189:	89 f9                	mov    %edi,%ecx
  80218b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80218f:	89 eb                	mov    %ebp,%ebx
  802191:	d3 e6                	shl    %cl,%esi
  802193:	89 c1                	mov    %eax,%ecx
  802195:	d3 eb                	shr    %cl,%ebx
  802197:	09 de                	or     %ebx,%esi
  802199:	89 f0                	mov    %esi,%eax
  80219b:	f7 74 24 08          	divl   0x8(%esp)
  80219f:	89 d6                	mov    %edx,%esi
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	f7 64 24 0c          	mull   0xc(%esp)
  8021a7:	39 d6                	cmp    %edx,%esi
  8021a9:	72 15                	jb     8021c0 <__udivdi3+0x100>
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	39 c5                	cmp    %eax,%ebp
  8021b1:	73 04                	jae    8021b7 <__udivdi3+0xf7>
  8021b3:	39 d6                	cmp    %edx,%esi
  8021b5:	74 09                	je     8021c0 <__udivdi3+0x100>
  8021b7:	89 d8                	mov    %ebx,%eax
  8021b9:	31 ff                	xor    %edi,%edi
  8021bb:	e9 2b ff ff ff       	jmp    8020eb <__udivdi3+0x2b>
  8021c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021c3:	31 ff                	xor    %edi,%edi
  8021c5:	e9 21 ff ff ff       	jmp    8020eb <__udivdi3+0x2b>
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	f3 0f 1e fb          	endbr32 
  8021d4:	55                   	push   %ebp
  8021d5:	57                   	push   %edi
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
  8021d8:	83 ec 1c             	sub    $0x1c,%esp
  8021db:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8021e3:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021eb:	89 da                	mov    %ebx,%edx
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	75 3f                	jne    802230 <__umoddi3+0x60>
  8021f1:	39 df                	cmp    %ebx,%edi
  8021f3:	76 13                	jbe    802208 <__umoddi3+0x38>
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	f7 f7                	div    %edi
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	89 fd                	mov    %edi,%ebp
  80220a:	85 ff                	test   %edi,%edi
  80220c:	75 0b                	jne    802219 <__umoddi3+0x49>
  80220e:	b8 01 00 00 00       	mov    $0x1,%eax
  802213:	31 d2                	xor    %edx,%edx
  802215:	f7 f7                	div    %edi
  802217:	89 c5                	mov    %eax,%ebp
  802219:	89 d8                	mov    %ebx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	f7 f5                	div    %ebp
  80221f:	89 f0                	mov    %esi,%eax
  802221:	f7 f5                	div    %ebp
  802223:	89 d0                	mov    %edx,%eax
  802225:	eb d4                	jmp    8021fb <__umoddi3+0x2b>
  802227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80222e:	66 90                	xchg   %ax,%ax
  802230:	89 f1                	mov    %esi,%ecx
  802232:	39 d8                	cmp    %ebx,%eax
  802234:	76 0a                	jbe    802240 <__umoddi3+0x70>
  802236:	89 f0                	mov    %esi,%eax
  802238:	83 c4 1c             	add    $0x1c,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5f                   	pop    %edi
  80223e:	5d                   	pop    %ebp
  80223f:	c3                   	ret    
  802240:	0f bd e8             	bsr    %eax,%ebp
  802243:	83 f5 1f             	xor    $0x1f,%ebp
  802246:	75 20                	jne    802268 <__umoddi3+0x98>
  802248:	39 d8                	cmp    %ebx,%eax
  80224a:	0f 82 b0 00 00 00    	jb     802300 <__umoddi3+0x130>
  802250:	39 f7                	cmp    %esi,%edi
  802252:	0f 86 a8 00 00 00    	jbe    802300 <__umoddi3+0x130>
  802258:	89 c8                	mov    %ecx,%eax
  80225a:	83 c4 1c             	add    $0x1c,%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5f                   	pop    %edi
  802260:	5d                   	pop    %ebp
  802261:	c3                   	ret    
  802262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802268:	89 e9                	mov    %ebp,%ecx
  80226a:	ba 20 00 00 00       	mov    $0x20,%edx
  80226f:	29 ea                	sub    %ebp,%edx
  802271:	d3 e0                	shl    %cl,%eax
  802273:	89 44 24 08          	mov    %eax,0x8(%esp)
  802277:	89 d1                	mov    %edx,%ecx
  802279:	89 f8                	mov    %edi,%eax
  80227b:	d3 e8                	shr    %cl,%eax
  80227d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802281:	89 54 24 04          	mov    %edx,0x4(%esp)
  802285:	8b 54 24 04          	mov    0x4(%esp),%edx
  802289:	09 c1                	or     %eax,%ecx
  80228b:	89 d8                	mov    %ebx,%eax
  80228d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e7                	shl    %cl,%edi
  802295:	89 d1                	mov    %edx,%ecx
  802297:	d3 e8                	shr    %cl,%eax
  802299:	89 e9                	mov    %ebp,%ecx
  80229b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 c7                	mov    %eax,%edi
  8022a3:	89 d1                	mov    %edx,%ecx
  8022a5:	89 f0                	mov    %esi,%eax
  8022a7:	d3 e8                	shr    %cl,%eax
  8022a9:	89 e9                	mov    %ebp,%ecx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	d3 e6                	shl    %cl,%esi
  8022af:	09 d8                	or     %ebx,%eax
  8022b1:	f7 74 24 08          	divl   0x8(%esp)
  8022b5:	89 d1                	mov    %edx,%ecx
  8022b7:	89 f3                	mov    %esi,%ebx
  8022b9:	f7 64 24 0c          	mull   0xc(%esp)
  8022bd:	89 c6                	mov    %eax,%esi
  8022bf:	89 d7                	mov    %edx,%edi
  8022c1:	39 d1                	cmp    %edx,%ecx
  8022c3:	72 06                	jb     8022cb <__umoddi3+0xfb>
  8022c5:	75 10                	jne    8022d7 <__umoddi3+0x107>
  8022c7:	39 c3                	cmp    %eax,%ebx
  8022c9:	73 0c                	jae    8022d7 <__umoddi3+0x107>
  8022cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8022cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8022d3:	89 d7                	mov    %edx,%edi
  8022d5:	89 c6                	mov    %eax,%esi
  8022d7:	89 ca                	mov    %ecx,%edx
  8022d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022de:	29 f3                	sub    %esi,%ebx
  8022e0:	19 fa                	sbb    %edi,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	d3 e0                	shl    %cl,%eax
  8022e6:	89 e9                	mov    %ebp,%ecx
  8022e8:	d3 eb                	shr    %cl,%ebx
  8022ea:	d3 ea                	shr    %cl,%edx
  8022ec:	09 d8                	or     %ebx,%eax
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	89 da                	mov    %ebx,%edx
  802302:	29 fe                	sub    %edi,%esi
  802304:	19 c2                	sbb    %eax,%edx
  802306:	89 f1                	mov    %esi,%ecx
  802308:	89 c8                	mov    %ecx,%eax
  80230a:	e9 4b ff ff ff       	jmp    80225a <__umoddi3+0x8a>
