/// DAY 15: Read Object Model & Create FarmState Struct (no UID yet)
/// 
/// Today you will:
/// 1. Learn about Sui objects (conceptually)
/// 2. Create a simple struct for farm counters
/// 3. Write basic functions to increment counters
/// 
/// NOTE: Today we're NOT creating a Sui object yet, just a regular struct.
/// We'll add UID and make it an object tomorrow.

module challenge::day_15 {

    // --- SABİTLER ---
    const MAX_PLOTS: u64 = 20;
    const E_PLOT_NOT_FOUND: u64 = 1;
    const E_PLOT_LIMIT_EXCEEDED: u64 = 2;
    const E_PLOT_ALREADY_EXISTS: u64 = 4;

    // --- STRUCT ---
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>,
    }

    // --- FONKSİYONLAR ---
    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty(),
        }
    }

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
