import UIKit

struct NGO {
    let name: String
    let type: String
    let logoName: String
}

// Safe test data
let recommendedNGOs: [NGO] = [
    NGO(
        name: "Abrar Family Welfare Charity Association",
        type: "Charity",
        logoName: "AlabrarCharity"
    ),
    NGO(
        name: "Karrana Charity Society",
        type: "Charity",
        logoName: "KarranaCharity"
    ),
    NGO(
        name: "Aali Social Charity Society",
        type: "Charity",
        logoName: "AaliCharity"
    ),
    NGO(
        name: "Manama Charity Society",
        type: "Charity",
        logoName: "manamaCharity"
    ),
    NGO(
        name: "Tree Of Life Social Charity Society",
        type: "Orphans",
        logoName: "treeOfLife"
    )
]
