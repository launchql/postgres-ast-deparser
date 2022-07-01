export const indexes = [
{
    "RawStmt": {
    "stmt": {
        "IndexStmt": {
        "idxname": "idx_simple",
        "relation": {
            "relname": "table_simple",
            "inh": true,
            "relpersistence": "p",
            "location": 27
        },
        "accessMethod": "btree",
        "indexParams": [
            {
            "IndexElem": {
                "name": "simple",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ]
        }
    },
    "stmt_len": 48,
    "stmt_location": 0
    }
},
{
    "RawStmt": {
    "stmt": {
        "IndexStmt": {
        "idxname": "idx_composite",
        "relation": {
            "relname": "table_composite",
            "inh": true,
            "relpersistence": "p",
            "location": 80
        },
        "accessMethod": "btree",
        "indexParams": [
            {
            "IndexElem": {
                "name": "col1",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            },
            {
            "IndexElem": {
                "name": "col2",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ]
        }
    },
    "stmt_len": 59,
    "stmt_location": 49
    }
},
{
    "RawStmt": {
    "stmt": {
        "IndexStmt": {
        "idxname": "idx_include",
        "relation": {
            "relname": "table_include",
            "inh": true,
            "relpersistence": "p",
            "location": 138
        },
        "accessMethod": "btree",
        "indexParams": [
            {
            "IndexElem": {
                "name": "col1",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ],
        "indexIncludingParams": [
            {
            "IndexElem": {
                "name": "col2",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            },
            {
            "IndexElem": {
                "name": "col3",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ]
        }
    },
    "stmt_len": 70,
    "stmt_location": 109
    }
},
{
    "RawStmt": {
    "stmt": {
        "IndexStmt": {
        "idxname": "idx_CaseSimple",
        "relation": {
            "relname": "Table_CaseSimple",
            "inh": true,
            "relpersistence": "p",
            "location": 214
        },
        "accessMethod": "btree",
        "indexParams": [
            {
            "IndexElem": {
                "name": "CaseSimple",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ]
        }
    },
    "stmt_len": 67,
    "stmt_location": 180
    }
},
{
    "RawStmt": {
    "stmt": {
        "IndexStmt": {
        "idxname": "idx_CaseInclude",
        "relation": {
            "relname": "table_caseinclude",
            "inh": true,
            "relpersistence": "p",
            "location": 283
        },
        "accessMethod": "btree",
        "indexParams": [
            {
            "IndexElem": {
                "name": "simple",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ],
        "indexIncludingParams": [
            {
            "IndexElem": {
                "name": "CaseInclude",
                "ordering": "SORTBY_DEFAULT",
                "nulls_ordering": "SORTBY_NULLS_DEFAULT"
            }
            }
        ]
        }
    },
    "stmt_len": 85,
    "stmt_location": 248
    }
}
];