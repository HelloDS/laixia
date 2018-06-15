local GameAbout = class("GameAbout", import("...CBaseDialog"):new()) -- 
local soundConfig = laixia.soundcfg;    

function GameAbout:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameAbout:getName()
    return "GameAbout"
end

function GameAbout:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_GAMEDESCRIBE_WINDOW, handler(self, self.show))
    self.shengming = "来下科技是国内几位资深游戏老兵于2017年共同创办的棋牌竞技娱乐公司，先后获得众多资本青睐和种子轮投资。公司致力于推动全民棋牌竞技精神的普及和发扬，将会以斗地主为基础，不断完善增加游戏品类，为用户打造休闲娱乐全新体验。"
    self.yinsi = "1要求用户提供与其个人身份有关的信息资料时，应当事先以明确而易见的方式向用户公开其隐私权保护政策和个人信息利用政策，并采取必要措施保护用户的个人信息资料的安全。2未经用户许可运营商不得向任何第三方提供、公开或共享用户注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：（1）用户或用户监护人授权甲方披露的；（2）有关法律要求运营商披露的；（3）司法机关或行政机关基于法定程序要求运营商提供的；（4）运营商为了维护自己合法权益而向用户提起诉讼或者仲裁时；（5）应用户监护人的合法要求而提供用户个人身份信息时。"
    self.zhishi = "引言\n\
    芝士超人重视您的隐私。 \n\
您在使用芝士超人服务时，芝士超人（湖南湘生网络科技有限公司出品）可能会收集和使用您的信息。 \n\
芝士超人希望通过本《隐私政策》向您说明在您使用芝士超人的服务时，芝士超人如何收集、使用、储存和分享这些信息，以及芝士超人为您提供的访问、更新、控制和保护这些信息的方式。本《隐私政策》与您所使用的芝士超人服务息息相关，芝士超人也希望您能够仔细阅读，并在需要时，按照本《隐私政策》的指引，作出您认为适当的选择。本《隐私政策》之中涉及的相关技术词汇，芝士超人尽量以简明扼要的表述向您解释，并提供了进一步说明的链接，以便您的理解。 您使用或继续使用芝士超人的服务，视为您同意芝士超人按照本《隐私政策》收集、使用、储存和分享您的信息。 \n\
如您对本《隐私政策》或与本《隐私政策》相关的事宜有任何问题，请通过support@ingkee.com 与芝士超人联系。 \n\
芝士超人收集的信息\n\
    芝士超人提供服务时，可能会收集、储存和使用下列与您有关的信息。如果您不提供相关信息，可能无法注册成为芝士超人的用户、享受芝士超人提供的某些服务，或者即便芝士超人可以继续向您提供一些服务，也无法达到该服务拟达到的效果。\n\
您提供的信息\n\
    您在注册芝士超人的账户或使用芝士超人的服务时，向芝士超人提供的相关个人信息，例如电话号码、电子邮件等；\n\
您通过芝士超人的服务向其他方提供的共享信息，以及您使用芝士超人的服务时所储存的信息。 \n\
其他方分享的您的信息\n\
其他方使用我们的服务时所提供有关您的共享信息。\n\
芝士超人获取的您的信息\n\
    您使用芝士超人服务时芝士超人可能收集如下信息：\n\
日志信息指您使用芝士超人服务时，系统可能会通过cookies、web beacon或其他方式自动采集的技术信息，包括： \n\
设备或软件信息，例如您的移动设备、网页浏览器或您用于接入芝士超人的服务的其他程序所提供的配置信息、您的IP地址和您的移动设备所用的版本和设备识别码； \n\
您在使用芝士超人服务时搜索和浏览的信息，例如您使用的网页搜索词语、访问的社交媒体页面url地址，以及您在使用芝士超人服务时浏览或要求提供的其他信息和内容详情； \n\
有关您曾使用的移动应用（APP）和其他软件的信息，以及您曾经使用该等移动应用和软件的信息； \n\
您通过芝士超人的服务进行通讯的信息，例如曾通讯的账号，以及通讯时间、数据和时长； \n\
您通过芝士超人的服务分享的内容所包含的信息（元数据），例如拍摄或上传的共享照片或录像的日期、时间或地点等。 \n\
位置信息指您开启设备定位功能并使用芝士超人基于位置提供的相关服务时，芝士超人收集的有关您位置的信息，包括： \n\
您通过具有定位功能的移动设备使用芝士超人的服务时，芝士超人通过GPS或WiFi等方式收集的您的地理位置信息； \n\
您或其他用户提供的包含您所处地理位置的实时信息，例如您提供的账户信息中包含的您所在地区信息，您或其他人上传的显示您当前或曾经所处地理位置的共享信息，例如您或其他人共享的照片包含的地理标记信息；\n\
您可以通过关闭定位功能随时停止芝士超人对您的地理位置信息的收集。\n\
芝士超人如何使用您的信息\n\
    芝士超人可能将在向您提供服务的过程之中所收集的信息用作下列用途： \n\
向您提供服务； \n\
在芝士超人提供服务时，用于身份验证、客户服务、安全防范、诈骗监测、存档和备份用途，确保芝士超人向您提供的产品和服务的安全性；\n\
帮助芝士超人设计新服务，改善芝士超人现有服务； \n\
使芝士超人更加了解您如何接入和使用芝士超人的服务，从而针对性地回应您的个性化需求，例如语言设定、位置设定、个性化的帮助服务和指示，或对您和其他使用芝士超人服务的用户作出其他方面的回应；\n\
向您提供与您更加相关的广告以替代普遍投放的广告； \n\
评估芝士超人服务中的广告和其他促销及推广活动的效果，并加以改善； \n\
软件认证或管理软件升级； \n\
让您参与有关芝士超人产品和服务的调查。 \n\
为了让芝士超人的用户有更好的体验、改善芝士超人的服务或您同意的其他用途，在符合相关法律法规的前提下，芝士超人可能将通过芝士超人的某一项服务所收集的个人信息，以汇集信息或者个性化的方式，用于芝士超人的其他服务。例如，在您使用芝士超人的一项服务时所收集的您的个人信息，可能在另一服务中用于向您提供特定内容或向您展示与您相关的、而非普遍推送的信息。如芝士超人在相关服务之中提供了相应选项，您也可以主动要求芝士超人将您在该服务所提供和储存的个人信息用于芝士超人的其他服务。 针对某些特定服务的特定隐私政策将更具体地说明芝士超人在该等服务中如何使用您的信息。\n\
如何访问和控制您的信息\n\
    芝士超人将尽量采取适当的技术手段，保证您可以访问、更新和更正您的注册信息或使用芝士超人的服务时提供的其他个人信息。在访问、更新、更正和删除您的个人信息时，芝士超人可能会要求您进行身份验证，以保障您的账户安全。\n\
芝士超人如何分享您的信息\n\
除以下情形外，未经您同意，芝士超人、芝士超人关联方或合作方不会与任何第三方分享您的个人信息： \n\
芝士超人以及芝士超人的关联公司可能将您的个人信息与芝士超人的关联公司、合作方及第三方服务供应商、承包商及代理（例如代表芝士超人发出电子邮件或推送通知的通讯服务提供商、以及为芝士超人提供位置数据的地图服务供应商）分享（他们可能并非位于您所在法域），用作下列用途： \n\
向您提供芝士超人的服务； \n\
实现“芝士超人如何使用您的信息”部分所述目的； \n\
履行芝士超人在本《隐私政策》中的义务和形式芝士超人的权利； \n\
理解、维护和改善芝士超人的服务。 \n\
如芝士超人或芝士超人的关联公司与任何上述第三方分享您的个人信息，芝士超人将努力确保该等第三方在使用您的个人信息时遵守本《隐私政策》及芝士超人要求其遵守的其他适当的保密和安全措施。 \n\
随着芝士超人业务的持续发展，芝士超人以及芝士超人的关联公司有可能进行合并、收购、资产转让或类似的交易，而您的个人信息有可能作为此类交易的一部分而被转移。芝士超人将在您的个人信息转移前通知您。 \n\
芝士超人或芝士超人的关联公司还可能为以下需要保留、保存或披露您的个人信息： \n\
遵守适用的法律法规； \n\
遵守法院命令或其他法律程序的规定； \n\
遵守相关政府机关的要求； \n\
芝士超人为遵守适用的法律法规、维护社会公共利益、或保护芝士超人或芝士超人的集团公司、芝士超人的客户、其他用户或雇员的人身和财产安全或合法权益所合理必需的。\n\
芝士超人如何保留、储存和保护您的信息\n\
    芝士超人仅在本《隐私政策》所述目的所必需期间和法律法规要求的时限内保留您的个人信息。芝士超人使用各种安全技术和程序，以防信息的丢失、不当使用、未经授权阅览或披露。例如，在某些服务中，芝士超人将利用加密技术（例如SSL）来保护您向芝士超人提供的个人信息。但请您谅解，由于技术的限制以及风险防范的局限，即便芝士超人已经尽量加强安全措施，也无法始终保证信息百分之百的安全。您需要了解，您接入芝士超人的服务所用的系统和通讯网络，有可能因芝士超人可控范围外的情况而发生问题。\n\
有关共享信息的提示\n\
芝士超人的多项服务可让您不仅与您的社交网络、也与使用该服务的所有用户公开分享您的相关信息，例如，您在芝士超人的服务中所上传或发布的信息（包括您公开的个人信息、您建立的名单）、您对其他人上传或发布的信息作出的回应，以及包括与这些信息有关的位置数据和日志信息。使用芝士超人服务的其他用户也有可能分享与您有关的信息（包括位置数据和日志信息）。特别是芝士超人的社交媒体服务，是专为使您可以与世界各地的用户共享信息而设计，从而使共享信息可实时、广泛的传递。只要您不删除共享信息，有关信息便一直留存在公众领域；即使您删除共享信息，有关信息仍可能由其他用户或不受芝士超人控制的非关联第三方独立地缓存、复制或储存，或由其他用户或该等第三方在公众领域保存。 因此，请您认真考虑您通过芝士超人的服务上传、发布和交流的信息内容。在一些情况下，您可通过芝士超人某些服务的隐私设定来控制有权浏览您的共享信息的用户范围。如您要求从芝士超人的服务中删除您的个人信息，请通过该等特别服务条款提供的方式操作。\n\
有关敏感个人信息的提示\n\
    某些个人信息因其特殊性可能被认为是敏感个人信息，例如您的种族、宗教、个人健康和医疗信息等。相比其他个人信息，敏感个人信息受到更加严格的保护。\n\
请注意，您在我们的服务中所提供、上传或发布的内容和信息（例如有关您社交活动的照片或信息），可能会泄露您的敏感个人信息。您需要谨慎地考虑，是否使用我们的服务披露您的敏感个人信息。\n\
您同意您的敏感个人信息按本《隐私政策》所述的目的和方式来处理。\n\
COOKIES、日志档案和WEB BEACON\n\
    芝士超人和第三方合作伙伴可能通过cookies和web beacon收集和使用您的信息，并将该等信息储存为日志信息。 \n\
芝士超人使用自己的cookies和web beacon，目的是为您提供更个性化的用户体验和服务，并用于以下用途： \n\
记住您的身份。例如：cookies和web beacon有助于芝士超人辨认您作为芝士超人的注册用户的身份，或保存您向芝士超人提供有关您的喜好或其他信息； \n\
分析您使用芝士超人服务的情况。芝士超人可利用cookies和web beacon来了解您使用芝士超人的服务进行什么活动、或哪些网页或服务最受欢迎；广告优化。Cookies和web beacon有助于芝士超人根据您的信息，向您提供与您相关的广告而非进行普遍的广告投放。\n\
芝士超人为上述目的使用cookies和web beacon的同时，可能将通过cookies和web beacon收集的非个人身份信息汇总提供给广告商和其他伙伴，用于分析 您和其他用户如何使用芝士超人的服务并用于广告服务。芝士超人的产品和服务上可能会有广告商和其他合作方放置的cookies和web beacon。这些cookies和web beacon可能会收集与您相关的非个人身份信息，以用于分析用户如何使用该等服务、向您发送您可能感兴趣的广告，或用于评估广告服务的效果。这些第三方cookies和web beacon收集和使用该等信息不受本《隐私政策》约束，而是受到其自身的隐私政策约束，芝士超人不对第三方的cookies或web beacon承担责任。 \n\
您可以通过浏览器设置拒绝或管理cookies或web beacon。但请您注意，如果您停用cookies或web beacon，芝士超人有可能无法为您提供最佳的服务体验，某些服务也可能无法正常使用。同时，您仍然将收到同样数量的广告，只是这些广告与您的相关性会降低。\n\
广告\n\
    芝士超人可能使用您的信息，向您提供与您更加相关的广告。 \n\
芝士超人也可能使用您的信息，通过芝士超人的服务、电子邮件或其他方式向您发送营销信息，提供或推广芝士超人或第三方的如下商品和服务：\n\
芝士超人的商品和服务，以及芝士超人的关联公司和合营伙伴的商品和服务，包括即时通讯服务、网上媒体服务、互动娱乐服务、社交网络服务、付款服务、互联网搜索服务、位置和地图服务、应用软件和服务、数据管理软件和服务、网上广告服务、互联网金融及其他社交媒体、娱乐、电子商务、资讯及通讯软件和服务（“互联网服务”）；\n\
第三方互联网服务供应商，以及与下列有关的第三方商品和服务：食物和餐饮、体育、音乐、电影、电视、现场表演和其他艺术和娱乐、书册、杂志和其他刊物、服装和配饰、珠宝、化妆品、个人健康和卫生、电子、收藏品、家用器皿、电器、家居装饰和摆设、宠物、汽车、酒店、交通和旅游、银行、保险及金融服务、会员积分和奖励计划，以及芝士超人认为可能与您相关的其他商品和服务。如您不希望芝士超人将您的个人信息用作前述广告用途，您可以通过芝士超人在广告中提供的相关指示、或在特定服务中提供的指引，要求芝士超人停止为上述用途使用您的个人信息。\n\
芝士超人向您发送的邮件和信息\n\
    邮件和信息推送您使用芝士超人服务时，芝士超人可能使用您的信息向您的设备发送电子邮件、新闻或推送通知。如您不希望收到这些信息，您可以按照芝士超人向您发出的电子邮件所述指示，在设备上选择取消订阅。与服务有关的公告 芝士超人可能在必需时（例如当芝士超人由于系统维护而暂停某一项服务时）向您发出与服务有关的公告。您可能无法取消这些与服务有关、性质不属于推广的公告。\n\
我们服务中的第三方服务\n\
    芝士超人的服务可能包括或链接至第三方提供的社交媒体或其他服务（包括网站）。例如：\n\
您可利用“分享”键将某些内容分享到芝士超人的服务，或您可利用第三方连线服务登录芝士超人的服务。这些功能可能会收集您的信息（包括您的日志信息），并可能在您的电脑装置cookies，从而正常运行上述功能； \n\
芝士超人通过广告或芝士超人服务的其他方式向您提供链接，使您可以接入第三方的服务或网站。 \n\
该等第三方社交媒体或其他服务可能由相关的第三方或芝士超人运营。您使用该等第三方的社交媒体服务或其他服务（包括您向该等第三方提供的任何个人信息），须受第三方自己的服务条款及隐私政策（而非《通用服务条款》或本《隐私政策》）约束，您需要仔细阅读其条款。本《隐私政策》仅适用于芝士超人所收集的任何信息，并不适用于任何第三方提供的服务或第三方的信息使用规则，而芝士超人对任何第三方使用由您提供的信息不承担任何责任。\n\
年龄限制\n\
    芝士超人禁止未成年人进行充值、消费行为。芝士超人鼓励父母或监护人指导未满十八岁的未成年人使用芝士超人的服务。芝士超人建议未成年人鼓励他们的父母或监护人阅读本《隐私政策》，并建议未成年人在提交的个人信息之前寻求父母或监护人的同意和指导。\n\
本《隐私政策》的适用范围\n\
    除某些特定服务外，芝士超人所有的服务均适用本《隐私政策》。这些特定服务将适用特定的隐私政策。该特定服务的隐私政策构成本《隐私政策》的一部分。如任何特定服务的隐私政策与本《隐私政策》有不一致之处，则适用特定服务的隐私政策。 \n\
请您注意，本《隐私政策》不适用于以下情况： \n\
通过芝士超人的服务而接入的第三方服务（包括任何第三方网站）收集的信息； \n\
通过在芝士超人服务中提供广告服务的第三方所收集的信息。\n\
本《隐私政策》的修改\n\
芝士超人可能随时修改本《隐私政策》的条款，该等修改构成本《隐私政策》的一部分。如该等修改造成您在本《隐私政策》下权利的实质减少，芝士超人将在修改生效前通过在主页上显著位置提示或向您发送电子邮件或以其他方式通知您，在该种情况下，若您继续使用芝士超人的服务，即表示同意受经修订的本《隐私政策》的约束。"
  self.xieyi = "一、总则 \n\
1.1 本《协议》为您（即用户）与来下科技有限公司（以下简称来下科技公司）就来下科技公司所提供的服务达成的协议。来下科技公司在此特别提醒您认真阅读、充分理解本《用户服务协议》（下称《协议》） 用户应认真阅读、充分理解本《协议》中各条款，特别涉及免除或者限制来下科技公司责任的免责条款，对用户的权利限制的条款，法律适用、争议解决方式的条款。\n\
1.2 请您审慎阅读并选择同意或不同意本《协议》，除非您接受本《协议》所有条款，否则您无权下载、安装、升级、登陆、显示、运行、截屏等方式使用本软件及其相关服务。您的下载、安装、显示、帐号获取和登录、截屏等行为表明您自愿接受本协议的全部内容并受其约束，不得以任何理由包括但不限于未能认真阅读本协议等作为纠纷抗辩理由。\n\
1.3 本《协议》可由来下科技公司随时更新，更新后的协议条款一旦公布即代替原来的协议条款，不再另行个别通知。您可重新下载安装本软件或网站查阅最新版协议条款。在来下科技公司修改《协议》条款后，如果您不接受修改后的条款，请立即停止使用来下科技公司提供的软件和服务，您继续使用来下科技公司提供的软件和服务将被视为已接受了修改后的协议。\n\
1.4 本《协议》内容包括但不限于本协议以下内容，针对某些具体服务所约定的管理办法、公告、重要提示、指引、说明等均为本协议的补充内容，为本协议不可分割之组成部分，具有本协议同等法律效力，接受本协议即视为您自愿接受以上管理办法、公告、重要提示、指引、说明等并受其约束；否则请您立即停止使用来下科技公司提供的软件和服务。\n\
二、特殊规定 \n\
2.1 未满十八周岁的未成年人应经其监护人陪同阅读本服务条款并表示同意，方可接受本服务条款。监护人应加强对未成年人的监督和保护，因其未谨慎履行监护责任而损害未成年人利益或者影响来下科技公司利益的，应由监护人承担责任。\n\
2.2 青少年用户应遵守全国青少年网络文明公约：要善于网上学习，不浏览不良信息；要诚实友好交流，不侮辱欺诈他人；要增强自护意识，不随意约会网友；要维护网络安全，不破坏网络秩序；要有益身心健康，不沉溺虚拟时空。\n\
三、权利声明\n\
3.1 来下科技公司拥有向最终用户提供内容服务的、网址中包含www.laixia.com的互联网网站、以及《来下斗地主》网络游戏平台（以下简称《来下斗地主》）APP及其服务器端、最终客户端程序、文档的（包括上述内容的升级、改进版本）的所有权和一切知识产权，包括但不限于：\n\
　　3.1.1 《来下斗地主》软件及其他物品的著作权、版权、名称权、商标权以及由其派生的各项权利；\n\
　　3.1.2 《来下斗地主》中的电子文档、文字、数据库、图片、图标、图示、照片、程序、音乐、色彩、版面设计、界面设计等可从作品中单独使用的作品元素的著作权、版权、名称权、商标权以及由其派生的各项权利；\n\
　　3.1.3 来下科技公司向用户提供服务过程中所产生并存储于来下科技公司系统中的任何数据（包括但不限于账号、元宝、经验值、级别等游戏数据）的所有权。\n\
　　3.1.4 用户在使用《来下斗地主》游戏过程中产生的电子文档、文字、图片、照片、色彩、游戏界面等可以单独使用的游戏元素，以及由其形成的截屏、录像、录音等衍生品的各项权利。\n\
3.2 上述权利来下科技公司书面授权用户以非商业、不损害来下科技公司利益的目的临时的、有限的、不可转让的使用权。用户不得为商业运营目的安装、使用、运行“来下斗地主”，不可以对该软件或者该软件运行过程中释放到任何计算机终端内存中的数据及该软件运行过程中客户端与服务器端的交互数据进行复制、更改、修改、挂接运行或创作任何衍生作品，形式包括但不限于使用截屏、插件、外挂或非经授权的第三方工具/服务接入本“软件”和相关系统。\n\
3.3 未经来下科技公司书面同意，用户以任何营利性、非营利性或损害来下科技公司利益的目的实施以下几种行为的，来下科技公司保留追究上述未经许可行为一切法律责任的权利，给来下科技公司造成经济或名誉上损失的，来下科技公司有权根据相关法律法规另行要求赔偿，情节严重涉嫌犯罪的，来下科技公司将提交司法机关追究刑事责任：\n\
　　3.3.1 进行编译、反编译等方式破解该软件作品的行为；\n\
　　3.3.2 利用技术手段破坏软件系统或者服务器的行为；\n\
　　3.3.3 利用游戏外挂、作弊软件、系统漏洞侵犯来下科技公司利益的行为；\n\
　　3.3.4 对游戏进行截屏、录像或利用游戏中数据、图片、截屏进行发表的行为；\n\
　　3.3.5 制作游戏线下衍生品的行为；\n\
　　3.3.6 其他严重侵犯来下科技公司知识产权的行为。\n\
四、用户基本权利和责任\n\
4.1 用户享有由来下科技公司根据实际情况提供的各种服务，包括但不限于线上游戏、网上论坛、举办活动等。在某些情况下，来下科技公司许可用户以其来下帐号登录或使用来下科技公司合作方运营的产品或服务。\n\
4.2 用户可以通过充值金豆等方式获得来下科技公司的服务。用户充值金豆至固定账号后，未经来下科技公司书面同意不得将金豆再转至其他账号。\n\
4.3 用户认为自己在游戏中的权益受到侵害，有权根据来下科技公司相关规定进行投诉申诉。\n\
4.4 用户有权对来下科技公司的管理和服务提出批评、意见、建议，有权就客户服务相关工作向客服提出咨询。\n\
4.5 用户在《来下斗地主》的游戏活动应遵守中华人民共和国法律、法规，遵守来下科技公司的相关管理规定（包括但不限于管理办法、禁止性和限制性行为等），并自行承担因游戏活动直接或间接引起的一切法律责任。\n\
4.6 用户有权自主选择依照游戏设定的方式和规则进行竞赛或游戏，对其游戏活动承担相应责任和由此产生的损失，包括经济损失和精神损害。来下科技公司就用户的游戏的行为、活动、交易或利用《来下斗地主》进行的非法活动不承担任何责任。\n\
4.7 用户需遵守网络道德，注意网络礼仪，做到文明上网。\n\
4.8 来下科技公司仅提供相关的网络服务，除此之外与相关网络服务有关的上网设备如电脑、调制解调器及其他互联网接入装置)及所需的费用（如为接入互联网而支付的电话费、上网费）均应由用户自行负担。\n\
五、用户账号\n\
5.1 账号注册\n\
　　5.1.1 在来下科技公司根据国家法律法规要求需要您以真实身份注册成为来下科技公司游戏的用户时，您应提供真实身份信息进行注册并保证所提供的个人身份资料信息真实、完整、有效，并依据法律规定和本条款约定对所提供的信息承担相应的法律责任。\n\
　　5.1.2 账号和昵称注册应符合法律法规和社会公德的要求，不得以党和国家领导人或其他名人的真实姓名、字号、艺名、笔名和不文明、不健康用语注册。\n\
　　5.1.3 您以真实身份注册成为来下科技公司用户后，需要修改所提供的个人身份资料信息的，来下科技公司将及时、有效地为您提供该项服务。\n\
　　5.1.4 账户所有权归属于来下科技公司，用户享有该账户在游戏运营期间的使用权。\n\
5.2 用户账号使用与保管\n\
　　5.2.1 来下科技公司有权审查用户注册所提供的身份信息是否真实、有效，并应积极地采取技术与管理等合理措施保障用户账号的安全、有效；用户有义务妥善保管其账号及密码，并根据来下科技公司的要求正确、安全地使用其账号及密码。因黑客行为或用户保管疏忽等非来下科技公司过错导致帐号、密码遭他人非法使用，来下科技公司不承担任何责任。\n\
　　5.2.2 用户对登录后所持账号产生的行为依法享有权利和承担责任。\n\
　　5.2.3 用户发现其账号或密码被他人非法使用或有使用异常的情况的，应及时根据来下科技公司公布的账号申述规则通知来下科技公司，并有权通知来下科技公司采取措施暂停该账号的登录和使用。\n\
　　5.2.4 来下科技公司根据用户的通知采取措施暂停用户账号的登录和使用的，来下科技公司有权要求用户提供并核实与其注册身份信息相一致的个人有效身份信息。用户没有提供其个人有效身份证件或者用户提供的个人有效身份证件与所注册的身份信息不一致的，来下科技公司有权拒绝用户上述请求。\n\
六、用户信息保护\n\
6.1 来下科技公司将保护用户提供的有效个人信息数据的安全。不对外向任何第三方提供、公开或共享用户注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：\n\
　　6.1.1 用户或用户监护人授权披露的；\n\
　　6.1.2 有关法律要求披露的；\n\
　　6.1.3 司法机关或行政机关基于法定程序要求提供的；\n\
　　6.1.4 来下科技公司为了维护自己合法权益而披露；\n\
　　6.1.5 应用户监护人的合法要求而提供用户个人身份信息时。\n\
6.2 来下科技公司要求用户提供与其个人身份有关的信息资料时，已事先以明确而易见的方式向用户公开其隐私保护政策和个人信息利用政策，并采取必要措施保护用户的个人信息资料的安全。\n\
七、服务的中止与终止\n\
7.1 用户实施或有重大可能实施以下行为的，来下科技公司有权中止对其部分或全部服务，中止提供服务的方式包括但不限于暂停对该账号的登录和使用、暂时禁止使用充值服务、暂时禁止兑换相应奖品、降低或者清除账号中的积分、游戏道具等、暂时禁止使用论坛服务：\n\
　　7.1.1 私下进行买卖游戏道具的行为；\n\
　　7.1.2 提供虚假注册身份信息的行为；\n\
　　7.1.3 游戏中合伙作弊，尚未对其他用户利益造成严重影响的行为；\n\
　　7.1.4 发布不道德信息、广告、言论、辱骂骚扰他人，扰乱正常的网络秩序和游戏秩序的行为；\n\
　　7.1.5 实施违反本协议和相关规定、管理办法、公告、重要提示，对来下科技公司和其他用户利益造成损害的其他行为。\n\
7.2 用户实施或有重大可能实施以下不正当行为的，来下科技公司有权终止对用户提供服务，终止提供服务的方式包括但不限于永久性的删除该账号、发表的帖子、留言、将非法所得的积分和荣誉道具清零：\n\
　　7.2.1 发布违法信息、严重违背社会公德、以及其他违反法律禁止性规定的行为；\n\
　　7.2.2 利用《来下斗地主》进行赌博活动的行为；\n\
　　7.2.3 涉嫌买卖偷盗的虚拟财产、游戏道具的行为；\n\
　　7.2.4 游戏中合伙作弊对其他用户利益造成严重影响的行为；\n\
　　7.2.5 用非法手段盗取其他用户账号和虚拟财产、游戏道具的行为；\n\
　　7.2.6 论坛、游戏中传播非法讯息、木马病毒、外挂软件等的行为；\n\
　　7.2.7 利用游戏作弊工具或者外挂、游戏bug获取非法利益，严重侵犯来下科技公司利益的行为；\n\
　　7.2.8 发布不道德信息、广告、言论、辱骂骚扰他人，严重扰乱正常的网络秩序和游戏秩序的行为；\n\
　　7.2.9 实施违反本协议和相关规定、管理办法、公告、重要提示，对来下科技公司和其他用户利益造成严重损害的其他行为。\n\
7.3 本协议中未涉及到的禁止或限制性行为及处罚规则，由来下科技公司针对具体服务制定相关规定、管理办法、公告、重要提示、指引、说明等，视为本协议之补充协议，为本协议不可分割之组成部分，具有本协议同等法律效力，接受本协议即视为您自愿接受相关规定、管理办法、公告、重要提示、指引、说明等并受其约束。\n\
八、免责条款\n\
8.1 用户之间因线上游戏行为所发生或可能发生的任何心理、生理上的伤害和经济上的损失，来下科技公司不承担任何责任。\n\
8.2 用户因其个人原因造成账号资料保管不妥而导致个人信息数据被他人泄露或账号中虚拟财产、游戏道具被盗或损失的，来下科技公司不承担任何责任。\n\
8.3 用户因除了按游戏规则进行游戏的行为外的其他行为触犯了中华人民共和国法律法规的，责任自负，来下科技不承担任何责任。\n\
8.4 用户账号长期不使用的，来下科技公司有权进行回收，因此带来的用户个人信息数据丢失、账户内虚拟财产和游戏道具清零等一切损失由用户个人承担，来下科技公司不承担任何责任。\n\
8.5 用户因违反本协议7.1、7.2条款而被来下科技公司采取处罚措施所产生的一切损失包括但不限于虚拟货币、积分、荣誉被清零、道具失效或其他损失，均由用户个人承担，来下科技公司不承担任何责任。\n\
8.6 基于网络环境的复杂性，来下科技公司不担保服务一定能满足用户的要求，也不保证各项服务不会中断，对服务的及时性、安全性也不作担保。因网络安全、网络故障问题和其他用户的非法行为给用户造成的损失，来下科技不承担任何责任。\n\
8.7 基于网络环境的特殊性，来下科技公司不担保对用户限制性行为和禁止性行为的判断的准确性，用户因此产生的任何损失来下科技公司不承担任何责任，用户可按来下科技公司相关规定进行申诉解决。\n\
8.8 来下科技公司不保证您从第三方获得的来下科技公司虚拟货币、游戏道具（金币、门票）等游戏物品能正常使用，也不保证该等物品不被索回，因私下购买虚拟货币、游戏道具（金币、门票）等游戏物品所产生的一切损失均由用户承担，来下科技公司不承担任何责任。\n\
九、法律适用和争议解决\n\
本协议的订立、效力、解释、履行和争议的解决均适用中华人民共和国法律。因本协议所产生的以及因履行本协议而产生的任何争议，双方均应本着友好协商的原则加以解决。协商解决未果，任何一方有权向北京海淀区人民法院提请审理。\n\
十、其他\n\
10.1 不弃权原则。除非得到双方签字盖章的书面形式证明，否则，不得对本协议任何条款进行修改、修订或放弃。任何一方未能按照本协议规定行使权力或进行补救或延误进行，不得视为该方放弃行使该种权力，除非本协议另有明文规定。\n\
10.2 可分割性。如果本协议的任何条款违法，该条款将被修改和解释，以在法律允许的最大限度内，最好地实现原条款的目标，同时本协议的其余条款将继续保留其全部效力。"
    self.fuwu = "欢迎申请使用本公司提供的在线网络游戏服务，为了保障您的权益，请详细阅读网络版游戏软件用户条款(以下简称《条款》)所有内容。本《条款》系由用户与本公司就本网络版游戏产品及服务所订立的协议 。甲方为网络游戏运营企业，乙方为网络游戏用户。当用户在本平台注册帐户完成时，则视用户已经详细阅读了本《条款》的内容，并同意遵守本合约的规定。1.账号注册1.1 乙方承诺以其真实身份注册成为甲方的用户，并保证所提供的个人身份资料信息真实、完整、有效，依据法律规定和必备条款约定对所提供的信息承担相应的法律责任。1.2 乙方以其真实身份注册成为甲方用户后，需要修改所提供的个人身份资料信息的，甲方应当及时、有效地为其提供该项服务。2.用户账号使用与保管2.1 根据约定，甲方有权审查乙方注册所提供的身份信息是否真实、有效，并应积极地采取技术与管理等合理措施保障用户账号的安全、有效；乙方有义务妥善保管其账号及密码，并正确、安全地使用其账号及密码。任何一方未尽上述义务导致账号密码遗失、账号被盗等情形而给乙方和他人的民事权利造成损害的，应当承担由此产生的法律责任。2.2乙方对登录后所持账号产生的行为依法享有权利和承担责任。2.3 乙方发现其账号或密码被他人非法使用或有使用异常的情况的，应及时根据甲方公布的处理方式通知甲方，并有权通知甲方采取措施暂停该账号的登录和使用。2.4 甲方根据乙方的通知采取措施暂停乙方账号的登录和使用的，甲方应当要求乙方提供并核实与其注册身份信息相一致的个人有效身份信息。2.4.1 甲方核实乙方所提供的个人有效身份信息与所注册的身份信息相一致的，应当及时采取措施暂停乙方账号的登录和使用。2.4.2 甲方违反2.4.1款项的约定，未及时采取措施暂停乙方账号的登录和使用，因此而给乙方造成损失的，应当承担其相应的法律责任。2.4.3 乙方没有提供其个人有效身份证件或者乙方提供的个人有效身份证件与所注册的身份信息不一致的，甲方有权拒绝乙方上述请求。2.5 乙方为了维护其合法权益，向甲方提供与所注册的身份信息相一致的个人有效身份信息时，甲方应当为乙方提供账号注册人证明、原始注册信息等必要的协助和支持，并根据需要向有关行政机关和司法机关提供相关证据信息资料。3.服务的中止与终止3.1乙方有发布违法信息、严重违背社会公德、以及其他违反法律禁止性规定的行为，甲方应当立即终止对乙方提供服务。3.2乙方在接受甲方服务时实施不正当行为的，甲方有权终止对乙方提供服务。该不正当行为的具体情形应当在本协议中有明确约定或属于甲方事先明确告知的应被终止服务的禁止性行为，否则，甲方不得终止对乙方提供服务。3.3乙方提供虚假注册身份信息，或实施违反本协议的行为，甲方有权中止对乙方提供全部或部分服务；甲方采取中止措施应当通知乙方并告知中止期间，中止期间应该是合理的，中止期间届满甲方应当及时恢复对乙方的服务。3.4 甲方根据本条约定中止或终止对乙方提供部分或全部服务的，甲方应负举证责任。4.用户信息保护4.1 甲方要求乙方提供与其个人身份有关的信息资料时，应当事先以明确而易见的方式向乙方公开其隐私权保护政策和个人信息利用政策，并采取必要措施保护乙方的个人信息资料的安全。4.2未经乙方许可甲方不得向任何第三方提供、公开或共享乙方注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：4.2.1 乙方或乙方监护人授权甲方披露的；4.2.2 有关法律要求甲方披露的；4.2.3 司法机关或行政机关基于法定程序要求甲方提供的；4.2.4 甲方为了维护自己合法权益而向乙方提起诉讼或者仲裁时；4.2.5 应乙方监护人的合法要求而提供乙方个人身份信息时。5.资费政策 5.1有关产品和服务的收费标准、购买方式等信息本公司将会放置在该产品和服务网页的相应位置。5.2本公司有权决定本公司所提供的产品和服务的资费标准和收费方式，本公司可能会就不同的产品和服务制定不同的资费标准和收费方式，也可能按照本公司所提供的产品和服务的不同阶段确定不同的资费标准和收费方式。6.责任限制6.1对于本公司的产品和服务，本公司仅作下述有限保证，该有限保证取代任何文档、包装、或其他资料中的任何其他明示或默示的保证(如果有)。6.2本公司仅以 \"现有状况且包含所有错误\"的形式提供相关的产品、软件或程序及任何支持服务，并仅保证：6.2.1产品和服务基本与本公司正式公布的服务承诺相符。6.2.2本公司仅在商业上允许的合理范围内尽力解决本公司在提供产品和服务过程中所遇到的任何问题。6.3在适用法律允许的最大范围内，本公司明确表示不提供任何其他类型的保证，不论是明示的或默示的，包括但不限于适销性、适用性、可靠性、准确性、完整性、无病毒以及无错误的任何默示保证和责任。7.知识产权7.1本平台网络游戏官方网站上所有的作品及资料，其著作权、专利权、商标专用权、商业秘密权及其它知识产权，均为本公司或授权本公司使用的合法权利人所有，除非事先经本公司或其权利人的合法授权，任何人皆不得擅自以任何形式使用，否则本公司可立即终止向用户提供产品和服务，并依法追究其法律责任，赔偿本公司一切损失。7.2未经本公司授权，任何人不得擅自复制、反编译(de-compile)、反汇编(disassemble)任何功能或程序，不得对任何功能和或程序进行反向工程(reverse engineering)。8.通知8.1本公司所有发给用户的通知可通过重要页面的公告或电子邮件或常规的信件传送。9纠纷9.1本用户条款适用中华人民共和国的法律。9.2如本公司服务条款与中华人民共和国法律相抵触时，则这些条款将完全按法律规定重新解释，而其它条款法律效力不变。9.3如出现纠纷，用户和本公司一致同意交由公司所在地法院管辖。 "
        --暫時帮助用这个文字 by wangtianye
        self.bangzhu = "游戏规则：\n\
1、  一人为地主，其余两人为农民；\n\
2、  发牌到只剩3张之后，开始叫地主，1、2、3分。也可以选择不叫；\n\
3、  所有人都不叫，则本副首叫的用户直接成为地主；\n\
4、  上轮选择不叫的人本副无权再叫；\n\
5、  每副开始后，由系统随机确定一人当地主；\n\
6、  第一轮由地主首先出牌；\n\
7、  其他玩家依次出牌，其他两家均不出时，大住牌的玩家继续出牌；\n\
8、  下一家出的牌必须大过上家出的牌；\n\
9、  两位农民其中一位先于地主身份玩家出完手中所有的牌，即为胜。\n\
10、 地主先于两位农民身份玩家出完手中所有的牌，即为胜。\n\
\n\
牌型：\n\
火箭：即双王（大王+小王），最大的牌；\n\
炸弹：四张同样数字的牌（如四个K）；\n\
单张：单张牌（如：黑桃A）；\n\
对子：数字相同的两张牌（如黑桃Q和红桃Q）；\n\
三张牌：三张数字相同的牌（如三个2）；\n\
三带一：数字相同的三张牌+一张单牌或一对牌。（如222+3或222+44）；\n\
单顺：五张或更多的连续单牌（如34567或78910JQKA，不包括2点和双王）；\n\
双顺：三对或更多的连续对牌（如334455、88991010JJQQKKAA，不包括2点和双王）；\n\
飞机带翅膀：三顺+同数量的单牌或同数量的对牌（如444555+79或666777888+334455）；\n\
四带二：四张牌+两手牌（注：四带二不是炸弹，不翻倍，如AAAA+3+4或KKKK+33+44）；\n\
\n\
牌型比较：\n\
火箭>炸弹>一般牌型（单牌、对牌、三张牌、三带一、单顺、双顺、三顺、飞机带翅膀、四带二）。 "



    self.guanyuyouxi = "《来下斗地主》是一款玩法简单刺激、娱乐性强、老少皆宜的争先型扑克游戏。该游戏由三个人玩一副牌(54张)，每局牌有一个玩家是“地主”，独自对抗另两个组成同盟的农民。双方对战，先出完牌的一方（地主or农民中的任何一人）即可获得胜利。虽然游戏本身带有运气成分，但是它更注重玩家掌握出牌技巧：记牌、算牌、多思考、多总结。开发公司：北京来下科技有限公司"

