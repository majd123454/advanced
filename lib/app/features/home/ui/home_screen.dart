import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:swb_advance/app/core/widgets/section_heading.dart';
import 'package:swb_advance/app/core/widgets/vertical_product_card.dart';
import 'package:swb_advance/app/features/home/data/models/section_heading_view_model.dart';
import 'package:swb_advance/app/features/home/logic/cubit/product_cubit.dart';
import 'package:swb_advance/app/features/home/ui/widgets/home_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeViewShimmer extends StatelessWidget {
  const HomeViewShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(
      baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: dark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Column(
        children: [
          // Header Section Shimmer
          Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          // Banner Carousel Shimmer
          Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          // Section Heading Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 120, height: 20, color: Colors.white),
                Container(width: 80, height: 20, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Grid Layout Shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 288,
            ),
            itemCount: 4,
            itemBuilder: (_, _) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Product Image Shimmer
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  // Product Details Shimmer
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60,
                                height: 20,
                                color: Colors.white,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ProductCubit>().getProducts(refresh: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductCubit>().getProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                /// 🔹 Header
                const SliverToBoxAdapter(child: HomeHeaderSection()),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                /// 🔹 Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SectionHeading(
                      sectionHeadingModel: SectionHeadingModel(
                        title: "Top Rated Products",
                        showActionButton: true,
                        textColor: AppColors.primary,
                        actionButtonTitle: "View All",
                        actionButtonOnPressed: () {},
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                /// 🔹 الحالات
                if (state is ProductLoading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (state is ProductError)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          children: [
                            Text(
                              state.error.message,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProductCubit>().getProducts(
                                  refresh: true,
                                );
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (state is ProductLoaded)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return VerticalProductCard(
                          product: state.products[index],
                        );
                      }, childCount: state.products.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            mainAxisExtent: 288,
                          ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(child: SizedBox()),

                /// 🔹 لودينغ تحت (لما يحمل صفحة جديدة)
                SliverToBoxAdapter(
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      final cubit = context.read<ProductCubit>();

                      if (state is ProductLoaded && cubit.hasMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
