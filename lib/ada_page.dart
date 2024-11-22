import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Color.fromRGBO(120, 206, 198, 1.0),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 22, right: 20, top: 30, bottom: 0),
              child: Text(
                'Все ещё не знаешь кто я?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 22, right: 20, top: 30, bottom: 0),
              child: Text(
                'Я - Ада Лавлейс, математик и одна из первых людей, кто взялась за программирование в истории. Моя работа с механическим компьютером Чарльза Бэббиджа выделяется своими инновационными алгоритмами, разработанными для анализа чисел и символов. Мой уникальный взгляд на использование машины позволил предвидеть, что такие устройства могут делать не только математические вычисления, но и обрабатывать данные, что в конечном итоге послужило основой для развития современного программирования и компьютерных наук.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Color.fromRGBO(175, 238, 238, 1.0),
                  width: 4,
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: Color.fromRGBO(120, 206, 198, 1.0),
                    width: 5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/Ada_portret.jpg',
                    fit: BoxFit.cover, // Устанавливает, как изображение должно заполнять контейнер
                  ),
                ),
              )
            ),


            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    children: [
                      ExpandableContainer(
                        closedText: 'Родители',
                        openText: 'Моими родителями были лорд Байрон (Джордж Гордон Байрон) и Анна Изабелла (Аннабелла) Милбэнк Байрон. Лорд Байрон был известным английским поэтом и одним из ведущих деятелей Романтизма, прославился своими поэмами, а также эксцентричным образом жизни. Аннабелла Милбэнк Байрон была образованной женщиной, интересовавшейся математикой и наукой. Брак Байрона и Аннабеллы длился около года, после чего Аннабелла взяла на себя моё воспитание',
                          imagePath: ''
                      ),
                      ExpandableContainer(
                        closedText: 'Чарльз Бэббидж',
                        openText: 'Имя Чарльза Бэббиджа я впервые услышала за обеденным столом от Мэри Сомервилль. Спустя несколько недель мы впервые увиделись. Чарльз Бэббидж в момент нашего знакомства был профессором на кафедре математики Кембриджского университета. Позднее я познакомилась и с другими выдающимися личностями той эпохи: Майклом Фарадеем, Дэвидом Брюстером, Чарльзом Уитстоном, Чарльзом Диккенсом и другими.',
                          imagePath: 'assets/images/Babbage.jpg'
                      ),
                      ExpandableContainer(
                        closedText: 'Ткацкий станок',
                        openText: 'Я использовала аналогию с ткацким станком Жаккара, чтобы объяснить принцип работы аналитической машины Чарльза Бэббиджа и её потенциал для программирования. Ткацкий станок Жаккара был устройством, которое использовало перфорированные карты для управления ткацким процессом. Эти карты определяли узоры ткани, позволяя создавать дизайны автоматическим образом. Каждая перфорация на карте соответствовала определенному движению станка, и комбинация этих движений создавала различные узоры. Я увидела параллели между ткацким станком Жаккара и аналитической машиной. Она отметила, что так же, как перфорированные карты могут использоваться для создания узоров на ткани, аналогичные карты могли бы быть использованы для программирования аналитической машины для выполнения вычислений и операций.',
                          imagePath: 'assets/images/jacquard2.jpg'
                      ),
                      ExpandableContainer(
                        closedText: 'Исскуство',
                        openText: 'Я всегда искала связь между наукой, математикой и искусством. Мои письма и статьи отражают мою глубокую страсть к этим темам. Я считала, что наука — это не только набор формул и уравнений, но и искусство, которое требует вдохновения и воображения.',
                          imagePath: ''
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    children: [
                      ExpandableContainer(
                        closedText: 'Образование',
                        openText: 'Мама нанимала лучших преподавателей того времени для меня. Среди них был Август Де Морган, один из ведущих математиков своего времени, он преподавал мне продвинутую математику. Также я училась у Мэри Сомервилль, известной учёной и популяризатора науки. Аннабелла обеспечила мне всестороннее образование, включающее не только математику и науку, но и литературу, искусство и музыку. Такое сочетание позволило мне стать одной из первых программисток в истории.',
                          imagePath: ''
                      ),
                      ExpandableContainer(
                        closedText: 'Счётная машина',
                        openText: 'Чарльз Бэббидж разработал концепцию аналитической машины в 1830-х годах. Это была механическая вычислительная машина, предшественник современных компьютеров. Я стала тесно сотрудничать с Бэббиджем. Я перевела и расширила описание аналитической машины, написанное итальянским математиком Луиджи Федерико Менабреа. Также в своём переводе добавила собственные обширные комментарии и заметки, которые содержали моё видение потенциала аналитической машины. Среди этих заметок особенно выделяется "Программа для аналитической машины" — алгоритм, который рассматривался как первый в мире программируемый алгоритм, разработанный специально для выполнения машиной.',
                          imagePath: 'assets/images/analitick_machine.jpg'
                      ),
                      ExpandableContainer(
                        closedText: 'Числа Бернулли',
                        openText: 'Я сделала алгоритм для вычисления чисел Бернулли с использованием аналитической машины Чарльза Бэббиджа. Этот алгоритм считается первым в мире программируемым алгоритмом. Числа Бернулли — это последовательность рациональных чисел, которые возникают в ряде математических контекстов, таких как теория чисел и вычисление сумм рядов. Я включила этот алгоритм в свои примечания к переводу статьи о аналитической машине Бэббиджа.',
                          imagePath: ''
                      ),
                      ExpandableContainer(
                        closedText: 'Память',
                        openText: 'В 1975 году Министерство обороны США приняло решение о начале разработки универсального языка программирования. Министр прочитал подготовленный секретарями исторический экскурс и без колебаний одобрил и проект, и предполагаемое название для будущего языка — «Ада». В 2022 году NVIDIA выпустила графические процессоры с микроархитектурой Ada Lovelace. GPU с микроархитектурой «Ada Lovelace» дебютировали в линейке видеокарт серии GeForce RTX 40',
                          imagePath: 'assets/images/geforce-ada.jpg'
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 10,
                ),
              ]
            ),

            BigExpandableContainer(),
          ],
        ),
      ),
    );
  }
}