end

function GameAbout:onShow(data)


    self.data = data.data.data
    -- self.ListView_GuanYuYouXi = self:GetWidgetByName("ListView_GuanYuYouXi")
    -- self.ListView_YinSi = self:GetWidgetByName("ListView_YinSi")
    self.BG = self:GetWidgetByName("Image_1")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    self.ListView_bangzhu = self:GetWidgetByName("ListView_bangzhu")
    self.ListView_FuWu = self:GetWidgetByName("ListView_FuWu")
    self.Text_1 = self:GetWidgetByName("Text_1")
    if self.data == "bangzhu" then         
        if laixia.config.isAudit then
            self:GetWidgetByName("Image_bangzhu"):setVisible(false)
        else
            self:GetWidgetByName("Image_guize"):setVisible(false)   
        end
        self:GetWidgetByName("Image_guanyu"):setVisible(false)
        self:GetWidgetByName("Image_45"):setVisible(false)
        self:GetWidgetByName("Panel_zhuanyong"):setVisible(false)
        self.Text_1:setVisible(false)
        self.ListView_FuWu:setVisible(false)
        self.ListView_bangzhu:runAction(cc.Sequence:create(cc.CallFunc:create(function()
              local txt  = self:GetWidgetByName("Text_bangzhu",self.ListView_bangzhu)
              txt:setString(self.bangzhu)
        end)))
    elseif self.data == "xieyi" then
        self:GetWidgetByName("Image_bangzhu"):setVisible(false)
        self:GetWidgetByName("Image_guize"):setVisible(false)

        self:GetWidgetByName("Image_45"):setVisible(false)
        self:GetWidgetByName("Image_guanyu"):setVisible(false)
        self:GetWidgetByName("Image_4"):setVisible(false)
        self:GetWidgetByName("Image_1"):setVisible(false)
        self:GetWidgetByName("Image_3"):setVisible(false)
        self:GetWidgetByName("Button_GameAbout_Quit"):setVisible(false)

        self:GetWidgetByName("Panel_zhuanyong"):setVisible(true)
        
       

        if device.platform == "ios" then --这块没解决
            self.webView = ccexp.WebView:create()
            self.Image_guanyukuang = self:GetWidgetByName("Image_guanyukuang")
            self.Image_guanyukuang:addChild(self.webView,10)
            if laixia.kconfig.isYingKe == true then
                self.webView:loadURL(laixia.config.ZHISHI_AGREEMENT_URL)
            else
                self.webView:loadURL(laixia.config.AGREEMENT_URL)
            end
            
            self.webView:setVisible(true)
             self.webView:setContentSize(cc.size(self.Image_guanyukuang:getContentSize().width,self.Image_guanyukuang:getContentSize().height)) -- 一定要设置大小才能显示
             self.webView:setScalesPageToFit(true)
    
             self.webView:setAnchorPoint(0.5,0.5)
             self.webView:setPosition(self.Image_guanyukuang:getContentSize().width/2,self.Image_guanyukuang:getContentSize().height/2)
        elseif device.platform == "android" or device.platform == "windows" then
             self.ListView_FuWu:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
                if laixia.kconfig.isYingKe == true then
                    self:GetWidgetByName("Label_MSG_Content"):setString(self.zhishi)
                else
                    self:GetWidgetByName("Label_MSG_Content"):setString(self.xieyi)            
                end
            end)))
        end

    elseif self.data == "guanyu" then
        self:GetWidgetByName("Image_3"):setVisible(false)
        self:GetWidgetByName("Image_guize"):setVisible(false)
        self:GetWidgetByName("Image_bangzhu"):setVisible(false)
        self:GetWidgetByName("Image_45"):setVisible(true)
        self:GetWidgetByName("Panel_zhuanyong"):setVisible(false)
        self:GetWidgetByName("Image_guanyu"):setVisible(true)
         self.ListView_FuWu:setVisible(false)
         self.Text_1:setVisible(false)

        -- self.ListView_FuWu:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
        --     self.Text_1:setString(self.guanyuyouxi)
        -- end)))

