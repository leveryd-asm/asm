# asm是什么？

<table>
  <tr>
      <td width="50%" align="center"><b>提交爬扫任务</b></td>
      <td width="50%" align="center"><b>查看报警</b></td>
  </tr>
  <tr>
     <td><img src="https://user-images.githubusercontent.com/1846319/209668967-d2eff688-80b5-4657-9429-51b2c1d06ba8.png"/></td>
     <td><img src="https://user-images.githubusercontent.com/1846319/209669120-0e7ef61b-7c64-47de-8536-3d00cef2c164.png"/></td>
  </tr>
  <tr>
      <td width="50%" align="center"><b>提交POC扫描任务</b></td>
      <td width="50%" align="center"><b>查看任务状态</b></td>
  </tr>
  <tr>
     <td><img  src="https://user-images.githubusercontent.com/1846319/209672294-5e74ab2a-3679-447a-96dc-e5fe595480e5.png"/></td>
     <td><img  src="https://user-images.githubusercontent.com/1846319/209672007-0c3c46be-6245-406c-8935-e4200574abb4.png"/></td>
  </tr>
</table>


设计思路见 [基于任务编排玩一玩漏扫](https://mp.weixin.qq.com/s/CQshF0KsDCPB6AmtOgOBqw)

因为担心被人拿来做恶意扫描，所以有需要的可以联系我微信`happy_leveryd`获取demo环境地址。

# 特点
<details>
<summary><b>💻  开箱即用 </b></summary>
内置五条工作流，只需要输入资产信息，就可以完成扫描任务
</details>

<details>
<summary><b>🕸 任务编排 </b></summary>
基于argo-workflow提供功能丰富、稳定的任务编排能力
</details>

<details>
<summary><b>🔗  基于kubernetes </b></summary>
任务编排引擎基于kubernetes调度工作容器，因此很容易通过水平扩展提升扫描性能；通过kubesphere可以更好地观测、运维应用
</details>

<details>
<summary><b>🤖 管理控制台 </b></summary>
向用户提供UI界面管理资产、运营漏洞；对于开发者来说，想要在控制台新增一个模板可以很快，常规的crud操作只需要通过配置选项就能完成模块的前后端开发
</details>

<details>
<summary><b>💡 多实例部署 </b></summary>
同一kubernetes集群可以部署多个asm实例，数据互不影响。所以你可以区分正式环境和线上环境，也可以对不同类型的资产分别部署实例（比如国外资产和国内资产）
</details>

# 运维指南
## 在k8s集群中一键部署
* 安装 kubesphere

kubesphere 可以用来管理k8s集群，并且提供了`ingress controller`。

可以按照如下命令安装`v3.3.1`版本
```
kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.1/kubesphere-installer.yaml
kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.1/cluster-configuration.yaml
```

> 详细安装步骤参考 [kubesphere](https://kubesphere.io/docs/quick-start/minimal-kubesphere-on-k8s/)

如果你不需要kubesphere，可以使用`ingress-nginx`作为`ingress controller`。

* 安装本项目

第一次安装，需要执行`helm dependency build`下载依赖。

执行如下命令会在asm命名空间中安装本项目
```
helm -n asm template ./helm | kubectl apply -n asm -f -
```

你也可以向helm传递参数来修改安装的配置，如下命令会使用`manage.com`作为域名访问控制台
```
helm -n asm template ./helm --set console_domain=manage.com  | kubectl apply -n asm -f -
```

* 卸载本项目
```
helm -n asm template ./helm | kubectl delete -n asm -f -
```

# 用户指南
## 怎么访问asm控制台？

绑定域名到node节点后(域名默认是`console.com`)，在`kubesphere`控制台上找到`console` ingress访问地址，如下图所示

![](https://user-images.githubusercontent.com/1846319/209645921-d845c719-4f31-4e88-ae7c-c4326019b90a.png)
![](https://user-images.githubusercontent.com/1846319/209645971-34b5443c-bcd3-46a2-84a8-fa2378cbc9df.png)

访问服务进入到asm控制台
![](https://user-images.githubusercontent.com/1846319/209646013-f7486b38-f79d-4e5a-9b1e-2ff2f2a199aa.png)

## 怎么对某个域名做漏洞扫描？

可以选择默认的`nuclei扫描-保存结果`模板，如下图所示。输入域名后，点击`Submit`按钮，等待扫描完成即可。

![](https://user-images.githubusercontent.com/1846319/209649547-4e262584-ed7c-4503-9510-79b459b065ea.png)

默认还有其他模板，可以针对二级域名(比如`leveryd.top`)做扫描，或者针对库中的二级域名列表做扫描。你可以根据自己的需求选择合适的模板。

## 怎么运营漏洞？
你可以在asm控制台上运营漏洞。

xray扫描的漏洞也会通过webhook推送到企业微信群。

> 需要你在安装本项目时有设置`weixin_webhook_url`参数，比如`helm --set weixin_webhook_url=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=07d4613c-45ef-46e2-9379-a7b2aade3132`

## 怎么管理扫描任务？
你可以在控制台上管理扫描任务，具体办法如下。

浏览器输入 `http://asm控制台地址/argo` 地址，进入到argo界面，点击`Submit Workflow`按钮，选择一个模板后，创建一个扫描任务.

![](https://user-images.githubusercontent.com/1846319/209646774-bf267eb3-b842-4560-bf6b-2f169671fc81.png)

## 怎么管理任务模板？
你可以在控制台上管理任务模板 ，目前默认有五个工作流，功能分别是：
* 从API获取兄弟域名-获取子域名-nuclei扫描-保存结果
* 从API获取兄弟域名-获取子域名-katana爬虫-xray扫描-保存结果
* 获取子域名-nuclei扫描-保存结果
* 获取子域名-katana爬虫-xray扫描-保存结果
* nuclei扫描-保存结果

子域名扫描用到`oneforall`、`subfinder`等工具。

当然你也可以定义自己的任务模板，可以参考`helm/templates/argo`目录下的模板文件。

## 贡献者 ✨

欢迎任何形式的贡献! 感谢这些优秀的贡献者，是他们让我们的项目快速成长。

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center"><a href="https://github.com/Evilran"><img src="https://avatars.githubusercontent.com/u/8848173?v=4?s=100" width="100px;" alt="pixiake"/><br /><sub><b>Evilran</b></sub></a><br /></td>
    </tr>

  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
