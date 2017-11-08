library win;

{$APPTYPE CONSOLE}

uses  SysUtils, Classes, Messages, Windows;

var h,m:Integer;
msg:TMsg;
keys:array[0..255]of byte;


function clear():Double;cdecl;
var i:integer;
begin
for i:=0 to 255 do keys[i]:=0;
Result:=0;
end;

function handle(han:Double):Double;cdecl;
begin
h:=Round(han);
Result:=0;
while(true)do begin
m:=Integer(PeekMessage(msg,h,0,0,1));
if m<=0 then break;
case msg.message of
WM_QUIT: begin Result:=1;end;
WM_CLOSE: begin Result:=1;end;
WM_DESTROY: begin Result:=1;end;
WM_SYSCOMMAND: begin Result:=1;end;
WM_COMMAND: begin Result:=1;end;
WM_KEYDOWN: begin keys[msg.wParam]:=1;end;
WM_SYSKEYDOWN: begin keys[msg.wParam]:=1;end;
WM_KEYUP: begin keys[msg.wParam]:=0;end;
WM_SYSKEYUP: begin keys[msg.wParam]:=0;end;
WM_LBUTTONDOWN: begin keys[1]:=1;end;
WM_LBUTTONDBLCLK: begin keys[1]:=1;end;
WM_RBUTTONDOWN: begin keys[2]:=1;end;
WM_RBUTTONDBLCLK: begin keys[2]:=1;end;
WM_LBUTTONUP: begin keys[1]:=0;end;
WM_RBUTTONUP: begin keys[2]:=0;end;
end;
//TranslateMessage(msg);
//DispatchMessage(msg);
DefWindowProc(msg.hwnd,msg.message,msg.wParam,msg.lParam);
end;
end;

function check(key:Double):Double;cdecl;
begin
Result:=keys[Round(key)];
end;

function timeGetTime():Cardinal;stdcall;
external 'Winmm.dll';

function timestamp():Double;
begin
Result:=timeGetTime();
end;

function difftime(new,old:Double):Double;cdecl;
begin
Result:=Cardinal(Round(new))-Cardinal(Round(old));
end;

exports clear,handle,check,timestamp,difftime;

begin
clear();
end.
