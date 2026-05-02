import importlib.util
import json
from pathlib import Path
import tempfile
import unittest


REPO_ROOT = Path(__file__).resolve().parents[1]
ANALYZER_PATH = REPO_ROOT / "scripts" / "analyze-diff.py"


def load_analyzer():
    spec = importlib.util.spec_from_file_location("analyze_diff", ANALYZER_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class AnalyzeDiffTests(unittest.TestCase):
    def test_counts_changed_files_diff_stats_and_keyword_references(self):
        analyzer = load_analyzer()
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            changed = root / "Mira" / "Mira" / "Screens" / "Settings" / "SettingsView.swift"
            changed.parent.mkdir(parents=True)
            changed.write_text(
                "import SwiftUI\n"
                "struct SettingsView: View {\n"
                "  var body: some View { Text(\"Settings\").foregroundStyle(MiraColors.textPrimary).accessibilityLabel(\"Settings\") }\n"
                "}\n",
                encoding="utf-8",
            )
            config = {
                "allowedChangedPaths": ["Mira/Mira/Screens/Settings/"],
                "designTokenKeywords": ["MiraColors"],
                "disallowedRawColorPatterns": ["Color\\.red"],
                "accessibilityKeywords": [".accessibilityLabel"],
            }
            diff_numstat = "4\t0\tMira/Mira/Screens/Settings/SettingsView.swift\n"

            result = analyzer.analyze_changed_files(
                repo_root=root,
                changed_files=["Mira/Mira/Screens/Settings/SettingsView.swift"],
                numstat_text=diff_numstat,
                config=config,
            )

            self.assertEqual(result["filesChanged"], 1)
            self.assertEqual(result["linesAdded"], 4)
            self.assertEqual(result["linesRemoved"], 0)
            self.assertEqual(result["designTokenReferences"], 1)
            self.assertEqual(result["accessibilityReferences"], 1)
            self.assertEqual(result["rawColorUsages"], 0)
            self.assertEqual(result["unrelatedFilesChanged"], [])

    def test_flags_files_outside_allowed_paths_and_raw_colors(self):
        analyzer = load_analyzer()
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            changed = root / "Mira" / "Mira" / "Data" / "SampleData.swift"
            changed.parent.mkdir(parents=True)
            changed.write_text("let color = Color.red\n", encoding="utf-8")
            config = {
                "allowedChangedPaths": ["Mira/Mira/Screens/Settings/"],
                "designTokenKeywords": ["MiraColors"],
                "disallowedRawColorPatterns": ["Color\\.red"],
                "accessibilityKeywords": [".accessibilityLabel"],
            }

            result = analyzer.analyze_changed_files(
                repo_root=root,
                changed_files=["Mira/Mira/Data/SampleData.swift"],
                numstat_text="1\t0\tMira/Mira/Data/SampleData.swift\n",
                config=config,
            )

            self.assertEqual(result["rawColorUsages"], 1)
            self.assertEqual(result["unrelatedFilesChanged"], ["Mira/Mira/Data/SampleData.swift"])

    def test_build_log_success_detection_accepts_xcode_success_marker(self):
        analyzer = load_analyzer()
        self.assertTrue(analyzer.log_looks_successful("** BUILD SUCCEEDED **"))
        self.assertFalse(analyzer.log_looks_successful("** BUILD FAILED **"))

    def test_success_detection_ignores_nonfatal_simulator_failed_warnings(self):
        analyzer = load_analyzer()
        log = "load_eligibility_plist: Failed to open simulator plist\n** TEST SUCCEEDED **"
        self.assertTrue(analyzer.log_looks_successful(log))


if __name__ == "__main__":
    unittest.main()
