@set /p SEND_CHANNELS_MAX= Enter value (1 to 15) for number of send channels: 
@set /p RCV_CHANNELS_MAX= Enter value (1 to 15) for number of rcv channels: 
@set /p DATA_WIDTH= Enter value (1 to 64) for data width: 
@set /p ROW_MAX= Enter value (1 to 15) for number of rows in mesh array: 
@set /p COL_MAX= Enter value (1 to 15) for number of cols in mesh array: 
@set /p WIRES_PER_PORT= Enter value for number of wires per port: 
rmdir /S /Q generated\
mkdir generated\
DesignTool.exe %SEND_CHANNELS_MAX% %RCV_CHANNELS_MAX% %DATA_WIDTH% %ROW_MAX% %COL_MAX% %WIRES_PER_PORT%
cd generated\
mkdir pcores\
mkdir pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\
mkdir pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\data\
move *.mpd pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\data\
move *.pao pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\data\
mkdir pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\devl\
mkdir pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\hdl\
mkdir pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\hdl\vhdl\
move *.vhd pcores\top_%ROW_MAX%by%COL_MAX%_%SEND_CHANNELS_MAX%send_%RCV_CHANNELS_MAX%rcv_v1_00_a\hdl\vhdl\
cd .. 