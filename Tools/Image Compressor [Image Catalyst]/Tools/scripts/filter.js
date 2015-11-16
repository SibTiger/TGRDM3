/*
�������� � ������� � stdout ������ ������ �� ��������� ��������.

� ���������� ��� � stdin (��.����������� ���������) ���������� ���� � ������ �/��� ������.
���������� ����� ������������� �� ������������� � �������� �������. ���� �����/����� �� ����������,
�� ������ �������� ������������ � � stderr ��������� ������ ���������� ���� � �����/�����.
���� � ��������� ������� ���� � �����, �� � ���� ����� � ���������� ���������
��������� ������ ����, ������� ��������. ��� ���� ������������� � ������ ���������� ���� � �����.

���� � �������� ���������� (��./Outdir) � �������������� ���� ����������� �� ������������ RegExp(rd) 
��� ����������� ����.�������� � ������ ������/���������, � �������� �� ��������� �������� 
������� FSO. ����� �����/�������� ������������ � � stderr ��������� ������ ���������� ���� � �����/�����.
���� ����.������ ��������� � ���� � �������� ����������, �� ������ ����������� ��� ��������� � � 
stderr ��������� ������ ���������� ���� � �������� ����������.

������ ���� � ����� ������� �� ���� � ��� ����� � �� ����������� ����������� ������������ 
RegExp'� (re) �� ���������� � ���� ��� ����� ����.��������.

���� ��� ������������ RegExp�, �� ���� ���������� � outdir (��.����������� ���������) �
� stdout ��������� ������ ���������� ���� � �������������� �����.

���� � ����/����� ����� ������� ������������, �� � stderr ������� ������ ���������� ���� � �����.

��� ������� �����, ����������� ������ ���������� � ����������� ��������� ��������� ������������ ���������.
��� ����������� ������/���������, ���� � �������� ���������� ��� ���������� ����/������� � ����� 
�� �������, �� � ����� ����������� �����/�������� ����������� ������� ����� � �������:
<��� �����/��������>-NNNN.<���������� �����/��������>

����������� ���������. 
����� ����� � ���� ������ ����� ���� �������� ��������� ����������� ���������:
/Outdir:<���� � �������� ����������>	- � ���� ������� ����� ����������� �����, ���� ��
	�����, �� ����� ������ �� ���������� � �������������� �� �����. 
/IsStdIn:yes	- ���� �����, �� ����/����� ������ �������� �� stdin, � �� �� ����������.
/JPG:yes	- ������������� ����� jpg
/PNG:yes	- ������������� ����� png
*/

if(WScript.Arguments.length == 0) WScript.quit(-1);
var fso = new ActiveXObject("Scripting.FileSystemObject");
var re = new RegExp("[^a-z�-�0-9\\.\\,~@#$_\\-=\\+\\\\/:[\\]{} ]","ig");
//rd - RegExp ��� ���������������� FSO ��������: 
// - \u2191
var rd = new RegExp("[\\u2191]","ig");
var rp = new RegExp("\"","ig");
var ri;
//var rslesh = new RegExp("\\\\","ig");
var basepath, basepathdos, ret, outfirst;
var argn, outdirorig, outdir, isstdin;
outdir = ""; outdirorig = "";
isstdin = "";
argn = WScript.Arguments.named;
if(argn.Exists("Outdir")) {
	outdirorig = argn.Item("Outdir");
//	WScript.echo(outdirorig);
	if(outdirorig.match(rd) || outdirorig.match(re)) {
		WScript.StdErr.WriteLine(sDOS2Win(outdirorig,true));
		WScript.quit(-1);
	}
	outdirorig = fso.GetAbsolutePathName(outdirorig);
	if(!fso.FolderExists(outdirorig)) if(CreateTree(outdirorig)) WScript.quit(-3);
}	

var isjpg = false, ispng = false;
if(argn.Exists("JPG")) 
	if(argn.Item("JPG").toUpperCase()=="YES") isjpg=true;
if(argn.Exists("PNG")) 
	if(argn.Item("PNG").toUpperCase()=="YES") ispng=true;
if(isjpg && ispng) ri = new RegExp("\\.(png|jp(g|e|eg))$","ig");
else if(isjpg && !ispng) ri = new RegExp("\\.(jp(g|e|eg))$","ig");
else if(ispng && !isjpg) ri = new RegExp("\\.png$","ig");
else WScript.quit(0);

