# Use Brother P-touch Label Printer on Linux

These are my notes on how to use a Brother P-touch D450 ([PT-450]) from Linux, which is connected via USB.  They are written around the **[ptouch-print]** command-line tool for communicating with the label printer.

## Gist

* The label printer is connected to the computer via a USB A-to-Micro B cable

* **ptouch-print** communicates with the printer directly over USB. There is no need to install printer drivers (but Ubuntu might still do so).

* **ptouch-print** can send a monochrome PNG file to the label printer

* **ptouch-print** can generate a monochrome PNG file from a sequence of multi-line plain text, images, and padding command-line options

* **ptouch-print** can send the sequence directly to the label printer, but it's hard to predict what it will look like. Better to always output to a PNG for preview

* **ptouch-print** can handle multiple monochrome PNG files as input, e.g. either to be print one after each other or to output a new monochrome PNG file. You can add separation by adding `--pad <pixels>` between each `--image <file>` option

* To save label tape, **ptouch-print** can merge multiple monochrome PNG images into one long PNG image

* **ptouch-print** needs to build from source, which is straightforward if basic compile tools are already installed



## Usage

```sh
$ ptouch-print --help
usage: ptouch-print [options] <print-command(s)>
options:
	--debug			enable debug output
	--font <file>		use font <file> or <name>
	--fontsize <size>	Manually set fontsize
	--writepng <file>	instead of printing, write output to png file
print commands:
	--image <file>		print the given image which must be a 2 color
				(black/white) png
	--text <text>		Print 1-4 lines of text.
				If the text contains spaces, use quotation marks
				around it.
	--cutmark		Print a mark where the tape should be cut
	--pad <n>		Add n pixels padding (blank tape)
other commands:
	--version		show version info (required for bug report)
	--info			show info about detected tape
	--list-supported	show printers supported by this version
```



## Supported label printers

```sh
$ ptouch-print --version
ptouch-print version v1.5-r4-g674e0da by Dominic Radermacher

$ ptouch-print --list-supported
Supported printers (some might have quirks)
	PT-2420PC
	PT-2450PC
	PT-1950
	PT-2700
	PT-1230PC
	PT-2430PC
	PT-2730
	PT-H500
	PT-E500
	PT-P700
	PT-P750W
	PT-D450
	PT-D600
	PT-P710BT
```


## Examples

### Query printer from information

```sh
$ sudo ptouch-print --info
PT-D450 found on USB bus 1, device 8
maximum printing width for this tape is 120px
media type = 01
media width = 18 mm
tape color = 01
text color = 08
error = 0000
```


### Generate PNG

```sh
$ sudo ptouch-print --text "John Doe" "john.doe@example.org" "+1 123-456-7890" --writepng johndoe.png
PT-D450 found on USB bus 1, device 11
choosing font size=30
$ ls -l johndoe.png 
-rw-r--r-- 1 root root 1591 Jun 10 11:55 johndoe.png
$ file johndoe.png 
johndoe.png: PNG image data, 467 x 120, 1-bit colormap, non-interlaced
```

<img src="images/johndoe.png" style="border: 1px solid #666"/>


### Print PNG image

```sh
$ sudo ptouch-print --image johndoe.png
PT-D450 found on USB bus 1, device 11
max_pixels=128, offset=4
```

### Print multiple PNG images at once (saves tape)

The label printer will always feed the tape forward after each print so that the cutter won't cut into the printed content. If you print many labels, one by one, this way, you end up wasting a lot of label tape.  To avoid this, you can print multiple labels at the same time.  For example,

```sh
$ sudo ptouch-print --image alice.png --pad 10 --image bob.png --pad 10 --image carol.png
PT-D450 found on USB bus 1, device 11
max_pixels=128, offset=4
```

## Man pages

