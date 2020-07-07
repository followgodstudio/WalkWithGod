import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;
  final String icon;
  final String author;
  final List content;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
    @required this.icon,
    @required this.author,
    @required this.content,
  });
}

class Paragraph {
  final String subtitle;
  final String body;

  Paragraph({
    @required this.subtitle,
    @required this.body,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/images/image0.jpg',
    title: '只要互联网还在，我就不会停止敲打键盘',
    description: '我梦想有一天 耶稣基督的名字传遍互联网 无论哪个网络 在哪一个国家',
    icon: 'assets/images/icon.jpeg',
    author: '文 / 范学德',
    //subtitles:['公号被封，经历恩典', '不是防范，而是进攻', '我在这里，请差遣我', '网络宣教，全心参与', '结语'],
    content: [
      Paragraph(
          subtitle: '公号被封，经历恩典',
          body:
              '那一天，北京时间2019年的4月18日，耶稣受难日3个小时前，我运营了3年多的公众号被封了。一千多篇原创文章，七千多张我拍摄的照片，无数读者的留言，42034位订户，一下子全都没了。但就像那句老话说的那样，现在不是悲伤的时候。因为我在主面前曾经立志，只要我还在，只要我的公众号还在，每一天我就要发一篇原创文章。3个小时后耶稣受难日就要到了，更是绝对不能停。于是，我立即启用备用公众号“fanxuede2017”，一边整理文章，一边祷告：“主啊，求你赐给我一颗宁静的心。”主听了我的呼求。我安静地整理文章，上传。受难节早上，北京时间6点半，我在新的公众号上推送了第一篇文章，文章的题目是——《受难日：耶稣被钉在十字架上》。 因要外出，我必须将一直到复活节的文章和照片写好并整理好，上传。就这样，从美国中部时间周四早上8点，一直到周五凌晨2点，我拼了整整18个小时后，文章终于全都上传好了。睡了2个小时后，我去到机场。没有缺一天，每天一篇原创文章，新的公众号正常运转至今。近日还有两个朋友给我发来短信说，感谢主，找了好几个月，终于又找到我的新公众号。感谢主，在他有无尽的恩典。'),
      Paragraph(
          subtitle: '不是防范，而是进攻',
          body:
              '这么长的一个开头无非是想说，无论在怎样的时代，基督徒都要活出自己的天命，就是上帝赋予我们的人生使命，说得更浅白一点，就是我为什么要活着，诺大个地球，将近70亿人，为什么要有我这一位？！不错，我们正处在E时代中。不错，这个时代有许多新特点，它们影响并改变着我们的生活。这是现实，必须承认。以我的经历来说，别说10年前，就连5年前我还拒绝使用手机，更别说智能手机了。但自从3年前开了个人公众号之后，我每天都会接到无数信息，并且还要把自己的信息上传、群发到不同的微信群里。而原来的那个破手机根本就没法用，一两个小时发不出一点东西，还经常卡机、死机。看到它，我甚至都有死的心了。准确地说，我承认了，拒绝使用新工具，无异于慢性自杀。就在这时，多年的一位好弟兄竟然送了我一部苹果手机，并且邮寄到家，上帝的恩典又一次得到证实。就这样，我跟上了潮流，可以用苹果手机上网了。速度快得让我好开心，节省了很多时间。其实，E时代的网络、电脑、手机等，都是工具，在这个环境中如何生活，这是我们自己要选择的。最重要的不是防范，而是进攻。就是说，意识到自己在这个E时代的特殊使命，然后，在这个使命的引导下，效法保罗，打我必须要打的那一仗，“务要传道，无论得时不得时，总要专心，并用百般的忍耐，各样的教训，责备人，警戒人，劝勉人”（《提摩太后书》4:2）。'),
      Paragraph(
          subtitle: '我在这里，请差遣我',
          body:
              '对我而言，我在E时代的特殊使命就是专注地在网络世界传福音，简言之，即“网络宣教”！我是最早在华人基督教界提出“网络宣教”的基督徒之一，并且近20年来一直身体力行。早在2005年，我就在《海外校园》杂志上发表文章疾呼：“牧师和传道人，要上网。教会的差传事工，应当把网络宣教作为一个重要的方面。北美的华人教会中，盼望出现几百个甚至几千个‘网络传教士’，几万个‘网上基督徒’。”这段话曾被某些媒体批判过，但我至今不悔，这是一个基督徒的心里话。在这个E时代，谁能不上网呢？在网络上，基督徒又怎能不传扬好消息呢？2007年，我用中文出版了第一本网络宣教文集：《福音进中国——网络上下的对话》，在书中我又一次呼吁：“该行动了！网络宣教士，网上基督徒，你们在哪里？上帝可以差遣谁呢？”转眼间，十多年过去了，越来越多的基督徒上网了，建立了自己的群、朋友圈，但我的呼吁依旧没有变，我听从的那个呼召也没有变，每一天我都渴望自己像以赛亚一样对主说：“我在这里，请差遣我！”（参《以赛亚书》6:8）几百年前，路德注释了圣经《诗篇》中的一句名言：“你要在你仇敌中掌权。”（参《诗篇》110:2）路德说：“上帝不是要我们在我们的朋友中掌权，不是在玫瑰花中百合花中掌权，而是在荆棘中在仇敌中掌权。由此看来，凡要服侍上帝，跟从基督的人一定要遭遇苦难，正如基督自己说，‘在世界你们有苦难，在我里面有平安。’（参《约翰福音》16:33）这是上帝所命定的，无法改变。你要在你仇敌中掌权。”把这就话翻译成现代汉语就是，上帝要我们在互联网中掌权。如果觉得“掌权”这两个字眼太大，换用“发声”如何？这是我的梦想：“我有一个梦，只要中文的互联网还在，只要我还能写作并且文章还能发表出来，我就绝不会停止敲打键盘，以便使更多的人听到耶稣基督并接受他为救主。我梦想有一天，耶稣基督的名字传遍互联网，无论这个网络在哪一个国家。”'),
      Paragraph(
        subtitle: '网络宣教，全心参与',
        body:
            '在互联网上为我主耶稣基督发声，这可能吗？可能，完全可能！只要家中有一台电脑、一个手机、一个Ipad就够了。古语说，秀才不出门，全知天下事。这在古代是不可能的，但在当代，已经成为现实。约翰·卫斯理曾经说过一句名言：“全世界都是我的工场。”这在他生活的那个时代是不可能的，但在E时代却成为现实，整个世界成了一个地球村。以往教会一说到宣教，许多弟兄姐妹就会有一种罪疚感，因为种种原因，无法远渡重洋，到他国去宣教。但如今，人人皆是宣教士在历史上第一次成为可能。因为我们有微信，我的朋友圈就是我的工场，我加入的群就是我的工场。因此，近年来我提出了宣教的两个新观念。第一：朋友圈就是我的工场。换言之，朋友圈就是耶稣要我去的“天下”。在这个“天下”里，我至少可以做一件事：我的朋友圈我做主，不，我的朋友圈让耶稣做主。我要让我的朋友在这里看到耶稣基督，听到上帝的话。第二：转发就是宣教。一些弟兄姐妹会说，我不会玩视频，不会写作，不会摄影，也不懂神学，等等。怎么办？��于这些担忧，还有一个方式参与宣教，那就是“转发”。将好的信息转到自己的朋友圈中，这不仅是文章，也包括视频、歌曲和照片，等等。最简单的，我至少可以每日在自己的微信朋友圈中复制一段圣经的经文。还有一个转发，就是好的信息转发到自己加入的群中。问题是，现在的网络信息浩如烟海，我如何海里捞针？我这几年有一个简单的方法，就是认定三五个信仰纯正，文章接地气的公众号，经常转发它们的信息。在最近一次会议上，我说了一段话后大家笑了，有人把它概括成了“洗手间三分钟宣教”。我说，在洗手间里，随手发两三篇你信赖的公众号的文章到自己的朋友圈里，放到你加入的群中，这样你就参与宣教了。夸张了一点，不过，就是那么一回事。',
      ),
      Paragraph(
          subtitle: '结语',
          body:
              '在E时代作基督的使者，必须祈求主赐给我们一个为主受苦的心志，背起十字架来跟随主。在虚拟空间中行走将近20年的经验告诉我，在网络世界中做一个福音使者，你不可能不受迫害，最可怕的攻击往往来自你的兄弟姐妹。他们自认为对圣经的理解最正确、信仰最纯正，因此就成了鲁迅笔下的“奴隶总管”，无论你如何尽心尽力，他们总是批评你、侮辱你，甚至拿着“鞭子”打你。当陷入这样的处境中时，我们也只能像耶稣一样祈祷：“父阿，赦免他们！因为他们所作的，他们不晓得。”（参《路加福音》23:34）祷告完了，擦一把眼泪，继续上网，为主征战，对主尽忠.'),
    ],
  ),
  Slide(
    imageUrl: 'assets/images/image2.jpg',
    title: 'Design Interactive App UI',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
    icon: 'assets/images/icon.jpeg',
    author: '文 / 范学德',
    content: [
      Paragraph(
          subtitle: '公号被封2，经历恩典',
          body:
              '那一天，北京时间2019年的4月18日，耶稣受难日3个小时前，我运营了3年多的公众号被封了。一千多篇原创文章，七千多张我拍摄的照片，无数读者的留言，42034位订户，一下子全都没了。但就像那句老话说的那样，现在不是悲伤的时候。因为我在主面前曾经立志，只要我还在，只要我的公众号还在，每一天我就要发一篇原创文章。3个小时后耶稣受难日就要到了，更是绝对不能停。于是，我立即启用备用公众号“fanxuede2017”，一边整理文章，一边祷告：“主啊，求你赐给我一颗宁静的心。”主听了我的呼求。我安静地整理文章，上传。受难节早上，北京时间6点半，我在新的公众号上推送了第一篇文章，文章的题目是——《受难日：耶稣被钉在十字架上》。 因要外出，我必须将一直到复活节的文章和照片写好并整理好，上传。就这样，从美国中部时间周四早上8点，一直到周五凌晨2点，我拼了整整18个小时后，文章终于全都上传好了。睡了2个小时后，我去到机场。没有缺一天，每天一篇原创文章，新的公众号正常运转至今。近日还有两个朋友给我发来短信说，感谢主，找了好几个月，终于又找到我的新公众号。感谢主，在他有无尽的恩典。'),
      Paragraph(
          subtitle: '不是防范，而是进攻',
          body:
              '这么长的一个开头无非是想说，无论在怎样的时代，基督徒都要活出自己的天命，就是上帝赋予我们的人生使命，说得更浅白一点，就是我为什么要活着，诺大个地球，将近70亿人，为什么要有我这一位？！不错，我们正处在E时代中。不错，这个时代有许多新特点，它们影响并改变着我们的生活。这是现实，必须承认。以我的经历来说，别说10年前，就连5年前我还拒绝使用手机，更别说智能手机了。但自从3年前开了个人公众号之后，我每天都会接到无数信息，并且还要把自己的信息上传、群发到不同的微信群里。而原来的那个破手机根本就没法用，一两个小时发不出一点东西，还经常卡机、死机。看到它，我甚至都有死的心了。准确地说，我承认了，拒绝使用新工具，无异于慢性自杀。就在这时，多年的一位好弟兄竟然送了我一部苹果手机，并且邮寄到家，上帝的恩典又一次得到证实。就这样，我跟上了潮流，可以用苹果手机上网了。速度快得让我好开心，节省了很多时间。其实，E时代的网络、电脑、手机等，都是工具，在这个环境中如何生活，这是我们自己要选择的。最重要的不是防范，而是进攻。就是说，意识到自己在这个E时代的特殊使命，然后，在这个使命的引导下，效法保罗，打我必须要打的那一仗，“务要传道，无论得时不得时，总要专心，并用百般的忍耐，各样的教训，责备人，警戒人，劝勉人”（《提摩太后书》4:2）。'),
      Paragraph(
          subtitle: '我在这里，请差遣我',
          body:
              '对我而言，我在E时代的特殊使命就是专注地在网络世界传福音，简言之，即“网络宣教”！我是最早在华人基督教界提出“网络宣教”的基督徒之一，并且近20年来一直身体力行。早在2005年，我就在《海外校园》杂志上发表文章疾呼：“牧师和传道人，要上网。教会的差传事工，应当把网络宣教作为一个重要的方面。北美的华人教会中，盼望出现几百个甚至几千个‘网络传教士’，几万个‘网上基督徒’。”这段话曾被某些媒体批判过，但我至今不悔，这是一个基督徒的心里话。在这个E时代，谁能不上网呢？在网络上，基督徒又怎能不传扬好消息呢？2007年，我用中文出版了第一本网络宣教文集：《福音进中国——网络上下的对话》，在书中我又一次呼吁：“该行动了！网络宣教士，网上基督徒，你们在哪里？上帝可以差遣谁呢？”转眼间，十多年过去了，越来越多的基督徒上网了，建立了自己的群、朋友圈，但我的呼吁依旧没有变，我听从的那个呼召也没有变，每一天我都渴望自己像以赛亚一样对主说：“我在这里，请差遣我！”（参《以赛亚书》6:8）几百年前，路德注释了圣经《诗篇》中的一句名言：“你要在你仇敌中掌权。”（参《诗篇》110:2）路德说：“上帝不是要我们在我们的朋友中掌权，不是在玫瑰花中百合花中掌权，而是在荆棘中在仇敌中掌权。由此看来，凡要服侍上帝，跟从基督的人一定要遭遇苦难，正如基督自己说，‘在世界你们有苦难，在我里面有平安。’（参《约翰福音》16:33）这是上帝所命定的，无法改变。你要在你仇敌中掌权。”把这就话翻译成现代汉语就是，上帝要我们在互联网中掌权。如果觉得“掌权”这两个字眼太大，换用“发声”如何？这是我的梦想：“我有一个梦，只要中文的互联网还在，只要我还能写作并且文章还能发表出来，我就绝不会停止敲打键盘，以便使更多的人听到耶稣基督并接受他为救主。我梦想有一天，耶稣基督的名字传遍互联网，无论这个网络在哪一个国家。”'),
      Paragraph(
        subtitle: '网络宣教，全心参与',
        body:
            '在互联网上为我主耶稣基督发声，这可能吗？可能，完全可能！只要家中有一台电脑、一个手机、一个Ipad就够了。古语说，秀才不出门，全知天下事。这在古代是不可能的，但在当代，已经成为现实。约翰·卫斯理曾经说过一句名言：“全世界都是我的工场。”这在他生活的那个时代是不可能的，但在E时代却成为现实，整个世界成了一个地球村。以往教会一说到宣教，许多弟兄姐妹就会有一种罪疚感，因为种种原因，无法远渡重洋，到他国去宣教。但如今，人人皆是宣教士在历史上第一次成为可能。因为我们有微信，我的朋友圈就是我的工场，我加入的群就是我的工场。因此，近年来我提出了宣教的两个新观念。第一：朋友圈就是我的工场。换言之，朋友圈就是耶稣要我去的“天下”。在这个“天下”里，我至少可以做一件事：我的朋友圈我做主，不，我的朋友圈让耶稣做主。我要让我的朋友在这里看到耶稣基督，听到上帝的话。第二：转发就是宣教。一些弟兄姐妹会说，我不会玩视频，不会写作，不会摄影，也不懂神学，等等。怎么办？��于这些担忧，还有一个方式参与宣教，那就是“转发”。将好的信息转到自己的朋友圈中，这不仅是文章，也包括视频、歌曲和照片，等等。最简单的，我至少可以每日在自己的微信朋友圈中复制一段圣经的经文。还有一个转发，就是好的信息转发到自己加入的群中。问题是，现在的网络信息浩如烟海，我如何海里捞针？我这几年有一个简单的方法，就是认定三五个信仰纯正，文章接地气的公众号，经常转发它们的信息。在最近一次会议上，我说了一段话后大家笑了，有人把它概括成了“洗手间三分钟宣教”。我说，在洗手间里，随手发两三篇你信赖的公众号的文章到自己的朋友圈里，放到你加入的群中，这样你就参与宣教了。夸张了一点，不过，就是那么一回事。',
      ),
      Paragraph(
          subtitle: '结语',
          body:
              '在E时代作基督的使者，必须祈求主赐给我们一个为主受苦的心志，背起十字架来跟随主。在虚拟空间中行走将近20年的经验告诉我，在网络世界中做一个福音使者，你不可能不受迫害，最可怕的攻击往往来自你的兄弟姐妹。他们自认为对圣经的理解最正确、信仰最纯正，因此就成了鲁迅笔下的“奴隶总管”，无论你如何尽心尽力，他们总是批评你、侮辱你，甚至拿着“鞭子”打你。当陷入这样的处境中时，我们也只能像耶稣一样祈祷：“父阿，赦免他们！因为他们所作的，他们不晓得。”（参《路加福音》23:34）祷告完了，擦一把眼泪，继续上网，为主征战，对主尽忠.'),
    ],
  ),
  Slide(
    imageUrl: 'assets/images/image3.jpg',
    title: 'It\'s Just the Beginning',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
    icon: 'assets/images/icon.jpeg',
    author: '文 / 范学德',
    content: [
      Paragraph(
          subtitle: '公号被封3，经历恩典',
          body:
              '那一天，北京时间2019年的4月18日，耶稣受难日3个小时前，我运营了3年多的公众号被封了。一千多篇原创文章，七千多张我拍摄的照片，无数读者的留言，42034位订户，一下子全都没了。但就像那句老话说的那样，现在不是悲伤的时候。因为我在主面前曾经立志，只要我还在，只要我的公众号还在，每一天我就要发一篇原创文章。3个小时后耶稣受难日就要到了，更是绝对不能停。于是，我立即启用备用公众号“fanxuede2017”，一边整理文章，一边祷告：“主啊，求你赐给我一颗宁静的心。”主听了我的呼求。我安静地整理文章，上传。受难节早上，北京时间6点半，我在新的公众号上推送了第一篇文章，文章的题目是——《受难日：耶稣被钉在十字架上》。 因要外出，我必须将一直到复活节的文章和照片写好并整理好，上传。就这样，从美国中部时间周四早上8点，一直到周五凌晨2点，我拼了整整18个小时后，文章终于全都上传好了。睡了2个小时后，我去到机场。没有缺一天，每天一篇原创文章，新的公众号正常运转至今。近日还有两个朋友给我发来短信说，感谢主，找了好几个月，终于又找到我的新公众号。感谢主，在他有无尽的恩典。'),
      Paragraph(
          subtitle: '不是防范，而是进攻',
          body:
              '这么长的一个开头无非是想说，无论在怎样的时代，基督徒都要活出自己的天命，就是上帝赋予我们的人生使命，说得更浅白一点，就是我为什么要活着，诺大个地球，将近70亿人，为什么要有我这一位？！不错，我们正处在E时代中。不错，这个时代有许多新特点，它们影响并改变着我们的生活。这是现实，必须承认。以我的经历来说，别说10年前，就连5年前我还拒绝使用手机，更别说智能手机了。但自从3年前开了个人公众号之后，我每天都会接到无数信息，并且还要把自己的信息上传、群发到不同的微信群里。而原来的那个破手机根本就没法用，一两个小时发不出一点东西，还经常卡机、死机。看到它，我甚至都有死的心了。准确地说，我承认了，拒绝使用新工具，无异于慢性自杀。就在这时，多年的一位好弟兄竟然送了我一部苹果手机，并且邮寄到家，上帝的恩典又一次得到证实。就这样，我跟上了潮流，可以用苹果手机上网了。速度快得让我好开心，节省了很多时间。其实，E时代的网络、电脑、手机等，都是工具，在这个环境中如何生活，这是我们自己要选择的。最重要的不是防范，而是进攻。就是说，意识到自己在这个E时代的特殊使命，然后，在这个使命的引导下，效法保罗，打我必须要打的那一仗，“务要传道，无论得时不得时，总要专心，并用百般的忍耐，各样的教训，责备人，警戒人，劝勉人”（《提摩太后书》4:2）。'),
      Paragraph(
          subtitle: '我在这里，请差遣我',
          body:
              '对我而言，我在E时代的特殊使命就是专注地在网络世界传福音，简言之，即“网络宣教”！我是最早在华人基督教界提出“网络宣教”的基督徒之一，并且近20年来一直身体力行。早在2005年，我就在《海外校园》杂志上发表文章疾呼：“牧师和传道人，要上网。教会的差传事工，应当把网络宣教作为一个重要的方面。北美的华人教会中，盼望出现几百个甚至几千个‘网络传教士’，几万个‘网上基督徒’。”这段话曾被某些媒体批判过，但我至今不悔，这是一个基督徒的心里话。在这个E时代，谁能不上网呢？在网络上，基督徒又怎能不传扬好消息呢？2007年，我用中文出版了第一本网络宣教文集：《福音进中国——网络上下的对话》，在书中我又一次呼吁：“该行动了！网络宣教士，网上基督徒，你们在哪里？上帝可以差遣谁呢？”转眼间，十多年过去了，越来越多的基督徒上网了，建立了自己的群、朋友圈，但我的呼吁依旧没有变，我听从的那个呼召也没有变，每一天我都渴望自己像以赛亚一样对主说：“我在这里，请差遣我！”（参《以赛亚书》6:8）几百年前，路德注释了圣经《诗篇》中的一句名言：“你要在你仇敌中掌权。”（参《诗篇》110:2）路德说：“上帝不是要我们在我们的朋友中掌权，不是在玫瑰花中百合花中掌权，而是在荆棘中在仇敌中掌权。由此看来，凡要服侍上帝，跟从基督的人一定要遭遇苦难，正如基督自己说，‘在世界你们有苦难，在我里面有平安。’（参《约翰福音》16:33）这是上帝所命定的，无法改变。你要在你仇敌中掌权。”把这就话翻译成现代汉语就是，上帝要我们在互联网中掌权。如果觉得“掌权”这两个字眼太大，换用“发声”如何？这是我的梦想：“我有一个梦，只要中文的互联网还在，只要我还能写作并且文章还能发表出来，我就绝不会停止敲打键盘，以便使更多的人听到耶稣基督并接受他为救主。我梦想有一天，耶稣基督的名字传遍互联网，无论这个网络在哪一个国家。”'),
      Paragraph(
        subtitle: '网络宣教，全心参与',
        body:
            '在互联网上为我主耶稣基督发声，这可能吗？可能，完全可能！只要家中有一台电脑、一个手机、一个Ipad就够了。古语说，秀才不出门，全知天下事。这在古代是不可能的，但在当代，已经成为现实。约翰·卫斯理曾经说过一句名言：“全世界都是我的工场。”这在他生活的那个时代是不可能的，但在E时代却成为现实，整个世界成了一个地球村。以往教会一说到宣教，许多弟兄姐妹就会有一种罪疚感，因为种种原因，无法远渡重洋，到他国去宣教。但如今，人人皆是宣教士在历史上第一次成为可能。因为我们有微信，我的朋友圈就是我的工场，我加入的群就是我的工场。因此，近年来我提出了宣教的两个新观念。第一：朋友圈就是我的工场。换言之，朋友圈就是耶稣要我去的“天下”。在这个“天下”里，我至少可以做一件事：我的朋友圈我做主，不，我的朋友圈让耶稣做主。我要让我的朋友在这里看到耶稣基督，听到上帝的话。第二：转发就是宣教。一些弟兄姐妹会说，我不会玩视频，不会写作，不会摄影，也不懂神学，等等。怎么办？��于这些担忧，还有一个方式参与宣教，那就是“转发”。将好的信息转到自己的朋友圈中，这不仅是文章，也包括视频、歌曲和照片，等等。最简单的，我至少可以每日在自己的微信朋友圈中复制一段圣经的经文。还有一个转发，就是好的信息转发到自己加入的群中。问题是，现在的网络信息浩如烟海，我如何海里捞针？我这几年有一个简单的方法，就是认定三五个信仰纯正，文章接地气的公众号，经常转发它们的信息。在最近一次会议上，我说了一段话后大家笑了，有人把它概括成了“洗手间三分钟宣教”。我说，在洗手间里，随手发两三篇你信赖的公众号的文章到自己的朋友圈里，放到你加入的群中，这样你就参与宣教了。夸张了一点，不过，就是那么一回事。',
      ),
      Paragraph(
          subtitle: '结语',
          body:
              '在E时代作基督的使者，必须祈求主赐给我们一个为主受苦的心志，背起十字架来跟随主。在虚拟空间中行走将近20年的经验告诉我，在网络世界中做一个福音使者，你不可能不受迫害，最可怕的攻击往往来自你的兄弟姐妹。他们自认为对圣经的理解最正确、信仰最纯正，因此就成了鲁迅笔下的“奴隶总管”，无论你如何尽心尽力，他们总是批评你、侮辱你，甚至拿着“鞭子”打你。当陷入这样的处境中时，我们也只能像耶稣一样祈祷：“父阿，赦免他们！因为他们所作的，他们不晓得。”（参《路加福音》23:34）祷告完了，擦一把眼泪，继续上网，为主征战，对主尽忠.'),
    ],
  ),
];
