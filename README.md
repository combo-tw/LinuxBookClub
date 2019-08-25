# Linux 讀書會
## 軟體清單 
* Linux Kernel 4.14.50 [link](https://github.com/raspberrypi/linux/tree/rpi-4.4.y)
* QEMU 2.12.0
* GDB 8.1 (for arm)
* GCC 5.4
* ARM-GCC 5.4

## 使用說明
* 編譯
	* 進入到build目錄
	`cd build`
	* 同步檔案至build資料夾
	`./build-raspi-kerenl.sh`
	* 輸入要同步的資料夾名稱
    * 選擇是否要啟動 QEMU
* 建立新的Kernel空目錄
	* 進入到linux目錄
	`cd build/linux`
	* 複製linux目錄下的目錄架構
	`./make_new_folder.sh`
	* 輸入目標的資料夾名稱
