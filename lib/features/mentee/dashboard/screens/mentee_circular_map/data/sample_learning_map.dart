import '../models/learning_map_models.dart';

final sampleSubject = Subject(
  subject: "EPC Core Foundation",
  modules: [
    Module(
      id: "m001",
      moduleName: "Intro EPC",
      chapters: [
        Chapter(id: "c00101", title: "What is EPC"),
        Chapter(id: "c00102", title: "EPC vs EPCM"),
        Chapter(id: "c00103", title: "Project Life"),
        Chapter(id: "c00104", title: "Stakeholders"),
        Chapter(id: "c00105", title: "Market")
      ]
    ),
    Module(
      id: "m002",
      moduleName: "Project Phases",
      chapters: [
        Chapter(id: "c00201", title: "Concept"),
        Chapter(id: "c00202", title: "FEED"),
        Chapter(id: "c00203", title: "Detail Eng"),
        Chapter(id: "c00204", title: "Procurement"),
        Chapter(id: "c00205", title: "Construction")
      ]
    ),
    Module(
      id: "m003",
      moduleName: "Eng Basics",
      chapters: [
        Chapter(id: "c00301", title: "Disciplines"),
        Chapter(id: "c00302", title: "Codes"),
        Chapter(id: "c00303", title: "Deliverables"),
        Chapter(id: "c00304", title: "Coordination"),
        Chapter(id: "c00305", title: "Review")
      ]
    ),
    Module(
      id: "m004",
      moduleName: "Civil & Struct",
      chapters: [
        Chapter(id: "c00401", title: "Layout"),
        Chapter(id: "c00402", title: "Foundations"),
        Chapter(id: "c00403", title: "Steel"),
        Chapter(id: "c00404", title: "Concrete"),
        Chapter(id: "c00405", title: "Seismic")
      ]
    ),
    Module(
      id: "m005",
      moduleName: "Mechanical",
      chapters: [
        Chapter(id: "c00501", title: "Equip Overview"),
        Chapter(id: "c00502", title: "Vessels"),
        Chapter(id: "c00503", title: "Pumps & Turb"),
        Chapter(id: "c00504", title: "Datasheets"),
        Chapter(id: "c00505", title: "Materials")
      ]
    ),
    Module(
      id: "m006",
      moduleName: "Piping",
      chapters: [
        Chapter(id: "c00601", title: "Design"),
        Chapter(id: "c00602", title: "Routing"),
        Chapter(id: "c00603", title: "P&ID"),
        Chapter(id: "c00604", title: "Stress"),
        Chapter(id: "c00605", title: "Supports")
      ]
    ),
    Module(
      id: "m007",
      moduleName: "Electrical",
      chapters: [
        Chapter(id: "c00701", title: "Loads"),
        Chapter(id: "c00702", title: "Power Dist"),
        Chapter(id: "c00703", title: "SLD"),
        Chapter(id: "c00704", title: "Earthing"),
        Chapter(id: "c00705", title: "Hazard Area")
      ]
    ),
    Module(
      id: "m008",
      moduleName: "Instr & Ctrl",
      chapters: [
        Chapter(id: "c00801", title: "Instruments"),
        Chapter(id: "c00802", title: "Control"),
        Chapter(id: "c00803", title: "Field Dev"),
        Chapter(id: "c00804", title: "DCS/PLC"),
        Chapter(id: "c00805", title: "Loops")
      ]
    ),
    Module(
      id: "m009",
      moduleName: "Process Eng",
      chapters: [
        Chapter(id: "c00901", title: "PFD"),
        Chapter(id: "c00902", title: "Mass/Energy"),
        Chapter(id: "c00903", title: "Simulations"),
        Chapter(id: "c00904", title: "Heat/Mass"),
        Chapter(id: "c00905", title: "Basis Docs")
      ]
    ),
    Module(
      id: "m010",
      moduleName: "Procurement",
      chapters: [
        Chapter(id: "c01001", title: "Vendors"),
        Chapter(id: "c01002", title: "Tech Bid"),
        Chapter(id: "c01003", title: "Comm Bid"),
        Chapter(id: "c01004", title: "POs"),
        Chapter(id: "c01005", title: "Expediting")
      ]
    ),
    Module(
      id: "m011",
      moduleName: "Construction",
      chapters: [
        Chapter(id: "c01101", title: "Planning"),
        Chapter(id: "c01102", title: "Mobilization"),
        Chapter(id: "c01103", title: "Safety"),
        Chapter(id: "c01104", title: "Progress"),
        Chapter(id: "c01105", title: "Quality")
      ]
    ),
    Module(
      id: "m012",
      moduleName: "Commissioning",
      chapters: [
        Chapter(id: "c01201", title: "Pre-Comm"),
        Chapter(id: "c01202", title: "Mech Complete"),
        Chapter(id: "c01203", title: "Cold/Hot"),
        Chapter(id: "c01204", title: "Testing"),
        Chapter(id: "c01205", title: "Handover")
      ]
    ),
    Module(
      id: "m013",
      moduleName: "Planning",
      chapters: [
        Chapter(id: "c01301", title: "WBS"),
        Chapter(id: "c01302", title: "Scheduling"),
        Chapter(id: "c01303", title: "CPM"),
        Chapter(id: "c01304", title: "Resources"),
        Chapter(id: "c01305", title: "Progress")
      ]
    ),
    Module(
      id: "m014",
      moduleName: "Cost & Risk",
      chapters: [
        Chapter(id: "c01401", title: "Estimation"),
        Chapter(id: "c01402", title: "Control"),
        Chapter(id: "c01403", title: "Changes"),
        Chapter(id: "c01404", title: "Risks"),
        Chapter(id: "c01405", title: "Mitigation")
      ]
    ),
    Module(
      id: "m015",
      moduleName: "HSE",
      chapters: [
        Chapter(id: "c01501", title: "HSE Sys"),
        Chapter(id: "c01502", title: "Hazards"),
        Chapter(id: "c01503", title: "Permits"),
        Chapter(id: "c01504", title: "Env"),
        Chapter(id: "c01505", title: "Incidents")
      ]
    ),
    Module(
      id: "m016",
      moduleName: "Contracts",
      chapters: [
        Chapter(id: "c01601", title: "EPC Types"),
        Chapter(id: "c01602", title: "Terms"),
        Chapter(id: "c01603", title: "Claims"),
        Chapter(id: "c01604", title: "Damages"),
        Chapter(id: "c01605", title: "Closeout")
      ]
    )
  ]
);  