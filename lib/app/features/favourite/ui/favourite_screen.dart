import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/features/favourite/logic/cubit/favourite_cubit.dart';
import 'package:swb_advance/app/core/widgets/vertical_product_card.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضّلة')),
      body: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) {
          if (state is FavouriteLoading || state is FavouriteInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavouriteError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () =>
                          context.read<FavouriteCubit>().getFavourites(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = (state as FavouriteLoaded).products;
          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات في المفضّلة'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FavouriteCubit>().getFavourites(),
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 288,
              ),
              itemBuilder: (context, index) =>
                  VerticalProductCard(product: products[index]),
            ),
          );
        },
      ),
    );
  }
}