class ExpandableContainer extends StatefulWidget {
  final String closedText;
  final String openText;
  final String imagePath;

  ExpandableContainer({required this.closedText, required this.openText, required this.imagePath});

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool _isExpanded = false;

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 0, right: 0),
          margin: EdgeInsets.only( top: 10, bottom: 10),
          width:195,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(3, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 19),
                        child: Text(
                          widget.closedText,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 15,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  AnimatedSize(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    child: ConstrainedBox(
                        constraints: _isExpanded
                            ? BoxConstraints()
                            : BoxConstraints(maxHeight: 0),
                        child: Container(
                            margin: EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top:3, bottom: 8, right: 7, left: 7),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.openText,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        height: 1.1,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),


                                    Container(
                                      margin: EdgeInsets.only(top: 8, bottom: 4, right: 4, left: 4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Применяем borderRadius к изображению
                                        child: Image.asset(
                                          widget.imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            )
                        )
                    ),
                  ),

                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: _toggleContainer,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                      padding: EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      margin: EdgeInsets.only(right: 16),
                      child:
                      Container(
                        margin: EdgeInsets.only(top: 2, bottom: 5),
                        child: Image(
                          width: 20,
                          height: 20,
                          color: Colors.black.withOpacity(0.5),
                          image: _isExpanded
                              ? AssetImage('assets/icons/angle-circle-up.png')
                              : AssetImage('assets/icons/angle-circle-down.png'),
                        ),
                      )

                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BigExpandableContainer extends StatefulWidget {


  @override
  _BigExpandableContainerState createState() => _BigExpandableContainerState();
}

class _BigExpandableContainerState extends State<BigExpandableContainer> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 0, right: 0),
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(3, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.only(right: 19),
                        child: Text(
                          'Подробнее про мою программу',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  Container(
                    child: Container(
                            margin: EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top:3, bottom: 8, right: 7, left: 7),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 17, right: 15, top: 10, bottom: 20),
                                      child: Text(
                                        'В своих заметках об аналитическом двигателе я продемонстрировала свой алгоритм, используя пошаговый процесс, известный как «таблица алгоритма».',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),

                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          border: Border.all(
                                            color: Color.fromRGBO(175, 238, 238, 1.0),
                                            width: 4,
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(35),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image.asset(
                                              'assets/images/prog.png',
                                              fit: BoxFit.cover, // Устанавливает, как изображение должно заполнять контейнер
                                            ),
                                          ),
                                        )
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 17, right: 15, top: 20, bottom: 10),
                                      child: Text(
                                        'Мой алгоритм для вычисления чисел Бернулли включает следующие шаги:',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 17, right: 15, top: 15, bottom: 15),
                                      child: Text(
                                        '''1. Инициализация данных. 
  В начале алгоритма определяются переменные и начальные значения, которые будут использоваться для вычислений.

2. Циклы и условия. 
  Я использовала циклы, чтобы повторять вычисления для различных входных значений. Это позволило мне обрабатывать большие наборы данных без необходимости вручную выполнять каждое вычисление.

3. Хранение результатов. 
  Важной частью алгоритма было хранение промежуточных результатов в памяти машины, чтобы их можно было использовать для последующих вычислений.

4. Вывод результата. 
  После завершения всех вычислений, алгоритм выдает конечные значения, которые могут быть использованы для различных математических задач.''',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                            )
                        )
                    ),

                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}