```sh
PTOUCH-PRINT(1)           ptouch printer util          PTOUCH-PRINT(1)

NAME
       ptouch-print  - a command line tool to use Brother Ptouch label
       printers

SYNOPSIS
       ptouch-print [options] <print command options>

DESCRIPTION
       ptouch-print is a command line tool that can be used  to  print
       labels with several Brother Ptouch label printers.

OPTIONS
       General  options, font selection options and optput options are
       valid for the whole printout and should  be  given  only  once.
       Each duplication will override the previous argument value.

       Any of the printing command options can be given more than once
       in any order, and will be executed in the given order.

   General options
       --debug
              Enables printing of debugging information.

   Font selection options
       --fontsize <size>
              Disable auto-detection of the font size  and  force  the
              font  size  to  the  size given as argument. Please note
              that text will be cut off if you  specify  a  too  large
              font size here.

       --font <fontname>
              Set the font to the fontname given as argument.

   Output control options
       --writepng <file>
              Instead of printing to the label printer, write the out‐
              put in a PNG image file (which can be printed later  us‐
              ing the --image printing command option).

   Printing command options
       --text text
              Print  the  given text at the current position. Text in‐
              cluding spaces must be enclosed in question  marks.   To
              print a text in multiple lines, give multiple text argu‐
              ments.  Also see the EXAMPLES section.

       --image image.png
              Print the image file at the current position. The  image
              file  must  be  a  two color, palette based image in PNG
              format.

       --cutmark
              Print a cutmark (dashed line) at the current position.

       --pad <n>
              Print <n> pixels of white space at the current position.
              Useful  for  printers that would otherwise cut off parts
              of the printed text or image.

   Getting help and display information
       -?, --help
              Print a help message and exit.

       --version
              Display version information and exit.

       --info Show info about the tape detected (like  printing  width
              etc.) and exit.

DEFAULTS
       The default font used is 'DejaVuSans'.

       The  default  fontsize  is auto-detected, depending on the used
       tape width and font.

EXIT STATUS
       0      Successful program execution.

       1      Usage syntax error.

       5      Printer device could not been opened.

EXAMPLES
       ptouch-print --text 'Hello World'
              Print the text 'Hello World' in one line

       ptouch-print --text 'Hello' 'World'
              Print the text 'Hello World' in two  lines  ('Hello'  in
              the first line and 'World' in the second line).

       ptouch-print --image icon.png
              Print   the  image  contained  in  the  PNG  image  file
              'icon.png'.  The image file must be  palette  based  PNG
              format with two colors.

AUTHOR
       Written   by   Dominic   Radermacher  (dominic@familie-raderma‐
       cher.ch).

       Also      see       https://familie-radermacher.ch/dominic/pro‐
       ptouch-print --text 'Hello' 'World'
              Print the text 'Hello World' in two  lines  ('Hello'  in
              the first line and 'World' in the second line).

       ptouch-print --image icon.png
              Print   the  image  contained  in  the  PNG  image  file
              'icon.png'.  The image file must be  palette  based  PNG
              format with two colors.

AUTHOR
       Written   by   Dominic   Radermacher  (dominic@familie-raderma‐
       cher.ch).

       Also      see       https://familie-radermacher.ch/dominic/pro‐
       jekte/ptouch-print/

1.4.3                         2021-08-30               PTOUCH-PRINT(1)
```


## Installation

### Requirements

Installation:
* Linux
* C compiler, e.g. GCC
* CMake

Run time:
* Linux
* `sudo` for permissions to access printer via USB (see below)


### Build

```sh
$ git clone https://git.familie-radermacher.ch/linux/ptouch-print.git
$ cd ptouch-print
$ ./build.sh
-- The C compiler identification is GNU 9.4.0
...
[100%] Linking C executable ptouch-print
[100%] Built target ptouch-print

$ ls -l build/ptouch-print 
-rwxrwxr-x 1 hb hb 94544 Jun 10 11:29 build/ptouch-print

$ build/ptouch-print --version
ptouch-print version v1.5-r4-g674e0da by Dominic Radermacher
```


### Install

```sh
$ prefix=$HOME/software/ptouch-print
$ mkdir -p "$prefix"/{bin,share/man/man1}
$ cp build/ptouch-print "$prefix/bin/"
$ cp ptouch-print.1 "$prefix/share/man/man1"
```

Update `PATH` and `MANPATH` as below, e.g. in `~/.bashrc`.

```sh
$ prefix=$HOME/software/ptouch-print
$ PATH="$prefix/bin:$PATH"
$ MANPATH="$prefix/share/man/man1:$MANPATH"
```

With this in place, the executable and the manual page should be found;


```sh
$ command -v ptouch-print
/home/hb/software/ptouch-print/bin/ptouch-print
$ man -w ptouch-print
/home/hb/software/ptouch-print/share/man/man1/ptouch-print.1
```



## Troubleshooting

If you get:

```sh
$ build/ptouch-print --info
PT-D450 found on USB bus 1, device 8
libusb_open error :LIBUSB_ERROR_ACCESS
```