--        local agreementScrollVw = self:GetWidgetByName("ListView_FuWu")
--        -- self.Text1 = gt.seekNodeByName(agreementScrollVw,"Text_1")
--        -- self.Text1:setString(xhr)
--        local scrollVwSize = agreementScrollVw:getContentSize()
--        local agreementLabel = display.newTTFLabel({text = self.xieyi,size = 16});
--        agreementLabel:setAnchorPoint(0.5, 0.5)
--        agreementLabel:setColor(cc.c3b(74,6,6))
--        agreementLabel:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
--        agreementLabel:setWidth(scrollVwSize.width)
--        local labelSize = agreementLabel:getContentSize()
--        agreementLabel:setPosition(scrollVwSize.width * 0.5, 0)--labelSize.height)
--        agreementScrollVw:addChild(agreementLabel)
--        agreementScrollVw:setInnerContainerSize(labelSize)
    end

    self:AddWidgetEventListenerFunction("Button_guanyuzhuanyong", handler(self, self.Shutdown))
    self:AddWidgetEventListenerFunction("Button_GameAbout_Quit", handler(self, self.Shutdown))
end

function GameAbout:onHideAllTile()
     for i,v in ipairs(self.mTitleArray) do
          local isshown = v:isVisible()
          v:setVisible(false)
     end
