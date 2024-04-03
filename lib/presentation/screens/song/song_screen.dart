import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/di/providers.dart';
import 'package:music_player/presentation/config/assets.dart';
import 'package:music_player/presentation/config/palette.dart';
import 'package:music_player/presentation/config/strings.dart';
import '../../../domain/entity/song.dart';

class SongScreen extends ConsumerStatefulWidget {

  final List<String> favourites;
  final Song song;

  const SongScreen(this.song, this.favourites);

  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends ConsumerState<SongScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isFavorite = false;


  @override
  void initState() {
    super.initState();

    _isFavorite = widget.favourites.contains(widget.song.id);

    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        _isPlaying = event == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _setAudio();
  }

  void _setAudio() async {
    final player = AudioCache(prefix: Assets.songsPath);
    final url = await player.load(widget.song.song);
    _audioPlayer.setSourceUrl(url.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(Strings.strNowPlaying),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Palette.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.secondary,
            ]
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.song.id,
                child: CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage(widget.song.image),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.song.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0,),
              Text(
                widget.song.artist,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 64,
                    onPressed: () {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.resume();
                      }
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        widget.favourites.add(widget.song.id);
      } else {
        widget.favourites.remove(widget.song.id);
      }
      ref.read(songControllerProvider.notifier).updateFavourites(widget.favourites);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
