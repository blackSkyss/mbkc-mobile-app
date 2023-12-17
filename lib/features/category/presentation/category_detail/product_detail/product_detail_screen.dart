import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../../utils/constants/asset_constant.dart';
import '../../../../../utils/enums/enums_export.dart';
import '../../../domain/models/product_model.dart';
import 'information_tab.dart';
import 'product_child_tab.dart';
import 'product_detail_controller.dart';
import 'product_detail_shimmer.dart';
import 'product_extra_tab.dart';

@RoutePage()
class ProductDetailScreen extends HookConsumerWidget {
  const ProductDetailScreen(this.productId, this.productType, {super.key});
  final int productId;
  final ProductType productType;

  // fetch data
  Future<void> fetchData({
    required WidgetRef ref,
    required BuildContext context,
    required ValueNotifier<ProductModel?> product,
  }) async {
    final productData = await ref
        .read(productDetailControllerProvider.notifier)
        .getProductDetail(context, productId);

    product.value = productData;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // intit
    final size = MediaQuery.sizeOf(context);
    final product = useState<ProductModel?>(null);
    final tabController = useTabController(
      initialLength: productType == ProductType.parent
          ? 3
          : productType != ProductType.extra
              ? 2
              : 1,
    );
    final state = ref.watch(productDetailControllerProvider);

    // fetch data
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await fetchData(ref: ref, context: context, product: product);
      });

      return () {
        tabController.dispose;
      };
    }, const []);

    return Scaffold(
      backgroundColor: AssetsConstants.whiteColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: state.isLoading
            ? const ProductDetailShimmer()
            : product.value == null
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: EmptyBox(title: 'Sai thông tin'),
                  )
                : Stack(
                    children: [
                      DefaultTabController(
                        length: productType == ProductType.parent
                            ? 3
                            : productType != ProductType.extra
                                ? 2
                                : 1,
                        child: NestedScrollView(
                          headerSliverBuilder: (context, value) {
                            return [
                              SliverAppBar(
                                leading: IconButton(
                                  onPressed: () => context.router.pop(),
                                  icon: Stack(
                                    children: [
                                      Container(
                                        height: size.height * 0.045,
                                        width: size.width * 0.1,
                                        decoration: BoxDecoration(
                                          color: AssetsConstants.black_20
                                              .withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            AssetsConstants.defaultBorder + 20,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: AssetsConstants.whiteColor,
                                            size: AssetsConstants
                                                    .defaultFontSize -
                                                5.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                expandedHeight: size.height * 0.36,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: product.value!.image.isEmpty
                                      ? Image.asset(
                                          AssetsConstants.defaultAvatar)
                                      : FadeInImage(
                                          fit: BoxFit.cover,
                                          placeholder: const AssetImage(
                                            AssetsConstants.welcomeImage,
                                          ),
                                          image: NetworkImage(
                                            product.value!.image,
                                          ),
                                        ),
                                ),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: SliverAppBarDelegate(
                                  minHeight: size.height * 0.06,
                                  maxHeight: size.height * 0.06,
                                  child: Container(
                                    color: AssetsConstants.whiteColor,
                                    child: TabBar(
                                      indicatorColor: AssetsConstants.mainColor,
                                      dividerColor: AssetsConstants.borderColor,
                                      controller: tabController,
                                      tabs: [
                                        const Tab(
                                          child: LabelText(
                                            content: 'Thông tin',
                                            size: AssetsConstants
                                                    .defaultFontSize -
                                                14.0,
                                            color: AssetsConstants.mainColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (productType == ProductType.parent)
                                          const Tab(
                                            child: LabelText(
                                              content: 'Sản phẩm con',
                                              size: AssetsConstants
                                                      .defaultFontSize -
                                                  14.0,
                                              color: AssetsConstants.mainColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        if (productType != ProductType.extra)
                                          const Tab(
                                            child: LabelText(
                                              content: 'Sản phẩm thêm',
                                              size: AssetsConstants
                                                      .defaultFontSize -
                                                  14.0,
                                              color: AssetsConstants.mainColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ];
                          },
                          body: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AssetsConstants.defaultPadding - 10.0,
                            ),
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                InformationTab(product: product.value!),
                                if (productType == ProductType.parent)
                                  ProductChildTab(
                                    productsChild:
                                        product.value!.childrenProducts!,
                                  ),
                                if (productType != ProductType.extra)
                                  ProductExtraTab(
                                    productsExtra:
                                        product.value!.extraProducts!,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
