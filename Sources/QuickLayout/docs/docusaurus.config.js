/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import {fbContent} from 'docusaurus-plugin-internaldocs-fb/internal';
const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

// With JSDoc @type annotations, IDEs can provide config autocompletion
/** @type {import('@docusaurus/types').DocusaurusConfig} */
(module.exports = {
  title: 'QuickLayout',
  tagline: 'QuickLayout is a declarative layout library for iOS, designed to work seamlessly with UIKit. It is lightning-fast, incredibly simple to use, and offers a powerful set of modern layout primitives.',
  url: fbContent({
    internal: 'https://internalfb.com/',
    external: 'https://facebookincubator.github.io/',
  }),
  baseUrl: fbContent({
    internal: '/',
    external: '/QuickLayout/',
  }),
  onBrokenLinks: 'throw',
  trailingSlash: true,
  favicon: 'img/favicon.ico',
  organizationName: 'facebookincubator',
  projectName: 'QuickLayout',
  deploymentBranch: 'main',
  customFields: {
    fbRepoName: 'fbsource',
    ossRepoPath: 'fbobjc/Libraries/MobileUI/QuickLayout/docs',
  },

  presets: [
    [
      'docusaurus-plugin-internaldocs-fb/docusaurus-preset',
      /** @type {import('docusaurus-plugin-internaldocs-fb').PresetOptions} */
      ({
        docs: {
          breadcrumbs: false,
          routeBasePath: '/', // Serve the docs at the site's root
          sidebarCollapsible: false,
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: fbContent({
            internal: 'https://www.internalfb.com/code/fbsource/fbobjc/Libraries/MobileUI/QuickLayout/docs',
            external: 'https://github.com/facebookincubator/QuickLayout/edit/main/Sources/QuickLayout/docs',
          }),
        },
        experimentalXRepoSnippets: {
          baseDir: '.',
        },
        staticDocsProject: 'QuickLayout',
        trackingFile: 'fbcode/staticdocs/WATCHED_FILES',
        blog: false, // Optional: disable the blog plugin
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
        googleAnalytics: {
          trackingID: 'G-893KEXXG32',
          anonymizeIP: true,
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: 'QuickLayout Handbook',
        items: [
        ],
      },
      footer: {
      },
      prism: {
        additionalLanguages: ['swift'],
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
});
