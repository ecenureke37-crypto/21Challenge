/// DAY 16: Introduce Object with UID & key
/// 
/// Today you will:
/// 1. Learn about UID (Unique Identifier)
/// 2. Learn about the 'key' ability
/// 3. Create your first Sui object
///
/// Note: The code includes plotId support. You can copy code from 
/// day_15/sources/solution.move if needed (note: plotId functionality has been added)

module challenge::day_16 {
    // GÖREV 1: Sui Object kütüphanelerini ekliyoruz
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;

    // SABİTLER
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // STRUCTS

    // Bu bizim veri paketimiz (Store yeteneği var, çünkü Farm objesinin içine koyacağız)
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    // GÖREV 2: Gerçek SUI OBJESİ (Farm)
    // 'key' yeteneği bunun bir obje olduğunu ve global storage'da saklanabileceğini söyler.
    // Her objenin ilk alanı mutlaka 'id: UID' olmak zorundadır!
    public struct Farm has key {
        id: UID,                // Objenin benzersiz kimliği
        counters: FarmCounters  // İçindeki veriler
    }

    // FONKSİYONLAR

    // Yardımcı fonksiyon (Private)
    fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

    // GÖREV 3: Farm Objesi Oluşturucu (Constructor)
    // Yeni bir UID oluşturmak için 'ctx' (Transaction Context) gerekir.
    public fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx), // Benzersiz ID oluşturur
            counters: new_counters()
        }
    }

    //MANTIK FONKSİYONLARI (Logic)
    // Not: Bu fonksiyonları şimdilik FarmCounters üzerinde tutuyoruz,
    // yarın bunları Farm objesine bağlayacağız.

    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        assert!(vector::length(&counters.plots) < MAX_PLOTS, E_PLOT_LIMIT_EXCEEDED);
        let (exists, _) = vector::index_of(&counters.plots, &plot_id);
        assert!(!exists, E_PLOT_ALREADY_EXISTS);

        counters.planted = counters.planted + 1;
        vector::push_back(&mut counters.plots, plot_id);
    }

    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        let (exists, index) = vector::index_of(&counters.plots, &plot_id);
        assert!(exists, E_PLOT_NOT_FOUND);

        counters.harvested = counters.harvested + 1;
        vector::remove(&mut counters.plots, index);
    }
}