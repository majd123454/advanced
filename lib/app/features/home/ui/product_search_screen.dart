import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/widgets/vertical_product_card.dart';
import 'package:swb_advance/app/features/home/logic/cubit/product_cubit.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _searchDebounce?.cancel();
    context.read<ProductCubit>().resetSearch();

    final query = value.trim();
    if (query.isEmpty) return;

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<ProductCubit>().searchProducts(query);
    });
  }

  void _search() {
    _searchDebounce?.cancel();
    FocusScope.of(context).unfocus();
    context.read<ProductCubit>().searchProducts(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search products')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Enter a product name',
                  prefixIcon: const Icon(Iconsax.search_normal),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          icon: const Icon(Iconsax.close_circle),
                          tooltip: 'Clear search',
                        ),
                      IconButton(
                        onPressed: _searchController.text.trim().isEmpty
                            ? null
                            : _search,
                        icon: const Icon(Iconsax.search_normal),
                        tooltip: 'Search',
                      ),
                    ],
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.error.message,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            FilledButton.icon(
                              onPressed: _search,
                              icon: const Icon(Iconsax.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ProductSearchProductsLoaded) {
                    if (state.productsList.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.productsList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            mainAxisExtent: 288,
                          ),
                      itemBuilder: (context, index) => VerticalProductCard(
                        product: state.productsList[index],
                      ),
                    );
                  }

                  return const Center(child: Text('Search for products'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
