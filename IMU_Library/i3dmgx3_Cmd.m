function CommandArray = i3dmgx3_Cmd
%Creates the Command array in the MatLab workspace
CommandArray = {
    'CMD_RAW_ACCELEROMETER   0xC1',193,1,31;
    'CMD_ACCELERATION_ANGU   0xC2',194,1,31;
    'CMD_DELTA_ANGLE_VELOC   0xC3',195,1,31;
    'CMD_SET_CONTINIOUS      0xC4',[196,193,41],3,8;
    'CMD_ORRIENTATION_MAT    0xC5',197,1,43;
    'CMD_ATTITUDE_UP_MATRIX  0xC6',198,1,43;
    'CMD_MAGNETROMETER_VECT  0xC7',199,1,19;
    'CMD_ACCEL_ANG_ORIENT    0xC8',200,1,67;
    'CMD_WRITE_ACEL_BIAS_COR 0xC9',[201,183,68],3,19;
    'CMD_WRITE_GYRO_BIAS     0xCA',[202,18,165],3,19;
    'CMD_ACCEL_ANG_MAG_VECTO 0xCB',203,1,43;
    'CMD_ACEL_ANG_MAG_VEC_OR 0xCC',204,1,79;
    'CMD_CAPTURE_GYRO_BIAS   0xCD',[205,193,41],3,19;
    'CMD_EULER_ANGLES        0xCE',206,1,19;
    'CMD_EULER_ANGLES_ANG_RT 0xCF',207,1,31;
    'CMD_TRANSFER_NONV_MEM   0xD0',[208,193,41],3,9;
    'CMD_TEMPERATURES        0xD1',209,1,15;
    'CMD_GYRO_STAB_A_AR_MG   0xD2',210,1,43;
    'CMD_DELTA_ANGVEL_MAGV   0xD3',211,1,43;
    'CMD_SET_READ_MODE       0xD4',[212,163,71],3,4;
    'CMD_MODE_PRESET         0xD5',[213,186,137],3,4;
    'CMD_CONTINUOUS_PRESET   0xD6',[214,198,107],3,4;
    'CMD_SET_READ_TIMER      0xD7',[215,193,41],3,7;
    'CMD_COMM_SETTINGS       0xD9',[217,195,85],3,10;
    'CMD_STATIONARY_TEST     0xDA',218,1,7;
    'CMD_SAMPLING_SETTINGS   0xDB',[219,168,185],3,19;
    'CMD_WRITE_WORD_EEPROM   0xE4',[228,193,41,0],4,5;
    'CMD_READ_WORD_EEPROM    0xE5',[229,0],2,5;
    'CMD_FIRWARE_VERSION     0xE9',233,1,7;
    'CMD_GET_DEVICE_ID       0xEA',234,1,20;
    'CMD_STOP_CONTINIOUS     0xFA',[250,117,180],1,0;
    'CMD_FIRMWARE_UPDATE     0xFD',[253,115,74],3,0;
    'CMD_DEVICE_RESET        0xFE',[254,158,58],3,0};