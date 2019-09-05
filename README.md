# Linux 讀書會
## 軟體清單 
* Linux Kernel 4.14.50 [link](https://github.com/raspberrypi/linux/tree/rpi-4.14.y)
* QEMU 2.12.0
* GDB 8.1 (for arm)
* GCC 5.4
* ARM-GCC 5.4

## 使用說明
* 編譯
	* 進入到 build 目錄  
	`cd build`
	* 同步檔案至 build 資料夾  
	`./build-raspi-kerenl.sh`
	* 輸入章節的資料夾數字 (e.g. `03`)
    * 選擇是否要啟動 QEMU
* 建立新的 Kernel 空目錄
	* 進入到 linux 目錄  
	`cd build/linux`
	* 複製 linux 目錄下的目錄架構  
	`./make_new_folder.sh`
	* 輸入目標的資料夾名稱
