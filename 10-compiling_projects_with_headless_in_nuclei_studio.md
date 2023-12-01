# 在Nuclei Studio下用命令行编译工程
Nuclei Studio是图形化（GUI）的代码编写工具，但是在某些特定的场景下，用户需要通过命令行来快速编译工程，在Nuclei Studio中，只需要一行命令就可以实现。下载好Nuclei Studio后，在Nuclei Studio的workspace已经创建好了需要编译的工程`test`,**同时Nuclei Studio已退出运行**,执行以下命令就可以完成工程的编译。
```shell
NucleiStudio.exe -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -data C:\NucleiStudio_workspace -cleanBuild test/Debug -Debug
```

- NucleiStudio.exe：该参数是Nuclei Studio的启动应用，在Nuclei Studio的安装目录下。
- -nosplash：该参数用于关闭启动时的 Splash 屏幕。这意味着在启动 Eclipse 时不会显示一个短暂的加载屏幕。
- -application：该参数用于指定要运行的应用程序。在这里，`org.eclipse.cdt.managedbuilder.core.headlessbuild` 是指  Headless 构建应用程序。该应用程序用于执行构建操作，而不需要图形用户界面（GUI）。
- -data：该参数用于指定工作区路径。它告诉 Nuclei Studio 将数据存储在哪里，例如工作空间、项目和文件。
- -build：该参数用于指定需要编译的工程，`test/Debug`，表示的是编译test工程中的Debug配置；一般Nuclei Studio创建的工程有Debug、Release两套配置，如果不指定配置，这个默认会编译出Debug、Release，可以看到编译后工程目录下有Debug、Release两个目录。
```    
    ├─.settings
    ├─application
    ├─Debug
    │  ├─application
    │  └─nuclei_sdk
    ├─nuclei_sdk
    └─Release
        ├─application
        └─nuclei_sdk
   ```
- -cleanBuild：该参数与`-build`类似，只是在编译之前，会清空清理工作空间。建议使用`-cleanBuild`。
- -Debug：该参数用于指定编译过程是Debug模式，在编译时会输出详细的编译过程日志。如果不带此参数，命令将静默执行，没有任何输出。


以下为`org.eclipse.cdt.managedbuilder.core.headlessbuild`所提供的参数，以供参考。
```
   -data       {/path/to/workspace}
   -remove     {[uri:/]/path/to/project}
   -removeAll  {[uri:/]/path/to/projectTreeURI} Remove all projects under URI
   -import     {[uri:/]/path/to/project}
   -importAll  {[uri:/]/path/to/projectTreeURI} Import all projects under URI
   -build      {project_name_reg_ex{/config_reg_ex} | all}
   -cleanBuild {project_name_reg_ex{/config_reg_ex} | all}
   -markerType Marker types to fail build on {all | cdt | marker_id}
   -no-indexer Disable indexer
   -verbose    Verbose progress monitor updates
   -printErrorMarkers Print all error markers
   -I          {include_path} additional include_path to add to tools
   -include    {include_file} additional include_file to pass to tools
   -D          {prepoc_define} addition preprocessor defines to pass to the tools
   -E          {var=value} replace/add value to environment variable when running all tools
   -Ea         {var=value} append value to environment variable when running all tools
   -Ep         {var=value} prepend value to environment variable when running all tools
   -Er         {var} remove/unset the given environment variable
   -T          {toolid} {optionid=value} replace a tool option value in each configuration built
   -Ta         {toolid} {optionid=value} append to a tool option value in each configuration built
   -Tp         {toolid} {optionid=value} prepend to a tool option value in each configuration built
   -Tr         {toolid} {optionid=value} remove a tool option value in each configuration built
               Tool option values are parsed as a string, comma separated list of strings or a boolean based on the options type
               
```