#!/usr/bin/env python2
#-*- coding:utf-8 -*-
#

# Useage:
#   tools/convert.py sourcedir resultdir

import os
import sys
import subprocess
import ConfigParser
import shutil
import threading

OPTIPNG = '/usr/bin/optipng'
SVGEXPORT = '/usr/bin/svgexport'

INDEX = 'index.theme'

def copytree(src, dst, symlinks=False, ignore=None):
    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks, ignore)
        else:
            shutil.copy2(s, d)

class Render(object):
    _instance = None
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = object.__new__(cls)
        return cls._instance

    def optimize_png(self, png_file):
        if os.path.exists(OPTIPNG):
            process = subprocess.Popen([OPTIPNG, '-quiet', '-o7', png_file])
            process.wait()

    def render_svg(self, icon_file, width, height, output_file):
        process = subprocess.Popen([SVGEXPORT, icon_file, output_file, 'output', '%s:%s' % (width, height)])
        process.wait()
        self.optimize_png(output_file)

    def copy_file(self, source_path, dest_path):
        print "[Info] Copy %s -> %s" % (source_path, dest_path)
        if os.path.lexists(dest_path):
            os.unlink(dest_path)
        shutil.copy2(source_path, dest_path)

    def copy_link(self, source_name, dest_name, output_dir):
        curdir=os.getcwd()
        try:
            os.chdir(output_dir)
            if os.path.lexists(dest_name):
                os.unlink(dest_name)
            os.symlink(source_name, dest_name)
        finally:
            os.chdir(curdir)

class Paser(object):
    def __init__(self, src_path, result):
        self.src_path = src_path
        self.result = result
        self.cf = ConfigParser.ConfigParser()
        self.cf.read(os.path.join(src_path, INDEX))
        self.basedir=os.path.join(os.getcwd(),result)
        self.render=Render()
        self.theme_dir = self.get_info('Icon Theme','Name').lower()

    def install_misc(self):
        import shutil
        print "[Info] Copy index.theme..."
        shutil.copy2(os.path.join(self.src_path,"index.theme"), os.path.join(self.basedir, self.theme_dir))
        if os.path.exists(os.path.join(self.src_path,"overrides")):
            copytree(os.path.join(self.src_path,"overrides"), os.path.join(self.basedir, self.theme_dir))


    def get_info(self,section,key):
        return self.cf.get(section, key)

    def create_dirs(self):
        if not os.path.exists(os.path.join(self.basedir,self.theme_dir)):
            os.makedirs(os.path.join(self.basedir,self.theme_dir))

        for d in self.get_info('Icon Theme','Directories').split(','):
            if not os.path.exists(os.path.join(self.basedir, self.theme_dir, d)):
                    os.makedirs(os.path.join(self.basedir, self.theme_dir, d))

    def handler_content(self):
        self.create_dirs()
        dirs = self.get_info('Icon Theme','Directories').split(',')
        for d in dirs:
            self.render_directory(d)

    def render_directory(self, directory):
        size=self.get_info(directory,'Size')
        if directory.split('/')[0].replace('x','').isdigit:
            src_dir,flag=directory.split('/')
        else:
            flag,src_dir=directory.split('/')

        if flag == 'scalable':
            out_format = "svg"
        else:
            out_format = "png"

        threads = []

        for d,_,files in os.walk(os.path.join(self.src_path, src_dir)):
            for f in files:
                 if not f.endswith(".svg"):
                     continue 
                 if out_format == "png":
                     output_file=f.replace(".svg",".png")
                 else:
                     output_file=f

                 if not os.path.islink(os.path.join(d, f)):
                     if output_file.endswith(".svg"):
                         self.render.copy_file(os.path.join(d,f), os.path.join(self.result, self.theme_dir, directory, output_file))
                     elif output_file.endswith(".png"):
                         th = threading.Thread(target=self.render.render_svg, args=(os.path.join(d,f), size, size, os.path.join(self.result, self.theme_dir, directory, output_file)))
                         th.start()
                         threads.append(th)
                     else:
                         print "[WARNING] Not support %s" % output_file
                         pass

                 else:
                     source=os.path.basename(os.path.realpath(os.path.join(d,f)))
                     if out_format == "png":
                         real_source=source.replace(".svg",".png")
                     else:
                         real_source=source
                     self.render.copy_link(real_source, output_file, os.path.join(self.result,self.theme_dir,directory))
        for th in threads:
            th.join()

if __name__ == "__main__":
    src_dir = sys.argv[1]
    result_dir = sys.argv[2]
    t = Paser(src_dir, result_dir)
    t.handler_content()
    t.install_misc()
