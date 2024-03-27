import 'package:audio_player_tutorial2/utils/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPlaying = false;
  late final AudioPlayer player;
  late final AssetSource path;
  double _playbackSpeed = 1.0;

  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future initPlayer() async {
    player = AudioPlayer();
    path = AssetSource('audios/sound.mp3');

    player.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    player.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    player.onPlayerComplete.listen((_) {
      setState(() {
        _position = _duration;
        isPlaying = false;
      });
    });
  }

  void togglePlaybackSpeed() {
    if (_playbackSpeed == 1.0) {
      _playbackSpeed = 2.0;
    } else if (_playbackSpeed == 2.0) {
      _playbackSpeed = 4.0;
    } else {
      _playbackSpeed = 1.0;
    }
    player.setPlaybackRate(_playbackSpeed);
    setState(() {});
  }

  void playPause() async {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play(path);
      isPlaying = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Si Pitung",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppins',
              fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 34, 77, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 34, 77, 1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(160, 21, 62, 1),
              ),
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: const Image(
                      image: AssetImage('assets/images/sipitung.jpeg'),
                      width: 300,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: const Text(
                      '''Si Pitung, pemuda soleh dari Rawa Belong, tumbuh dengan rajin belajar mengaji dan bela diri di bawah bimbingan Haji Naipin. Atas dasar penderitaan rakyat kecil di bawah cengkeraman Belanda, ia menegakkan keadilan dengan cara merampok rumah-rumah orang kaya untuk kemudian membagi hasilnya kepada yang membutuhkan. Keberhasilan mereka tidak hanya karena keahlian silat Si Pitung yang tinggi, tetapi juga karena rahasia kekebalan tubuhnya yang membuatnya legendaris. Namun, kemenangan mereka tidak berlangsung lama. Saat informasi tentang Si Pitung mulai tersebar, polisi kompeni bergerak cepat. Dalam sebuah penyergapan brutal, Si Pitung terluka parah dan dikejar hingga tewas. Di tengah kesedihan atas kepergiannya, Si Pitung masih dianggap sebagai simbol perlawanan dan pembela rakyat kecil.''',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            await player.seek(Duration(seconds: value.toInt()));
                            setState(() {});
                          },
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          inactiveColor: Colors.grey,
                          activeColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          (_duration - _position).format(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: togglePlaybackSpeed,
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder()),
                        child: Text('${_playbackSpeed}x'),
                      ),
                      InkWell(
                        onTap: playPause,
                        child: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: const Color.fromRGBO(160, 21, 62, 1),
                          size: 50,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          player.stop();
                          setState(() {
                            _position = const Duration();
                            isPlaying = false;
                          });
                        },
                        icon: const Icon(Icons.stop_circle),
                        color: Colors.white,
                        iconSize: 42,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