if(argn.Exists("IsStdIn")) isstdin = argn.Item("IsStdIn").toUpperCase();
ret = 0;
if(isstdin=="YES") {
	while (!WScript.StdIn.AtEndOfStream) {
//		str = sDOS2Win(WScript.StdIn.ReadLine(),false);
		basepath = WScript.StdIn.ReadLine().replace(rp,"");
		WorkBasepath();
	}

} else {
	for(i=0;i<WScript.Arguments.unnamed.count;++i) {
		basepath = WScript.Arguments.unnamed(i);
		WorkBasepath();
	}
}
WScript.quit(ret);

function WorkBasepath() {
//	WScript.echo(basepath);
//	WScript.echo(GetCharCodeHexString(basepath));
	if(basepath.match(rd)) {
		WScript.StdErr.WriteLine(sDOS2Win(basepath,true));
		return 0;
	}
	basepath = fso.GetAbsolutePathName(basepath);
	if(fso.FileExists(basepath) && basepath.match(ri)) {
		ret += work(basepath);
	} else if(fso.FolderExists(basepath)) {
		if(outdirorig!="") {
			//2.1.�������� ��������� ������� �� �������� �������� � ��������� ��� 
			//���������� ��� � outdir
			outfirst = fso.GetBaseName(basepath);
			if(fso.GetExtensionName(basepath)!="") outfirst += "." + fso.GetExtensionName(basepath);
			outfirst = getFolderName(fso.BuildPath(outdirorig,outfirst));
			if(outfirst=="") {
				WScript.StdErr.WriteLine(sDOS2Win(basepath,true));
				return 0;
			}
		}
		ret += DirWork(basepath);
	}
}

/*
����������� ����� ��������� ����������� � ��������� �������� ��������
� ���������� ���� ������.
*/
function DirWork(dir) {
	var f, fc, ret;
	ret = 0;
	f = fso.GetFolder(dir);
	fc = new Enumerator(f.files);
	for (; !fc.atEnd(); fc.moveNext()) {
		if(fc.item().Path.match(ri)) ret += work(fc.item().Path);
	}
	fc = new Enumerator(f.SubFolders);
	for (; !fc.atEnd(); fc.moveNext()) {
		ret += DirWork(fc.item().Path);
	}
	return(ret);
}

/*
����������� �������, ������� ����, �������� � ���������.
���� ��� ������ �������, �� ���������� 0, ����� - �������� <0
*/
function CreateTree(p) {
	p = fso.GetAbsolutePathName(p);
	if(fso.FileExists(p)) return(-1);
	if(fso.FolderExists(p)) return(0);
	var owner = fso.GetParentFolderName(p);
	if(!fso.FolderExists(owner))
		if(CreateTree(owner)) return(-2);
	fso.CreateFolder(p);
	return(0);
}

/*
������������ ������ ���� � �����, ���������� � ��������� �� ��������� ���������� � �����.
*/
function work(str) {
	var p, tp, tf;
	if(str.match(rd)) {
		WScript.StdErr.WriteLine(sDOS2Win(basepath,true));
		return 0;
	}
	p = fso.GetParentFolderName(str);
	if(outdirorig.toUpperCase() == fso.GetAbsolutePathName(p).toUpperCase()) 
		outdir = "";
	else
		outdir = outdirorig;
	if(!str.match(re) && !str.match(rd)) {
		tf = fso.GetFileName(str);
		if(outdir!="") {
			//1.���� ������� ������� == ��������������� �����
			if(str.toUpperCase()==basepath.toUpperCase()) {
				//1.1.�������� �������������� ���� � outdir
				tp = outdir;
			//2.�����:
			} else {
				//2.2.�������� �� p ������� ������� � ��������� � ���������� ����� 
				//	� �����, �� ��� ���������� � 2.1.
				tp = outfirst + p.substr(basepath.length);
				//2.3.������� � outdir ��������� ��������� ����� �� ��� � �.2.2
				if(CreateTree(tp)) {
					WScript.StdErr.WriteLine(sDOS2Win(str,true));
					return 0;
				}
				//2.4.�������� ���� �� ���������� � �.2.3. ����
			}
			filecopy(str,fso.BuildPath(tp,tf));
		} else {
			tp = p;
		}
		WScript.StdOut.WriteLine(sDOS2Win(fso.BuildPath(tp,tf),true));
		return 1;
	} else {
		WScript.StdErr.WriteLine(sDOS2Win(str,true));
		return 0;
	}
}

