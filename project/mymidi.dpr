//program mymidi;
library mymidi;

{$APPTYPE CONSOLE}

uses  SysUtils,Classes;

//function midiOutGetNumDevs():Integer;stdcall;external 'Winmm.dll';

function midiOutOpen(h:Pointer;i,n,p,f:Integer):Integer;stdcall;
external 'Winmm.dll';

function midiOutShortMsg(h:integer;m:Cardinal):Integer;stdcall;
external 'Winmm.dll';

var han:integer;

function midi_init():Double;cdecl;
begin
Result:=midiOutOpen(@han,-1,0,0,0);
end;

function midi_play(d:Double):Double;cdecl;
begin
Result:=midiOutShortMsg(han,Cardinal(Round(d)));
end;

exports midi_init,midi_play;

function timeGetDevCaps(p:Pointer;s:Integer):Integer;stdcall;
external 'Winmm.dll';
function timeBeginPeriod(r:Cardinal):Integer;stdcall;
external 'Winmm.dll';
function timeEndPeriod(r:Cardinal):Integer;stdcall;
external 'Winmm.dll';
function timeGetTime():Cardinal;stdcall;
external 'Winmm.dll';
function GetTickCount():Cardinal;stdcall;
external 'kernel32.dll';
type dc_=record
Min:Cardinal;
Max:Cardinal;
end;

type wf_=record
wFormatTag:Word;
nChannels:Word;
nSamplesPerSec:Cardinal;
nAvgBytesPerSec:Cardinal;
nBlockAlign:Word;
wBitsPerSample:Word;
cbSize:Word;
wBitsPerSample2:Word;
end;

type wh_=record
lpData:Pointer;
dwBufferLength:Cardinal;
dwBytesRecorded:Cardinal;
dwUser:Cardinal;
dwFlags:Cardinal;
dwLoops:Cardinal;
lpNext:Cardinal;
reserved:Cardinal;
end;

type mt_=record
wType:Cardinal;
sample:Cardinal;
pad:array[0..23]of byte;
end;

function waveOutOpen(han:Pointer;id:integer;format:Pointer;call:Pointer;val:integer;flags:integer):Cardinal;stdcall;
external 'Winmm.dll';
function waveOutPrepareHeader(han:integer;buf:Pointer;size:integer):Cardinal;stdcall;
external 'Winmm.dll';
function waveOutWrite(han:integer;buf:Pointer;size:integer):Cardinal;stdcall;
external 'Winmm.dll';
function waveOutGetPosition(han:integer;time:Pointer;size:integer):Cardinal;stdcall;
external 'Winmm.dll';
function waveOutReset(han:integer):Cardinal;stdcall;
external 'Winmm.dll';
function waveOutGetErrorTextA(err:integer;buf:Pointer;size:integer):Cardinal;stdcall;
external 'Winmm.dll';
var handle:integer;
wf:wf_;
wh1,wh2:wh_;
mt:mt_;
buf1,buf2:Pointer;
stream:TFileStream;
size:integer;
//pc:array[0..2048] of char;

begin
Exit;
//waveOutGetErrorTextA(1,@pc,2048);Writeln(pc);

wf.wFormatTag:=1;
wf.nChannels:=1;
wf.nSamplesPerSec:=44100;
wf.nAvgBytesPerSec:=44100*2;
wf.nBlockAlign:=2;
wf.wBitsPerSample:=16;
wf.cbSize:=2;
wf.wBitsPerSample:=16;
handle:=0;
Writeln(waveOutOpen(@handle,-1,@wf,nil,0,0));
Writeln(handle);

stream:=TFileStream.Create('C:\w1.wav',fmOpenRead or fmShareDenyNone);
size:=stream.Size;
GetMem(buf1,Size);
stream.ReadBuffer(buf1^,Size);
stream.Free;

wh1.lpData:=buf1;
wh1.dwBufferLength:=Size;
wh1.dwFlags:=0;

stream:=TFileStream.Create('C:\w2.wav',fmOpenRead or fmShareDenyNone);
size:=stream.Size;
GetMem(buf2,Size);
stream.ReadBuffer(buf2^,Size);
stream.Free;

wh2.lpData:=buf2;
wh2.dwBufferLength:=Size;
wh2.dwFlags:=0;

Writeln(waveOutPrepareHeader(handle,@wh1,sizeof(wh1)));
Writeln(waveOutPrepareHeader(handle,@wh2,sizeof(wh2)));

waveOutWrite(handle,@wh1,sizeof(wh1));

mt.wType:=2;

while(true)do begin
Sleep(100);
waveOutGetPosition(handle,@mt,sizeof(mt));
Writeln(mt.sample);
waveOutReset(handle)
end;




{
//Writeln(midiOutGetNumDevs());
Writeln(midiOutOpen(@han,-1,0,0,0));
//Randomize;for i:=0 to 1000 do Writeln(midiOutShortMsg(han,Random(16000000)));
//for i:=0 to 127 do begin
midiOutShortMsg(han,$C0 or (10 shl 8));
midiOutShortMsg(han,$90 or (70 shl 8) or ($7f shl 16));
Sleep(100);
midiOutShortMsg(han,$90 or (70 shl 8));
Sleep(1000);
//end;
//Writeln(midiOutPrepareHeader(han,@b,65535));
}
end.



