import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty_bloc_intermediate_guide/features/episodes/models/episode.dart';
import 'package:rickandmorty_bloc_intermediate_guide/utils/widgets/appbar/rm_appbar.dart';
import 'package:rickandmorty_bloc_intermediate_guide/utils/widgets/failed/rm_failed.dart';
import 'package:rickandmorty_bloc_intermediate_guide/utils/widgets/loading/rm_loading.dart';
import '../../../constants/constants.dart';
import '../../../utils/widgets/boxs/rm_header_box.dart';
import '../../characters/widgets/rm_characters_card.dart';
import '../bloc/episodes_bloc.dart';
import 'package:rickandmorty_bloc_intermediate_guide/injection_container.dart'
    as di;

class EpisodesDetailScreen extends StatefulWidget {
  final int id;
  const EpisodesDetailScreen({super.key, required this.id});

  @override
  State<EpisodesDetailScreen> createState() => _EpisodesDetailScreenState();
}

class _EpisodesDetailScreenState extends State<EpisodesDetailScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl.get<EpisodesBloc>(),
      child: BlocBuilder<EpisodesBloc, EpisodesState>(
        builder: (context, state) {
          final episodeDetail = state.episodes[widget.id];
          switch (state.status) {
            case EpisodesStatus.loading:
              return RMLoading(title: state.episodes[widget.id].name);

            case EpisodesStatus.loaded:
              return body(state, episodeDetail);

            case EpisodesStatus.failed:
              return const RmFailed();

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  Scaffold body(EpisodesState state, Episode episodeDetail) {
    return Scaffold(
      appBar: RMAppBar(title: state.episodes[widget.id].name),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: RMPaddings.p16),
        children: [
          const SizedBox(height: RMSizes.s20),
          RMHeaderContainer(
              header: RMTexts.name,
              description: episodeDetail.name,
              color: RMColors.purple),
          const SizedBox(height: RMSizes.s20),
          RMHeaderContainer(
              header: RMTexts.episode,
              description: episodeDetail.episode,
              color: RMColors.green),
          const SizedBox(height: RMSizes.s20),
          RMHeaderContainer(
              header: RMTexts.airDate,
              description: episodeDetail.air_date,
              color: RMColors.accent),
          const SizedBox(height: RMSizes.s20),
          GridView.builder(
            shrinkWrap: true,
            key: const PageStorageKey<String>('episodesGridView'),
            controller: _scrollController,
            itemCount: state.episodes[widget.id].characterDetail!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: RMSizes.s12,
              crossAxisSpacing: RMSizes.s12,
              crossAxisCount: 2,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              return RMCharactersCard(
                index: index,
                character: state.episodes[widget.id].characterDetail![index],
              );
            },
          ),
        ],
      ),
    );
  }
}
