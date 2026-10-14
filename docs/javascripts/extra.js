// Play videos from the start when they scroll into view, and pause them when they scroll out of view.
const observer = new IntersectionObserver(
  (entries) => {
    for (const { target: video, isIntersecting } of entries) {
      if (isIntersecting) {
        video.currentTime = 0;
        video.play().catch(() => {});
      } else {
        video.pause();
      }
    }
  },
  { threshold: 0.5 },
);

// Instant navigation replaces the page content, so find the videos again after every page load.
document$.subscribe(() => {
  observer.disconnect();
  const videos = document.querySelectorAll(".md-typeset video");
  if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    // Let the reader play the videos instead.
    videos.forEach((video) => (video.controls = true));
  } else {
    videos.forEach((video) => observer.observe(video));
  }
});