end
--显示唯一的前景按钮
function GameAbout:showOnlyButton(index)
    laixia.UItools.onShowOnly(index,self.ButtonArray)    
end
--关于游戏
function GameAbout:onAboutGame(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.ListView_GuanYuYouXi:setVisible(true)
        self.ListView_YinSi:setVisible(false)
        self.ListView_FuWu:setVisible(false)
        self.ListView_ShengMing:setVisible(false)
        self:showOnlyButton(1)
        self:onHideAllTile()
        self:GetWidgetByName("Image_GameAbout_Title"):setVisible(true)
    end
end
--隐私策略
function GameAbout:onPrivacy(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.ListView_GuanYuYouXi:setVisible(false)
        self.ListView_YinSi:setVisible(true)
        self.ListView_FuWu:setVisible(false)
        self.ListView_ShengMing:setVisible(false)
        self:showOnlyButton(3)
        self:onHideAllTile()
        self:GetWidgetByName("Image_Game_yscl_Tile"):setVisible(true)
    end
end
--服务消息
function GameAbout:onService(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.ListView_GuanYuYouXi:setVisible(false)
        self.ListView_YinSi:setVisible(false)
        self.ListView_FuWu:setVisible(true)
        self.ListView_ShengMing:setVisible(false)
        self:showOnlyButton(5)
        self:onHideAllTile()
        self:GetWidgetByName("Image_Game_fwxy_Tile"):setVisible(true)
    end
end

function GameAbout:onGameStatement(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.ListView_GuanYuYouXi:setVisible(false)
        self.ListView_YinSi:setVisible(false)
        self.ListView_FuWu:setVisible(false)
        self.ListView_ShengMing:setVisible(true)
        self:showOnlyButton(7)
        self:onHideAllTile()
        self:GetWidgetByName("Image_Game_SM_Tile"):setVisible(true)
    end
end


-- 关闭
function GameAbout:Shutdown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        print("+++++++++++++++++++++++++++++++++++++++++++quit")
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end


return GameAbout.new()