This is due to lack of permissions to access the printer over USB. The quick fix is to run as admin:

```sh
$ sudo build/ptouch-print --info
[sudo] password for hb: 
PT-D450 found on USB bus 1, device 8
maximum printing width for this tape is 120px
media type = 01
media width = 18 mm
tape color = 01
text color = 08
error = 0000
```


## Appendix

### Installation log

```sh
$ ./build.sh
-- The C compiler identification is GNU 9.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Found Gettext: /usr/bin/msgmerge (found version "0.19.8.1") 
Found GD: YES
-- Looking for gdImagePng in /usr/lib/x86_64-linux-gnu/libgd.so
-- Looking for gdImagePng in /usr/lib/x86_64-linux-gnu/libgd.so - found
-- Found ZLIB: /usr/lib/x86_64-linux-gnu/libz.so (found version "1.2.11") 
-- Found PNG: /usr/lib/x86_64-linux-gnu/libpng.so (found version "1.6.37") 
-- Looking for gdImageJpeg in /usr/lib/x86_64-linux-gnu/libgd.so
-- Looking for gdImageJpeg in /usr/lib/x86_64-linux-gnu/libgd.so - found
-- Found JPEG: /usr/lib/x86_64-linux-gnu/libjpeg.so (found version "80") 
-- Looking for gdImageGif in /usr/lib/x86_64-linux-gnu/libgd.so
-- Looking for gdImageGif in /usr/lib/x86_64-linux-gnu/libgd.so - found
-- Found GD: /usr/lib/x86_64-linux-gnu/libgd.so
-- Found Git: /usr/bin/git (found version "2.25.1") 
-- Found PkgConfig: /usr/bin/pkg-config (found version "0.29.1") 
-- Found Intl: /usr/include  
-- Checking for module 'libusb-1.0'
--   Found libusb-1.0, version 1.0.23
-- Configuring done
-- Generating done
-- Build files have been written to: /home/hb/repositories/other/ptouch-print/build
[ 25%] Generating ../version.h, _version.h
Scanning dependencies of target ptouch-print
[ 50%] Building C object CMakeFiles/ptouch-print.dir/src/libptouch.c.o
[ 75%] Building C object CMakeFiles/ptouch-print.dir/src/ptouch-print.c.o
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c: In function ‘print_img’:
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c:93:20: warning: implicit declaration of function ‘ptouch_get_max_width’; did you mean ‘ptouch_getmaxwidth’? [-Wimplicit-function-declaration]
   93 |  size_t max_pixels=ptouch_get_max_width(ptdev);
      |                    ^~~~~~~~~~~~~~~~~~~~
      |                    ptouch_getmaxwidth
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c:95:22: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘size_t’ {aka ‘long unsigned int’} [-Wformat=]
   95 |  printf("max_pixels=%d, offset=%d\n", max_pixels, offset);
      |                     ~^                ~~~~~~~~~~
      |                      |                |
      |                      int              size_t {aka long unsigned int}
      |                     %ld
In file included from /home/hb/repositories/other/ptouch-print/src/ptouch-print.c:32:
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c: In function ‘main’:
/home/hb/repositories/other/ptouch-print/include/gettext.h:88:25: warning: statement with no effect [-Wunused-value]
   88 |     ((void) (Domainname), (const char *) (Dirname))
      |     ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c:484:2: note: in expansion of macro ‘bindtextdomain’
  484 |  bindtextdomain("ptouch-print", "/usr/share/locale/");
      |  ^~~~~~~~~~~~~~
/home/hb/repositories/other/ptouch-print/include/gettext.h:85:34: warning: statement with no effect [-Wunused-value]
   85 | # define textdomain(Domainname) ((const char *) (Domainname))
      |                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c:485:2: note: in expansion of macro ‘textdomain’
  485 |  textdomain("ptouch-print");
      |  ^~~~~~~~~~
/home/hb/repositories/other/ptouch-print/src/ptouch-print.c:531:5: warning: implicit declaration of function ‘ptouch_rawstatus’; did you mean ‘ptouch_getstatus’? [-Wimplicit-function-declaration]
  531 |     ptouch_rawstatus(ptdev->status);
      |     ^~~~~~~~~~~~~~~~
      |     ptouch_getstatus
[100%] Linking C executable ptouch-print
[100%] Built target ptouch-print
```

[PT-450]: https://www.brother-usa.com/products/ptd450
[ptouch-print]: https://git.familie-radermacher.ch/linux/ptouch-print.git