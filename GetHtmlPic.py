# -*- coding: utf-8 -*-
import urllib
import re
import time
import os

#显示下载进度
def schedule(a,b,c):
  '''''
  a:已经下载的数据块
  b:数据块的大小
  c:远程文件的大小
   '''
  per = 100.0 * a * b / c
  if per > 100 :
    per = 100
  print '%.2f%%' % per

def getHtml(url):
  page = urllib.urlopen(url)
  html = page.read()
  return html

def downloadImg(html):
  ###fa 正则匹配网页中元素
  #reg = r'src="(.+?\.jpg)"'                        ###fa 爬取普通网页
  reg = r'objURL":"(http://.+?\.jpg)"'              ###fa 爬取搜索百度图片

  imgre = re.compile(reg)
  imglist = re.findall(imgre, html)
  #定义文件夹的名字
  t = time.localtime(time.time())
  foldername = str(t.__getattribute__("tm_year"))+"-"+str(t.__getattribute__("tm_mon"))+"-"+str(t.__getattribute__("tm_mday"))
  ###fa   桌面路径文件夹
  picpath = '/Users/0280102pc0102/Desktop/%s' % (foldername) #下载到的本地目录
  
  if not os.path.exists(picpath):   #路径不存在时创建一个
    os.makedirs(picpath)   
  x = 0
  for imgurl in imglist:
    target = picpath+'/%s.jpg' % x
    print 'Downloading image to location: ' + target + '\nurl=' + imgurl
    image = urllib.urlretrieve(imgurl, target, schedule)
    x += 1
  return image;

  
if __name__ == '__main__':
  print '''		
     ********************************
      **	  Welcome to use Spider	  **
      **	 Created on  2014-05-13	  **
      **	   @author: cruise		    **
      **   start getting pictures   **
      ********************************'''
  ###fa 要抓取的网页地址
  pichtml="http://image.baidu.com/search/index?tn=baiduimage&ipn=r&ct=201326592&cl=2&lm=-1&st=-1&fr=&sf=1&fmq=1463574658346_R&pv=&ic=0&nc=1&z=&se=1&showtab=0&fb=0&width=&height=&face=0&istype=2&ie=utf-8&word=御坂美琴"
  #pichtml="http://yd.sina.cn/article/detail-iawzunex3797944.d.html"   
  #pichtml ="http://tieba.baidu.com/p/2460150866"
  #html = getHtml("http://tieba.baidu.com/p/2460150866")
  html = getHtml(pichtml)
  downloadImg(html)
  print "Download has finished."