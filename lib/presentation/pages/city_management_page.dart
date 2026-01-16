import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../injection.dart';
import '../bloc/city_list_bloc.dart';
import '../bloc/city_list_event.dart';
import '../bloc/city_list_state.dart';
import '../widgets/glass_container.dart';

class CityManagementPage extends StatelessWidget {
  const CityManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CityListBloc>()..add(LoadCities()),
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: _CityListView(),
      ),
    );
  }
}

class _CityListView extends StatelessWidget {
  const _CityListView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách thành phố',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
                  onPressed: () async {
                    final result = await context.push<String>('/search');
                    if (result != null && context.mounted) {
                      context.read<CityListBloc>().add(AddCity(result));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List
            Expanded(
              child: BlocBuilder<CityListBloc, CityListState>(
                builder: (context, state) {
                  if (state is CityListLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  
                  if (state is CityListLoaded) {
                    if (state.cities.isEmpty) {
                      return const Center(
                        child: Text(
                          'Chưa lưu thành phố nào.\nBấm dấu + để thêm.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.cities.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final city = state.cities[index];
                        return Dismissible(
                          key: Key(city),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            context.read<CityListBloc>().add(RemoveCity(city));
                          },
                          child: GestureDetector(
                            onTap: () {
                               // Optional: Select city to jump to
                               // For simplicity, just pop. 
                               // Ideally pass index back?
                               context.pop(index + 1); // +1 because index 0 is GPS
                            },
                            child: GlassContainer(
                              opacity: 0.2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          city,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Future: Show temp/condition here by fetching data?
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
