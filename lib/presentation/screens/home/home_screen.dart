import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/di/providers.dart';
import 'package:music_player/domain/customds/pair.dart';
import 'package:music_player/presentation/config/assets.dart';
import 'package:music_player/presentation/config/palette.dart';
import 'package:music_player/presentation/config/routes.dart';
import 'package:music_player/presentation/config/songs.dart';
import 'package:music_player/presentation/config/strings.dart';
import 'package:music_player/presentation/config/theme/theme_provider.dart';

import '../../../domain/entity/song.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final List<String>? favourites;

  HomeScreen(this.favourites);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool _isDarkMode = true;
List<String> _favourites = [];

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late List<Song> filteredSongs;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSongs = List.from(songs);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStateLogic();
    });
  }

  void _initStateLogic() {
    if (widget.favourites != null) {
      ref
          .read(homeControllerProvider.notifier)
          .updateFavourites(widget.favourites!);
    } else {
      ref.read(homeControllerProvider.notifier).getUserFavourites();
    }
  }

  @override
  Widget build(BuildContext context) {
    _favourites = ref.watch(homeControllerProvider);
    ref.watch(internetConnectivityProvider); // Internet connectivity

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Assets.bgArtist), fit: BoxFit.cover),
              ),
              child: Container(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(Strings.strWelcome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32.0)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onPressed: () {
                        ref.read(homeControllerProvider.notifier).logout();
                        context.go(Routes.login);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onPressed: () {
                        setState(() {
                          _isDarkMode = !_isDarkMode;
                          ref
                              .read(themeProvider.notifier)
                              .toggleTheme(_isDarkMode);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchTextChanged,
                  decoration: InputDecoration(
                    hintText: Strings.strSearch,
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ).animate().shimmer(duration: const Duration(seconds: 2)),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    cacheExtent: 500,
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(filteredSongs[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSearchTextChanged(String query) {
    setState(() {
      filteredSongs = songs
          .where(
              (song) => song.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildListItem(Song song) {
    bool isFavorite = _favourites.contains(song.id) ?? false;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Hero(
            tag: song.id,
            child: GestureDetector(
              onTap: () => _goToSongDetail(song),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(song.image),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Song Name and Artist Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.name,
                        style: const TextStyle(
                            color: Palette.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(song.artist,
                          style: const TextStyle(
                            color: Palette.textDark,
                          )),
                    ],
                  ),
                  // Heart Icon
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Palette.red : null,
                    ).animate().shakeX(),
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          _favourites.remove(song.id);
                        } else {
                          _favourites.add(song.id);
                        }
                      });
                      ref
                          .read(homeControllerProvider.notifier)
                          .updateFavourites(_favourites);
                    },
                  ),
                ],
              ),
            ).animate().shimmer(duration: const Duration(seconds: 2)),
          ),
        ],
      ),
    );
  }

  void _goToSongDetail(Song song) {
    context.push(Routes.song, extra: Pair(song, _favourites));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