/*
��������� ���������� � ��������� ��� ����� �� ������������ RegExp(re), ���� ������������ �������,
�� ���������� ��������� ��� ����� � ��� �� �����������.
���� ������������ �� �������, ������������ �� �� ����� ��� �����.
*/
function checkFileName(fn) {
	if (fn.match(re)) {
		return fso.GetBaseName(fso.GetTempName()) + "." + fso.GetExtensionName(fn);
	}
	return fn;
}

/*
�������� ���� source � target. ���� ���� ������ ��� ����������, �� � ����� target ����������� 
���������� ����� ����� � �������:
<��� target>-NNNN.<���������� target>
�������: ��� �������������� �����, ���� �� ������, �� ������ ������.
*/
function filecopy(source,target) {
	if(!fso.FileExists(source)) return "";
	var name = getFileName(target);
	if(name=="") return "";
	fso.CopyFile(source,name,true);
	return name;
}

/*
����������/��������������� ���� source � target. ���� ���� ������ ��� ����������, �� � ����� 
target ����������� ���������� ����� ����� � �������:
<��� target>-NNNN.<���������� target>
�������: ��� �������������� �����, ���� �� ������, �� ������ ������.
*/
function filemove(source,target) {
	if(!fso.FileExists(source)) return "";
	var name = getFileName(target);
	if(name=="") return "";
	fso.MoveFile(source,name);
	return name;
}


/*
���������� ���������� ��� �����, ����������� � ���������.
���� ����� �� ����������, ������������ �� �� ����� ���.
���� ���� ���������� � ����� ����� ����������� ���������� ����� � �������:
<��� target>-NNNN.<���������� target>
�������: ���������� ��� �����.
*/
function getFileName(fn) {
	if(!fso.FileExists(fn)) return fn;
	var ext, name, i;
	ext = fso.GetExtensionName(fn);
	name = fso.GetParentFolderName(fn) + "\\" + fso.GetBaseName(fn);
	i = 1;
	while(fso.FileExists(name+"-"+padleft(i,4,"0")+"."+ext) && i<10000) ++i;
	if(i>9999) return "";
	return name+"-"+padleft(i,4,"0")+"."+ext;
}

/*
���������� ���������� ��� ��������, ����������� � ���������.
���� �������� �� ����������, ������������ �� �� ����� ���.
���� ������� ���������� � ��� ����� ����������� ���������� ����� � �������:
<��� target>-NNNN.<���������� target>
�������: ���������� ��� ��������.
*/
function getFolderName(fn) {
	if(!fso.FolderExists(fn)) return fn;
	var ext, name, i;
	ext = fso.GetExtensionName(fn);
	if(ext!="") ext = "." + ext;
	name = fso.GetParentFolderName(fn) + "\\" + fso.GetBaseName(fn);
	i = 1;
	while(fso.FolderExists(name+"-"+padleft(i,4,"0")+ext) && i<10000) ++i;
	if(i>9999) return "";
	return name+"-"+padleft(i,4,"0")+ext;
}


/*
��������� ������ �������� s �� ������ l ��������� c.
�������: ����������� ������.
*/
function padleft(s,l,c) {
	while(s.toString().length<l) s = c + s;
	return s;
}

function GetCharCodeHexString(sText) {
	var j, str1="";
	for(j=0;j<sText.length;++j) str1 += " " + sText.charCodeAt(j).toString(16);
	return str1.substr(1);
}

/*	���������� ����� sText ��������������� �� ��������� cp866 (DOS) � windows-1251. 
	��� �������� - �� 1251 � DOS - ���� ���� bInsideOut ����� true.
	�����: http://forum.script-coding.com/viewtopic.php?id=997
*/
 
function sDOS2Win(sText, bInsideOut) {
	var aCharsets = ["windows-1251", "cp866"];
	sText += "";
	bInsideOut = bInsideOut ? 1 : 0;
	with (new ActiveXObject("ADODB.Stream")) { //http://www.w3schools.com/ado/ado_ref_stream.asp
		type = 2; //Binary 1, Text 2 (default) 
		mode = 3; //Permissions have not been set 0,	Read-only 1,	Write-only 2,	Read-write 3,
		//Prevent other read 4,	Prevent other write 8,	Prevent other open 12,	Allow others all 16
		charset = aCharsets[bInsideOut];
		open();
		writeText(sText);
		position = 0;
		charset = aCharsets[1 - bInsideOut];
		return readText();
	}
}
