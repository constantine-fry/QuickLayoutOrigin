/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import React from 'react';
import Footer from '@theme-original/Footer';

export default function FooterWrapper(props) {
  return (
    <footer style={{ textAlign: 'center', padding: '2rem 0', fontFamily: 'var(--ifm-font-family-base)', color: 'var(--ifm-font-color-base)', fontSize: '0.875em' }}>
      <div>
        Copyright © Meta Platforms, Inc
        {' | '}
        <a
          href="https://opensource.fb.com/legal/privacy/"
          target="_blank"
          rel="noreferrer noopener">
          Privacy
        </a>
        {' | '}
        <a
          href="https://opensource.fb.com/legal/terms/"
          target="_blank"
          rel="noreferrer noopener">
          Terms
        </a>
      </div>
    </footer>
  );
}
